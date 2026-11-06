//! Inventory: the stock ledger and its invariants, units of measure, lots, serial units,
//! transfers, counts, reservations and availability, cost visibility and company isolation.

mod common;

use axum::http::{Method, StatusCode};
use common::{call, dec, setup};
use rust_decimal::Decimal;
use serde_json::{json, Value};
use sqlx::PgPool;
use uuid::Uuid;

const ADMIN: &str = "admin@example.com";
const SALES: &str = "sales@example.com";
const VIEWER: &str = "viewer@example.com";
const STORES: &str = "stores@example.com"; // role warehouse
const PM: &str = "pm@example.com"; // role product_manager
const TECH: &str = "technician@example.com";
const COMPANY: &str = "00000000-0000-7000-8000-000000000001";
const ALPHA: &str = "00000000-0000-7000-8000-000000000401";
const FRAME: &str = "00000000-0000-7000-8000-000000000307"; // pcs, no tracking
const PROFILE: &str = "00000000-0000-7000-8000-000000000308"; // metres
const BOLT: &str = "00000000-0000-7000-8000-000000000309"; // pcs, made lot-tracked in tests
const PUMP: &str = "00000000-0000-7000-8000-000000000303"; // serial
const CTRL: &str = "00000000-0000-7000-8000-000000000310"; // serial
const UNIT_100: &str = "00000000-0000-7000-8000-000000000301"; // serial
const SERVICE: &str = "00000000-0000-7000-8000-000000000305";

fn uid() -> String {
    Uuid::now_v7().to_string()
}

async fn add_user(db: &PgPool, email: &str, role: &str) {
    let id = Uuid::now_v7();
    sqlx::query("INSERT INTO core.users (id, email, display_name) VALUES ($1, $2, $3)")
        .bind(id)
        .bind(email)
        .bind(email)
        .execute(db)
        .await
        .unwrap();
    sqlx::query("INSERT INTO core.user_companies (user_id, company_id, roles, is_default) VALUES ($1, $2::uuid, $3, true)")
        .bind(id)
        .bind(COMPANY)
        .bind(vec![role.to_string()])
        .execute(db)
        .await
        .unwrap();
}

async fn api(
    app: &axum::Router,
    user: &str,
    method: Method,
    uri: &str,
    body: Option<Value>,
) -> (StatusCode, Value) {
    call(app, user, method, &format!("/api/v1{uri}"), body).await
}
async fn post(app: &axum::Router, user: &str, uri: &str, body: Value) -> (StatusCode, Value) {
    api(app, user, Method::POST, uri, Some(body)).await
}
async fn get(app: &axum::Router, user: &str, uri: &str) -> (StatusCode, Value) {
    api(app, user, Method::GET, uri, None).await
}

struct Env {
    app: axum::Router,
    db: PgPool,
    /// Main warehouse WH1 and its default location MAIN.
    wh: String,
    main: String,
}

async fn env(db: PgPool) -> Env {
    let app = setup(db.clone()).await;
    add_user(&db, STORES, "warehouse").await;
    add_user(&db, PM, "product_manager").await;
    let (status, w) = post(
        &app,
        ADMIN,
        "/inventory/warehouses",
        json!({ "code": "WH1", "name": "Main warehouse" }),
    )
    .await;
    assert_eq!(status, StatusCode::CREATED, "{w}");
    Env {
        app,
        db,
        wh: w["id"].as_str().unwrap().into(),
        main: w["locations"][0]["id"].as_str().unwrap().into(),
    }
}

impl Env {
    async fn location(&self, code: &str) -> String {
        let (status, l) = post(
            &self.app,
            ADMIN,
            "/inventory/locations",
            json!({ "warehouse_id": self.wh, "code": code }),
        )
        .await;
        assert_eq!(status, StatusCode::CREATED, "{l}");
        l["id"].as_str().unwrap().into()
    }

    async fn receive(&self, product: &str, location: &str, quantity: &str) -> Value {
        let (status, m) = post(
            &self.app,
            STORES,
            "/inventory/receipts",
            json!({ "id": uid(), "product_id": product, "location_id": location, "quantity": quantity }),
        )
        .await;
        assert_eq!(status, StatusCode::CREATED, "{m}");
        m
    }

    async fn issue(&self, product: &str, location: &str, quantity: &str) -> (StatusCode, Value) {
        post(
            &self.app,
            STORES,
            "/inventory/issues",
            json!({ "id": uid(), "product_id": product, "location_id": location, "quantity": quantity }),
        )
        .await
    }

    /// (on hand, reserved, available) of a product in the warehouses.
    async fn totals(&self, product: &str) -> (Decimal, Decimal, Decimal) {
        let (status, p) = get(
            &self.app,
            ADMIN,
            &format!("/inventory/stock/products?product_id={product}"),
        )
        .await;
        assert_eq!(status, StatusCode::OK, "{p}");
        let i = &p["items"][0];
        (
            dec(&i["on_hand"]),
            dec(&i["reserved"]),
            dec(&i["available"]),
        )
    }

    async fn integrity_ok(&self) {
        let (status, i) = get(&self.app, ADMIN, "/inventory/integrity").await;
        assert_eq!(status, StatusCode::OK, "{i}");
        assert_eq!(i["ok"], true, "balances differ from the ledger: {i}");
    }
}

fn q(s: &str) -> Decimal {
    s.parse().unwrap()
}

// ---------------------------------------------------------------------------------------------
// Setup
// ---------------------------------------------------------------------------------------------

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn warehouses_locations_and_vans_are_maintained_by_the_admin(db: PgPool) {
    let e = env(db).await;
    // A van belongs to a technician and has its own location.
    let tech: Uuid = sqlx::query_scalar("SELECT id FROM core.users WHERE email = $1")
        .bind(TECH)
        .fetch_one(&e.db)
        .await
        .unwrap();
    let (status, van) = post(
        &e.app,
        ADMIN,
        "/inventory/warehouses",
        json!({ "code": "VAN-TOM", "name": "Van of Tom", "kind": "van", "assigned_user_id": tech }),
    )
    .await;
    assert_eq!(status, StatusCode::CREATED, "{van}");
    assert_eq!(van["kind"], "van");
    assert_eq!(van["locations"][0]["code"], "VAN");
    let (status, _) = post(
        &e.app,
        ADMIN,
        "/inventory/warehouses",
        json!({ "code": "WH1", "name": "again" }),
    )
    .await;
    assert_eq!(status, StatusCode::CONFLICT);
    let (status, _) = post(
        &e.app,
        ADMIN,
        "/inventory/warehouses",
        json!({ "code": "X", "name": "x", "assigned_user_id": tech }),
    )
    .await;
    assert_eq!(
        status,
        StatusCode::UNPROCESSABLE_ENTITY,
        "only a van has an assignee"
    );

    let shelf = e.location("A-01").await;
    let (_, list) = get(&e.app, SALES, "/inventory/warehouses").await;
    assert_eq!(list.as_array().unwrap().len(), 2);
    assert_eq!(list[1]["code"], "WH1");
    assert_eq!(list[1]["locations"].as_array().unwrap().len(), 2);

    // Only the admin changes the structure.
    for who in [STORES, SALES, VIEWER, PM] {
        let (status, _) = post(
            &e.app,
            who,
            "/inventory/locations",
            json!({ "warehouse_id": e.wh, "code": "Z" }),
        )
        .await;
        assert_eq!(status, StatusCode::FORBIDDEN, "{who}");
    }
    let (status, _) = get(&e.app, TECH, "/inventory/warehouses").await;
    assert_eq!(
        status,
        StatusCode::FORBIDDEN,
        "technicians have no inventory access yet"
    );

    // A location or warehouse with stock cannot be deactivated.
    e.receive(FRAME, &shelf, "3").await;
    let (status, r) = api(
        &e.app,
        ADMIN,
        Method::PUT,
        &format!("/inventory/locations/{shelf}"),
        Some(json!({ "code": "A-01", "active": false })),
    )
    .await;
    assert_eq!(status, StatusCode::CONFLICT, "{r}");
    let (status, _) = api(
        &e.app,
        ADMIN,
        Method::PUT,
        &format!("/inventory/warehouses/{}", e.wh),
        Some(json!({ "code": "WH1", "name": "Main", "active": false })),
    )
    .await;
    assert_eq!(status, StatusCode::CONFLICT);
    e.issue(FRAME, &shelf, "3").await;
    let (status, r) = api(
        &e.app,
        ADMIN,
        Method::PUT,
        &format!("/inventory/locations/{shelf}"),
        Some(json!({ "code": "A-01", "active": false })),
    )
    .await;
    assert_eq!(status, StatusCode::OK, "{r}");
    // ...and an inactive location takes no more stock.
    let (status, _) = post(
        &e.app,
        STORES,
        "/inventory/receipts",
        json!({ "id": uid(), "product_id": FRAME, "location_id": shelf, "quantity": "1" }),
    )
    .await;
    assert_eq!(status, StatusCode::UNPROCESSABLE_ENTITY);
}

