use chrono::{DateTime, NaiveDate, Utc};
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use utoipa::{IntoParams, ToSchema};
use uuid::Uuid;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize, ToSchema)]
#[serde(rename_all = "snake_case")]
pub enum QuotationStatus {
    Draft,
    Sent,
    Accepted,
    Rejected,
    Superseded,
}

impl QuotationStatus {
    pub fn as_str(self) -> &'static str {
        match self {
            QuotationStatus::Draft => "draft",
            QuotationStatus::Sent => "sent",
            QuotationStatus::Accepted => "accepted",
            QuotationStatus::Rejected => "rejected",
            QuotationStatus::Superseded => "superseded",
        }
    }

    pub fn parse(s: &str) -> Option<Self> {
        Some(match s {
            "draft" => QuotationStatus::Draft,
            "sent" => QuotationStatus::Sent,
            "accepted" => QuotationStatus::Accepted,
            "rejected" => QuotationStatus::Rejected,
            "superseded" => QuotationStatus::Superseded,
            _ => return None,
        })
    }
}

#[derive(Debug, Clone, Deserialize, ToSchema)]
pub struct QuotationLineInput {
    pub product_id: Uuid,
    #[schema(value_type = String, example = "2")]
    pub quantity: Decimal,
    #[serde(default)]
    #[schema(value_type = String, example = "0")]
    pub line_discount_percent: Decimal,
    /// Overrides the product name on the document.
    pub description: Option<String>,
}

#[derive(Debug, Clone, Deserialize, ToSchema)]
pub struct QuotationInput {
    pub customer_id: Uuid,
    /// Links the quotation to an open opportunity of the same customer.
    pub opportunity_id: Option<Uuid>,
    /// Defaults to today. Prices valid on this date are used.
    #[serde(default, deserialize_with = "traydcraft_core::serde_util::opt_date")]
    pub quote_date: Option<NaiveDate>,
    /// Defaults to 30 days.
    pub valid_days: Option<i64>,
    #[serde(default)]
    pub notes: String,
    pub lines: Vec<QuotationLineInput>,
}

#[derive(Debug, Clone, Deserialize, ToSchema)]
pub struct PricingPreviewInput {
    pub customer_id: Uuid,
    #[serde(default, deserialize_with = "traydcraft_core::serde_util::opt_date")]
    pub quote_date: Option<NaiveDate>,
    pub lines: Vec<QuotationLineInput>,
}

#[derive(Debug, Clone, Serialize, FromRow, ToSchema)]
pub struct QuotationLine {
    pub position: i32,
    pub product_id: Option<Uuid>,
    pub product_code: String,
    pub description: String,
    pub unit: String,
    #[schema(value_type = String)]
    pub quantity: Decimal,
    #[schema(value_type = String)]
    pub list_unit_price: Decimal,
    #[schema(value_type = String)]
    pub line_discount_percent: Decimal,
    #[schema(value_type = String)]
    pub net_unit_price: Decimal,
    #[schema(value_type = String)]
    pub line_total: Decimal,
    #[schema(value_type = String)]
    pub vat_rate: Decimal,
}

#[derive(Debug, Clone, Serialize, ToSchema)]
pub struct VatGroup {
    #[schema(value_type = String)]
    pub vat_rate: Decimal,
    #[schema(value_type = String)]
    pub base: Decimal,
    #[schema(value_type = String)]
    pub vat: Decimal,
}

/// Result of pricing lines without saving anything.
#[derive(Debug, Clone, Serialize, ToSchema)]
pub struct PricingPreview {
    pub price_zone_code: String,
    #[schema(value_type = String)]
    pub customer_discount_percent: Decimal,
    pub quote_date: NaiveDate,
    pub lines: Vec<QuotationLine>,
    pub vat_groups: Vec<VatGroup>,
    #[schema(value_type = String)]
    pub subtotal: Decimal,
    #[schema(value_type = String)]
    pub vat_total: Decimal,
    #[schema(value_type = String)]
    pub total: Decimal,
}

#[derive(Debug, Clone, Serialize, FromRow, ToSchema)]
pub struct QuotationSummary {
    pub id: Uuid,
    pub number: String,
    pub revision: i32,
    #[schema(value_type = QuotationStatus)]
    pub status: String,
    pub customer_id: Uuid,
    pub opportunity_id: Option<Uuid>,
    pub customer_name: String,
    pub quote_date: NaiveDate,
    pub valid_until: NaiveDate,
    pub currency: String,
    #[schema(value_type = String)]
    pub subtotal: Decimal,
    #[schema(value_type = String)]
    pub total: Decimal,
}

