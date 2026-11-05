//! HTTP application: wires the business modules into one API.

use axum::Router;
use tower_http::cors::{Any, CorsLayer};
use tower_http::trace::TraceLayer;
use traydcraft_core::AppState;
use utoipa::openapi::security::{HttpAuthScheme, HttpBuilder, SecurityScheme};
use utoipa::openapi::OpenApi as OpenApiDoc;
use utoipa::{Modify, OpenApi};
use utoipa_axum::router::OpenApiRouter;
use utoipa_scalar::{Scalar, Servable};

pub static MIGRATOR: sqlx::migrate::Migrator = sqlx::migrate!("../../migrations");

/// Development seed data: one company, five price zones, users, customers and products.
pub const DEV_SEED_SQL: &str = include_str!("../../../seed/dev_seed.sql");

#[derive(OpenApi)]
#[openapi(
    info(title = "traydcraft API", description = "Business platform API (CRM, products, pricing, sales, engineering)."),
    modifiers(&Security),
    security(("bearer" = [])),
    tags(
        (name = "core", description = "Users and companies"),
        (name = "crm", description = "Customers and opportunities"),
        (name = "products", description = "Products, price zones and price lists"),
        (name = "sales", description = "Quotations, pricing and orders"),
        (name = "engineering", description = "Bills of materials and serial numbers"),
        (name = "helpdesk", description = "Tickets, e-mail and prepared answers"),
    )
)]
struct ApiDoc;

struct Security;

impl Modify for Security {
    fn modify(&self, openapi: &mut OpenApiDoc) {
        let components = openapi.components.get_or_insert_with(Default::default);
        components.add_security_scheme(
            "bearer",
            SecurityScheme::Http(
                HttpBuilder::new()
                    .scheme(HttpAuthScheme::Bearer)
                    .bearer_format("JWT")
                    .build(),
            ),
        );
    }
}

fn api() -> (Router<AppState>, OpenApiDoc) {
    let v1 = OpenApiRouter::new()
        .merge(traydcraft_core::company::router())
        .merge(traydcraft_crm::router())
        .merge(traydcraft_products::router())
        .merge(traydcraft_sales::router())
        .merge(traydcraft_engineering::router())
        .merge(traydcraft_helpdesk::router());
    OpenApiRouter::with_openapi(ApiDoc::openapi())
        .nest("/api/v1", v1)
        .split_for_parts()
}

pub fn openapi() -> OpenApiDoc {
    api().1
}

pub fn app(state: AppState) -> Router {
    let (router, doc) = api();
    router
        .route("/health", axum::routing::get(|| async { "ok" }))
        .merge(Scalar::with_url("/docs", doc.clone()))
        .route(
            "/api-docs/openapi.json",
            axum::routing::get(move || async move { axum::Json(doc) }),
        )
        .layer(TraceLayer::new_for_http())
        .layer(
            CorsLayer::new()
                .allow_origin(Any)
                .allow_methods(Any)
                .allow_headers(Any),
        )
        .with_state(state)
}

/// Loads development seed data if the database has no company yet.
pub async fn seed_if_empty(db: &sqlx::PgPool) -> anyhow::Result<bool> {
    let companies: i64 = sqlx::query_scalar("SELECT count(*) FROM core.companies")
        .fetch_one(db)
        .await?;
    if companies > 0 {
        return Ok(false);
    }
    sqlx::raw_sql(DEV_SEED_SQL).execute(db).await?;
    Ok(true)
}
