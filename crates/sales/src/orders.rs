//! Sales orders: a frozen copy of an accepted quotation revision.
//! If the customer wants changes when confirming, a new quotation revision is made first and
//! that revision is converted.

use axum::extract::{Path, Query, State};
use axum::http::StatusCode;
use axum::Json;
use chrono::{DateTime, Datelike, NaiveDate, Utc};
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use sqlx::{FromRow, PgConnection};
use traydcraft_core::{
    audit, new_id, numbering, AppError, AppResult, AppState, CurrentUser, Permission,
};
use utoipa::{IntoParams, ToSchema};
use utoipa_axum::router::OpenApiRouter;
use utoipa_axum::routes;
use uuid::Uuid;

use crate::model::QuotationStatus;
use crate::service;

type ErrorBody = traydcraft_core::error::ErrorBody;

#[derive(Debug, Clone, Serialize, FromRow, ToSchema)]
pub struct OrderSummary {
    pub id: Uuid,
    pub number: String,
    /// confirmed | cancelled
    pub status: String,
    pub quotation_id: Uuid,
    pub quotation_number: String,
    pub quotation_revision: i32,
    pub customer_id: Uuid,
    pub customer_name: String,
    pub customer_reference: String,
    pub order_date: NaiveDate,
    pub currency: String,
    #[schema(value_type = String)]
    pub subtotal: Decimal,
    #[schema(value_type = String)]
    pub total: Decimal,
    pub salesperson_id: Uuid,
    pub salesperson_name: String,
}

#[derive(Debug, Clone, Serialize, FromRow, ToSchema)]
pub struct OrderLine {
    pub position: i32,
    pub product_id: Option<Uuid>,
    pub product_code: String,
    pub description: String,
    pub unit: String,
    #[schema(value_type = String)]
    pub quantity: Decimal,
    #[schema(value_type = String)]
    pub list_unit_price: Decimal,
    #[schema(value_type = String)]
    pub rebate_percent: Decimal,
    #[schema(value_type = String)]
    pub line_discount_percent: Decimal,
    #[schema(value_type = String)]
    pub net_unit_price: Decimal,
    #[schema(value_type = String)]
    pub line_total: Decimal,
    #[schema(value_type = String)]
    pub vat_rate: Decimal,
}

#[derive(Debug, Clone, Serialize, ToSchema)]
pub struct Order {
    pub order: OrderSummary,
    #[schema(value_type = String)]
    pub vat_total: Decimal,
    pub notes: String,
    pub created_at: DateTime<Utc>,
    pub lines: Vec<OrderLine>,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct ConvertInput {
    /// The customer's purchase order number or reference.
    #[serde(default)]
    pub customer_reference: String,
    #[serde(default)]
    pub notes: String,
}

#[derive(Debug, Serialize, ToSchema)]
pub struct OrderPage {
    pub items: Vec<OrderSummary>,
    pub total: i64,
}

#[derive(Debug, Deserialize, IntoParams)]
pub struct ListParams {
    /// Searches order number, quotation number, customer name and customer reference.
    pub q: Option<String>,
    pub customer_id: Option<Uuid>,
    pub limit: Option<i64>,
    pub offset: Option<i64>,
}

const SELECT: &str = "SELECT o.id, o.number, o.status, o.quotation_id, q.number AS quotation_number,
        q.revision AS quotation_revision, o.customer_id, o.customer_name, o.customer_reference, o.order_date,
        o.currency::text AS currency, o.subtotal, o.total, o.salesperson_id, u.display_name AS salesperson_name
     FROM sales.orders o
     JOIN sales.quotations q ON q.id = o.quotation_id
     JOIN core.users u ON u.id = o.salesperson_id";

pub async fn load_order(conn: &mut PgConnection, company_id: Uuid, id: Uuid) -> AppResult<Order> {
    let order: OrderSummary =
        sqlx::query_as(&format!("{SELECT} WHERE o.id = $1 AND o.company_id = $2"))
            .bind(id)
            .bind(company_id)
            .fetch_optional(&mut *conn)
            .await?
            .ok_or(AppError::NotFound("order"))?;
    #[derive(FromRow)]
    struct Extra {
        vat_total: Decimal,
        notes: String,
        created_at: DateTime<Utc>,
    }
    let extra: Extra =
        sqlx::query_as("SELECT vat_total, notes, created_at FROM sales.orders WHERE id = $1")
            .bind(id)
            .fetch_one(&mut *conn)
            .await?;
    let lines = sqlx::query_as(
        "SELECT position, product_id, product_code, description, unit, quantity, list_unit_price, rebate_percent,
                line_discount_percent, net_unit_price, line_total, vat_rate
         FROM sales.order_lines WHERE order_id = $1 ORDER BY position",
    )
    .bind(id)
    .fetch_all(&mut *conn)
    .await?;
    Ok(Order {
        order,
        vat_total: extra.vat_total,
        notes: extra.notes,
        created_at: extra.created_at,
        lines,
    })
}

/// Converts a sent or accepted quotation into a sales order, in the caller's transaction.
/// A sent quotation is marked accepted (and its opportunity won) first.
pub async fn convert_quotation(
    conn: &mut PgConnection,
    user: &CurrentUser,
    quotation_id: Uuid,
    input: &ConvertInput,
) -> AppResult<Uuid> {
    user.require(Permission::OrdersWrite)?;
    let q = service::load_quotation(conn, user.company_id, quotation_id, true).await?;
    let existing: Option<String> =
        sqlx::query_scalar("SELECT number FROM sales.orders WHERE quotation_id = $1")
            .bind(quotation_id)
            .fetch_optional(&mut *conn)
            .await?;
    if let Some(n) = existing {
        return Err(AppError::Conflict(format!(
            "quotation {} is already order {n}",
            q.number
        )));
    }
    match service::status_of(&q) {
        QuotationStatus::Sent => {
            sqlx::query(
                "UPDATE sales.quotations SET status = 'accepted', updated_at = now() WHERE id = $1",
            )
            .bind(quotation_id)
            .execute(&mut *conn)
            .await?;
            audit::record(
                conn,
                user,
                "quotation",
                quotation_id,
                "accepted",
                serde_json::json!({ "from": "sent" }),
            )
            .await?;
            if let Some(opp) = q.opportunity_id {
                traydcraft_crm::opportunities::mark_won(conn, user, opp).await?;
            }
        }
        QuotationStatus::Accepted => {}
        other => {
            return Err(AppError::Conflict(format!(
                "quotation {} rev. {} is {}; only a sent or accepted revision can become an order",
                q.number,
                q.revision,
                other.as_str()
            )))
        }
    }
    let today = traydcraft_core::today();
    let n = numbering::next_number(conn, user.company_id, "order", today.year()).await?;
    let number = format!("SO{}-{n:05}", today.year());
    let id = new_id();
    sqlx::query(
        "INSERT INTO sales.orders (id, company_id, number, quotation_id, customer_id, customer_name, customer_reference,
                                   order_date, currency, subtotal, vat_total, total, salesperson_id, notes, created_by)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)",
    )
    .bind(id)
    .bind(user.company_id)
    .bind(&number)
    .bind(quotation_id)
    .bind(q.customer_id)
    .bind(&q.customer_name)
    .bind(input.customer_reference.trim())
    .bind(today)
    .bind(&q.currency)
    .bind(q.subtotal)
    .bind(q.vat_total)
    .bind(q.total)
    .bind(q.created_by)
    .bind(&input.notes)
    .bind(user.user_id)
    .execute(&mut *conn)
    .await?;
    sqlx::query(
        "INSERT INTO sales.order_lines (id, order_id, position, product_id, product_code, description, unit, quantity,
                list_unit_price, rebate_percent, line_discount_percent, net_unit_price, line_total, vat_rate)
         SELECT gen_random_uuid(), $2, position, product_id, product_code, description, unit, quantity,
                list_unit_price, rebate_percent, line_discount_percent, net_unit_price, line_total, vat_rate
         FROM sales.quotation_lines WHERE quotation_id = $1",
    )
    .bind(quotation_id)
    .bind(id)
    .execute(&mut *conn)
    .await?;
    audit::record(
        conn,
        user,
        "order",
        id,
        "created",
        serde_json::json!({ "number": number, "quotation": q.number, "revision": q.revision }),
    )
    .await?;
    Ok(id)
}

