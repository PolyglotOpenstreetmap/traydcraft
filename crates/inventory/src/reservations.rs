//! Reservations of stock for sales order lines, and availability (ATP) on the order.

use std::collections::HashMap;

use axum::extract::{Path, Query, State};
use axum::Json;
use chrono::{DateTime, Utc};
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use sqlx::{FromRow, PgConnection};
use traydcraft_core::{audit, new_id, AppError, AppResult, AppState, CurrentUser, Permission};
use traydcraft_products::get_product;
use utoipa::{IntoParams, ToSchema};
use utoipa_axum::router::OpenApiRouter;
use utoipa_axum::routes;
use uuid::Uuid;

use crate::ledger::to_stock_quantity;

type ErrorBody = traydcraft_core::error::ErrorBody;

/// Order statuses in which stock can be reserved (the customer has confirmed).
const RESERVABLE: [&str; 5] = [
    "confirmed",
    "in_planning",
    "planned",
    "in_production",
    "ready_for_shipping",
];

#[derive(Debug, Serialize, FromRow, ToSchema)]
pub struct Allocation {
    pub id: Uuid,
    pub location_id: Uuid,
    pub location: String,
    pub lot_id: Option<Uuid>,
    pub lot_number: Option<String>,
    #[schema(value_type = String)]
    pub quantity: Decimal,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Serialize, ToSchema)]
pub struct LineReservation {
    pub order_line_id: Uuid,
    pub product_id: Uuid,
    pub product_code: String,
    /// Ordered quantity in the stock unit of the product.
    #[schema(value_type = String)]
    pub ordered: Decimal,
    #[schema(value_type = String)]
    pub reserved: Decimal,
    pub allocations: Vec<Allocation>,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct ReserveInput {
    /// The quantity that should be reserved for the line in total, in the stock unit of the
    /// product. More reserves additional stock, less releases the newest allocations, 0 releases all.
    #[schema(value_type = String, example = "5")]
    pub quantity: Decimal,
    /// Take additional stock only from this warehouse...
    pub warehouse_id: Option<Uuid>,
    /// ...or this location...
    pub location_id: Option<Uuid>,
    /// ...or this lot.
    pub lot_id: Option<Uuid>,
}

#[derive(FromRow)]
struct LineInfo {
    order_id: Uuid,
    order_number: String,
    order_status: String,
    product_id: Option<Uuid>,
    quantity: Decimal,
    unit: String,
    is_current: bool,
}

async fn load_line(
    conn: &mut PgConnection,
    company_id: Uuid,
    line_id: Uuid,
) -> AppResult<LineInfo> {
    sqlx::query_as(
        "SELECT o.id AS order_id, o.number AS order_number, o.status AS order_status, ol.product_id, ol.quantity,
                ol.unit, (ol.revision = COALESCE(o.confirmed_revision, o.current_revision)) AS is_current
         FROM sales.order_lines ol JOIN sales.orders o ON o.id = ol.order_id
         WHERE ol.id = $1 AND o.company_id = $2",
    )
    .bind(line_id)
    .bind(company_id)
    .fetch_optional(conn)
    .await?
    .ok_or(AppError::NotFound("order line"))
}

async fn allocations(
    conn: &mut PgConnection,
    company_id: Uuid,
    line_id: Uuid,
) -> AppResult<Vec<Allocation>> {
    Ok(sqlx::query_as(
        "SELECT r.id, r.location_id, w.code || '/' || l.code AS location, r.lot_id, lot.lot_number, r.quantity, r.created_at
         FROM inventory.reservations r
         JOIN inventory.locations l ON l.id = r.location_id
         JOIN inventory.warehouses w ON w.id = l.warehouse_id
         LEFT JOIN inventory.lots lot ON lot.id = r.lot_id
         WHERE r.company_id = $1 AND r.order_line_id = $2 AND r.status = 'active'
         ORDER BY r.created_at, r.id",
    )
    .bind(company_id)
    .bind(line_id)
    .fetch_all(conn)
    .await?)
}

async fn line_reservation(
    conn: &mut PgConnection,
    company_id: Uuid,
    line_id: Uuid,
) -> AppResult<LineReservation> {
    let line = load_line(conn, company_id, line_id).await?;
    let product_id = line
        .product_id
        .ok_or_else(|| AppError::Validation("this order line has no product".into()))?;
    let product = get_product(&mut *conn, product_id).await?;
    let ordered = ordered_in_stock_unit(conn, &product, &line).await?;
    let allocations = allocations(conn, company_id, line_id).await?;
    Ok(LineReservation {
        order_line_id: line_id,
        product_id,
        product_code: product.code,
        ordered,
        reserved: allocations.iter().map(|a| a.quantity).sum(),
        allocations,
    })
}

/// The ordered quantity in the stock unit of the product. A line in a unit that does not convert
/// is an error, never a guess.
async fn ordered_in_stock_unit(
    conn: &mut PgConnection,
    product: &traydcraft_products::Product,
    line: &LineInfo,
) -> AppResult<Decimal> {
    Ok(to_stock_quantity(conn, product, line.quantity, Some(&line.unit))
        .await?
        .0)
}

#[utoipa::path(get, path = "/inventory/order-lines/{id}/reservation", tag = "inventory", params(("id" = Uuid, Path)),
    responses((status = 200, body = LineReservation), (status = 404, body = ErrorBody)))]
