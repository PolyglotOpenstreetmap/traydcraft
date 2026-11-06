//! CRM: customers and their per-company commercial terms.
//!
//! Other modules use the public service functions here (e.g. [`get_customer_for_quoting`])
//! and never query `crm.*` tables directly.

pub mod contacts;
pub mod opportunities;
pub mod rebates;

use axum::extract::{Path, Query, State};
use axum::http::StatusCode;
use axum::Json;
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use sqlx::{FromRow, PgExecutor};
use traydcraft_core::{audit, new_id, AppError, AppResult, AppState, CurrentUser, Permission};
use utoipa::{IntoParams, ToSchema};
use utoipa_axum::router::OpenApiRouter;
use utoipa_axum::routes;
use uuid::Uuid;

#[derive(Debug, Clone, Serialize, FromRow, ToSchema)]
pub struct Customer {
    pub id: Uuid,
    pub code: String,
    pub name: String,
    pub vat_number: Option<String>,
    pub email: Option<String>,
    pub phone: Option<String>,
    pub street: String,
    pub postal_code: String,
    pub city: String,
    pub country_code: String,
    pub language: String,
    pub active: bool,
    // Commercial terms in the active company (null if the customer has none there).
    pub price_zone_id: Option<Uuid>,
    pub price_zone_code: Option<String>,
    #[schema(value_type = Option<String>, example = "5.00")]
    pub discount_percent: Option<Decimal>,
    pub payment_terms_days: Option<i32>,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct CustomerInput {
    pub code: String,
    pub name: String,
    pub vat_number: Option<String>,
    pub email: Option<String>,
    pub phone: Option<String>,
    #[serde(default)]
    pub street: String,
    #[serde(default)]
    pub postal_code: String,
    #[serde(default)]
    pub city: String,
    #[serde(default = "default_country")]
    pub country_code: String,
    #[serde(default = "default_language")]
    pub language: String,
    #[serde(default = "default_true")]
    pub active: bool,
    pub price_zone_id: Uuid,
    #[serde(default)]
    #[schema(value_type = String, example = "0")]
    pub discount_percent: Decimal,
    #[serde(default = "default_payment_terms")]
    pub payment_terms_days: i32,
}

fn default_country() -> String {
    "BE".into()
}
fn default_language() -> String {
    "nl".into()
}
fn default_true() -> bool {
    true
}
fn default_payment_terms() -> i32 {
    30
}

impl CustomerInput {
    fn validate(&self) -> AppResult<()> {
        if self.code.trim().is_empty() || self.name.trim().is_empty() {
            return Err(AppError::Validation("code and name are required".into()));
        }
        if self.country_code.len() != 2 {
            return Err(AppError::Validation(
                "country_code must be a 2-letter code".into(),
            ));
        }
        if !traydcraft_core::is_language(&self.language.to_lowercase()) {
            return Err(AppError::Validation(format!(
                "language must be one of {}",
                traydcraft_core::LANGUAGES.join(", ")
            )));
        }
        if self.discount_percent < Decimal::ZERO || self.discount_percent > Decimal::ONE_HUNDRED {
            return Err(AppError::Validation(
                "discount_percent must be between 0 and 100".into(),
            ));
        }
        Ok(())
    }
}

#[derive(Debug, Serialize, ToSchema)]
pub struct CustomerPage {
    pub items: Vec<Customer>,
    pub total: i64,
}

#[derive(Debug, Deserialize, IntoParams)]
pub struct ListParams {
    /// Searches code, name, VAT number and city.
    pub q: Option<String>,
    pub limit: Option<i64>,
    pub offset: Option<i64>,
}

const SELECT_CUSTOMER: &str = r#"
    SELECT c.id, c.code, c.name, c.vat_number, c.email, c.phone, c.street, c.postal_code, c.city,
           c.country_code::text AS country_code, c.language::text AS language, c.active,
           t.price_zone_id, z.code AS price_zone_code, t.discount_percent, t.payment_terms_days
    FROM crm.customers c
    LEFT JOIN crm.customer_terms t ON t.customer_id = c.id AND t.company_id = $1
    LEFT JOIN pricing.price_zones z ON z.id = t.price_zone_id
"#;

pub async fn get_customer<'e>(
    db: impl PgExecutor<'e>,
    company_id: Uuid,
    id: Uuid,
) -> AppResult<Customer> {
    sqlx::query_as(&format!("{SELECT_CUSTOMER} WHERE c.id = $2"))
        .bind(company_id)
        .bind(id)
        .fetch_optional(db)
        .await?
        .ok_or(AppError::NotFound("customer"))
}

