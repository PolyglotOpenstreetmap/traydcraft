//! Products (shared master data), price zones and zone price lists (per company).
//!
//! Other modules use [`get_products_for_quoting`] rather than reading these tables.

use std::collections::HashMap;

use axum::extract::{Path, Query, State};
use axum::http::StatusCode;
use axum::Json;
use chrono::NaiveDate;
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use sqlx::{FromRow, PgExecutor};
use traydcraft_core::{audit, new_id, AppError, AppResult, AppState, CurrentUser, Permission};
use traydcraft_pricing::{resolve_zone_price, ZonePrice};
use utoipa::{IntoParams, ToSchema};
use utoipa_axum::router::OpenApiRouter;
use utoipa_axum::routes;
use uuid::Uuid;

const PRODUCT_TYPES: [&str; 4] = ["purchased", "manufactured", "configurable", "service"];
const TRACKING: [&str; 3] = ["none", "serial", "lot"];
const PRICING_TYPES: [&str; 3] = ["list", "net", "indicative"];

pub mod bulk;
pub mod families;

#[derive(Debug, Clone, Serialize, FromRow, ToSchema)]
pub struct Product {
    pub id: Uuid,
    pub code: String,
    pub name: String,
    pub description: String,
    pub unit: String,
    /// purchased | manufactured | configurable | service
    pub product_type: String,
    #[schema(value_type = String, example = "21")]
    pub vat_rate: Decimal,
    /// none | serial | lot — serial-tracked products get an individual serial number per unit,
    /// lot-tracked products are stocked per lot or batch.
    pub tracking: String,
    pub family_id: Option<Uuid>,
    pub family_code: Option<String>,
    /// list (rebates apply) | net (fixed net price, never discounted) |
    /// indicative (price must be confirmed on each quotation)
    pub pricing_type: String,
    pub active: bool,
    /// Standard cost per stock unit. Only returned with the permission `inventory.cost`, else null.
    #[schema(value_type = Option<String>, example = "42.5000")]
    pub standard_cost: Option<Decimal>,
    /// Reorder when the available stock falls below this quantity.
    #[schema(value_type = Option<String>, example = "10")]
    pub reorder_min: Option<Decimal>,
    /// Order up to this quantity.
    #[schema(value_type = Option<String>, example = "40")]
    pub reorder_max: Option<Decimal>,
    pub lead_time_days: Option<i32>,
    pub barcode: Option<String>,
}