async fn get_reservation(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
) -> AppResult<Json<LineReservation>> {
    user.require(Permission::InventoryRead)?;
    let mut conn = state.db.acquire().await?;
    Ok(Json(
        line_reservation(&mut conn, user.company_id, id).await?,
    ))
}

/// Sets how much stock is reserved for an order line. Idempotent: the same call twice changes
/// nothing the second time.
#[utoipa::path(put, path = "/inventory/order-lines/{id}/reservation", tag = "inventory", params(("id" = Uuid, Path)),
    request_body = ReserveInput,
    responses((status = 200, body = LineReservation), (status = 409, body = ErrorBody), (status = 422, body = ErrorBody)))]
async fn set_reservation(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(line_id): Path<Uuid>,
    Json(input): Json<ReserveInput>,
) -> AppResult<Json<LineReservation>> {
    user.require(Permission::InventoryWrite)?;
    if input.quantity < Decimal::ZERO || input.quantity.round_dp(4) != input.quantity {
        return Err(AppError::Validation(
            "quantity must be 0 or more, with at most 4 decimals".into(),
        ));
    }
    let mut tx = state.db.begin().await?;
    let line = load_line(&mut tx, user.company_id, line_id).await?;
    let product_id = line
        .product_id
        .ok_or_else(|| AppError::Validation("this order line has no product".into()))?;
    let product = get_product(&mut *tx, product_id).await?;
    if product.product_type == "service" {
        return Err(AppError::Validation(format!(
            "{} is a service and is not stocked",
            product.code
        )));
    }
    let ordered = ordered_in_stock_unit(&mut tx, &product, &line).await?;

    // Serialise reservations and moves on this product.
    sqlx::query("SELECT id FROM inventory.stock_balances WHERE company_id = $1 AND product_id = $2 ORDER BY id FOR UPDATE")
        .bind(user.company_id)
        .bind(product_id)
        .execute(&mut *tx)
        .await?;

    let current: Vec<Allocation> = allocations(&mut tx, user.company_id, line_id).await?;
    let have: Decimal = current.iter().map(|a| a.quantity).sum();
    let want = input.quantity;
    if want > have {
        if !RESERVABLE.contains(&line.order_status.as_str()) || !line.is_current {
            return Err(AppError::Conflict(format!(
                "order {} is {}; stock can be reserved once the customer has confirmed it",
                line.order_number, line.order_status
            )));
        }
        if want > ordered {
            return Err(AppError::Validation(format!(
                "the line asks for {} {}; cannot reserve {}",
                ordered.normalize(),
                product.unit,
                want.normalize()
            )));
        }
        allocate(&mut tx, &user, line_id, product_id, want - have, &input).await?;
    } else if want < have {
        release_newest(&mut tx, &user, line_id, have - want).await?;
    }
    audit::record(
        &mut tx,
        &user,
        "order_line",
        line_id,
        "reservation_set",
        serde_json::json!({ "order_id": line.order_id, "product_id": product_id, "from": have, "to": want }),
    )
    .await?;
    let result = line_reservation(&mut tx, user.company_id, line_id).await?;
    tx.commit().await?;
    Ok(Json(result))
}

#[derive(FromRow)]
struct Candidate {
    location_id: Uuid,
    lot_id: Option<Uuid>,
    free: Decimal,
}

