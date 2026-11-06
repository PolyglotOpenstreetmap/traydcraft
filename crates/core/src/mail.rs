//! System e-mail that is not part of a ticket (e.g. portal login links). Rows are queued in the
//! same transaction as the business operation and sent by the worker.

use sqlx::PgConnection;
use uuid::Uuid;

/// Queues a plain-text e-mail from the company's address.
pub async fn enqueue(
    conn: &mut PgConnection,
    company_id: Uuid,
    to_address: &str,
    subject: &str,
    body: &str,
) -> Result<(), sqlx::Error> {
    sqlx::query(
        "INSERT INTO core.mail_outbox (id, company_id, to_address, subject, body) VALUES ($1, $2, $3, $4, $5)",
    )
    .bind(crate::new_id())
    .bind(company_id)
    .bind(to_address)
    .bind(subject)
    .bind(body)
    .execute(conn)
    .await?;
    Ok(())
}
