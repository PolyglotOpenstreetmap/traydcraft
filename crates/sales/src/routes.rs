use axum::extract::{Path, Query, State};
use axum::http::{header, StatusCode};
use axum::response::{IntoResponse, Response};
use axum::Json;
use rust_decimal::Decimal;
use traydcraft_core::company::get_company;
use traydcraft_core::{audit, AppError, AppResult, AppState, CurrentUser, Permission};
use utoipa_axum::router::OpenApiRouter;
use utoipa_axum::routes;
use uuid::Uuid;

use crate::model::*;
use crate::pdf;
use crate::service::{self, NewQuotation};

type ErrorBody = traydcraft_core::error::ErrorBody;

/// Prices lines for a customer without saving. The app calls this while the user edits,
/// so every number on screen comes from the server's pricing engine.
#[utoipa::path(post, path = "/pricing/preview", tag = "sales", request_body = PricingPreviewInput,
    responses((status = 200, body = PricingPreview), (status = 403, body = ErrorBody), (status = 422, body = ErrorBody)))]
async fn preview(
    State(state): State<AppState>,
    user: CurrentUser,
    Json(input): Json<PricingPreviewInput>,
) -> AppResult<Json<PricingPreview>> {
    user.require(Permission::QuotationsRead)?;
    let quote_date = input.quote_date.unwrap_or_else(service::today);
    let price_date = input.price_date.unwrap_or(quote_date);
    service::check_price_date(&user, quote_date, price_date)?;
    let p = service::price_lines(
        &state.db,
        user.company_id,
        input.customer_id,
        price_date,
        &input.lines,
    )
    .await?;
    Ok(Json(PricingPreview {
        price_zone_code: p.customer.price_zone_code.clone(),
        customer_discount_percent: p.customer.discount_percent,
        quote_date,
        price_date,
        unconfirmed_lines: p.unconfirmed_lines(),
        vat_groups: service::vat_groups(&p.totals),
        subtotal: p.totals.subtotal,
        vat_total: p.totals.vat_total,
        total: p.totals.total,
        lines: p.lines,
    }))
}

#[utoipa::path(get, path = "/quotations", tag = "sales", params(ListParams),
    responses((status = 200, body = QuotationPage)))]
async fn list_quotations(
    State(state): State<AppState>,
    user: CurrentUser,
    Query(p): Query<ListParams>,
) -> AppResult<Json<QuotationPage>> {
    user.require(Permission::QuotationsRead)?;
    if let Some(s) = &p.status {
        QuotationStatus::parse(s)
            .ok_or_else(|| AppError::Validation(format!("unknown status {s}")))?;
    }
    let pattern =
        p.q.as_deref()
            .map(|q| format!("%{}%", q.trim().to_lowercase()));
    let filter = "WHERE company_id = $1
          AND ($2::text IS NULL OR lower(number) LIKE $2 OR lower(customer_name) LIKE $2)
          AND ($3::text IS NULL OR status = $3)
          AND ($4::uuid IS NULL OR customer_id = $4)
          AND ($5::uuid IS NULL OR opportunity_id = $5)";
    let items = sqlx::query_as(&format!(
        "SELECT id, number, revision, status, customer_id, opportunity_id, customer_name, quote_date, valid_until,
                currency::text AS currency, subtotal, total
         FROM sales.quotations {filter}
         ORDER BY quote_date DESC, number DESC, revision DESC LIMIT $6 OFFSET $7"
    ))
    .bind(user.company_id)
    .bind(&pattern)
    .bind(&p.status)
    .bind(p.customer_id)
    .bind(p.opportunity_id)
    .bind(p.limit.unwrap_or(50).clamp(1, 500))
    .bind(p.offset.unwrap_or(0).max(0))
    .fetch_all(&state.db)
    .await?;
    let total = sqlx::query_scalar(&format!("SELECT count(*) FROM sales.quotations {filter}"))
        .bind(user.company_id)
        .bind(&pattern)
        .bind(&p.status)
        .bind(p.customer_id)
        .bind(p.opportunity_id)
        .fetch_one(&state.db)
        .await?;
    Ok(Json(QuotationPage { items, total }))
}