async fn allocate(
    conn: &mut PgConnection,
    user: &CurrentUser,
    line_id: Uuid,
    product_id: Uuid,
    mut needed: Decimal,
    input: &ReserveInput,
) -> AppResult<()> {
    let candidates: Vec<Candidate> = sqlx::query_as(
        "SELECT b.location_id, b.lot_id, b.quantity - COALESCE(res.q, 0) AS free
         FROM inventory.stock_balances b
         JOIN inventory.locations l ON l.id = b.location_id AND l.kind = 'internal' AND l.active
         JOIN inventory.warehouses w ON w.id = l.warehouse_id AND w.active
         LEFT JOIN inventory.lots lot ON lot.id = b.lot_id
         LEFT JOIN (
             SELECT location_id, lot_id, sum(quantity) AS q FROM inventory.reservations
             WHERE company_id = $1 AND product_id = $2 AND status = 'active' GROUP BY location_id, lot_id
         ) res ON res.location_id = b.location_id AND res.lot_id IS NOT DISTINCT FROM b.lot_id
         WHERE b.company_id = $1 AND b.product_id = $2
           AND ($3::uuid IS NULL OR w.id = $3) AND ($4::uuid IS NULL OR l.id = $4) AND ($5::uuid IS NULL OR b.lot_id = $5)
           AND (w.kind = 'warehouse' OR $3::uuid IS NOT NULL OR $4::uuid IS NOT NULL)
           AND (lot.expiry_date IS NULL OR lot.expiry_date >= current_date)
           AND b.quantity - COALESCE(res.q, 0) > 0
         ORDER BY lot.expiry_date NULLS LAST, w.code, l.code
         FOR UPDATE OF b",
    )
    .bind(user.company_id)
    .bind(product_id)
    .bind(input.warehouse_id)
    .bind(input.location_id)
    .bind(input.lot_id)
    .fetch_all(&mut *conn)
    .await?;
    let free_total: Decimal = candidates.iter().map(|c| c.free).sum();
    if free_total < needed {
        return Err(AppError::Conflict(format!(
            "only {} available to reserve, {} needed",
            free_total.normalize(),
            needed.normalize()
        )));
    }
    for c in candidates {
        if needed <= Decimal::ZERO {
            break;
        }
        let take = c.free.min(needed);
        sqlx::query(
            "INSERT INTO inventory.reservations (id, company_id, order_line_id, product_id, location_id, lot_id, quantity, created_by)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8)",
        )
        .bind(new_id())
        .bind(user.company_id)
        .bind(line_id)
        .bind(product_id)
        .bind(c.location_id)
        .bind(c.lot_id)
        .bind(take)
        .bind(user.user_id)
        .execute(&mut *conn)
        .await?;
        needed -= take;
    }
    Ok(())
}

async fn release_newest(
    conn: &mut PgConnection,
    user: &CurrentUser,
    line_id: Uuid,
    mut to_release: Decimal,
) -> AppResult<()> {
    let rows: Vec<(Uuid, Decimal)> = sqlx::query_as(
        "SELECT id, quantity FROM inventory.reservations
         WHERE company_id = $1 AND order_line_id = $2 AND status = 'active'
         ORDER BY created_at DESC, id DESC FOR UPDATE",
    )
    .bind(user.company_id)
    .bind(line_id)
    .fetch_all(&mut *conn)
    .await?;
    for (id, quantity) in rows {
        if to_release <= Decimal::ZERO {
            break;
        }
        if quantity <= to_release {
            sqlx::query("UPDATE inventory.reservations SET status = 'released', closed_at = now(), closed_by = $2 WHERE id = $1")
                .bind(id)
                .bind(user.user_id)
                .execute(&mut *conn)
                .await?;
            to_release -= quantity;
        } else {
            sqlx::query("UPDATE inventory.reservations SET quantity = quantity - $2 WHERE id = $1")
                .bind(id)
                .bind(to_release)
                .execute(&mut *conn)
                .await?;
            to_release = Decimal::ZERO;
        }
    }
    Ok(())
}

/// Releases every active reservation of an order, for example when it is cancelled. Runs in the
/// caller's transaction; returns the number of allocations released.
pub async fn release_for_order(
    conn: &mut PgConnection,
    company_id: Uuid,
    order_id: Uuid,
    user_id: Option<Uuid>,
) -> Result<u64, sqlx::Error> {
    let done = sqlx::query(
        "UPDATE inventory.reservations r SET status = 'released', closed_at = now(), closed_by = $3
         FROM sales.order_lines ol
         WHERE ol.id = r.order_line_id AND ol.order_id = $2 AND r.company_id = $1 AND r.status = 'active'",
    )
    .bind(company_id)
    .bind(order_id)
    .bind(user_id)
    .execute(conn)
    .await?;
    Ok(done.rows_affected())
}

// -------------------------------------------------------------------------------------------
// Reservation list and availability on the order
// -------------------------------------------------------------------------------------------

