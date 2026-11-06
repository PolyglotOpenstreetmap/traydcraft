//! Background worker.
//!
//! * Polls the helpdesk mailbox over IMAP (when IMAP_HOST is set) and turns mails into tickets.
//! * Sends queued outgoing e-mails (ticket replies and system mail such as portal login links)
//!   over SMTP, or writes them as .eml files when
//!   MAIL_TRANSPORT=files (development).
//!
//! Several workers may run at once: outbox rows are locked while sent, and IMAP messages are only
//! marked read after they are stored.

use std::path::PathBuf;
use std::time::Duration;

use anyhow::Context;
use sqlx::postgres::PgPoolOptions;
use tracing_subscriber::EnvFilter;
use traydcraft_helpdesk::imap::{poll, ImapConfig};
use traydcraft_helpdesk::mailer::{process_outbox, process_system_mail, Mailer, SmtpSecurity};
use uuid::Uuid;

fn env(name: &str) -> Option<String> {
    std::env::var(name).ok().filter(|v| !v.trim().is_empty())
}

fn mailer() -> anyhow::Result<Mailer> {
    match env("MAIL_TRANSPORT").as_deref().unwrap_or("files") {
        "smtp" => Mailer::smtp(
            &env("SMTP_HOST").context("SMTP_HOST is required for MAIL_TRANSPORT=smtp")?,
            env("SMTP_PORT")
                .map(|p| p.parse())
                .transpose()?
                .unwrap_or(587),
            env("SMTP_USER"),
            env("SMTP_PASSWORD"),
            match env("SMTP_SECURITY").as_deref().unwrap_or("starttls") {
                "starttls" => SmtpSecurity::StartTls,
                "tls" => SmtpSecurity::Tls,
                "none" => SmtpSecurity::None,
                other => anyhow::bail!("unknown SMTP_SECURITY {other} (starttls, tls or none)"),
            },
        ),
        "files" => {
            let dir = PathBuf::from(env("MAIL_FILES_DIR").unwrap_or_else(|| "outbox".into()));
            tracing::warn!(dir = %dir.display(), "MAIL_TRANSPORT=files: e-mails are written to disk, not sent");
            Ok(Mailer::Files(dir))
        }
        other => anyhow::bail!("unknown MAIL_TRANSPORT {other} (expected smtp or files)"),
    }
}

async fn company_id(db: &sqlx::PgPool) -> anyhow::Result<Uuid> {
    if let Some(id) = env("HELPDESK_COMPANY_ID") {
        return Ok(Uuid::parse_str(&id)?);
    }
    let ids: Vec<Uuid> = sqlx::query_scalar("SELECT id FROM core.companies LIMIT 2")
        .fetch_all(db)
        .await?;
    match ids.as_slice() {
        [one] => Ok(*one),
        _ => anyhow::bail!("set HELPDESK_COMPANY_ID: there is not exactly one company"),
    }
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt()
        .with_env_filter(
            EnvFilter::try_from_default_env().unwrap_or_else(|_| "info,sqlx=warn".into()),
        )
        .init();
    let db = PgPoolOptions::new()
        .max_connections(5)
        .connect(&env("DATABASE_URL").context("DATABASE_URL is required")?)
        .await?;
    let mailer = mailer()?;
    let interval = Duration::from_secs(
        env("POLL_SECONDS")
            .map(|s| s.parse())
            .transpose()?
            .unwrap_or(30),
    );
    let imap = match env("IMAP_HOST") {
        Some(host) => Some(ImapConfig {
            host,
            port: env("IMAP_PORT")
                .map(|p| p.parse())
                .transpose()?
                .unwrap_or(993),
            user: env("IMAP_USER").context("IMAP_USER is required")?,
            password: env("IMAP_PASSWORD").context("IMAP_PASSWORD is required")?,
            mailbox: env("IMAP_MAILBOX").unwrap_or_else(|| "INBOX".into()),
            tls: env("IMAP_TLS").as_deref() != Some("false"),
            company_id: company_id(&db).await?,
        }),
        None => {
            tracing::warn!("IMAP_HOST not set: incoming e-mail is not fetched");
            None
        }
    };
    tracing::info!(seconds = interval.as_secs(), "worker started");
    loop {
        if let Some(cfg) = &imap {
            match poll(&db, cfg).await {
                Ok(0) => {}
                Ok(n) => tracing::info!(n, "e-mails fetched"),
                Err(e) => tracing::error!(error = ?e, "IMAP poll failed"),
            }
        }
        match process_outbox(&db, &mailer, 50).await {
            Ok(0) => {}
            Ok(n) => tracing::info!(n, "e-mails sent"),
            Err(e) => tracing::error!(error = ?e, "sending the outbox failed"),
        }
        match process_system_mail(&db, &mailer, 50).await {
            Ok(0) => {}
            Ok(n) => tracing::info!(n, "system e-mails sent"),
            Err(e) => tracing::error!(error = ?e, "sending system e-mail failed"),
        }
        tokio::select! {
            _ = tokio::time::sleep(interval) => {}
            _ = tokio::signal::ctrl_c() => {
                tracing::info!("stopping");
                return Ok(());
            }
        }
    }
}
