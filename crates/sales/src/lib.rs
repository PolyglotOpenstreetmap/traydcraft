//! Sales: quotations.
//!
//! A quotation is a commercial snapshot. While `draft` it is repriced from the
//! current price lists on every change; from `sent` onwards it is immutable and
//! changes go through a new revision (same number, revision + 1).

mod model;
mod pdf;
mod routes;
mod service;

pub use model::*;
pub use routes::router;