// ---------------------------------------------------------------------------------------------
// Ledger invariants
// ---------------------------------------------------------------------------------------------

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn balance_equals_the_sum_of_moves_and_every_product_nets_to_zero(db: PgPool) {
    let e = env(db).await;
    let b = e.location("B-01").await;
    e.receive(FRAME, &e.main, "10").await;
    e.issue(FRAME, &e.main, "4").await;
    let (status, t) = post(&e.app, STORES, "/inventory/transfers", json!({ "id": uid(), "product_id": FRAME, "from_location_id": e.main, "to_location_id": b, "quantity": "2.5" })).await;
    assert_eq!(status, StatusCode::CREATED, "{t}");
    assert_eq!(t["kind"], "transfer");

    assert_eq!(e.totals(FRAME).await.0, q("6"));
    let (_, rows) = get(
        &e.app,
        SALES,
        &format!("/inventory/stock?product_id={FRAME}"),
    )
    .await;
    let by_loc: Vec<(String, Decimal)> = rows["items"]
        .as_array()
        .unwrap()
        .iter()
        .map(|r| {
            (
                r["location"].as_str().unwrap().to_string(),
                dec(&r["on_hand"]),
            )
        })
        .collect();
    assert_eq!(
        by_loc,
        vec![
            ("WH1/B-01".to_string(), q("2.5")),
            ("WH1/MAIN".to_string(), q("3.5"))
        ]
    );

    // The projection equals the ledger, row by row...
    let mismatches: i64 = sqlx::query_scalar(
        "SELECT count(*) FROM inventory.stock_balances b WHERE b.quantity <> (
             SELECT COALESCE(sum(CASE WHEN m.to_location_id = b.location_id THEN m.quantity ELSE -m.quantity END), 0)
             FROM inventory.stock_moves m WHERE m.product_id = b.product_id
               AND (m.to_location_id = b.location_id OR m.from_location_id = b.location_id)
               AND m.lot_id IS NOT DISTINCT FROM b.lot_id)",
    )
    .fetch_one(&e.db)
    .await
    .unwrap();
    assert_eq!(mismatches, 0);
    // ...and with the virtual locations every product nets to zero (double entry).
    let net: Decimal = sqlx::query_scalar("SELECT COALESCE(sum(quantity), 0) FROM inventory.stock_balances WHERE product_id = $1::uuid")
        .bind(FRAME)
        .fetch_one(&e.db)
        .await
        .unwrap();
    assert_eq!(net, Decimal::ZERO);
    e.integrity_ok().await;
}

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn the_ledger_is_append_only(db: PgPool) {
    let e = env(db).await;
    e.receive(FRAME, &e.main, "5").await;
    let update = sqlx::query("UPDATE inventory.stock_moves SET quantity = 99")
        .execute(&e.db)
        .await;
    assert!(update.is_err(), "UPDATE must be refused");
    let delete = sqlx::query("DELETE FROM inventory.stock_moves")
        .execute(&e.db)
        .await;
    assert!(delete.is_err(), "DELETE must be refused");
    let truncate = sqlx::query("TRUNCATE inventory.stock_moves CASCADE")
        .execute(&e.db)
        .await;
    assert!(truncate.is_err(), "TRUNCATE must be refused");
    assert_eq!(e.totals(FRAME).await.0, q("5"));
}

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn stock_cannot_go_negative(db: PgPool) {
    let e = env(db).await;
    e.receive(FRAME, &e.main, "2").await;
    let (status, r) = e.issue(FRAME, &e.main, "3").await;
    assert_eq!(status, StatusCode::CONFLICT, "{r}");
    assert!(
        r["message"].as_str().unwrap().contains("not enough stock"),
        "{r}"
    );
    let (status, _) = e.issue(FRAME, &e.main, "0").await;
    assert_eq!(status, StatusCode::UNPROCESSABLE_ENTITY);
    let (status, _) = e.issue(FRAME, &e.main, "1.00001").await;
    assert_eq!(
        status,
        StatusCode::UNPROCESSABLE_ENTITY,
        "four decimals at most"
    );
    let (status, _) = post(
        &e.app,
        STORES,
        "/inventory/receipts",
        json!({ "id": uid(), "product_id": SERVICE, "location_id": e.main, "quantity": "1" }),
    )
    .await;
    assert_eq!(
        status,
        StatusCode::UNPROCESSABLE_ENTITY,
        "services are not stocked"
    );
    assert_eq!(e.totals(FRAME).await.0, q("2"));
    e.integrity_ok().await;
}

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn a_retry_with_the_same_id_changes_nothing_and_a_clash_is_refused(db: PgPool) {
    let e = env(db).await;
    let id = uid();
    let body = json!({ "id": id, "product_id": FRAME, "location_id": e.main, "quantity": "7" });
    let (s1, m1) = post(&e.app, STORES, "/inventory/receipts", body.clone()).await;
    let (s2, m2) = post(&e.app, STORES, "/inventory/receipts", body.clone()).await;
    assert_eq!((s1, s2), (StatusCode::CREATED, StatusCode::OK));
    assert_eq!(m1["id"], m2["id"]);
    assert_eq!(m1["seq"], m2["seq"]);
    assert_eq!(e.totals(FRAME).await.0, q("7"));
    let n: i64 = sqlx::query_scalar("SELECT count(*) FROM inventory.stock_moves")
        .fetch_one(&e.db)
        .await
        .unwrap();
    assert_eq!(n, 1);

    // Same id, different content.
    let (status, r) = post(
        &e.app,
        STORES,
        "/inventory/receipts",
        json!({ "id": id, "product_id": FRAME, "location_id": e.main, "quantity": "8" }),
    )
    .await;
    assert_eq!(status, StatusCode::CONFLICT, "{r}");
    // Same id used for another kind of move.
    let (status, _) = post(
        &e.app,
        STORES,
        "/inventory/issues",
        json!({ "id": id, "product_id": FRAME, "location_id": e.main, "quantity": "7" }),
    )
    .await;
    assert_eq!(status, StatusCode::CONFLICT);
    assert_eq!(e.totals(FRAME).await.0, q("7"));
}

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn a_correction_is_a_reversal_move_and_the_original_stays(db: PgPool) {
    let e = env(db).await;
    e.receive(FRAME, &e.main, "10").await;
    let (_, issued) = e.issue(FRAME, &e.main, "4").await;
    let issued_id = issued["id"].as_str().unwrap();
    assert_eq!(e.totals(FRAME).await.0, q("6"));

    let rid = uid();
    let (status, r) = post(
        &e.app,
        ADMIN,
        &format!("/inventory/moves/{issued_id}/reverse"),
        json!({ "id": rid, "note": "wrong product picked" }),
    )
    .await;
    assert_eq!(status, StatusCode::CREATED, "{r}");
    assert_eq!(r["reversed_of"], issued_id);
    assert_eq!(r["reason"], "reversal");
    assert_eq!(r["from_location_id"], issued["to_location_id"]);
    assert_eq!(r["to_location_id"], issued["from_location_id"]);
    assert_eq!(e.totals(FRAME).await.0, q("10"));
    // The original is still there, marked as reversed.
    let (_, original) = get(&e.app, ADMIN, &format!("/inventory/moves/{issued_id}")).await;
    assert_eq!(original["reversed_by"], r["id"]);
    assert_eq!(original["quantity"], issued["quantity"]);

    // A retry returns the same reversal; a second reversal is refused; a reversal cannot be reversed.
    let (status, again) = post(
        &e.app,
        ADMIN,
        &format!("/inventory/moves/{issued_id}/reverse"),
        json!({ "id": rid }),
    )
    .await;
    assert_eq!(
        (status, again["id"].clone()),
        (StatusCode::OK, r["id"].clone())
    );
    let (status, _) = post(
        &e.app,
        ADMIN,
        &format!("/inventory/moves/{issued_id}/reverse"),
        json!({ "id": uid() }),
    )
    .await;
    assert_eq!(status, StatusCode::CONFLICT);
    let rev_id = r["id"].as_str().unwrap();
    let (status, _) = post(
        &e.app,
        ADMIN,
        &format!("/inventory/moves/{rev_id}/reverse"),
        json!({ "id": uid() }),
    )
    .await;
    assert_eq!(status, StatusCode::CONFLICT);
    // Only the inventory admin reverses.
    let (status, _) = post(
        &e.app,
        STORES,
        &format!("/inventory/moves/{issued_id}/reverse"),
        json!({ "id": uid() }),
    )
    .await;
    assert_eq!(status, StatusCode::FORBIDDEN);

    // Reversing a receipt fails when the stock has been used since.
    let receipt = e.receive(FRAME, &e.main, "5").await;
    e.issue(FRAME, &e.main, "12").await;
    let rid = receipt["id"].as_str().unwrap();
    let (status, r) = post(
        &e.app,
        ADMIN,
        &format!("/inventory/moves/{rid}/reverse"),
        json!({ "id": uid() }),
    )
    .await;
    assert_eq!(status, StatusCode::CONFLICT, "{r}");
    // History: newest first, with both sides of the correction.
    let (_, h) = get(
        &e.app,
        SALES,
        &format!("/inventory/moves?product_id={FRAME}&limit=2"),
    )
    .await;
    assert_eq!(h["total"], 5);
    assert_eq!(h["items"].as_array().unwrap().len(), 2);
    assert!(h["items"][0]["seq"].as_i64() > h["items"][1]["seq"].as_i64());
    e.integrity_ok().await;
}

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn balances_can_be_rebuilt_from_the_ledger(db: PgPool) {
    let e = env(db).await;
    e.receive(FRAME, &e.main, "10").await;
    e.issue(FRAME, &e.main, "3").await;
    sqlx::query("UPDATE inventory.stock_balances SET quantity = quantity + 5 WHERE quantity = 7")
        .execute(&e.db)
        .await
        .unwrap();
    sqlx::query("DELETE FROM inventory.stock_balances WHERE allow_negative")
        .execute(&e.db)
        .await
        .unwrap();
    let (_, i) = get(&e.app, ADMIN, "/inventory/integrity").await;
    assert_eq!(i["ok"], false);
    assert!(!i["differences"].as_array().unwrap().is_empty());
    let (status, r) = post(&e.app, ADMIN, "/inventory/balances/rebuild", json!({})).await;
    assert_eq!(status, StatusCode::OK, "{r}");
    e.integrity_ok().await;
    assert_eq!(e.totals(FRAME).await.0, q("7"));
    let (status, _) = post(&e.app, STORES, "/inventory/balances/rebuild", json!({})).await;
    assert_eq!(status, StatusCode::FORBIDDEN);
}