impl Product {
    /// Removes what the user may not see (cost).
    pub fn for_user(mut self, user: &CurrentUser) -> Self {
        if !user.can(Permission::InventoryCost) {
            self.standard_cost = None;
        }
        self
    }
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct ProductInput {
    pub code: String,
    pub name: String,
    #[serde(default)]
    pub description: String,
    #[serde(default = "default_unit")]
    pub unit: String,
    #[serde(default = "default_type")]
    pub product_type: String,
    #[schema(value_type = String, example = "21")]
    pub vat_rate: Decimal,
    /// none | serial
    #[serde(default = "default_tracking")]
    pub tracking: String,
    pub family_id: Option<Uuid>,
    /// list | net | indicative
    #[serde(default = "default_pricing_type")]
    pub pricing_type: String,
    #[serde(default = "default_true")]
    pub active: bool,
    /// Ignored (the stored cost is kept) without the permission `inventory.cost`.
    #[schema(value_type = Option<String>, example = "42.5")]
    pub standard_cost: Option<Decimal>,
    #[schema(value_type = Option<String>, example = "10")]
    pub reorder_min: Option<Decimal>,
    #[schema(value_type = Option<String>, example = "40")]
    pub reorder_max: Option<Decimal>,
    pub lead_time_days: Option<i32>,
    pub barcode: Option<String>,
}

fn barcode(input: &ProductInput) -> Option<&str> {
    input
        .barcode
        .as_deref()
        .map(str::trim)
        .filter(|b| !b.is_empty())
}

fn default_pricing_type() -> String {
    "list".into()
}

fn default_tracking() -> String {
    "none".into()
}

fn default_unit() -> String {
    "pcs".into()
}
fn default_type() -> String {
    "purchased".into()
}
fn default_true() -> bool {
    true
}

impl ProductInput {
    fn validate(&self) -> AppResult<()> {
        if self.code.trim().is_empty() || self.name.trim().is_empty() {
            return Err(AppError::Validation("code and name are required".into()));
        }
        if !PRODUCT_TYPES.contains(&self.product_type.as_str()) {
            return Err(AppError::Validation(format!(
                "product_type must be one of {}",
                PRODUCT_TYPES.join(", ")
            )));
        }
        if !TRACKING.contains(&self.tracking.as_str()) {
            return Err(AppError::Validation(format!(
                "tracking must be one of {}",
                TRACKING.join(", ")
            )));
        }
        if !PRICING_TYPES.contains(&self.pricing_type.as_str()) {
            return Err(AppError::Validation(format!(
                "pricing_type must be one of {}",
                PRICING_TYPES.join(", ")
            )));
        }
        if self.vat_rate < Decimal::ZERO {
            return Err(AppError::Validation("vat_rate cannot be negative".into()));
        }
        if self.tracking != "none" && self.product_type == "service" {
            return Err(AppError::Validation("services cannot be tracked".into()));
        }
        let negative = |v: Option<Decimal>| v.is_some_and(|v| v < Decimal::ZERO);
        if negative(self.standard_cost) || negative(self.reorder_min) || negative(self.reorder_max)
        {
            return Err(AppError::Validation(
                "cost and reorder quantities cannot be negative".into(),
            ));
        }
        if let (Some(min), Some(max)) = (self.reorder_min, self.reorder_max) {
            if max < min {
                return Err(AppError::Validation(
                    "reorder_max must be at least reorder_min".into(),
                ));
            }
        }
        if self.lead_time_days.is_some_and(|d| d < 0) {
            return Err(AppError::Validation(
                "lead_time_days cannot be negative".into(),
            ));
        }
        Ok(())
    }
}

#[derive(Debug, Serialize, ToSchema)]
pub struct ProductPage {
    pub items: Vec<Product>,
    pub total: i64,
}

#[derive(Debug, Deserialize, IntoParams)]
pub struct ListParams {
    /// Searches code and name.
    pub q: Option<String>,
    pub active: Option<bool>,
    pub family_id: Option<Uuid>,
    pub limit: Option<i64>,
    pub offset: Option<i64>,
}

#[derive(Debug, Clone, Serialize, FromRow, ToSchema)]
pub struct PriceZone {
    pub id: Uuid,
    pub code: String,
    pub name: String,
    pub sort_order: i32,
}

#[derive(Debug, Clone, Serialize, FromRow, ToSchema)]
pub struct ZonePriceEntry {
    pub id: Uuid,
    pub zone_id: Uuid,
    pub zone_code: String,
    #[schema(value_type = String, example = "125.0000")]
    pub unit_price: Decimal,
    pub valid_from: NaiveDate,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct ZonePriceInput {
    pub zone_id: Uuid,
    #[schema(value_type = String, example = "125.00")]
    pub unit_price: Decimal,
    #[serde(deserialize_with = "traydcraft_core::serde_util::date")]
    pub valid_from: NaiveDate,
}

/// Products with their family code; wrapped so callers can filter on plain column names.
const SELECT_PRODUCT: &str = "SELECT * FROM (
        SELECT p.id, p.code, p.name, p.description, p.unit, p.product_type, p.vat_rate, p.tracking,
               p.family_id, f.code AS family_code, p.pricing_type, p.active, p.standard_cost, p.reorder_min,
               p.reorder_max, p.lead_time_days, p.barcode
        FROM products.products p LEFT JOIN products.product_families f ON f.id = p.family_id
    ) p";

pub async fn get_product<'e>(db: impl PgExecutor<'e>, id: Uuid) -> AppResult<Product> {
    sqlx::query_as(&format!("{SELECT_PRODUCT} WHERE id = $1"))
        .bind(id)
        .fetch_optional(db)
        .await?
        .ok_or(AppError::NotFound("product"))
}

