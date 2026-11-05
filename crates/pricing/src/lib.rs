//! Pricing engine.
//!
//! This crate is deliberately free of I/O: it receives prices and conditions,
//! and returns calculated amounts. Every client (office, mobile, PDF, invoices)
//! gets its numbers from here, so two screens can never disagree on a price.
//!
//! Rules:
//! * Amounts are `Decimal`, never floating point.
//! * The list price comes from the customer's price zone, valid at the quote date.
//! * Discounts cascade: customer discount first, then the line discount.
//! * Line totals are rounded once, to 2 decimals, half away from zero.
//! * VAT is calculated per VAT rate on the sum of the line totals (not per line).

use chrono::NaiveDate;
use rust_decimal::{Decimal, RoundingStrategy};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

const HUNDRED: Decimal = Decimal::ONE_HUNDRED;

#[derive(Debug, thiserror::Error, PartialEq, Eq)]
pub enum PricingError {
    #[error("quantity must be greater than zero")]
    NonPositiveQuantity,
    #[error("discount must be between 0 and 100 percent")]
    InvalidDiscount,
    #[error("unit price cannot be negative")]
    NegativePrice,
    #[error("VAT rate cannot be negative")]
    NegativeVatRate,
    #[error("no price for this product in price zone {zone_code} on {date}")]
    NoPrice { zone_code: String, date: NaiveDate },
}

/// One entry of a zone price list. Entries are never modified; a new price
/// is a new entry with a later `valid_from`.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct ZonePrice {
    pub zone_id: Uuid,
    pub unit_price: Decimal,
    pub valid_from: NaiveDate,
}