// ---------------------------------------------------------------------------------------------
// Units of measure
// ---------------------------------------------------------------------------------------------

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn quantities_are_entered_in_other_units_and_stored_in_the_stock_unit(db: PgPool) {
    let e = env(db).await;
    // A box of 12 pieces, for this product only.
    let (status, u) = api(
        &e.app,
        ADMIN,
        Method::PUT,
        &format!("/inventory/products/{FRAME}/uoms"),
        Some(json!({ "uoms": [{ "uom_code": "set", "factor": "12" }] })),
    )
    .await;
    assert_eq!(status, StatusCode::OK, "{u}");
    let (status, m) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": FRAME, "location_id": e.main, "quantity": "2", "uom": "set" })).await;
    assert_eq!(status, StatusCode::CREATED, "{m}");
    assert_eq!(dec(&m["quantity"]), q("24"));
    assert_eq!(dec(&m["entered_quantity"]), q("2"));
    assert_eq!(m["entered_uom"], "set");
    assert_eq!(m["unit"], "pcs");

    // Metres from centimetres (same category), rounded to four decimals.
    let (status, m) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": PROFILE, "location_id": e.main, "quantity": "250", "uom": "cm" })).await;
    assert_eq!(status, StatusCode::CREATED, "{m}");
    assert_eq!(dec(&m["quantity"]), q("2.5"));
    let (status, m) = post(&e.app, STORES, "/inventory/issues", json!({ "id": uid(), "product_id": PROFILE, "location_id": e.main, "quantity": "5", "uom": "mm" })).await;
    assert_eq!(status, StatusCode::CREATED, "{m}");
    assert_eq!(dec(&m["quantity"]), q("0.005"));

    // No conversion between a length and pieces; an unknown unit is refused.
    let (status, _) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": PROFILE, "location_id": e.main, "quantity": "1", "uom": "kg" })).await;
    assert_eq!(status, StatusCode::UNPROCESSABLE_ENTITY);
    let (status, _) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": PROFILE, "location_id": e.main, "quantity": "1", "uom": "furlong" })).await;
    assert_eq!(status, StatusCode::UNPROCESSABLE_ENTITY);
    // Too small to be a stock quantity.
    let (status, _) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": PROFILE, "location_id": e.main, "quantity": "0.0001", "uom": "mm" })).await;
    assert_eq!(status, StatusCode::UNPROCESSABLE_ENTITY);
    // The stock unit of a product with moves cannot change.
    let (_, p) = get(&e.app, ADMIN, &format!("/products/{PROFILE}")).await;
    let mut input = p.clone();
    input["unit"] = json!("kg");
    let (status, _) = api(
        &e.app,
        ADMIN,
        Method::PUT,
        &format!("/products/{PROFILE}"),
        Some(input),
    )
    .await;
    assert_eq!(status, StatusCode::UNPROCESSABLE_ENTITY);
    e.integrity_ok().await;
}

// ---------------------------------------------------------------------------------------------
// Lots
// ---------------------------------------------------------------------------------------------

async fn make_lot_tracked(db: &PgPool, product: &str) {
    sqlx::query("UPDATE products.products SET tracking = 'lot' WHERE id = $1::uuid")
        .bind(product)
        .execute(db)
        .await
        .unwrap();
}

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn lot_tracked_stock_is_kept_per_lot(db: PgPool) {
    let e = env(db).await;
    make_lot_tracked(&e.db, BOLT).await;
    let (status, _) = post(
        &e.app,
        STORES,
        "/inventory/receipts",
        json!({ "id": uid(), "product_id": BOLT, "location_id": e.main, "quantity": "100" }),
    )
    .await;
    assert_eq!(
        status,
        StatusCode::UNPROCESSABLE_ENTITY,
        "a lot is required"
    );
    let (status, a) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": BOLT, "location_id": e.main, "quantity": "100", "lot_number": "L-A", "expiry_date": "2027-03-01" })).await;
    assert_eq!(status, StatusCode::CREATED, "{a}");
    let (_, b) = {
        let (s, v) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": BOLT, "location_id": e.main, "quantity": "50", "lot_number": "L-B", "expiry_date": "2026-12-01" })).await;
        assert_eq!(s, StatusCode::CREATED);
        (s, v)
    };
    // The generated Dart client sends dates as date-times.
    let (status, d) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": BOLT, "location_id": e.main, "quantity": "1", "lot_number": "L-C", "expiry_date": "2027-05-01T00:00:00.000" })).await;
    assert_eq!(status, StatusCode::CREATED, "{d}");
    let (_, lots) = get(&e.app, SALES, &format!("/inventory/lots?product_id={BOLT}")).await;
    assert!(lots
        .as_array()
        .unwrap()
        .iter()
        .any(|l| l["lot_number"] == "L-C" && l["expiry_date"] == "2027-05-01"));
    // More of an existing lot adds to it; a different expiry date for it is refused.
    let (status, _) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": BOLT, "location_id": e.main, "quantity": "10", "lot_number": "L-A" })).await;
    assert_eq!(status, StatusCode::CREATED);
    let (status, _) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": BOLT, "location_id": e.main, "quantity": "10", "lot_number": "L-A", "expiry_date": "2030-01-01" })).await;
    assert_eq!(status, StatusCode::CONFLICT);

    let (_, rows) = get(
        &e.app,
        SALES,
        &format!("/inventory/stock?product_id={BOLT}"),
    )
    .await;
    let per_lot: Vec<(String, Decimal)> = rows["items"]
        .as_array()
        .unwrap()
        .iter()
        .map(|r| {
            (
                r["lot_number"].as_str().unwrap().to_string(),
                dec(&r["on_hand"]),
            )
        })
        .collect();
    assert_eq!(
        per_lot,
        vec![
            ("L-A".to_string(), q("110")),
            ("L-B".to_string(), q("50")),
            ("L-C".to_string(), q("1"))
        ]
    );
    let (_, lots) = get(
        &e.app,
        SALES,
        &format!("/inventory/lots?product_id={BOLT}&in_stock=true"),
    )
    .await;
    assert_eq!(lots.as_array().unwrap().len(), 3);
    assert_eq!(lots[0]["lot_number"], "L-B", "earliest expiry first");

    // Issues name the lot, and one lot cannot be drawn below its own quantity.
    let lot_b = b["lot_id"].as_str().unwrap();
    let (status, _) = post(
        &e.app,
        STORES,
        "/inventory/issues",
        json!({ "id": uid(), "product_id": BOLT, "location_id": e.main, "quantity": "5" }),
    )
    .await;
    assert_eq!(status, StatusCode::UNPROCESSABLE_ENTITY);
    let (status, r) = post(&e.app, STORES, "/inventory/issues", json!({ "id": uid(), "product_id": BOLT, "location_id": e.main, "quantity": "60", "lot_id": lot_b })).await;
    assert_eq!(status, StatusCode::CONFLICT, "{r}");
    let (status, _) = post(&e.app, STORES, "/inventory/issues", json!({ "id": uid(), "product_id": BOLT, "location_id": e.main, "quantity": "20", "lot_id": lot_b })).await;
    assert_eq!(status, StatusCode::CREATED);
    // A lot of another product cannot be used, nor a lot on an untracked product.
    let (status, _) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": FRAME, "location_id": e.main, "quantity": "1", "lot_number": "X" })).await;
    assert_eq!(
        status,
        StatusCode::CREATED,
        "a lot number is ignored for untracked products"
    );
    let (status, _) = post(&e.app, STORES, "/inventory/issues", json!({ "id": uid(), "product_id": FRAME, "location_id": e.main, "quantity": "1", "lot_id": lot_b })).await;
    assert_eq!(status, StatusCode::UNPROCESSABLE_ENTITY);
    // Tracking cannot be switched once there are moves.
    let (_, p) = get(&e.app, ADMIN, &format!("/products/{BOLT}")).await;
    let mut input = p.clone();
    input["tracking"] = json!("none");
    let (status, _) = api(
        &e.app,
        ADMIN,
        Method::PUT,
        &format!("/products/{BOLT}"),
        Some(input),
    )
    .await;
    assert_eq!(status, StatusCode::UNPROCESSABLE_ENTITY);
    e.integrity_ok().await;
}