/// A product with its list price for a given company, zone and date.
#[derive(Debug, Clone)]
pub struct QuotingProduct {
    pub product: Product,
    pub list_unit_price: Decimal,
}

/// Loads the requested products with their zone price valid on `date`.
/// Fails if a product is unknown, inactive or has no price in that zone.
pub async fn get_products_for_quoting(
    db: &sqlx::PgPool,
    company_id: Uuid,
    zone_id: Uuid,
    zone_code: &str,
    date: NaiveDate,
    product_ids: &[Uuid],
) -> AppResult<HashMap<Uuid, QuotingProduct>> {
    let products: Vec<Product> = sqlx::query_as(&format!("{SELECT_PRODUCT} WHERE id = ANY($1)"))
        .bind(product_ids)
        .fetch_all(db)
        .await?;
    #[derive(FromRow)]
    struct Row {
        product_id: Uuid,
        zone_id: Uuid,
        unit_price: Decimal,
        valid_from: NaiveDate,
    }
    let rows: Vec<Row> = sqlx::query_as(
        "SELECT product_id, zone_id, unit_price, valid_from FROM pricing.zone_prices
         WHERE company_id = $1 AND zone_id = $2 AND product_id = ANY($3) AND valid_from <= $4",
    )
    .bind(company_id)
    .bind(zone_id)
    .bind(product_ids)
    .bind(date)
    .fetch_all(db)
    .await?;

    let mut result = HashMap::new();
    for id in product_ids {
        let product = products
            .iter()
            .find(|p| p.id == *id)
            .ok_or(AppError::NotFound("product"))?;
        if !product.active {
            return Err(AppError::Validation(format!(
                "product {} is inactive",
                product.code
            )));
        }
        let prices: Vec<ZonePrice> = rows
            .iter()
            .filter(|r| r.product_id == *id)
            .map(|r| ZonePrice {
                zone_id: r.zone_id,
                unit_price: r.unit_price,
                valid_from: r.valid_from,
            })
            .collect();
        let price = resolve_zone_price(&prices, zone_id, date).ok_or_else(|| {
            AppError::Validation(format!(
                "product {} has no price in price zone {zone_code} on {date}",
                product.code
            ))
        })?;
        result.insert(
            *id,
            QuotingProduct {
                product: product.clone(),
                list_unit_price: price,
            },
        );
    }
    Ok(result)
}

#[utoipa::path(get, path = "/products", tag = "products", params(ListParams),
    responses((status = 200, body = ProductPage)))]
async fn list_products(
    State(state): State<AppState>,
    user: CurrentUser,
    Query(p): Query<ListParams>,
) -> AppResult<Json<ProductPage>> {
    user.require(Permission::ProductsRead)?;
    let pattern =
        p.q.as_deref()
            .map(|q| format!("%{}%", q.trim().to_lowercase()));
    let filter = "WHERE ($1::text IS NULL OR lower(code) LIKE $1 OR lower(name) LIKE $1)
                  AND ($2::boolean IS NULL OR active = $2)
                  AND ($5::uuid IS NULL OR family_id = $5)";
    let items = sqlx::query_as(&format!(
        "{SELECT_PRODUCT} {filter} ORDER BY code LIMIT $3 OFFSET $4"
    ))
    .bind(&pattern)
    .bind(p.active)
    .bind(p.limit.unwrap_or(50).clamp(1, 500))
    .bind(p.offset.unwrap_or(0).max(0))
    .bind(p.family_id)
    .fetch_all(&state.db)
    .await?;
    let total = sqlx::query_scalar(&format!(
        "SELECT count(*) FROM products.products {}",
        filter.replace("$5", "$3")
    ))
    .bind(&pattern)
    .bind(p.active)
    .bind(p.family_id)
    .fetch_one(&state.db)
    .await?;
    let items = items
        .into_iter()
        .map(|p: Product| p.for_user(&user))
        .collect();
    Ok(Json(ProductPage { items, total }))
}

#[utoipa::path(get, path = "/products/{id}", tag = "products", operation_id = "get_product", params(("id" = Uuid, Path)),
    responses((status = 200, body = Product), (status = 404, body = traydcraft_core::error::ErrorBody)))]
