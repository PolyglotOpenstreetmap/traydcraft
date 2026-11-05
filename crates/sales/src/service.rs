use chrono::{Datelike, Duration, NaiveDate, Utc};
use sqlx::{PgConnection, PgPool};
use traydcraft_core::{new_id, numbering, AppError, AppResult, CurrentUser};
use traydcraft_crm::{get_customer_for_quoting, QuotingCustomer};
use traydcraft_pricing::{price_line, totals, LineInput, PricedLine, Totals};
use traydcraft_products::get_products_for_quoting;
use uuid::Uuid;

use crate::model::*;

pub const DEFAULT_VALID_DAYS: i64 = 30;

/// Customer conditions + priced lines + totals: everything needed to store or show a quotation.
pub struct Priced {
    pub customer: QuotingCustomer,
    pub quote_date: NaiveDate,
    pub lines: Vec<QuotationLine>,
    pub totals: Totals,
}

pub fn today() -> NaiveDate {
    Utc::now().date_naive()
}

/// Prices quotation lines from the current price lists. Used for previews,
/// drafts and new revisions; never for sent quotations.
pub async fn price_lines(
    db: &PgPool,
    company_id: Uuid,
    customer_id: Uuid,
    quote_date: NaiveDate,
    inputs: &[QuotationLineInput],
) -> AppResult<Priced> {
    let customer = get_customer_for_quoting(db, company_id, customer_id).await?;
    let mut ids: Vec<Uuid> = inputs.iter().map(|l| l.product_id).collect();
    ids.sort();
    ids.dedup();
    let products = get_products_for_quoting(
        db,
        company_id,
        customer.price_zone_id,
        &customer.price_zone_code,
        quote_date,
        &ids,
    )
    .await?;

    let mut lines = Vec::with_capacity(inputs.len());
    let mut priced: Vec<PricedLine> = Vec::with_capacity(inputs.len());
    for (i, input) in inputs.iter().enumerate() {
        let qp = &products[&input.product_id];
        let p = price_line(&LineInput {
            list_unit_price: qp.list_unit_price,
            quantity: input.quantity,
            customer_discount_percent: customer.discount_percent,
            line_discount_percent: input.line_discount_percent,
            vat_rate: qp.product.vat_rate,
        })
        .map_err(|e| AppError::Validation(format!("line {}: {e}", i + 1)))?;
        lines.push(QuotationLine {
            position: (i + 1) as i32,
            product_id: Some(qp.product.id),
            product_code: qp.product.code.clone(),
            description: input
                .description
                .clone()
                .filter(|d| !d.trim().is_empty())
                .unwrap_or_else(|| qp.product.name.clone()),
            unit: qp.product.unit.clone(),
            quantity: p.quantity,
            list_unit_price: p.list_unit_price,
            line_discount_percent: p.line_discount_percent,
            net_unit_price: p.net_unit_price,
            line_total: p.line_total,
            vat_rate: p.vat_rate,
        });
        priced.push(p);
    }
    let totals = totals(&priced);
    Ok(Priced {
        customer,
        quote_date,
        lines,
        totals,
    })
}

pub fn vat_groups(t: &Totals) -> Vec<VatGroup> {
    t.vat_groups
        .iter()
        .map(|g| VatGroup {
            vat_rate: g.vat_rate,
            base: g.base,
            vat: g.vat,
        })
        .collect()
}

/// Recomputes VAT groups from stored lines (same rules as when they were priced).
pub fn stored_totals(lines: &[QuotationLine]) -> Totals {
    let priced: Vec<PricedLine> = lines
        .iter()
        .map(|l| PricedLine {
            list_unit_price: l.list_unit_price,
            quantity: l.quantity,
            customer_discount_percent: Default::default(),
            line_discount_percent: l.line_discount_percent,
            net_unit_price: l.net_unit_price,
            line_total: l.line_total,
            vat_rate: l.vat_rate,
        })
        .collect();
    totals(&priced)
}

pub fn validate_input(input: &QuotationInput) -> AppResult<()> {
    if input.lines.is_empty() {
        return Err(AppError::Validation(
            "a quotation needs at least one line".into(),
        ));
    }
    if let Some(days) = input.valid_days {
        if !(1..=365).contains(&days) {
            return Err(AppError::Validation(
                "valid_days must be between 1 and 365".into(),
            ));
        }
    }
    Ok(())
}

pub async fn allocate_number(
    conn: &mut PgConnection,
    company_id: Uuid,
    date: NaiveDate,
) -> AppResult<String> {
    let n = numbering::next_number(conn, company_id, "quotation", date.year()).await?;
    Ok(format!("Q{}-{:05}", date.year(), n))
}