#[derive(Debug, Serialize, FromRow, ToSchema)]
pub struct ReservationRow {
    pub id: Uuid,
    pub order_id: Uuid,
    pub order_number: String,
    pub customer_name: String,
    pub order_line_id: Uuid,
    pub position: i32,
    pub product_id: Uuid,
    pub product_code: String,
    pub location: String,
    pub lot_number: Option<String>,
    #[schema(value_type = String)]
    pub quantity: Decimal,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Deserialize, IntoParams)]
pub struct ReservationParams {
    pub product_id: Option<Uuid>,
    pub order_id: Option<Uuid>,
}

/// Active reservations, for example to see which orders hold a product.
#[utoipa::path(get, path = "/inventory/reservations", tag = "inventory", params(ReservationParams),
    responses((status = 200, body = Vec<ReservationRow>)))]
async fn list_reservations(
    State(state): State<AppState>,
    user: CurrentUser,
    Query(p): Query<ReservationParams>,
) -> AppResult<Json<Vec<ReservationRow>>> {
    user.require(Permission::InventoryRead)?;
    Ok(Json(
        sqlx::query_as(
            "SELECT r.id, o.id AS order_id, o.number AS order_number, c.name AS customer_name, r.order_line_id,
                    ol.position, r.product_id, pr.code AS product_code, w.code || '/' || l.code AS location,
                    lot.lot_number, r.quantity, r.created_at
             FROM inventory.reservations r
             JOIN sales.order_lines ol ON ol.id = r.order_line_id
             JOIN sales.orders o ON o.id = ol.order_id
             JOIN crm.customers c ON c.id = o.customer_id
             JOIN products.products pr ON pr.id = r.product_id
             JOIN inventory.locations l ON l.id = r.location_id
             JOIN inventory.warehouses w ON w.id = l.warehouse_id
             LEFT JOIN inventory.lots lot ON lot.id = r.lot_id
             WHERE r.company_id = $1 AND r.status = 'active'
               AND ($2::uuid IS NULL OR r.product_id = $2) AND ($3::uuid IS NULL OR o.id = $3)
             ORDER BY o.number, ol.position, r.created_at LIMIT 500",
        )
        .bind(user.company_id)
        .bind(p.product_id)
        .bind(p.order_id)
        .fetch_all(&state.db)
        .await?,
    ))
}

#[derive(Debug, Serialize, ToSchema)]
pub struct LineAvailability {
    pub order_line_id: Uuid,
    pub position: i32,
    pub product_id: Option<Uuid>,
    pub product_code: String,
    pub description: String,
    pub unit: String,
    /// Ordered quantity, in the unit of the line.
    #[schema(value_type = String)]
    pub ordered: Decimal,
    /// Reserved for this line, in the stock unit.
    #[schema(value_type = String)]
    pub reserved: Decimal,
    /// In the warehouses.
    #[schema(value_type = String)]
    pub on_hand: Decimal,
    /// Reserved for all orders.
    #[schema(value_type = String)]
    pub reserved_total: Decimal,
    /// Available to promise: on hand minus everything reserved.
    #[schema(value_type = String)]
    pub available: Decimal,
    /// What neither the reservation nor free stock covers.
    #[schema(value_type = String)]
    pub shortfall: Decimal,
    /// reserved | available | partial | short | not_stocked
    pub state: String,
}

#[derive(Debug, Serialize, ToSchema)]
pub struct OrderAvailability {
    pub order_id: Uuid,
    pub order_number: String,
    pub order_status: String,
    /// Stock can be reserved: the customer has confirmed and the order is not cancelled.
    pub reservable: bool,
    pub lines: Vec<LineAvailability>,
}

#[derive(FromRow)]
struct OrderLineRow {
    id: Uuid,
    position: i32,
    product_id: Option<Uuid>,
    product_code: String,
    description: String,
    unit: String,
    quantity: Decimal,
    product_type: Option<String>,
}

/// Availability (ATP) of every line of the order: what is in the warehouses, what is reserved,
/// and what this order's lines still lack. Van stock is not counted.
#[utoipa::path(get, path = "/inventory/orders/{id}/availability", tag = "inventory", params(("id" = Uuid, Path)),
    responses((status = 200, body = OrderAvailability), (status = 404, body = ErrorBody)))]