#[derive(Debug, Serialize, ToSchema)]
pub struct QuotationPage {
    pub items: Vec<QuotationSummary>,
    pub total: i64,
}

#[derive(Debug, Clone, Serialize, FromRow, ToSchema)]
pub struct QuotationHeader {
    pub id: Uuid,
    pub company_id: Uuid,
    pub number: String,
    pub revision: i32,
    #[schema(value_type = QuotationStatus)]
    pub status: String,
    pub customer_id: Uuid,
    pub opportunity_id: Option<Uuid>,
    pub customer_name: String,
    pub customer_vat_number: Option<String>,
    pub customer_street: String,
    pub customer_postal_code: String,
    pub customer_city: String,
    pub customer_country_code: String,
    pub customer_language: String,
    pub price_zone_code: String,
    #[schema(value_type = String)]
    pub customer_discount_percent: Decimal,
    pub currency: String,
    pub quote_date: NaiveDate,
    pub valid_until: NaiveDate,
    pub notes: String,
    #[schema(value_type = String)]
    pub subtotal: Decimal,
    #[schema(value_type = String)]
    pub vat_total: Decimal,
    #[schema(value_type = String)]
    pub total: Decimal,
    pub supersedes_id: Option<Uuid>,
    pub created_by: Uuid,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub sent_at: Option<DateTime<Utc>>,
}

/// A quotation with its lines (flat JSON: header fields, `lines`, `vat_groups`).
#[derive(Debug, Clone, Serialize, ToSchema)]
pub struct Quotation {
    pub id: Uuid,
    pub company_id: Uuid,
    pub number: String,
    pub revision: i32,
    #[schema(value_type = QuotationStatus)]
    pub status: String,
    pub customer_id: Uuid,
    pub opportunity_id: Option<Uuid>,
    pub customer_name: String,
    pub customer_vat_number: Option<String>,
    pub customer_street: String,
    pub customer_postal_code: String,
    pub customer_city: String,
    pub customer_country_code: String,
    pub customer_language: String,
    pub price_zone_code: String,
    #[schema(value_type = String)]
    pub customer_discount_percent: Decimal,
    pub currency: String,
    pub quote_date: NaiveDate,
    pub valid_until: NaiveDate,
    pub notes: String,
    #[schema(value_type = String)]
    pub subtotal: Decimal,
    #[schema(value_type = String)]
    pub vat_total: Decimal,
    #[schema(value_type = String)]
    pub total: Decimal,
    pub supersedes_id: Option<Uuid>,
    pub created_by: Uuid,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub sent_at: Option<DateTime<Utc>>,
    pub lines: Vec<QuotationLine>,
    pub vat_groups: Vec<VatGroup>,
}

impl Quotation {
    pub fn new(h: QuotationHeader, lines: Vec<QuotationLine>, vat_groups: Vec<VatGroup>) -> Self {
        Quotation {
            id: h.id,
            company_id: h.company_id,
            number: h.number,
            revision: h.revision,
            status: h.status,
            customer_id: h.customer_id,
            opportunity_id: h.opportunity_id,
            customer_name: h.customer_name,
            customer_vat_number: h.customer_vat_number,
            customer_street: h.customer_street,
            customer_postal_code: h.customer_postal_code,
            customer_city: h.customer_city,
            customer_country_code: h.customer_country_code,
            customer_language: h.customer_language,
            price_zone_code: h.price_zone_code,
            customer_discount_percent: h.customer_discount_percent,
            currency: h.currency,
            quote_date: h.quote_date,
            valid_until: h.valid_until,
            notes: h.notes,
            subtotal: h.subtotal,
            vat_total: h.vat_total,
            total: h.total,
            supersedes_id: h.supersedes_id,
            created_by: h.created_by,
            created_at: h.created_at,
            updated_at: h.updated_at,
            sent_at: h.sent_at,
            lines,
            vat_groups,
        }
    }
}

#[derive(Debug, Deserialize, IntoParams)]
pub struct ListParams {
    /// Searches number and customer name.
    pub q: Option<String>,
    pub status: Option<String>,
    pub customer_id: Option<Uuid>,
    pub opportunity_id: Option<Uuid>,
    pub limit: Option<i64>,
    pub offset: Option<i64>,
}