/// Everything sales needs to quote a customer in a company.
#[derive(Debug, Clone)]
pub struct QuotingCustomer {
    pub customer: Customer,
    pub price_zone_id: Uuid,
    pub price_zone_code: String,
    pub discount_percent: Decimal,
}

pub async fn get_customer_for_quoting<'e>(
    db: impl PgExecutor<'e>,
    company_id: Uuid,
    id: Uuid,
) -> AppResult<QuotingCustomer> {
    let customer = get_customer(db, company_id, id).await?;
    if !customer.active {
        return Err(AppError::Validation(format!(
            "customer {} is inactive",
            customer.code
        )));
    }
    match (
        customer.price_zone_id,
        customer.price_zone_code.clone(),
        customer.discount_percent,
    ) {
        (Some(zone_id), Some(zone_code), Some(discount)) => Ok(QuotingCustomer {
            price_zone_id: zone_id,
            price_zone_code: zone_code,
            discount_percent: discount,
            customer,
        }),
        _ => Err(AppError::Validation(format!(
            "customer {} has no commercial terms (price zone) in this company",
            customer.code
        ))),
    }
}

#[utoipa::path(get, path = "/customers", tag = "crm", params(ListParams),
    responses((status = 200, body = CustomerPage)))]
async fn list_customers(
    State(state): State<AppState>,
    user: CurrentUser,
    Query(p): Query<ListParams>,
) -> AppResult<Json<CustomerPage>> {
    user.require(Permission::CustomersRead)?;
    let pattern =
        p.q.as_deref()
            .map(|q| format!("%{}%", q.trim().to_lowercase()));
    let filter = "WHERE ($2::text IS NULL OR lower(c.code) LIKE $2 OR lower(c.name) LIKE $2
                  OR lower(coalesce(c.vat_number, '')) LIKE $2 OR lower(c.city) LIKE $2)";
    let items = sqlx::query_as(&format!(
        "{SELECT_CUSTOMER} {filter} ORDER BY c.name LIMIT $3 OFFSET $4"
    ))
    .bind(user.company_id)
    .bind(&pattern)
    .bind(p.limit.unwrap_or(50).clamp(1, 500))
    .bind(p.offset.unwrap_or(0).max(0))
    .fetch_all(&state.db)
    .await?;
    let total = sqlx::query_scalar(&format!(
        "SELECT count(*) FROM crm.customers c {}",
        filter.replace("$2", "$1")
    ))
    .bind(&pattern)
    .fetch_one(&state.db)
    .await?;
    Ok(Json(CustomerPage { items, total }))
}

#[utoipa::path(get, path = "/customers/{id}", tag = "crm", operation_id = "get_customer", params(("id" = Uuid, Path)),
    responses((status = 200, body = Customer), (status = 404, body = traydcraft_core::error::ErrorBody)))]
async fn get_customer_handler(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
) -> AppResult<Json<Customer>> {
    user.require(Permission::CustomersRead)?;
    Ok(Json(get_customer(&state.db, user.company_id, id).await?))
}

async fn ensure_zone_in_company(
    conn: &mut sqlx::PgConnection,
    company_id: Uuid,
    zone_id: Uuid,
) -> AppResult<()> {
    let ok: bool = sqlx::query_scalar(
        "SELECT EXISTS (SELECT 1 FROM pricing.price_zones WHERE id = $1 AND company_id = $2)",
    )
    .bind(zone_id)
    .bind(company_id)
    .fetch_one(conn)
    .await?;
    if ok {
        Ok(())
    } else {
        Err(AppError::Validation(
            "price zone does not belong to the active company".into(),
        ))
    }
}