pub struct NewQuotation<'a> {
    pub number: &'a str,
    pub revision: i32,
    pub priced: &'a Priced,
    pub valid_until: NaiveDate,
    pub notes: &'a str,
    pub currency: &'a str,
    pub supersedes_id: Option<Uuid>,
}

pub async fn insert_quotation(
    conn: &mut PgConnection,
    user: &CurrentUser,
    q: NewQuotation<'_>,
) -> AppResult<Uuid> {
    let id = new_id();
    let c = &q.priced.customer;
    sqlx::query(
        "INSERT INTO sales.quotations (
            id, company_id, number, revision, status, customer_id, customer_name, customer_vat_number,
            customer_street, customer_postal_code, customer_city, customer_country_code, customer_language,
            price_zone_code, customer_discount_percent, currency, quote_date, valid_until, notes,
            subtotal, vat_total, total, supersedes_id, created_by)
         VALUES ($1, $2, $3, $4, 'draft', $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18,
                 $19, $20, $21, $22, $23)",
    )
    .bind(id)
    .bind(user.company_id)
    .bind(q.number)
    .bind(q.revision)
    .bind(c.customer.id)
    .bind(&c.customer.name)
    .bind(&c.customer.vat_number)
    .bind(&c.customer.street)
    .bind(&c.customer.postal_code)
    .bind(&c.customer.city)
    .bind(&c.customer.country_code)
    .bind(&c.customer.language)
    .bind(&c.price_zone_code)
    .bind(c.discount_percent)
    .bind(q.currency)
    .bind(q.priced.quote_date)
    .bind(q.valid_until)
    .bind(q.notes)
    .bind(q.priced.totals.subtotal)
    .bind(q.priced.totals.vat_total)
    .bind(q.priced.totals.total)
    .bind(q.supersedes_id)
    .bind(user.user_id)
    .execute(&mut *conn)
    .await?;
    insert_lines(conn, id, &q.priced.lines).await?;
    Ok(id)
}

pub async fn insert_lines(
    conn: &mut PgConnection,
    quotation_id: Uuid,
    lines: &[QuotationLine],
) -> AppResult<()> {
    for l in lines {
        sqlx::query(
            "INSERT INTO sales.quotation_lines (id, quotation_id, position, product_id, product_code, description,
                unit, quantity, list_unit_price, line_discount_percent, net_unit_price, line_total, vat_rate)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)",
        )
        .bind(new_id())
        .bind(quotation_id)
        .bind(l.position)
        .bind(l.product_id)
        .bind(&l.product_code)
        .bind(&l.description)
        .bind(&l.unit)
        .bind(l.quantity)
        .bind(l.list_unit_price)
        .bind(l.line_discount_percent)
        .bind(l.net_unit_price)
        .bind(l.line_total)
        .bind(l.vat_rate)
        .execute(&mut *conn)
        .await?;
    }
    Ok(())
}

const SELECT_HEADER: &str = "SELECT id, company_id, number, revision, status, customer_id, customer_name,
    customer_vat_number, customer_street, customer_postal_code, customer_city,
    customer_country_code::text AS customer_country_code, customer_language::text AS customer_language,
    price_zone_code, customer_discount_percent, currency::text AS currency, quote_date, valid_until, notes,
    subtotal, vat_total, total, supersedes_id, created_by, created_at, updated_at, sent_at
    FROM sales.quotations";

pub async fn load_quotation(
    conn: &mut PgConnection,
    company_id: Uuid,
    id: Uuid,
    lock: bool,
) -> AppResult<Quotation> {
    let sql = format!(
        "{SELECT_HEADER} WHERE id = $1 AND company_id = $2{}",
        if lock { " FOR UPDATE" } else { "" }
    );
    let header: QuotationHeader = sqlx::query_as(&sql)
        .bind(id)
        .bind(company_id)
        .fetch_optional(&mut *conn)
        .await?
        .ok_or(AppError::NotFound("quotation"))?;
    let lines: Vec<QuotationLine> = sqlx::query_as(
        "SELECT position, product_id, product_code, description, unit, quantity, list_unit_price,
                line_discount_percent, net_unit_price, line_total, vat_rate
         FROM sales.quotation_lines WHERE quotation_id = $1 ORDER BY position",
    )
    .bind(id)
    .fetch_all(&mut *conn)
    .await?;
    let vat_groups = vat_groups(&stored_totals(&lines));
    Ok(Quotation::new(header, lines, vat_groups))
}

pub fn valid_until(date: NaiveDate, valid_days: Option<i64>) -> NaiveDate {
    date + Duration::days(valid_days.unwrap_or(DEFAULT_VALID_DAYS))
}

pub fn status_of(q: &Quotation) -> QuotationStatus {
    QuotationStatus::parse(&q.status).unwrap_or(QuotationStatus::Draft)
}