#[utoipa::path(get, path = "/quotations/{id}", tag = "sales", params(("id" = Uuid, Path)),
    responses((status = 200, body = Quotation), (status = 404, body = ErrorBody)))]
async fn get_quotation(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
) -> AppResult<Json<Quotation>> {
    user.require(Permission::QuotationsRead)?;
    let mut conn = state.db.acquire().await?;
    Ok(Json(
        service::load_quotation(&mut conn, user.company_id, id, false).await?,
    ))
}

#[utoipa::path(post, path = "/quotations", tag = "sales", request_body = QuotationInput,
    responses((status = 201, body = Quotation), (status = 403, body = ErrorBody), (status = 422, body = ErrorBody)))]
async fn create_quotation(
    State(state): State<AppState>,
    user: CurrentUser,
    Json(input): Json<QuotationInput>,
) -> AppResult<(StatusCode, Json<Quotation>)> {
    user.require(Permission::QuotationsWrite)?;
    service::validate_input(&input)?;
    let quote_date = input.quote_date.unwrap_or_else(service::today);
    let price_date = input.price_date.unwrap_or(quote_date);
    let backdated = service::check_price_date(&user, quote_date, price_date)?;
    let priced = service::price_lines(
        &state.db,
        user.company_id,
        input.customer_id,
        price_date,
        &input.lines,
    )
    .await?;
    let company = get_company(&state.db, user.company_id).await?;

    let mut tx = state.db.begin().await?;
    if let Some(opp) = input.opportunity_id {
        traydcraft_crm::opportunities::link_quotation(&mut tx, &user, opp, input.customer_id)
            .await?;
    }
    let number = service::allocate_number(&mut tx, user.company_id, quote_date).await?;
    let id = service::insert_quotation(
        &mut tx,
        &user,
        NewQuotation {
            number: &number,
            revision: 1,
            priced: &priced,
            quote_date,
            valid_until: service::valid_until(quote_date, input.valid_days),
            notes: &input.notes,
            currency: &company.currency,
            supersedes_id: None,
            opportunity_id: input.opportunity_id,
        },
    )
    .await?;
    audit::record(
        &mut tx,
        &user,
        "quotation",
        id,
        "created",
        serde_json::json!({ "number": number }),
    )
    .await?;
    if backdated {
        audit::record(
            &mut tx,
            &user,
            "quotation",
            id,
            "price_date_backdated",
            serde_json::json!({ "price_date": price_date }),
        )
        .await?;
    }
    let q = service::load_quotation(&mut tx, user.company_id, id, false).await?;
    tx.commit().await?;
    Ok((StatusCode::CREATED, Json(q)))
}

/// Replaces customer, dates, notes and lines of a draft, repricing everything at its price date.
#[utoipa::path(put, path = "/quotations/{id}", tag = "sales", params(("id" = Uuid, Path)),
    request_body = QuotationInput,
    responses((status = 200, body = Quotation), (status = 403, body = ErrorBody), (status = 409, body = ErrorBody)))]
