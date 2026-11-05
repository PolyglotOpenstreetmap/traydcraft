//! Data handed to `templates/quotation.typ`. All values are pre-formatted strings.

use serde::Serialize;
use traydcraft_core::company::Company;
use traydcraft_documents::{format_amount, format_date, format_number, format_unit_price};

use crate::model::Quotation;

#[derive(Serialize)]
pub struct Doc {
    pub language: String,
    pub draft: bool,
    pub number: String,
    pub revision: i32,
    pub quote_date: String,
    pub valid_until: String,
    pub currency: String,
    pub notes: String,
    pub company: Party,
    pub customer: Party,
    pub lines: Vec<Line>,
    pub vat_groups: Vec<Vat>,
    pub subtotal: String,
    pub vat_total: String,
    pub total: String,
    pub iban: String,
}

#[derive(Serialize)]
pub struct Party {
    pub name: String,
    pub vat_number: String,
    pub street: String,
    pub city_line: String,
    pub country_code: String,
    pub contact: String,
}

#[derive(Serialize)]
pub struct Line {
    pub code: String,
    pub description: String,
    pub quantity: String,
    pub unit: String,
    pub unit_price: String,
    pub discount: String,
    pub vat_rate: String,
    pub total: String,
}

#[derive(Serialize)]
pub struct Vat {
    pub rate: String,
    pub base: String,
    pub vat: String,
}

pub fn document(company: &Company, q: &Quotation) -> Doc {
    let h = q;
    let has_customer_discount = !h.customer_discount_percent.is_zero();
    Doc {
        language: h.customer_language.clone(),
        draft: h.status == "draft",
        number: h.number.clone(),
        revision: h.revision,
        quote_date: format_date(h.quote_date),
        valid_until: format_date(h.valid_until),
        currency: h.currency.clone(),
        notes: h.notes.clone(),
        company: Party {
            name: company.name.clone(),
            vat_number: company.vat_number.clone().unwrap_or_default(),
            street: company.street.clone(),
            city_line: format!("{} {}", company.postal_code, company.city)
                .trim()
                .to_string(),
            country_code: company.country_code.clone(),
            contact: [company.phone.clone(), company.email.clone()]
                .into_iter()
                .flatten()
                .collect::<Vec<_>>()
                .join(" · "),
        },
        customer: Party {
            name: h.customer_name.clone(),
            vat_number: h.customer_vat_number.clone().unwrap_or_default(),
            street: h.customer_street.clone(),
            city_line: format!("{} {}", h.customer_postal_code, h.customer_city)
                .trim()
                .to_string(),
            country_code: h.customer_country_code.clone(),
            contact: String::new(),
        },
        lines: q
            .lines
            .iter()
            .map(|l| {
                // The document shows one combined discount, consistent with the net line total.
                let combined = if has_customer_discount || !l.line_discount_percent.is_zero() {
                    let hundred = rust_decimal::Decimal::ONE_HUNDRED;
                    let factor = (hundred - h.customer_discount_percent)
                        * (hundred - l.line_discount_percent)
                        / hundred;
                    format!("{} %", format_number((hundred - factor).round_dp(2)))
                } else {
                    String::new()
                };
                Line {
                    code: l.product_code.clone(),
                    description: l.description.clone(),
                    quantity: format_number(l.quantity),
                    unit: l.unit.clone(),
                    unit_price: format_unit_price(l.list_unit_price),
                    discount: combined,
                    vat_rate: format!("{} %", format_number(l.vat_rate)),
                    total: format_amount(l.line_total),
                }
            })
            .collect(),
        vat_groups: q
            .vat_groups
            .iter()
            .map(|g| Vat {
                rate: format!("{} %", format_number(g.vat_rate)),
                base: format_amount(g.base),
                vat: format_amount(g.vat),
            })
            .collect(),
        subtotal: format_amount(h.subtotal),
        vat_total: format_amount(h.vat_total),
        total: format_amount(h.total),
        iban: company.iban.clone().unwrap_or_default(),
    }
}
