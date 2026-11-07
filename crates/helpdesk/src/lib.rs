//! Helpdesk, inspired by Zammad: e-mails become tickets, agents answer from the ticket (with
//! prepared answers in the customer's language), internal notes carry questions between
//! colleagues, and tickets link to leads, quotations and orders. Tickets have service levels
//! (SLA), teams, attachments, tags, time entries and satisfaction surveys.

pub mod answers;
pub mod attachments;
pub mod classify;
pub mod collab;
pub mod csat;
pub mod email;
pub mod extras;
pub mod imap;
pub mod ingest;
pub mod language;
pub mod mailer;
pub mod portal;
pub mod render;
pub mod sla;
pub mod teams;
pub mod tickets;

use traydcraft_core::AppState;
use utoipa_axum::router::OpenApiRouter;

pub fn router() -> OpenApiRouter<AppState> {
    tickets::router().merge(answers::router())
}