async fn update_quotation(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
    Json(input): Json<QuotationInput>,
) -> AppResult<Json<Quotation>> {
    user.require(Permission::QuotationsWrite)?;
    service::validate_input(&input)?;
    let mut tx = state.db.begin().await?;
    let current = service::load_quotation(&mut tx, user.company_id, id, true).await?;
    if service::status_of(&current) != QuotationStatus::Draft {
        return Err(AppError::Conflict(format!(
            "quotation {} is {}; only drafts can be changed (create a revision instead)",
            current.number, current.status
        )));
    }
    if let Some(opp) = input.opportunity_id {
        traydcraft_crm::opportunities::link_quotation(&mut tx, &user, opp, input.customer_id)
            .await?;
    }
    let quote_date = input.quote_date.unwrap_or(current.quote_date);
    let price_date = input.price_date.unwrap_or(current.price_date);
    // Only a change to an earlier price list needs the permission; keeping one is fine.
    let backdated = price_date != current.price_date
        && service::check_price_date(&user, quote_date, price_date)?;
    let priced = service::price_lines(
        &state.db,
        user.company_id,
        input.customer_id,
        price_date,
        &input.lines,
    )
    .await?;
    let c = &priced.customer;
    sqlx::query(
        "UPDATE sales.quotations SET customer_id = $2, customer_name = $3, customer_vat_number = $4,
            customer_street = $5, customer_postal_code = $6, customer_city = $7, customer_country_code = $8,
            customer_language = $9, price_zone_code = $10, customer_discount_percent = $11, quote_date = $12,
            valid_until = $13, notes = $14, subtotal = $15, vat_total = $16, total = $17, opportunity_id = $18,
            price_date = $19, updated_at = now()
         WHERE id = $1",
    )
    .bind(id)
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
    .bind(quote_date)
    .bind(service::valid_until(quote_date, input.valid_days))
    .bind(&input.notes)
    .bind(priced.totals.subtotal)
    .bind(priced.totals.vat_total)
    .bind(priced.totals.total)
    .bind(input.opportunity_id)
    .bind(price_date)
    .execute(&mut *tx)
    .await?;
    sqlx::query("DELETE FROM sales.quotation_lines WHERE quotation_id = $1")
        .bind(id)
        .execute(&mut *tx)
        .await?;
    service::insert_lines(&mut tx, id, &priced.lines).await?;
    audit::record(
        &mut tx,
        &user,
        "quotation",
        id,
        "updated",
        serde_json::json!({}),
    )
    .await?;
    if backdated {
        audit::record(
            &mut tx,
            &user,
            "quotation",
            id,
            "price_date_backdated",
            serde_json::json!({ "price_date": price_date }),
        )
        .await?;
    }
    let q = service::load_quotation(&mut tx, user.company_id, id, false).await?;
    tx.commit().await?;
    Ok(Json(q))
}

async fn transition(
    state: &AppState,
    user: &CurrentUser,
    id: Uuid,
    allowed_from: &[QuotationStatus],
    to: QuotationStatus,
) -> AppResult<Quotation> {
    user.require(Permission::QuotationsWrite)?;
    let mut tx = state.db.begin().await?;
    let current = service::load_quotation(&mut tx, user.company_id, id, true).await?;
    let from = service::status_of(&current);
    if !allowed_from.contains(&from) {
        return Err(AppError::Conflict(format!(
            "cannot change quotation {} from {} to {}",
            current.number,
            from.as_str(),
            to.as_str()
        )));
    }
    if to == QuotationStatus::Sent {
        let unconfirmed: Vec<String> = current
            .lines
            .iter()
            .filter(|l| !l.price_confirmed)
            .map(|l| format!("line {} ({})", l.position, l.product_code))
            .collect();
        if !unconfirmed.is_empty() {
            return Err(AppError::Validation(format!(
                "confirm the indicative prices first: {}",
                unconfirmed.join(", ")
            )));
        }
    }
    sqlx::query(
        "UPDATE sales.quotations SET status = $2, updated_at = now(),
                sent_at = CASE WHEN $2 = 'sent' THEN now() ELSE sent_at END
         WHERE id = $1",
    )
    .bind(id)
    .bind(to.as_str())
    .execute(&mut *tx)
    .await?;
    audit::record(
        &mut tx,
        user,
        "quotation",
        id,
        to.as_str(),
        serde_json::json!({ "from": from.as_str() }),
    )
    .await?;
    if let (QuotationStatus::Accepted, Some(opp)) = (to, current.opportunity_id) {
        traydcraft_crm::opportunities::mark_won(&mut tx, user, opp).await?;
    }
    let q = service::load_quotation(&mut tx, user.company_id, id, false).await?;
    tx.commit().await?;
    Ok(q)
}

/// Freezes the quotation. From now on it can only be accepted, rejected or revised.
/// Refused while indicative prices are unconfirmed.
#[utoipa::path(post, path = "/quotations/{id}/send", tag = "sales", params(("id" = Uuid, Path)),
    responses((status = 200, body = Quotation), (status = 409, body = ErrorBody), (status = 422, body = ErrorBody)))]
async fn send_quotation(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
) -> AppResult<Json<Quotation>> {
    Ok(Json(
        transition(
            &state,
            &user,
            id,
            &[QuotationStatus::Draft],
            QuotationStatus::Sent,
        )
        .await?,
    ))
}

#[utoipa::path(post, path = "/quotations/{id}/accept", tag = "sales", params(("id" = Uuid, Path)),
    responses((status = 200, body = Quotation), (status = 409, body = ErrorBody)))]