// ---------------------------------------------------------------------------------------------
// Transfers
// ---------------------------------------------------------------------------------------------

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn transfers_move_stock_between_locations_and_to_a_van(db: PgPool) {
    let e = env(db).await;
    let (_, van) = post(
        &e.app,
        ADMIN,
        "/inventory/warehouses",
        json!({ "code": "VAN-1", "name": "Van 1", "kind": "van" }),
    )
    .await;
    let van_loc = van["locations"][0]["id"].as_str().unwrap().to_string();
    e.receive(FRAME, &e.main, "10").await;
    let (status, t) = post(&e.app, STORES, "/inventory/transfers", json!({ "id": uid(), "product_id": FRAME, "from_location_id": e.main, "to_location_id": van_loc, "quantity": "4", "reason": "van_replenishment" })).await;
    assert_eq!(status, StatusCode::CREATED, "{t}");
    assert_eq!(t["reason"], "van_replenishment");
    // Van stock is shown separately and is not available for orders.
    let (_, p) = get(
        &e.app,
        SALES,
        &format!("/inventory/stock/products?product_id={FRAME}"),
    )
    .await;
    assert_eq!(
        (
            dec(&p["items"][0]["on_hand"]),
            dec(&p["items"][0]["in_vans"])
        ),
        (q("6"), q("4"))
    );
    let (_, p) = get(
        &e.app,
        SALES,
        &format!(
            "/inventory/stock/products?product_id={FRAME}&warehouse_id={}",
            van["id"].as_str().unwrap()
        ),
    )
    .await;
    assert_eq!(dec(&p["items"][0]["on_hand"]), q("4"));

    let (status, _) = post(&e.app, STORES, "/inventory/transfers", json!({ "id": uid(), "product_id": FRAME, "from_location_id": van_loc, "to_location_id": e.main, "quantity": "5" })).await;
    assert_eq!(status, StatusCode::CONFLICT, "the van has 4");
    let (status, _) = post(&e.app, STORES, "/inventory/transfers", json!({ "id": uid(), "product_id": FRAME, "from_location_id": e.main, "to_location_id": e.main, "quantity": "1" })).await;
    assert_eq!(status, StatusCode::UNPROCESSABLE_ENTITY);
    let (status, _) = post(&e.app, STORES, "/inventory/transfers", json!({ "id": uid(), "product_id": FRAME, "from_location_id": e.main, "to_location_id": van_loc, "quantity": "1", "reason": "gift" })).await;
    assert_eq!(status, StatusCode::UNPROCESSABLE_ENTITY);
    // Sales may look, not move.
    let (status, _) = post(&e.app, SALES, "/inventory/transfers", json!({ "id": uid(), "product_id": FRAME, "from_location_id": e.main, "to_location_id": van_loc, "quantity": "1" })).await;
    assert_eq!(status, StatusCode::FORBIDDEN);
    e.integrity_ok().await;
}

// ---------------------------------------------------------------------------------------------
// Adjustments and counts
// ---------------------------------------------------------------------------------------------

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn adjustments_set_or_change_the_quantity_with_a_reason(db: PgPool) {
    let e = env(db).await;
    e.receive(FRAME, &e.main, "10").await;
    let id = uid();
    let body = json!({ "id": id, "product_id": FRAME, "location_id": e.main, "new_quantity": "8", "note": "broken in transit" });
    let (status, m) = post(&e.app, ADMIN, "/inventory/adjustments", body.clone()).await;
    assert_eq!(status, StatusCode::CREATED, "{m}");
    assert_eq!(
        (m["kind"].as_str(), m["to_location"].as_str()),
        (Some("adjustment"), Some("adjustment"))
    );
    assert_eq!(dec(&m["quantity"]), q("2"));
    // The retry returns the same move although the stock is now already 8.
    let (status, again) = post(&e.app, ADMIN, "/inventory/adjustments", body).await;
    assert_eq!(
        (status, again["id"].clone()),
        (StatusCode::OK, m["id"].clone())
    );
    assert_eq!(e.totals(FRAME).await.0, q("8"));
    let (status, m) = post(&e.app, ADMIN, "/inventory/adjustments", json!({ "id": uid(), "product_id": FRAME, "location_id": e.main, "delta": "1.5", "note": "found" })).await;
    assert_eq!(status, StatusCode::CREATED, "{m}");
    assert_eq!(m["from_location"], "adjustment");
    assert_eq!(e.totals(FRAME).await.0, q("9.5"));
    for body in [
        json!({ "id": uid(), "product_id": FRAME, "location_id": e.main, "new_quantity": "9.5", "note": "same" }),
        json!({ "id": uid(), "product_id": FRAME, "location_id": e.main, "new_quantity": "1", "delta": "1", "note": "both" }),
        json!({ "id": uid(), "product_id": FRAME, "location_id": e.main, "delta": "1", "note": " " }),
        json!({ "id": uid(), "product_id": FRAME, "location_id": e.main, "delta": "-20", "note": "too much" }),
        json!({ "id": uid(), "product_id": PUMP, "location_id": e.main, "delta": "1", "note": "serial" }),
    ] {
        let (status, r) = post(&e.app, ADMIN, "/inventory/adjustments", body.clone()).await;
        assert!(
            status == StatusCode::UNPROCESSABLE_ENTITY || status == StatusCode::CONFLICT,
            "{body} -> {status} {r}"
        );
    }
    let (status, _) = post(&e.app, STORES, "/inventory/adjustments", json!({ "id": uid(), "product_id": FRAME, "location_id": e.main, "delta": "1", "note": "x" })).await;
    assert_eq!(
        status,
        StatusCode::FORBIDDEN,
        "adjustments need inventory.admin"
    );
    e.integrity_ok().await;
}

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn a_count_posts_the_difference_between_counted_and_current_stock(db: PgPool) {
    let e = env(db).await;
    let shelf = e.location("A-01").await;
    e.receive(FRAME, &e.main, "10").await;
    e.receive(BOLT, &shelf, "100").await;
    e.receive(PROFILE, &e.main, "20").await;
    let (status, c) = post(
        &e.app,
        STORES,
        "/inventory/counts",
        json!({ "warehouse_id": e.wh, "note": "year end" }),
    )
    .await;
    assert_eq!(status, StatusCode::CREATED, "{c}");
    let cid = c["count"]["id"].as_str().unwrap().to_string();
    assert!(
        c["count"]["number"].as_str().unwrap().starts_with("CNT-"),
        "{c}"
    );
    assert_eq!(c["lines"].as_array().unwrap().len(), 3);
    let line_of = |code: &str| {
        c["lines"]
            .as_array()
            .unwrap()
            .iter()
            .find(|l| l["product_code"] == code)
            .unwrap()["id"]
            .as_str()
            .unwrap()
            .to_string()
    };
    let (frame, bolt) = (line_of("FRAME-A"), line_of("BOLT-M8"));

    // Stock moves while counting: the count compares with the stock at posting time.
    e.issue(FRAME, &e.main, "1").await;
    let (status, d) = api(
        &e.app,
        STORES,
        Method::PUT,
        &format!("/inventory/counts/{cid}/lines"),
        Some(json!({ "entries": [
            { "line_id": frame, "counted_quantity": "7" },
            { "line_id": bolt, "counted_quantity": "100" },
            { "product_id": PUMP, "location_id": e.main, "counted_quantity": "1" },
        ] })),
    )
    .await;
    assert_eq!(
        status,
        StatusCode::UNPROCESSABLE_ENTITY,
        "serial products are not counted: {d}"
    );
    // Stock that was not expected can be added as a line.
    let (status, d) = api(
        &e.app,
        STORES,
        Method::PUT,
        &format!("/inventory/counts/{cid}/lines"),
        Some(json!({ "entries": [
        { "line_id": frame, "counted_quantity": "7" },
        { "line_id": bolt, "counted_quantity": "100" },
        { "product_id": FRAME, "location_id": shelf, "counted_quantity": "2" },
    ] })),
    )
    .await;
    assert_eq!(status, StatusCode::OK, "{d}");
    assert_eq!(d["lines"].as_array().unwrap().len(), 4);
    assert_eq!(d["count"]["counted_count"], 3);

    // The warehouse team counts; the admin posts.
    let (status, _) = post(
        &e.app,
        STORES,
        &format!("/inventory/counts/{cid}/post"),
        json!({}),
    )
    .await;
    assert_eq!(status, StatusCode::FORBIDDEN);
    let (status, d) = post(
        &e.app,
        ADMIN,
        &format!("/inventory/counts/{cid}/post"),
        json!({}),
    )
    .await;
    assert_eq!(status, StatusCode::OK, "{d}");
    assert_eq!(d["count"]["status"], "posted");
    // FRAME: 9 on hand at posting, counted 7 -> -2; shelf found 2 -> +2; BOLT unchanged; profile not counted.
    let (_, rows) = get(
        &e.app,
        ADMIN,
        &format!("/inventory/stock?product_id={FRAME}"),
    )
    .await;
    let on_hand: Vec<Decimal> = rows["items"]
        .as_array()
        .unwrap()
        .iter()
        .map(|r| dec(&r["on_hand"]))
        .collect();
    assert_eq!(on_hand, vec![q("2"), q("7")]);
    assert_eq!(e.totals(BOLT).await.0, q("100"));
    assert_eq!(e.totals(PROFILE).await.0, q("20"));
    let (_, h) = get(
        &e.app,
        ADMIN,
        &format!("/inventory/moves?reference_type=stock_count&reference_id={cid}"),
    )
    .await;
    assert_eq!(h["total"], 2, "only differences become moves");
    assert!(h["items"]
        .as_array()
        .unwrap()
        .iter()
        .all(|m| m["reason"] == "count" && m["kind"] == "adjustment"));
    let posted_lines = d["lines"]
        .as_array()
        .unwrap()
        .iter()
        .filter(|l| !l["adjustment_move_id"].is_null())
        .count();
    assert_eq!(posted_lines, 2);

    // A posted count is closed.
    let (status, _) = post(
        &e.app,
        ADMIN,
        &format!("/inventory/counts/{cid}/post"),
        json!({}),
    )
    .await;
    assert_eq!(status, StatusCode::CONFLICT);
    let (status, _) = api(
        &e.app,
        STORES,
        Method::PUT,
        &format!("/inventory/counts/{cid}/lines"),
        Some(json!({ "entries": [] })),
    )
    .await;
    assert_eq!(status, StatusCode::CONFLICT);
    let (status, _) = post(
        &e.app,
        STORES,
        &format!("/inventory/counts/{cid}/cancel"),
        json!({}),
    )
    .await;
    assert_eq!(status, StatusCode::CONFLICT);

    // A cancelled count posts nothing.
    let (_, c2) = post(
        &e.app,
        STORES,
        "/inventory/counts",
        json!({ "warehouse_id": e.wh, "product_id": FRAME }),
    )
    .await;
    let c2id = c2["count"]["id"].as_str().unwrap();
    assert_ne!(c2["count"]["number"], c["count"]["number"]);
    let (status, d) = post(
        &e.app,
        STORES,
        &format!("/inventory/counts/{c2id}/cancel"),
        json!({}),
    )
    .await;
    assert_eq!(
        (status, d["count"]["status"].as_str()),
        (StatusCode::OK, Some("cancelled"))
    );
    let (_, list) = get(&e.app, SALES, "/inventory/counts?status=posted").await;
    assert_eq!(list.as_array().unwrap().len(), 1);
    e.integrity_ok().await;
}