async fn get_product_handler(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
) -> AppResult<Json<Product>> {
    user.require(Permission::ProductsRead)?;
    Ok(Json(get_product(&state.db, id).await?.for_user(&user)))
}

#[utoipa::path(post, path = "/products", tag = "products", request_body = ProductInput,
    responses((status = 201, body = Product), (status = 409, body = traydcraft_core::error::ErrorBody)))]
async fn create_product(
    State(state): State<AppState>,
    user: CurrentUser,
    Json(input): Json<ProductInput>,
) -> AppResult<(StatusCode, Json<Product>)> {
    user.require(Permission::ProductsWrite)?;
    input.validate()?;
    let id = new_id();
    let mut tx = state.db.begin().await?;
    sqlx::query(
        "INSERT INTO products.products (id, code, name, description, unit, product_type, vat_rate, active, tracking,
                                        family_id, pricing_type, standard_cost, reorder_min, reorder_max,
                                        lead_time_days, barcode)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)",
    )
    .bind(id)
    .bind(input.code.trim())
    .bind(input.name.trim())
    .bind(&input.description)
    .bind(&input.unit)
    .bind(&input.product_type)
    .bind(input.vat_rate)
    .bind(input.active)
    .bind(&input.tracking)
    .bind(input.family_id)
    .bind(&input.pricing_type)
    .bind(
        input
            .standard_cost
            .filter(|_| user.can(Permission::InventoryCost)),
    )
    .bind(input.reorder_min)
    .bind(input.reorder_max)
    .bind(input.lead_time_days)
    .bind(barcode(&input))
    .execute(&mut *tx)
    .await?;
    audit::record(
        &mut tx,
        &user,
        "product",
        id,
        "created",
        serde_json::json!({ "code": input.code }),
    )
    .await?;
    tx.commit().await?;
    Ok((
        StatusCode::CREATED,
        Json(get_product(&state.db, id).await?.for_user(&user)),
    ))
}

#[utoipa::path(put, path = "/products/{id}", tag = "products", params(("id" = Uuid, Path)),
    request_body = ProductInput, responses((status = 200, body = Product)))]
async fn update_product(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
    Json(input): Json<ProductInput>,
) -> AppResult<Json<Product>> {
    user.require(Permission::ProductsWrite)?;
    input.validate()?;
    let mut tx = state.db.begin().await?;
    let updated = sqlx::query(
        "UPDATE products.products SET code = $2, name = $3, description = $4, unit = $5, product_type = $6,
                vat_rate = $7, active = $8, tracking = $9, family_id = $10, pricing_type = $11,
                standard_cost = CASE WHEN $12 THEN $13 ELSE standard_cost END,
                reorder_min = $14, reorder_max = $15, lead_time_days = $16, barcode = $17, updated_at = now()
         WHERE id = $1",
    )
    .bind(id)
    .bind(input.code.trim())
    .bind(input.name.trim())
    .bind(&input.description)
    .bind(&input.unit)
    .bind(&input.product_type)
    .bind(input.vat_rate)
    .bind(input.active)
    .bind(&input.tracking)
    .bind(input.family_id)
    .bind(&input.pricing_type)
    .bind(user.can(Permission::InventoryCost))
    .bind(input.standard_cost)
    .bind(input.reorder_min)
    .bind(input.reorder_max)
    .bind(input.lead_time_days)
    .bind(barcode(&input))
    .execute(&mut *tx)
    .await?;
    if updated.rows_affected() == 0 {
        return Err(AppError::NotFound("product"));
    }
    audit::record(
        &mut tx,
        &user,
        "product",
        id,
        "updated",
        serde_json::json!({}),
    )
    .await?;
    tx.commit().await?;
    Ok(Json(get_product(&state.db, id).await?.for_user(&user)))
}

#[utoipa::path(get, path = "/price-zones", tag = "products",
    responses((status = 200, body = Vec<PriceZone>)))]
