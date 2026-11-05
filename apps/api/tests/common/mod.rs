//! Shared helpers for API integration tests.
#![allow(dead_code)]

use std::path::PathBuf;
use std::sync::Arc;

use axum::body::Body;
use axum::http::{Method, Request, StatusCode};
use http_body_util::BodyExt;
use rust_decimal::Decimal;
use serde_json::Value;
use sqlx::PgPool;
use tower::ServiceExt;
use traydcraft_core::auth::AuthConfig;
use traydcraft_core::{AppState, DocumentConfig};

pub async fn setup(db: PgPool) -> axum::Router {
    let _ = tracing_subscriber::fmt()
        .with_test_writer()
        .with_env_filter("error")
        .try_init();
    sqlx::raw_sql(traydcraft_api::DEV_SEED_SQL)
        .execute(&db)
        .await
        .unwrap();
    let root = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    traydcraft_api::app(AppState {
        db,
        auth: Arc::new(AuthConfig::Dev {
            default_email: None,
        }),
        documents: Arc::new(DocumentConfig {
            typst_bin: std::env::var("TYPST_BIN")
                .unwrap_or_else(|_| "typst".into())
                .into(),
            template_dir: root.join("templates"),
        }),
    })
}

pub async fn call(
    app: &axum::Router,
    user: &str,
    method: Method,
    uri: &str,
    body: Option<Value>,
) -> (StatusCode, Value) {
    let mut req = Request::builder()
        .method(method)
        .uri(uri)
        .header("x-dev-user", user);
    let body = match body {
        Some(b) => {
            req = req.header("content-type", "application/json");
            Body::from(b.to_string())
        }
        None => Body::empty(),
    };
    let res = app.clone().oneshot(req.body(body).unwrap()).await.unwrap();
    let status = res.status();
    let bytes = res.into_body().collect().await.unwrap().to_bytes();
    (
        status,
        serde_json::from_slice(&bytes).unwrap_or(Value::Null),
    )
}

pub fn dec(v: &Value) -> Decimal {
    v.as_str().expect("decimal as string").parse().unwrap()
}

/// Sends a raw (non-JSON) body, e.g. an e-mail to the import endpoint.
pub async fn call_raw(
    app: &axum::Router,
    user: &str,
    uri: &str,
    content_type: &str,
    body: Vec<u8>,
) -> (StatusCode, Value) {
    let req = Request::builder()
        .method(Method::POST)
        .uri(uri)
        .header("x-dev-user", user)
        .header("content-type", content_type)
        .body(Body::from(body))
        .unwrap();
    let res = app.clone().oneshot(req).await.unwrap();
    let status = res.status();
    let bytes = res.into_body().collect().await.unwrap().to_bytes();
    (
        status,
        serde_json::from_slice(&bytes).unwrap_or(Value::Null),
    )
}