async fn accept_quotation(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
) -> AppResult<Json<Quotation>> {
    Ok(Json(
        transition(
            &state,
            &user,
            id,
            &[QuotationStatus::Sent],
            QuotationStatus::Accepted,
        )
        .await?,
    ))
}

#[utoipa::path(post, path = "/quotations/{id}/reject", tag = "sales", params(("id" = Uuid, Path)),
    responses((status = 200, body = Quotation), (status = 409, body = ErrorBody)))]
async fn reject_quotation(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
) -> AppResult<Json<Quotation>> {
    Ok(Json(
        transition(
            &state,
            &user,
            id,
            &[QuotationStatus::Sent],
            QuotationStatus::Rejected,
        )
        .await?,
    ))
}

/// Compares a quotation with today's price list and rebates, line by line. Changes nothing.
#[utoipa::path(get, path = "/quotations/{id}/repricing", tag = "sales", params(("id" = Uuid, Path)),
    responses((status = 200, body = RepricingComparison), (status = 422, body = ErrorBody)))]
async fn repricing(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
) -> AppResult<Json<RepricingComparison>> {
    user.require(Permission::QuotationsRead)?;
    let mut conn = state.db.acquire().await?;
    let q = service::load_quotation(&mut conn, user.company_id, id, false).await?;
    drop(conn);
    let today = service::today();
    let inputs = service::line_inputs(&q.lines, false)?;
    let now =
        service::price_lines(&state.db, user.company_id, q.customer_id, today, &inputs).await?;
    let lines: Vec<RepricingLine> = q
        .lines
        .iter()
        .zip(&now.lines)
        .map(|(old, new)| RepricingLine {
            position: old.position,
            product_code: old.product_code.clone(),
            description: old.description.clone(),
            quantity: old.quantity,
            pricing_type: new.pricing_type.clone(),
            old_list_unit_price: old.list_unit_price,
            new_list_unit_price: new.list_unit_price,
            old_rebate_percent: old.rebate_percent,
            new_rebate_percent: new.rebate_percent,
            old_line_total: old.line_total,
            new_line_total: new.line_total,
            difference: new.line_total - old.line_total,
            needs_confirmation: !new.price_confirmed,
        })
        .collect();
    let old_subtotal: Decimal = q.subtotal;
    Ok(Json(RepricingComparison {
        old_price_date: q.price_date,
        new_price_date: today,
        lines,
        old_subtotal,
        new_subtotal: now.totals.subtotal,
        difference: now.totals.subtotal - old_subtotal,
    }))
}

/// Creates the next revision as a new draft with the same number; the revised quotation becomes
/// `superseded`. `keep` copies the agreed prices and price list date unchanged; `current` reprices
/// at today's price list and rebates (indicative prices must then be confirmed again).
#[utoipa::path(post, path = "/quotations/{id}/revise", tag = "sales", params(("id" = Uuid, Path)),
    request_body = ReviseInput,
    responses((status = 201, body = Quotation), (status = 409, body = ErrorBody)))]