async fn list_price_zones(
    State(state): State<AppState>,
    user: CurrentUser,
) -> AppResult<Json<Vec<PriceZone>>> {
    user.require(Permission::ProductsRead)?;
    Ok(Json(
        sqlx::query_as("SELECT id, code, name, sort_order FROM pricing.price_zones WHERE company_id = $1 ORDER BY sort_order, code")
            .bind(user.company_id)
            .fetch_all(&state.db)
            .await?,
    ))
}

const SELECT_ZONE_PRICES: &str =
    "SELECT p.id, p.zone_id, z.code AS zone_code, p.unit_price, p.valid_from
     FROM pricing.zone_prices p JOIN pricing.price_zones z ON z.id = p.zone_id
     WHERE p.company_id = $1 AND p.product_id = $2";

/// Full price history of a product in the active company, newest first per zone.
#[utoipa::path(get, path = "/products/{id}/prices", tag = "products", params(("id" = Uuid, Path)),
    responses((status = 200, body = Vec<ZonePriceEntry>)))]
async fn list_product_prices(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
) -> AppResult<Json<Vec<ZonePriceEntry>>> {
    user.require(Permission::ProductsRead)?;
    Ok(Json(
        sqlx::query_as(&format!(
            "{SELECT_ZONE_PRICES} ORDER BY z.sort_order, p.valid_from DESC"
        ))
        .bind(user.company_id)
        .bind(id)
        .fetch_all(&state.db)
        .await?,
    ))
}

/// Adds a price for a zone from a date. Prices are never edited: a new entry supersedes older ones.
#[utoipa::path(post, path = "/products/{id}/prices", tag = "products", params(("id" = Uuid, Path)),
    request_body = ZonePriceInput,
    responses((status = 201, body = ZonePriceEntry), (status = 409, body = traydcraft_core::error::ErrorBody)))]
async fn add_product_price(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(product_id): Path<Uuid>,
    Json(input): Json<ZonePriceInput>,
) -> AppResult<(StatusCode, Json<ZonePriceEntry>)> {
    user.require(Permission::PricesWrite)?;
    if input.unit_price < Decimal::ZERO {
        return Err(AppError::Validation("unit_price cannot be negative".into()));
    }
    let mut tx = state.db.begin().await?;
    let zone_ok: bool = sqlx::query_scalar(
        "SELECT EXISTS (SELECT 1 FROM pricing.price_zones WHERE id = $1 AND company_id = $2)",
    )
    .bind(input.zone_id)
    .bind(user.company_id)
    .fetch_one(&mut *tx)
    .await?;
    if !zone_ok {
        return Err(AppError::Validation(
            "price zone does not belong to the active company".into(),
        ));
    }
    get_product(&mut *tx, product_id).await?;
    let id = new_id();
    sqlx::query(
        "INSERT INTO pricing.zone_prices (id, company_id, zone_id, product_id, unit_price, valid_from, created_by)
         VALUES ($1, $2, $3, $4, $5, $6, $7)",
    )
    .bind(id)
    .bind(user.company_id)
    .bind(input.zone_id)
    .bind(product_id)
    .bind(input.unit_price)
    .bind(input.valid_from)
    .bind(user.user_id)
    .execute(&mut *tx)
    .await?;
    audit::record(
        &mut tx,
        &user,
        "product",
        product_id,
        "price_added",
        serde_json::json!({ "zone_id": input.zone_id, "unit_price": input.unit_price, "valid_from": input.valid_from }),
    )
    .await?;
    let entry = sqlx::query_as(&format!("{SELECT_ZONE_PRICES} AND p.id = $3"))
        .bind(user.company_id)
        .bind(product_id)
        .bind(id)
        .fetch_one(&mut *tx)
        .await?;
    tx.commit().await?;
    Ok((StatusCode::CREATED, Json(entry)))
}

pub fn router() -> OpenApiRouter<AppState> {
    OpenApiRouter::new()
        .routes(routes!(list_products, create_product))
        .routes(routes!(get_product_handler, update_product))
        .routes(routes!(list_product_prices, add_product_price))
        .routes(routes!(list_price_zones))
        .merge(families::router())
        .merge(bulk::router())
}