// ---------------------------------------------------------------------------------------------
// Serial units
// ---------------------------------------------------------------------------------------------

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn serial_units_keep_their_status_consistent_with_the_moves(db: PgPool) {
    let e = env(db).await;
    // Receiving registers the unit; the ledger puts it at the location.
    let (status, m) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": PUMP, "location_id": e.main, "quantity": "1", "serial_number": "P-NEW-1" })).await;
    assert_eq!(status, StatusCode::CREATED, "{m}");
    let unit = m["serial_unit_id"].as_str().unwrap().to_string();
    assert_eq!(m["serial_number"], "P-NEW-1");
    assert_eq!(e.totals(PUMP).await.0, q("1"));
    let (_, d) = get(&e.app, ADMIN, &format!("/serials/{unit}")).await;
    assert_eq!(d["unit"]["status"], "in_stock");

    for (body, expect) in [
        (
            json!({ "id": uid(), "product_id": PUMP, "location_id": e.main, "quantity": "2", "serial_number": "P-NEW-2" }),
            StatusCode::UNPROCESSABLE_ENTITY,
        ),
        (
            json!({ "id": uid(), "product_id": PUMP, "location_id": e.main, "quantity": "1" }),
            StatusCode::UNPROCESSABLE_ENTITY,
        ),
        (
            json!({ "id": uid(), "product_id": PUMP, "location_id": e.main, "quantity": "1", "serial_number": "P-NEW-1" }),
            StatusCode::CONFLICT,
        ),
    ] {
        let (status, r) = post(&e.app, STORES, "/inventory/receipts", body).await;
        assert_eq!(status, expect, "{r}");
    }

    // While it has a location, engineering cannot change its status or build it into a unit.
    let (status, r) = api(
        &e.app,
        ADMIN,
        Method::PUT,
        &format!("/serials/{unit}/status"),
        Some(json!({ "status": "scrapped" })),
    )
    .await;
    assert_eq!(status, StatusCode::CONFLICT, "{r}");
    let (status, r) = post(
        &e.app,
        ADMIN,
        "/serials/00000000-0000-7000-8000-000000000601/components",
        json!({ "child_id": unit }),
    )
    .await;
    assert_eq!(status, StatusCode::CONFLICT, "{r}");

    // Shipping needs a customer, then the unit is delivered and leaves the stock.
    let ship = json!({ "id": uid(), "product_id": PUMP, "location_id": e.main, "quantity": "1", "serial_unit_id": unit, "reason": "shipment" });
    let (status, _) = post(&e.app, STORES, "/inventory/issues", ship.clone()).await;
    assert_eq!(
        status,
        StatusCode::UNPROCESSABLE_ENTITY,
        "customer required"
    );
    let mut with_customer = ship.clone();
    with_customer["customer_id"] = json!(ALPHA);
    let (status, shipped) = post(&e.app, STORES, "/inventory/issues", with_customer).await;
    assert_eq!(status, StatusCode::CREATED, "{shipped}");
    assert_eq!(e.totals(PUMP).await.0, q("0"));
    let (_, d) = get(&e.app, ADMIN, &format!("/serials/{unit}")).await;
    assert_eq!(
        (
            d["unit"]["status"].as_str(),
            d["unit"]["customer_id"].as_str()
        ),
        (Some("delivered"), Some(ALPHA))
    );
    let (status, _) = post(&e.app, STORES, "/inventory/issues", json!({ "id": uid(), "product_id": PUMP, "location_id": e.main, "quantity": "1", "serial_unit_id": unit, "reason": "scrap" })).await;
    assert_eq!(
        status,
        StatusCode::CONFLICT,
        "a delivered unit is not in stock"
    );

    // Reversing the shipment puts it back in stock at the same location.
    let sid = shipped["id"].as_str().unwrap();
    let (status, r) = post(
        &e.app,
        ADMIN,
        &format!("/inventory/moves/{sid}/reverse"),
        json!({ "id": uid() }),
    )
    .await;
    assert_eq!(status, StatusCode::CREATED, "{r}");
    let (_, d) = get(&e.app, ADMIN, &format!("/serials/{unit}")).await;
    assert_eq!(
        (
            d["unit"]["status"].as_str(),
            d["unit"]["customer_id"].is_null()
        ),
        (Some("in_stock"), true)
    );
    assert_eq!(e.totals(PUMP).await.0, q("1"));

    // Consumption takes it out of stock without a status change; now it can be built in (ADR 0011).
    let (status, _) = post(&e.app, STORES, "/inventory/issues", json!({ "id": uid(), "product_id": PUMP, "location_id": e.main, "quantity": "1", "serial_unit_id": unit, "reason": "consumption" })).await;
    assert_eq!(status, StatusCode::CREATED);
    assert_eq!(e.totals(PUMP).await.0, q("0"));
    let (_, d) = get(&e.app, ADMIN, &format!("/serials/{unit}")).await;
    assert_eq!(d["unit"]["status"], "in_stock");
    // Scrapping another unit.
    let (_, m2) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": CTRL, "location_id": e.main, "quantity": "1", "serial_number": "C-NEW-1" })).await;
    let u2 = m2["serial_unit_id"].as_str().unwrap();
    let (status, _) = post(&e.app, STORES, "/inventory/issues", json!({ "id": uid(), "product_id": CTRL, "location_id": e.main, "quantity": "1", "serial_unit_id": u2, "reason": "scrap" })).await;
    assert_eq!(status, StatusCode::CREATED);
    let (_, d) = get(&e.app, ADMIN, &format!("/serials/{u2}")).await;
    assert_eq!(d["unit"]["status"], "scrapped");
    // Another product's unit cannot be moved as this one.
    let (status, _) = post(&e.app, STORES, "/inventory/transfers", json!({ "id": uid(), "product_id": CTRL, "from_location_id": e.main, "to_location_id": e.main, "quantity": "1", "serial_unit_id": unit })).await;
    assert_eq!(status, StatusCode::UNPROCESSABLE_ENTITY);
    e.integrity_ok().await;

    // A seed unit registered before inventory is in stock without a location; it can be received.
    let (status, m) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": PUMP, "location_id": e.main, "quantity": "1", "serial_unit_id": "00000000-0000-7000-8000-000000000605" })).await;
    assert_eq!(status, StatusCode::CREATED, "{m}");
    // A unit built into another one cannot be received.
    let (status, _) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": PUMP, "location_id": e.main, "quantity": "1", "serial_unit_id": "00000000-0000-7000-8000-000000000602" })).await;
    assert_eq!(status, StatusCode::CONFLICT);
    // And the finished unit can be tracked the same way.
    let (status, _) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": UNIT_100, "location_id": e.main, "quantity": "1", "serial_unit_id": "00000000-0000-7000-8000-000000000601" })).await;
    assert_eq!(status, StatusCode::CREATED);
    e.integrity_ok().await;
}

