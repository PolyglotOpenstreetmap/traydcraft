use std::net::SocketAddr;
use std::path::PathBuf;
use std::sync::Arc;

use anyhow::Context;
use sqlx::postgres::PgPoolOptions;
use tracing_subscriber::EnvFilter;
use traydcraft_core::auth::{AuthConfig, OidcVerifier};
use traydcraft_core::{AppState, DocumentConfig};

fn env(name: &str) -> Option<String> {
    std::env::var(name).ok().filter(|v| !v.trim().is_empty())
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    // `traydcraft-api openapi` prints the OpenAPI document (used to generate the Dart client).
    if std::env::args().nth(1).as_deref() == Some("openapi") {
        println!(
            "{}",
            serde_json::to_string_pretty(&traydcraft_api::openapi())?
        );
        return Ok(());
    }

    tracing_subscriber::fmt()
        .with_env_filter(
            EnvFilter::try_from_default_env().unwrap_or_else(|_| "info,sqlx=warn".into()),
        )
        .init();

    let database_url = env("DATABASE_URL").context("DATABASE_URL is required")?;
    let db = PgPoolOptions::new()
        .max_connections(20)
        .connect(&database_url)
        .await?;
    traydcraft_api::MIGRATOR
        .run(&db)
        .await
        .context("running migrations")?;

    if env("SEED_DEV_DATA").as_deref() == Some("true") && traydcraft_api::seed_if_empty(&db).await?
    {
        tracing::info!("development seed data loaded");
    }

    let auth = match env("AUTH_MODE").as_deref().unwrap_or("oidc") {
        "dev" => {
            tracing::warn!("AUTH_MODE=dev: X-Dev-User header is trusted. Never use this on a reachable server.");
            AuthConfig::Dev {
                default_email: env("DEV_DEFAULT_USER"),
            }
        }
        "oidc" => AuthConfig::Oidc(OidcVerifier::new(
            env("OIDC_ISSUER").context("OIDC_ISSUER is required when AUTH_MODE=oidc")?,
            env("OIDC_AUDIENCE").context("OIDC_AUDIENCE is required when AUTH_MODE=oidc")?,
        )),
        other => anyhow::bail!("unknown AUTH_MODE {other} (expected oidc or dev)"),
    };

    let documents = DocumentConfig {
        typst_bin: PathBuf::from(env("TYPST_BIN").unwrap_or_else(|| "typst".into())),
        template_dir: PathBuf::from(env("TEMPLATE_DIR").unwrap_or_else(|| "templates".into())),
    };

    let state = AppState {
        db,
        auth: Arc::new(auth),
        documents: Arc::new(documents),
    };
    let addr: SocketAddr = env("BIND_ADDR")
        .unwrap_or_else(|| "0.0.0.0:8080".into())
        .parse()?;
    let listener = tokio::net::TcpListener::bind(addr).await?;
    tracing::info!("listening on http://{addr} (API docs at /docs)");
    axum::serve(listener, traydcraft_api::app(state))
        .with_graceful_shutdown(async {
            let _ = tokio::signal::ctrl_c().await;
        })
        .await?;
    Ok(())
}