async fn order_availability(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(order_id): Path<Uuid>,
) -> AppResult<Json<OrderAvailability>> {
    user.require(Permission::InventoryRead)?;
    let mut conn = state.db.acquire().await?;
    let head: Option<(String, String)> =
        sqlx::query_as("SELECT number, status FROM sales.orders WHERE id = $1 AND company_id = $2")
            .bind(order_id)
            .bind(user.company_id)
            .fetch_optional(&mut *conn)
            .await?;
    let (number, status) = head.ok_or(AppError::NotFound("order"))?;
    let lines: Vec<OrderLineRow> = sqlx::query_as(
        "SELECT ol.id, ol.position, ol.product_id, ol.product_code, ol.description, ol.unit, ol.quantity,
                p.product_type
         FROM sales.order_lines ol JOIN sales.orders o ON o.id = ol.order_id
         LEFT JOIN products.products p ON p.id = ol.product_id
         WHERE o.id = $1 AND ol.revision = COALESCE(o.confirmed_revision, o.current_revision)
         ORDER BY ol.position",
    )
    .bind(order_id)
    .fetch_all(&mut *conn)
    .await?;
    let ids: Vec<Uuid> = lines.iter().filter_map(|l| l.product_id).collect();
    let on_hand: HashMap<Uuid, Decimal> = sqlx::query_as::<_, (Uuid, Decimal)>(
        "SELECT b.product_id, sum(b.quantity) FROM inventory.stock_balances b
         JOIN inventory.locations l ON l.id = b.location_id AND l.kind = 'internal'
         JOIN inventory.warehouses w ON w.id = l.warehouse_id AND w.kind = 'warehouse'
         WHERE b.company_id = $1 AND b.product_id = ANY($2) GROUP BY b.product_id",
    )
    .bind(user.company_id)
    .bind(&ids)
    .fetch_all(&mut *conn)
    .await?
    .into_iter()
    .collect();
    let reserved: HashMap<Uuid, Decimal> = sqlx::query_as::<_, (Uuid, Decimal)>(
        "SELECT r.product_id, sum(r.quantity) FROM inventory.reservations r
         JOIN inventory.locations l ON l.id = r.location_id
         JOIN inventory.warehouses w ON w.id = l.warehouse_id AND w.kind = 'warehouse'
         WHERE r.company_id = $1 AND r.status = 'active' AND r.product_id = ANY($2) GROUP BY r.product_id",
    )
    .bind(user.company_id)
    .bind(&ids)
    .fetch_all(&mut *conn)
    .await?
    .into_iter()
    .collect();
    let own: HashMap<Uuid, Decimal> = sqlx::query_as::<_, (Uuid, Decimal)>(
        "SELECT r.order_line_id, sum(r.quantity) FROM inventory.reservations r
         JOIN sales.order_lines ol ON ol.id = r.order_line_id
         WHERE r.company_id = $1 AND r.status = 'active' AND ol.order_id = $2 GROUP BY r.order_line_id",
    )
    .bind(user.company_id)
    .bind(order_id)
    .fetch_all(&mut *conn)
    .await?
    .into_iter()
    .collect();

    let mut out = Vec::new();
    for l in lines {
        let stocked =
            l.product_id.is_some() && l.product_type.as_deref().is_some_and(|t| t != "service");
        let mut item = LineAvailability {
            order_line_id: l.id,
            position: l.position,
            product_id: l.product_id,
            product_code: l.product_code,
            description: l.description,
            unit: l.unit.clone(),
            ordered: l.quantity,
            reserved: Decimal::ZERO,
            on_hand: Decimal::ZERO,
            reserved_total: Decimal::ZERO,
            available: Decimal::ZERO,
            shortfall: Decimal::ZERO,
            state: "not_stocked".into(),
        };
        if stocked {
            let pid = l.product_id.unwrap();
            let product = get_product(&mut *conn, pid).await?;
            let (needed, _) =
                to_stock_quantity(&mut conn, &product, l.quantity, Some(&l.unit)).await?;
            item.on_hand = on_hand.get(&pid).copied().unwrap_or_default();
            item.reserved_total = reserved.get(&pid).copied().unwrap_or_default();
            item.available = item.on_hand - item.reserved_total;
            item.reserved = own.get(&l.id).copied().unwrap_or_default();
            let open = (needed - item.reserved).max(Decimal::ZERO);
            let free = item.available.max(Decimal::ZERO);
            item.shortfall = (open - free).max(Decimal::ZERO);
            item.state = if open.is_zero() {
                "reserved"
            } else if item.shortfall.is_zero() {
                "available"
            } else if free.is_zero() && item.reserved.is_zero() {
                "short"
            } else {
                "partial"
            }
            .into();
        }
        out.push(item);
    }
    Ok(Json(OrderAvailability {
        order_id,
        order_number: number,
        reservable: RESERVABLE.contains(&status.as_str()),
        order_status: status,
        lines: out,
    }))
}

pub fn router() -> OpenApiRouter<AppState> {
    OpenApiRouter::new()
        .routes(routes!(get_reservation, set_reservation))
        .routes(routes!(list_reservations))
        .routes(routes!(order_availability))
}