async fn revise_quotation(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
    Json(input): Json<ReviseInput>,
) -> AppResult<(StatusCode, Json<Quotation>)> {
    user.require(Permission::QuotationsWrite)?;
    let mut tx = state.db.begin().await?;
    let old = service::load_quotation(&mut tx, user.company_id, id, true).await?;
    let from = service::status_of(&old);
    if !matches!(from, QuotationStatus::Sent | QuotationStatus::Rejected) {
        return Err(AppError::Conflict(format!(
            "only sent or rejected quotations can be revised (this one is {})",
            from.as_str()
        )));
    }
    if let Some(opp) = old.opportunity_id {
        traydcraft_crm::opportunities::link_quotation(&mut tx, &user, opp, old.customer_id).await?;
    }
    let today = service::today();
    let validity = (old.valid_until - old.quote_date).num_days().clamp(1, 365);
    let new_id = traydcraft_core::new_id();
    match input.pricing {
        RevisionPricing::Keep => {
            // Copy header and lines verbatim: same prices, rebates and price list date.
            sqlx::query(
                "INSERT INTO sales.quotations (
                    id, company_id, number, revision, status, customer_id, customer_name, customer_vat_number,
                    customer_street, customer_postal_code, customer_city, customer_country_code, customer_language,
                    price_zone_code, customer_discount_percent, currency, quote_date, valid_until, notes,
                    subtotal, vat_total, total, supersedes_id, created_by, opportunity_id, price_date)
                 SELECT $2, company_id, number, revision + 1, 'draft', customer_id, customer_name,
                    customer_vat_number, customer_street, customer_postal_code, customer_city,
                    customer_country_code, customer_language, price_zone_code, customer_discount_percent, currency,
                    $3, $4, notes, subtotal, vat_total, total, id, $5, opportunity_id, price_date
                 FROM sales.quotations WHERE id = $1",
            )
            .bind(id)
            .bind(new_id)
            .bind(today)
            .bind(service::valid_until(today, Some(validity)))
            .bind(user.user_id)
            .execute(&mut *tx)
            .await?;
            service::insert_lines(&mut tx, new_id, &old.lines).await?;
        }
        RevisionPricing::Current => {
            let inputs = service::line_inputs(&old.lines, false)?;
            let priced =
                service::price_lines(&state.db, user.company_id, old.customer_id, today, &inputs)
                    .await?;
            let created = service::insert_quotation(
                &mut tx,
                &user,
                NewQuotation {
                    number: &old.number,
                    revision: old.revision + 1,
                    priced: &priced,
                    quote_date: today,
                    valid_until: service::valid_until(today, Some(validity)),
                    notes: &old.notes,
                    currency: &old.currency,
                    supersedes_id: Some(id),
                    opportunity_id: old.opportunity_id,
                },
            )
            .await?;
            return finish_revision(tx, &user, id, created, "current").await;
        }
    }
    finish_revision(tx, &user, id, new_id, "keep").await
}

async fn finish_revision(
    mut tx: sqlx::Transaction<'_, sqlx::Postgres>,
    user: &CurrentUser,
    old_id: Uuid,
    new_id: Uuid,
    pricing: &str,
) -> AppResult<(StatusCode, Json<Quotation>)> {
    sqlx::query(
        "UPDATE sales.quotations SET status = 'superseded', updated_at = now() WHERE id = $1",
    )
    .bind(old_id)
    .execute(&mut *tx)
    .await?;
    audit::record(
        &mut tx,
        user,
        "quotation",
        old_id,
        "superseded",
        serde_json::json!({ "by": new_id }),
    )
    .await?;
    audit::record(
        &mut tx,
        user,
        "quotation",
        new_id,
        "created",
        serde_json::json!({ "revision_of": old_id, "pricing": pricing }),
    )
    .await?;
    let q = service::load_quotation(&mut tx, user.company_id, new_id, false).await?;
    tx.commit().await?;
    Ok((StatusCode::CREATED, Json(q)))
}

#[utoipa::path(get, path = "/quotations/{id}/pdf", tag = "sales", params(("id" = Uuid, Path)),
    responses((status = 200, content_type = "application/pdf", body = Vec<u8>), (status = 404, body = ErrorBody)))]
async fn quotation_pdf(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
) -> AppResult<Response> {
    user.require(Permission::QuotationsRead)?;
    let mut conn = state.db.acquire().await?;
    let q = service::load_quotation(&mut conn, user.company_id, id, false).await?;
    drop(conn);
    let company = get_company(&state.db, user.company_id).await?;
    let bytes = traydcraft_documents::render_pdf(
        &state.documents,
        "quotation",
        &pdf::document(&company, &q),
    )
    .await?;
    let filename = format!("{}-r{}.pdf", q.number, q.revision);
    Ok((
        [
            (header::CONTENT_TYPE, "application/pdf".to_string()),
            (
                header::CONTENT_DISPOSITION,
                format!("inline; filename=\"{filename}\""),
            ),
        ],
        bytes,
    )
        .into_response())
}

pub fn router() -> OpenApiRouter<AppState> {
    OpenApiRouter::new()
        .routes(routes!(preview))
        .routes(routes!(list_quotations, create_quotation))
        .routes(routes!(get_quotation, update_quotation))
        .routes(routes!(send_quotation))
        .routes(routes!(accept_quotation))
        .routes(routes!(reject_quotation))
        .routes(routes!(repricing))
        .routes(routes!(revise_quotation))
        .routes(routes!(quotation_pdf))
}
