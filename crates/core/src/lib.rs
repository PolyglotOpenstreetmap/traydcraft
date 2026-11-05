//! Shared foundation used by every business module.

pub mod audit;
pub mod auth;
pub mod company;
pub mod error;
pub mod numbering;
pub mod serde_util;
pub mod state;

pub use auth::{CurrentUser, Permission};
pub use error::{AppError, AppResult};
pub use state::{AppState, DocumentConfig};

/// New primary keys are UUIDv7: globally unique (safe to generate offline on
/// mobile devices) and time-ordered (index friendly).
pub fn new_id() -> uuid::Uuid {
    uuid::Uuid::now_v7()
}

/// Today's date (UTC). Business dates are calendar dates without time zone.
pub fn today() -> chrono::NaiveDate {
    chrono::Utc::now().date_naive()
}