/// Converts a sent or accepted quotation revision into a sales order.
#[utoipa::path(post, path = "/quotations/{id}/convert", tag = "sales", params(("id" = Uuid, Path)),
    request_body = ConvertInput,
    responses((status = 201, body = Order), (status = 409, body = ErrorBody)))]
async fn convert(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
    Json(input): Json<ConvertInput>,
) -> AppResult<(StatusCode, Json<Order>)> {
    let mut tx = state.db.begin().await?;
    let order_id = convert_quotation(&mut tx, &user, id, &input).await?;
    let order = load_order(&mut tx, user.company_id, order_id).await?;
    tx.commit().await?;
    Ok((StatusCode::CREATED, Json(order)))
}

#[utoipa::path(get, path = "/orders", tag = "sales", params(ListParams), responses((status = 200, body = OrderPage)))]
async fn list_orders(
    State(state): State<AppState>,
    user: CurrentUser,
    Query(p): Query<ListParams>,
) -> AppResult<Json<OrderPage>> {
    user.require(Permission::OrdersRead)?;
    let pattern =
        p.q.as_deref()
            .map(|q| format!("%{}%", q.trim().to_lowercase()));
    let filter = "WHERE o.company_id = $1
          AND ($2::text IS NULL OR lower(o.number) LIKE $2 OR lower(q.number) LIKE $2
               OR lower(o.customer_name) LIKE $2 OR lower(o.customer_reference) LIKE $2)
          AND ($3::uuid IS NULL OR o.customer_id = $3)";
    let items = sqlx::query_as(&format!(
        "{SELECT} {filter} ORDER BY o.order_date DESC, o.number DESC LIMIT $4 OFFSET $5"
    ))
    .bind(user.company_id)
    .bind(&pattern)
    .bind(p.customer_id)
    .bind(p.limit.unwrap_or(50).clamp(1, 500))
    .bind(p.offset.unwrap_or(0).max(0))
    .fetch_all(&state.db)
    .await?;
    let total = sqlx::query_scalar(&format!(
        "SELECT count(*) FROM sales.orders o JOIN sales.quotations q ON q.id = o.quotation_id {filter}"
    ))
    .bind(user.company_id)
    .bind(&pattern)
    .bind(p.customer_id)
    .fetch_one(&state.db)
    .await?;
    Ok(Json(OrderPage { items, total }))
}

#[utoipa::path(get, path = "/orders/{id}", tag = "sales", params(("id" = Uuid, Path)),
    responses((status = 200, body = Order), (status = 404, body = ErrorBody)))]
async fn get_order(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
) -> AppResult<Json<Order>> {
    user.require(Permission::OrdersRead)?;
    let mut conn = state.db.acquire().await?;
    Ok(Json(load_order(&mut conn, user.company_id, id).await?))
}

pub fn router() -> OpenApiRouter<AppState> {
    OpenApiRouter::new()
        .routes(routes!(convert))
        .routes(routes!(list_orders))
        .routes(routes!(get_order))
}