// ---------------------------------------------------------------------------------------------
// Reservations and availability
// ---------------------------------------------------------------------------------------------

async fn order_with(app: &axum::Router, product: &str, quantity: &str) -> (String, String) {
    let (status, qn) = api(app, SALES, Method::POST, "/quotations", Some(json!({ "customer_id": ALPHA, "lines": [{ "product_id": product, "quantity": quantity }] }))).await;
    assert_eq!(status, StatusCode::CREATED, "{qn}");
    let qid = qn["id"].as_str().unwrap();
    api(
        app,
        SALES,
        Method::POST,
        &format!("/quotations/{qid}/send"),
        None,
    )
    .await;
    let (status, o) = api(
        app,
        SALES,
        Method::POST,
        &format!("/quotations/{qid}/convert"),
        Some(json!({ "customer_reference": "PO" })),
    )
    .await;
    assert_eq!(status, StatusCode::CREATED, "{o}");
    (
        o["order"]["id"].as_str().unwrap().into(),
        o["lines"][0]["id"].as_str().unwrap().into(),
    )
}

async fn confirm(app: &axum::Router, order: &str) {
    let (status, o) = api(
        app,
        SALES,
        Method::POST,
        &format!("/orders/{order}/send"),
        None,
    )
    .await;
    assert_eq!(status, StatusCode::OK, "{o}");
    let (status, o) = api(
        app,
        SALES,
        Method::POST,
        &format!("/orders/{order}/confirm"),
        Some(json!({})),
    )
    .await;
    assert_eq!(status, StatusCode::OK, "{o}");
}

async fn reserve(app: &axum::Router, line: &str, quantity: &str) -> (StatusCode, Value) {
    api(
        app,
        STORES,
        Method::PUT,
        &format!("/inventory/order-lines/{line}/reservation"),
        Some(json!({ "quantity": quantity })),
    )
    .await
}

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn reserving_stock_for_a_confirmed_order_reduces_what_is_available(db: PgPool) {
    let e = env(db).await;
    e.receive(FRAME, &e.main, "8").await;
    let (order, line) = order_with(&e.app, FRAME, "5").await;

    // Before confirmation: availability is shown, but nothing can be reserved.
    let (_, a) = get(
        &e.app,
        SALES,
        &format!("/inventory/orders/{order}/availability"),
    )
    .await;
    assert_eq!(a["reservable"], false);
    assert_eq!(
        (
            dec(&a["lines"][0]["on_hand"]),
            dec(&a["lines"][0]["available"]),
            a["lines"][0]["state"].as_str()
        ),
        (q("8"), q("8"), Some("available"))
    );
    let (status, r) = reserve(&e.app, &line, "5").await;
    assert_eq!(status, StatusCode::CONFLICT, "{r}");

    confirm(&e.app, &order).await;
    let (status, r) = reserve(&e.app, &line, "5").await;
    assert_eq!(status, StatusCode::OK, "{r}");
    assert_eq!(dec(&r["reserved"]), q("5"));
    assert_eq!(e.totals(FRAME).await, (q("8"), q("5"), q("3")));
    // Doing it again changes nothing.
    let (_, r2) = reserve(&e.app, &line, "5").await;
    assert_eq!(dec(&r2["reserved"]), q("5"));
    assert_eq!(r2["allocations"].as_array().unwrap().len(), 1);
    let (_, a) = get(
        &e.app,
        SALES,
        &format!("/inventory/orders/{order}/availability"),
    )
    .await;
    assert_eq!(a["reservable"], true);
    assert_eq!(
        (
            dec(&a["lines"][0]["reserved"]),
            dec(&a["lines"][0]["available"]),
            a["lines"][0]["state"].as_str()
        ),
        (q("5"), q("3"), Some("reserved"))
    );
    // Stock overview per location shows reserved and available too.
    let (_, rows) = get(
        &e.app,
        SALES,
        &format!("/inventory/stock?product_id={FRAME}"),
    )
    .await;
    assert_eq!(
        (
            dec(&rows["items"][0]["reserved"]),
            dec(&rows["items"][0]["available"])
        ),
        (q("5"), q("3"))
    );

    // More than the line asks for, and more than is free, are refused.
    let (status, _) = reserve(&e.app, &line, "6").await;
    assert_eq!(status, StatusCode::UNPROCESSABLE_ENTITY);
    let (order2, line2) = order_with(&e.app, FRAME, "5").await;
    confirm(&e.app, &order2).await;
    let (status, r) = reserve(&e.app, &line2, "5").await;
    assert_eq!(status, StatusCode::CONFLICT, "only 3 are free: {r}");
    assert!(r["message"].as_str().unwrap().contains("only 3"), "{r}");
    let (_, a2) = get(
        &e.app,
        SALES,
        &format!("/inventory/orders/{order2}/availability"),
    )
    .await;
    assert_eq!(
        (
            dec(&a2["lines"][0]["shortfall"]),
            a2["lines"][0]["state"].as_str()
        ),
        (q("2"), Some("partial"))
    );
    let (status, r) = reserve(&e.app, &line2, "3").await;
    assert_eq!(status, StatusCode::OK, "{r}");
    let (_, a2) = get(
        &e.app,
        SALES,
        &format!("/inventory/orders/{order2}/availability"),
    )
    .await;
    assert_eq!(
        (
            dec(&a2["lines"][0]["shortfall"]),
            dec(&a2["lines"][0]["available"])
        ),
        (q("2"), q("0"))
    );
    let (_, list) = get(
        &e.app,
        SALES,
        &format!("/inventory/reservations?product_id={FRAME}"),
    )
    .await;
    assert_eq!(list.as_array().unwrap().len(), 2);

    // Reserved stock cannot be issued or transferred away.
    let (status, r) = e.issue(FRAME, &e.main, "1").await;
    assert_eq!(status, StatusCode::CONFLICT, "everything is reserved: {r}");
    assert!(r["message"].as_str().unwrap().contains("reserved"), "{r}");
    let (status, _) = post(&e.app, STORES, "/inventory/transfers", json!({ "id": uid(), "product_id": FRAME, "from_location_id": e.main, "to_location_id": e.location("B-01").await, "quantity": "1" })).await;
    assert_eq!(status, StatusCode::CONFLICT);

    // Lowering the reservation frees stock again; partial release keeps the rest.
    let (_, r) = reserve(&e.app, &line, "2").await;
    assert_eq!(dec(&r["reserved"]), q("2"));
    assert_eq!(e.totals(FRAME).await, (q("8"), q("5"), q("3")));
    let (status, _) = e.issue(FRAME, &e.main, "3").await;
    assert_eq!(status, StatusCode::CREATED);
    // Cancelling the order releases its reservations.
    let (status, o) = api(
        &e.app,
        SALES,
        Method::POST,
        &format!("/orders/{order2}/cancel"),
        Some(json!({ "reason": "customer withdrew" })),
    )
    .await;
    assert_eq!(status, StatusCode::OK, "{o}");
    assert_eq!(e.totals(FRAME).await, (q("5"), q("2"), q("3")));
    // Releasing all.
    let (_, r) = reserve(&e.app, &line, "0").await;
    assert_eq!(dec(&r["reserved"]), q("0"));
    assert_eq!(e.totals(FRAME).await, (q("5"), q("0"), q("5")));
    // A cancelled order cannot be reserved for, and the lifecycle is untouched by all this.
    let (status, _) = reserve(&e.app, &line2, "1").await;
    assert_eq!(status, StatusCode::CONFLICT);
    let (_, o) = api(
        &e.app,
        SALES,
        Method::GET,
        &format!("/orders/{order}"),
        None,
    )
    .await;
    assert_eq!(o["order"]["status"], "confirmed");
    e.integrity_ok().await;
}

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn reservations_take_lots_with_the_earliest_expiry_first_and_skip_vans(db: PgPool) {
    let e = env(db).await;
    make_lot_tracked(&e.db, BOLT).await;
    let shelf = e.location("A-01").await;
    for (lot, loc, qty, exp) in [
        ("LATE", &e.main, "10", "2027-06-01"),
        ("EARLY", &shelf, "4", "2026-12-31"),
    ] {
        let (s, r) = post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": BOLT, "location_id": loc, "quantity": qty, "lot_number": lot, "expiry_date": exp })).await;
        assert_eq!(s, StatusCode::CREATED, "{r}");
    }
    let (_, van) = post(
        &e.app,
        ADMIN,
        "/inventory/warehouses",
        json!({ "code": "VAN-1", "name": "Van", "kind": "van" }),
    )
    .await;
    post(&e.app, STORES, "/inventory/receipts", json!({ "id": uid(), "product_id": BOLT, "location_id": van["locations"][0]["id"], "quantity": "50", "lot_number": "VANLOT" })).await;
    let (order, line) = order_with(&e.app, BOLT, "6").await;
    confirm(&e.app, &order).await;
    let (status, r) = reserve(&e.app, &line, "6").await;
    assert_eq!(status, StatusCode::OK, "{r}");
    let allocs: Vec<(String, Decimal)> = r["allocations"]
        .as_array()
        .unwrap()
        .iter()
        .map(|a| {
            (
                a["lot_number"].as_str().unwrap().to_string(),
                dec(&a["quantity"]),
            )
        })
        .collect();
    assert_eq!(
        allocs,
        vec![("EARLY".to_string(), q("4")), ("LATE".to_string(), q("2"))]
    );
    // The van's 50 are not available for orders.
    assert_eq!(e.totals(BOLT).await, (q("14"), q("6"), q("8")));
    let (_, rows) = get(
        &e.app,
        SALES,
        &format!("/inventory/stock?product_id={BOLT}&warehouse_id={}", e.wh),
    )
    .await;
    let reserved: Vec<(String, Decimal)> = rows["items"]
        .as_array()
        .unwrap()
        .iter()
        .map(|r| {
            (
                r["lot_number"].as_str().unwrap().to_string(),
                dec(&r["reserved"]),
            )
        })
        .collect();
    assert_eq!(
        reserved,
        vec![("EARLY".to_string(), q("4")), ("LATE".to_string(), q("2"))]
    );
    // Lowering releases the newest allocation first.
    let (_, r) = reserve(&e.app, &line, "4").await;
    assert_eq!(r["allocations"].as_array().unwrap().len(), 1);
    assert_eq!(r["allocations"][0]["lot_number"], "EARLY");
    e.integrity_ok().await;
}

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn services_and_lines_without_stock_are_reported_as_not_stocked(db: PgPool) {
    let e = env(db).await;
    let (order, line) = order_with(&e.app, SERVICE, "2").await;
    confirm(&e.app, &order).await;
    let (_, a) = get(
        &e.app,
        SALES,
        &format!("/inventory/orders/{order}/availability"),
    )
    .await;
    assert_eq!(a["lines"][0]["state"], "not_stocked");
    let (status, _) = reserve(&e.app, &line, "1").await;
    assert_eq!(status, StatusCode::UNPROCESSABLE_ENTITY);
    let (status, _) = get(
        &e.app,
        SALES,
        &format!("/inventory/orders/{}/availability", uid()),
    )
    .await;
    assert_eq!(status, StatusCode::NOT_FOUND);
}