/// Returns the price of the given zone valid on `date`: the entry with the
/// latest `valid_from` that is not after `date`.
pub fn resolve_zone_price(prices: &[ZonePrice], zone_id: Uuid, date: NaiveDate) -> Option<Decimal> {
    prices
        .iter()
        .filter(|p| p.zone_id == zone_id && p.valid_from <= date)
        .max_by_key(|p| p.valid_from)
        .map(|p| p.unit_price)
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct LineInput {
    pub list_unit_price: Decimal,
    pub quantity: Decimal,
    pub customer_discount_percent: Decimal,
    pub line_discount_percent: Decimal,
    pub vat_rate: Decimal,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct PricedLine {
    pub list_unit_price: Decimal,
    pub quantity: Decimal,
    pub customer_discount_percent: Decimal,
    pub line_discount_percent: Decimal,
    /// Net unit price after both discounts, rounded to 4 decimals (informative).
    pub net_unit_price: Decimal,
    /// Line amount excluding VAT, rounded to 2 decimals (authoritative).
    pub line_total: Decimal,
    pub vat_rate: Decimal,
}

fn round_money(d: Decimal) -> Decimal {
    d.round_dp_with_strategy(2, RoundingStrategy::MidpointAwayFromZero)
}

fn round_unit(d: Decimal) -> Decimal {
    d.round_dp_with_strategy(4, RoundingStrategy::MidpointAwayFromZero)
}

fn valid_discount(d: Decimal) -> bool {
    d >= Decimal::ZERO && d <= HUNDRED
}

/// Prices a single line.
pub fn price_line(input: &LineInput) -> Result<PricedLine, PricingError> {
    if input.quantity <= Decimal::ZERO {
        return Err(PricingError::NonPositiveQuantity);
    }
    if input.list_unit_price < Decimal::ZERO {
        return Err(PricingError::NegativePrice);
    }
    if !valid_discount(input.customer_discount_percent)
        || !valid_discount(input.line_discount_percent)
    {
        return Err(PricingError::InvalidDiscount);
    }
    if input.vat_rate < Decimal::ZERO {
        return Err(PricingError::NegativeVatRate);
    }

    let factor = (HUNDRED - input.customer_discount_percent) / HUNDRED
        * (HUNDRED - input.line_discount_percent)
        / HUNDRED;
    let net_unit_exact = input.list_unit_price * factor;

    Ok(PricedLine {
        list_unit_price: input.list_unit_price,
        quantity: input.quantity,
        customer_discount_percent: input.customer_discount_percent,
        line_discount_percent: input.line_discount_percent,
        net_unit_price: round_unit(net_unit_exact),
        // Round once, from the exact value, to avoid double-rounding drift.
        line_total: round_money(net_unit_exact * input.quantity),
        vat_rate: input.vat_rate,
    })
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct VatGroup {
    pub vat_rate: Decimal,
    pub base: Decimal,
    pub vat: Decimal,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct Totals {
    pub subtotal: Decimal,
    /// Sorted by VAT rate, descending.
    pub vat_groups: Vec<VatGroup>,
    pub vat_total: Decimal,
    pub total: Decimal,
}

/// Document totals: VAT is computed per rate on the summed bases.
pub fn totals(lines: &[PricedLine]) -> Totals {
    let mut groups: Vec<VatGroup> = Vec::new();
    for line in lines {
        match groups.iter_mut().find(|g| g.vat_rate == line.vat_rate) {
            Some(g) => g.base += line.line_total,
            None => groups.push(VatGroup {
                vat_rate: line.vat_rate,
                base: line.line_total,
                vat: Decimal::ZERO,
            }),
        }
    }
    for g in &mut groups {
        g.vat = round_money(g.base * g.vat_rate / HUNDRED);
    }
    groups.sort_by_key(|g| std::cmp::Reverse(g.vat_rate));

    let subtotal: Decimal = groups.iter().map(|g| g.base).sum();
    let vat_total: Decimal = groups.iter().map(|g| g.vat).sum();
    Totals {
        subtotal,
        vat_total,
        total: subtotal + vat_total,
        vat_groups: groups,
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use rust_decimal_macros::dec;

    fn line(price: Decimal, qty: Decimal, cust: Decimal, disc: Decimal, vat: Decimal) -> LineInput {
        LineInput {
            list_unit_price: price,
            quantity: qty,
            customer_discount_percent: cust,
            line_discount_percent: disc,
            vat_rate: vat,
        }
    }

    fn d(s: &str) -> NaiveDate {
        NaiveDate::parse_from_str(s, "%Y-%m-%d").unwrap()
    }

    #[test]
    fn plain_line_without_discounts() {
        let p = price_line(&line(dec!(12.50), dec!(4), dec!(0), dec!(0), dec!(21))).unwrap();
        assert_eq!(p.net_unit_price, dec!(12.50));
        assert_eq!(p.line_total, dec!(50.00));
    }

    #[test]
    fn discounts_cascade_not_add() {
        // 10% then 5% = 14.5%, not 15%.
        let p = price_line(&line(dec!(100), dec!(1), dec!(10), dec!(5), dec!(21))).unwrap();
        assert_eq!(p.net_unit_price, dec!(85.50));
        assert_eq!(p.line_total, dec!(85.50));
    }

    #[test]
    fn line_total_rounded_once_from_exact_value() {
        // net unit = 0.33335 * 0.9 = 0.300015 -> unit shown 0.3000;
        // line = 0.300015 * 1000 = 300.015 -> 300.02 (not 0.3000*1000 = 300.00)
        let p = price_line(&line(
            dec!(0.33335),
            dec!(1000),
            dec!(10),
            dec!(0),
            dec!(21),
        ))
        .unwrap();
        assert_eq!(p.net_unit_price, dec!(0.3000));
        assert_eq!(p.line_total, dec!(300.02));
    }

    #[test]
    fn midpoint_rounds_away_from_zero() {
        let p = price_line(&line(dec!(0.005), dec!(1), dec!(0), dec!(0), dec!(21))).unwrap();
        assert_eq!(p.line_total, dec!(0.01));
    }

    #[test]
    fn fractional_quantities() {
        let p = price_line(&line(dec!(19.99), dec!(2.5), dec!(0), dec!(0), dec!(21))).unwrap();
        assert_eq!(p.line_total, dec!(49.98)); // 49.975 -> 49.98
    }

    #[test]
    fn full_discount_gives_zero() {
        let p = price_line(&line(dec!(250), dec!(3), dec!(0), dec!(100), dec!(21))).unwrap();
        assert_eq!(p.line_total, dec!(0.00));
    }

    #[test]
    fn rejects_invalid_input() {
        assert_eq!(
            price_line(&line(dec!(1), dec!(0), dec!(0), dec!(0), dec!(21))),
            Err(PricingError::NonPositiveQuantity)
        );
        assert_eq!(
            price_line(&line(dec!(1), dec!(1), dec!(-1), dec!(0), dec!(21))),
            Err(PricingError::InvalidDiscount)
        );
        assert_eq!(
            price_line(&line(dec!(1), dec!(1), dec!(0), dec!(100.01), dec!(21))),
            Err(PricingError::InvalidDiscount)
        );
        assert_eq!(
            price_line(&line(dec!(-1), dec!(1), dec!(0), dec!(0), dec!(21))),
            Err(PricingError::NegativePrice)
        );
        assert_eq!(
            price_line(&line(dec!(1), dec!(1), dec!(0), dec!(0), dec!(-6))),
            Err(PricingError::NegativeVatRate)
        );
    }

    #[test]
    fn vat_is_computed_per_rate_on_summed_base() {
        // Three lines of 0.05 at 21%: per-line VAT would be 3 x 0.01 = 0.03,
        // per-rate VAT on 0.15 is 0.0315 -> 0.03. Use values where it differs:
        // 3 x 0.10 at 6%: per line 0.006 -> 0.01 each = 0.03; on base 0.30 -> 0.018 -> 0.02.
        let lines: Vec<_> = (0..3)
            .map(|_| price_line(&line(dec!(0.10), dec!(1), dec!(0), dec!(0), dec!(6))).unwrap())
            .collect();
        let t = totals(&lines);
        assert_eq!(t.subtotal, dec!(0.30));
        assert_eq!(t.vat_total, dec!(0.02));
        assert_eq!(t.total, dec!(0.32));
    }

    #[test]
    fn totals_group_multiple_vat_rates() {
        let lines = vec![
            price_line(&line(dec!(100), dec!(2), dec!(0), dec!(0), dec!(21))).unwrap(),
            price_line(&line(dec!(50), dec!(1), dec!(0), dec!(0), dec!(6))).unwrap(),
            price_line(&line(dec!(10), dec!(1), dec!(0), dec!(0), dec!(21))).unwrap(),
        ];
        let t = totals(&lines);
        assert_eq!(t.vat_groups.len(), 2);
        assert_eq!(
            t.vat_groups[0],
            VatGroup {
                vat_rate: dec!(21),
                base: dec!(210),
                vat: dec!(44.10)
            }
        );
        assert_eq!(
            t.vat_groups[1],
            VatGroup {
                vat_rate: dec!(6),
                base: dec!(50),
                vat: dec!(3.00)
            }
        );
        assert_eq!(t.subtotal, dec!(260));
        assert_eq!(t.vat_total, dec!(47.10));
        assert_eq!(t.total, dec!(307.10));
    }

    #[test]
    fn empty_document_totals_zero() {
        let t = totals(&[]);
        assert_eq!(t.total, Decimal::ZERO);
        assert!(t.vat_groups.is_empty());
    }

    #[test]
    fn zone_price_resolution_uses_latest_valid_entry() {
        let zone_a = Uuid::from_u128(1);
        let zone_b = Uuid::from_u128(2);
        let prices = vec![
            ZonePrice {
                zone_id: zone_a,
                unit_price: dec!(100),
                valid_from: d("2026-01-01"),
            },
            ZonePrice {
                zone_id: zone_a,
                unit_price: dec!(110),
                valid_from: d("2026-07-01"),
            },
            ZonePrice {
                zone_id: zone_a,
                unit_price: dec!(120),
                valid_from: d("2027-01-01"),
            },
            ZonePrice {
                zone_id: zone_b,
                unit_price: dec!(90),
                valid_from: d("2026-01-01"),
            },
        ];
        assert_eq!(resolve_zone_price(&prices, zone_a, d("2025-12-31")), None);
        assert_eq!(
            resolve_zone_price(&prices, zone_a, d("2026-01-01")),
            Some(dec!(100))
        );
        assert_eq!(
            resolve_zone_price(&prices, zone_a, d("2026-06-30")),
            Some(dec!(100))
        );
        assert_eq!(
            resolve_zone_price(&prices, zone_a, d("2026-07-01")),
            Some(dec!(110))
        );
        assert_eq!(
            resolve_zone_price(&prices, zone_a, d("2026-11-05")),
            Some(dec!(110))
        );
        assert_eq!(
            resolve_zone_price(&prices, zone_b, d("2026-11-05")),
            Some(dec!(90))
        );
    }
}