async fn upsert_terms(
    conn: &mut sqlx::PgConnection,
    company_id: Uuid,
    id: Uuid,
    input: &CustomerInput,
) -> AppResult<()> {
    ensure_zone_in_company(conn, company_id, input.price_zone_id).await?;
    sqlx::query(
        "INSERT INTO crm.customer_terms (customer_id, company_id, price_zone_id, discount_percent, payment_terms_days)
         VALUES ($1, $2, $3, $4, $5)
         ON CONFLICT (customer_id, company_id) DO UPDATE
         SET price_zone_id = EXCLUDED.price_zone_id, discount_percent = EXCLUDED.discount_percent,
             payment_terms_days = EXCLUDED.payment_terms_days",
    )
    .bind(id)
    .bind(company_id)
    .bind(input.price_zone_id)
    .bind(input.discount_percent)
    .bind(input.payment_terms_days)
    .execute(conn)
    .await?;
    Ok(())
}

#[utoipa::path(post, path = "/customers", tag = "crm", request_body = CustomerInput,
    responses((status = 201, body = Customer), (status = 409, body = traydcraft_core::error::ErrorBody)))]
async fn create_customer(
    State(state): State<AppState>,
    user: CurrentUser,
    Json(input): Json<CustomerInput>,
) -> AppResult<(StatusCode, Json<Customer>)> {
    user.require(Permission::CustomersWrite)?;
    input.validate()?;
    let id = new_id();
    let mut tx = state.db.begin().await?;
    sqlx::query(
        "INSERT INTO crm.customers (id, code, name, vat_number, email, phone, street, postal_code, city,
                                    country_code, language, active)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)",
    )
    .bind(id)
    .bind(input.code.trim())
    .bind(input.name.trim())
    .bind(&input.vat_number)
    .bind(&input.email)
    .bind(&input.phone)
    .bind(&input.street)
    .bind(&input.postal_code)
    .bind(&input.city)
    .bind(input.country_code.to_uppercase())
    .bind(input.language.to_lowercase())
    .bind(input.active)
    .execute(&mut *tx)
    .await?;
    upsert_terms(&mut tx, user.company_id, id, &input).await?;
    audit::record(
        &mut tx,
        &user,
        "customer",
        id,
        "created",
        serde_json::json!({ "code": input.code }),
    )
    .await?;
    tx.commit().await?;
    Ok((
        StatusCode::CREATED,
        Json(get_customer(&state.db, user.company_id, id).await?),
    ))
}

#[utoipa::path(put, path = "/customers/{id}", tag = "crm", params(("id" = Uuid, Path)),
    request_body = CustomerInput, responses((status = 200, body = Customer)))]
async fn update_customer(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
    Json(input): Json<CustomerInput>,
) -> AppResult<Json<Customer>> {
    user.require(Permission::CustomersWrite)?;
    input.validate()?;
    let mut tx = state.db.begin().await?;
    let updated = sqlx::query(
        "UPDATE crm.customers SET code = $2, name = $3, vat_number = $4, email = $5, phone = $6, street = $7,
                postal_code = $8, city = $9, country_code = $10, language = $11, active = $12, updated_at = now()
         WHERE id = $1",
    )
    .bind(id)
    .bind(input.code.trim())
    .bind(input.name.trim())
    .bind(&input.vat_number)
    .bind(&input.email)
    .bind(&input.phone)
    .bind(&input.street)
    .bind(&input.postal_code)
    .bind(&input.city)
    .bind(input.country_code.to_uppercase())
    .bind(input.language.to_lowercase())
    .bind(input.active)
    .execute(&mut *tx)
    .await?;
    if updated.rows_affected() == 0 {
        return Err(AppError::NotFound("customer"));
    }
    upsert_terms(&mut tx, user.company_id, id, &input).await?;
    audit::record(
        &mut tx,
        &user,
        "customer",
        id,
        "updated",
        serde_json::json!({}),
    )
    .await?;
    tx.commit().await?;
    Ok(Json(get_customer(&state.db, user.company_id, id).await?))
}

pub fn router() -> OpenApiRouter<AppState> {
    OpenApiRouter::new()
        .routes(routes!(list_customers, create_customer))
        .routes(routes!(get_customer_handler, update_customer))
        .merge(contacts::router())
        .merge(opportunities::router())
        .merge(rebates::router())
}