// ---------------------------------------------------------------------------------------------
// Permissions, cost and company isolation
// ---------------------------------------------------------------------------------------------

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn cost_is_only_visible_to_roles_with_the_cost_permission(db: PgPool) {
    let e = env(db).await;
    let (_, p) = get(&e.app, PM, &format!("/products/{FRAME}")).await;
    let mut input = p.clone();
    input["standard_cost"] = json!("812.5");
    input["reorder_min"] = json!("4");
    input["reorder_max"] = json!("12");
    input["lead_time_days"] = json!(14);
    input["barcode"] = json!("5412345678901");
    let (status, saved) = api(
        &e.app,
        PM,
        Method::PUT,
        &format!("/products/{FRAME}"),
        Some(input.clone()),
    )
    .await;
    assert_eq!(status, StatusCode::OK, "{saved}");
    assert_eq!(dec(&saved["standard_cost"]), q("812.5"));
    assert_eq!(saved["barcode"], "5412345678901");
    // Sales sees the product, not the cost.
    let (_, seen) = get(&e.app, SALES, &format!("/products/{FRAME}")).await;
    assert!(seen["standard_cost"].is_null(), "{seen}");
    assert_eq!(
        (dec(&seen["reorder_min"]), seen["lead_time_days"].as_i64()),
        (q("4"), Some(14))
    );
    let (_, list) = get(&e.app, SALES, "/products?q=FRAME").await;
    assert!(list["items"][0]["standard_cost"].is_null());
    // Saving the product without the permission keeps the stored cost, and cannot set one.
    let mut by_admin_less = seen.clone();
    by_admin_less["standard_cost"] = json!("1");
    let (status, _) = api(
        &e.app,
        ADMIN,
        Method::PUT,
        &format!("/products/{FRAME}"),
        Some(by_admin_less.clone()),
    )
    .await;
    assert_eq!(status, StatusCode::OK);
    let (_, back) = get(&e.app, PM, &format!("/products/{FRAME}")).await;
    assert_eq!(
        dec(&back["standard_cost"]),
        q("1"),
        "admin holds the permission"
    );
    let (_, pm_bolt) = get(&e.app, PM, &format!("/products/{BOLT}")).await;
    assert!(pm_bolt["standard_cost"].is_null());
    let mut forged = seen.clone();
    forged["standard_cost"] = json!("0.01");
    let (status, _) = api(
        &e.app,
        SALES,
        Method::PUT,
        &format!("/products/{FRAME}"),
        Some(forged),
    )
    .await;
    assert_eq!(
        status,
        StatusCode::FORBIDDEN,
        "sales may not edit products at all"
    );

    // The cost at the time of a move is kept and equally hidden.
    api(
        &e.app,
        ADMIN,
        Method::PUT,
        &format!("/products/{FRAME}"),
        Some({
            let mut i = back.clone();
            i["standard_cost"] = json!("812.5");
            i
        }),
    )
    .await;
    let (_, m) = post(
        &e.app,
        ADMIN,
        "/inventory/receipts",
        json!({ "id": uid(), "product_id": FRAME, "location_id": e.main, "quantity": "1" }),
    )
    .await;
    assert_eq!(dec(&m["unit_cost"]), q("812.5"));
    let (_, h) = get(
        &e.app,
        SALES,
        &format!("/inventory/moves?product_id={FRAME}"),
    )
    .await;
    assert!(h["items"][0]["unit_cost"].is_null());
    let (_, h) = get(&e.app, PM, &format!("/inventory/moves?product_id={FRAME}")).await;
    assert_eq!(dec(&h["items"][0]["unit_cost"]), q("812.5"));
    // Barcodes are unique; negative values and a max below the min are refused.
    let mut dup = pm_bolt.clone();
    dup["barcode"] = json!("5412345678901");
    let (status, _) = api(
        &e.app,
        PM,
        Method::PUT,
        &format!("/products/{BOLT}"),
        Some(dup),
    )
    .await;
    assert_eq!(status, StatusCode::CONFLICT);
    let mut bad = pm_bolt.clone();
    bad["reorder_min"] = json!("5");
    bad["reorder_max"] = json!("2");
    let (status, _) = api(
        &e.app,
        PM,
        Method::PUT,
        &format!("/products/{BOLT}"),
        Some(bad),
    )
    .await;
    assert_eq!(status, StatusCode::UNPROCESSABLE_ENTITY);
}

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn reorder_levels_flag_products_below_their_minimum(db: PgPool) {
    let e = env(db).await;
    let (_, p) = get(&e.app, PM, &format!("/products/{FRAME}")).await;
    let mut input = p.clone();
    input["reorder_min"] = json!("5");
    api(
        &e.app,
        PM,
        Method::PUT,
        &format!("/products/{FRAME}"),
        Some(input),
    )
    .await;
    e.receive(FRAME, &e.main, "6").await;
    let (_, low) = get(
        &e.app,
        SALES,
        "/inventory/stock/products?below_reorder=true",
    )
    .await;
    assert_eq!(low["total"], 0);
    e.issue(FRAME, &e.main, "2").await;
    let (_, low) = get(
        &e.app,
        SALES,
        "/inventory/stock/products?below_reorder=true",
    )
    .await;
    assert_eq!(low["total"], 1);
    assert_eq!(low["items"][0]["below_reorder"], true);
    let (_, held) = get(&e.app, SALES, "/inventory/stock/products?in_stock=true").await;
    assert_eq!(held["total"], 1);
}

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn permissions_separate_reading_moving_and_administering(db: PgPool) {
    let e = env(db).await;
    e.receive(FRAME, &e.main, "5").await;
    for who in [ADMIN, SALES, VIEWER, STORES, PM] {
        let (status, _) = get(&e.app, who, "/inventory/stock").await;
        assert_eq!(status, StatusCode::OK, "{who} reads stock");
    }
    for uri in [
        "/inventory/stock",
        "/inventory/moves",
        "/inventory/warehouses",
        "/inventory/counts",
        "/inventory/integrity",
    ] {
        let (status, _) = get(&e.app, TECH, uri).await;
        assert_eq!(status, StatusCode::FORBIDDEN, "{uri}");
    }
    for who in [SALES, VIEWER, PM] {
        let (status, _) = post(
            &e.app,
            who,
            "/inventory/receipts",
            json!({ "id": uid(), "product_id": FRAME, "location_id": e.main, "quantity": "1" }),
        )
        .await;
        assert_eq!(status, StatusCode::FORBIDDEN, "{who}");
        let (status, _) = post(
            &e.app,
            who,
            "/inventory/counts",
            json!({ "warehouse_id": e.wh }),
        )
        .await;
        assert_eq!(status, StatusCode::FORBIDDEN, "{who}");
    }
    let (status, _) = get(&e.app, STORES, "/inventory/integrity").await;
    assert_eq!(status, StatusCode::FORBIDDEN);
    let (status, _) = post(
        &e.app,
        STORES,
        "/inventory/uoms",
        json!({ "code": "box", "name": "Box", "category": "unit", "factor": "1" }),
    )
    .await;
    assert_eq!(status, StatusCode::FORBIDDEN);
    let (status, u) = post(
        &e.app,
        ADMIN,
        "/inventory/uoms",
        json!({ "code": "dz", "name": "Dozen", "category": "unit", "factor": "12" }),
    )
    .await;
    assert_eq!(status, StatusCode::CREATED, "{u}");
    // Nothing was written by the refused calls.
    let n: i64 = sqlx::query_scalar("SELECT count(*) FROM inventory.stock_moves")
        .fetch_one(&e.db)
        .await
        .unwrap();
    assert_eq!(n, 1);
    // The audit trail records configuration and corrections.
    let audited: i64 = sqlx::query_scalar(
        "SELECT count(*) FROM audit.events WHERE entity IN ('warehouse', 'uom')",
    )
    .fetch_one(&e.db)
    .await
    .unwrap();
    assert!(audited >= 2);
}

