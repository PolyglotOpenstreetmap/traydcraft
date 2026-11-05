//! Helpdesk, inspired by Zammad: e-mails become tickets, agents answer from the ticket (with
//! prepared answers in the customer's language), internal notes carry questions between
//! colleagues, and tickets link to leads, quotations and orders.

pub mod answers;
pub mod classify;
pub mod email;
pub mod imap;
pub mod ingest;
pub mod language;
pub mod mailer;
pub mod render;
pub mod tickets;

use traydcraft_core::AppState;
use utoipa_axum::router::OpenApiRouter;

pub fn router() -> OpenApiRouter<AppState> {
    tickets::router().merge(answers::router())
}