async fn second_company(db: &PgPool) -> String {
    let company = Uuid::now_v7();
    sqlx::query("INSERT INTO core.companies (id, name, country_code, currency) VALUES ($1, 'Other BV', 'BE', 'EUR')")
        .bind(company)
        .execute(db)
        .await
        .unwrap();
    let id = Uuid::now_v7();
    sqlx::query("INSERT INTO core.users (id, email, display_name) VALUES ($1, 'other@example.com', 'Other')").bind(id).execute(db).await.unwrap();
    sqlx::query("INSERT INTO core.user_companies (user_id, company_id, roles, is_default) VALUES ($1, $2, '{admin}', true)").bind(id).bind(company).execute(db).await.unwrap();
    company.to_string()
}

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn another_company_sees_and_touches_nothing(db: PgPool) {
    let e = env(db).await;
    let other = second_company(&e.db).await;
    let _ = other;
    let (_, m) = {
        e.receive(FRAME, &e.main, "5").await;
        let (s, m) = post(
            &e.app,
            STORES,
            "/inventory/receipts",
            json!({ "id": uid(), "product_id": FRAME, "location_id": e.main, "quantity": "1" }),
        )
        .await;
        (s, m)
    };
    let (_, ow) = post(
        &e.app,
        "other@example.com",
        "/inventory/warehouses",
        json!({ "code": "WH1", "name": "Their warehouse" }),
    )
    .await;
    let their_loc = ow["locations"][0]["id"].as_str().unwrap().to_string();
    assert_eq!(ow["code"], "WH1", "codes are per company");

    let (_, w) = get(&e.app, "other@example.com", "/inventory/warehouses").await;
    assert_eq!(w.as_array().unwrap().len(), 1);
    let (_, s) = get(&e.app, "other@example.com", "/inventory/stock").await;
    assert_eq!(s["total"], 0);
    let (_, h) = get(&e.app, "other@example.com", "/inventory/moves").await;
    assert_eq!(h["total"], 0);
    let mid = m["id"].as_str().unwrap();
    let (status, _) = get(
        &e.app,
        "other@example.com",
        &format!("/inventory/moves/{mid}"),
    )
    .await;
    assert_eq!(status, StatusCode::NOT_FOUND);
    // Our locations are not theirs to receive into, nor can they reuse our move ids.
    let (status, _) = post(
        &e.app,
        "other@example.com",
        "/inventory/receipts",
        json!({ "id": uid(), "product_id": FRAME, "location_id": e.main, "quantity": "1" }),
    )
    .await;
    assert_eq!(status, StatusCode::NOT_FOUND);
    let (status, _) = post(
        &e.app,
        "other@example.com",
        "/inventory/receipts",
        json!({ "id": mid, "product_id": FRAME, "location_id": their_loc, "quantity": "1" }),
    )
    .await;
    assert_eq!(status, StatusCode::CONFLICT);
    let (status, _) = post(
        &e.app,
        "other@example.com",
        &format!("/inventory/moves/{mid}/reverse"),
        json!({ "id": uid() }),
    )
    .await;
    assert_eq!(status, StatusCode::NOT_FOUND);
    // Locations cannot be moved between companies either.
    let (status, _) = post(&e.app, "other@example.com", "/inventory/transfers", json!({ "id": uid(), "product_id": FRAME, "from_location_id": e.main, "to_location_id": their_loc, "quantity": "1" })).await;
    assert_eq!(status, StatusCode::NOT_FOUND);
    let (status, _) = api(
        &e.app,
        "other@example.com",
        Method::PUT,
        &format!("/inventory/warehouses/{}", e.wh),
        Some(json!({ "code": "X", "name": "x" })),
    )
    .await;
    assert_eq!(status, StatusCode::NOT_FOUND);
    let (status, _) = post(
        &e.app,
        "other@example.com",
        "/inventory/counts",
        json!({ "warehouse_id": e.wh }),
    )
    .await;
    assert_eq!(status, StatusCode::NOT_FOUND);
    // An order line of ours cannot be reserved for by them.
    let (_, line) = order_with(&e.app, FRAME, "1").await;
    let (status, _) = api(
        &e.app,
        "other@example.com",
        Method::PUT,
        &format!("/inventory/order-lines/{line}/reservation"),
        Some(json!({ "quantity": "1" })),
    )
    .await;
    assert_eq!(status, StatusCode::NOT_FOUND);
    // Their own ledger is independent and consistent.
    let (status, _) = post(
        &e.app,
        "other@example.com",
        "/inventory/receipts",
        json!({ "id": uid(), "product_id": FRAME, "location_id": their_loc, "quantity": "3" }),
    )
    .await;
    assert_eq!(status, StatusCode::CREATED);
    let (_, i) = get(&e.app, "other@example.com", "/inventory/integrity").await;
    assert_eq!(i["ok"], true);
    assert_eq!(e.totals(FRAME).await.0, q("6"), "ours is unchanged");
}

#[sqlx::test(migrator = "traydcraft_api::MIGRATOR")]
async fn every_inventory_query_filters_on_the_company(_db: PgPool) {
    // A static check, as the roadmap asks: statements in the crate that read a transactional
    // table must mention company_id.
    let dir = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../crates/inventory/src");
    let tables = [
        "stock_moves",
        "stock_balances",
        "reservations",
        "counts",
        "count_lines",
        "lots",
        "warehouses",
        "locations",
    ];
    let mut missing = Vec::new();
    for entry in std::fs::read_dir(dir).unwrap() {
        let path = entry.unwrap().path();
        let text = std::fs::read_to_string(&path).unwrap();
        // String literals that look like SQL. Fragments declared as `const X: &str = "SELECT ..."`
        // are completed by a WHERE clause where they are used, and that literal is checked.
        let mut offset = 0;
        for (i, lit) in text.split('"').enumerate() {
            let start = offset;
            offset += lit.len() + 1;
            if i % 2 == 0 {
                continue;
            }
            let before = &text[start.saturating_sub(70)..start];
            if before.contains("const ") || lit.contains("{filter}") {
                continue;
            }
            let sql = lit.to_lowercase();
            let is_query = sql.contains("select")
                || sql.contains("update inventory.")
                || sql.contains("delete from");
            let touches = tables
                .iter()
                .any(|t| sql.contains(&format!("inventory.{t}")));
            if is_query && touches && !sql.contains("company_id") && !sql.contains("where id = $1")
            {
                missing.push(format!(
                    "{}: {}",
                    path.file_name().unwrap().to_string_lossy(),
                    lit.chars().take(90).collect::<String>()
                ));
            }
        }
    }
    assert!(
        missing.is_empty(),
        "queries without company_id:\n{}",
        missing.join("\n")
    );
}
