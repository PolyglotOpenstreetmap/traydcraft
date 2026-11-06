//! Customer portal.
//!
//! Contacts of a customer sign in without a password: they ask for a login link, receive it by
//! e-mail at one of their registered addresses, and exchange it for a session. In the portal they
//! see and raise their tickets and set how they want to be addressed. Staff controls who may use
//! the portal (`portal_access` on the contact) and what they see (`portal_scope`).
//!
//! These endpoints are separate from the staff API: they use portal sessions, never staff tokens.

mod mail;
pub mod session;

use axum::body::Bytes;
use axum::extract::{DefaultBodyLimit, Path, Query, State};
use axum::http::StatusCode;
use axum::response::Response;
use axum::Json;
use chrono::{DateTime, Duration, Utc};
use serde::{Deserialize, Serialize};
use session::{new_token, PortalUser, LINK_PREFIX, SESSION_PREFIX};
use traydcraft_core::{audit, is_language, new_id, AppError, AppResult, AppState, LANGUAGES};
use traydcraft_crm::contacts::{self, Contact, ADDRESS_FORMS, TITLES};
use traydcraft_helpdesk::portal::{self, PortalTicket, PortalTicketDetail};
use traydcraft_repairs::portal::{
    self as repair_portal, Announcement, PortalRepair, PortalRepairDetail,
};
use utoipa::{IntoParams, ToSchema};
use utoipa_axum::router::OpenApiRouter;
use utoipa_axum::routes;
use uuid::Uuid;

type ErrorBody = traydcraft_core::error::ErrorBody;

/// How long a login link works, in minutes.
const LINK_MINUTES: i64 = 15;
/// How long a portal session lasts, in hours.
const SESSION_HOURS: i64 = 24;
/// At most one login link per contact in this many seconds (mail flooding, brute force).
const LINK_THROTTLE_SECONDS: i64 = 60;

#[derive(Debug, Deserialize, ToSchema)]
pub struct LoginLinkInput {
    /// The company whose portal this is.
    pub company_id: Uuid,
    pub email: String,
}

/// Always answers 202, whether or not the address belongs to a portal user, so the endpoint
/// cannot be used to find out who is a customer.
#[utoipa::path(post, path = "/portal/login-links", tag = "portal", security(()), request_body = LoginLinkInput,
    responses((status = 202, description = "If the address may use the portal, a login link was sent.")))]
async fn request_login_link(
    State(state): State<AppState>,
    Json(input): Json<LoginLinkInput>,
) -> AppResult<StatusCode> {
    let mut tx = state.db.begin().await?;
    let Some(contact) = contacts::find_by_email(&mut tx, &input.email).await? else {
        return Ok(StatusCode::ACCEPTED);
    };
    let eligible: bool = sqlx::query_scalar(
        "SELECT c.active AND c.portal_access AND cu.active
                AND EXISTS (SELECT 1 FROM crm.customer_terms t WHERE t.customer_id = cu.id AND t.company_id = $2)
         FROM crm.contacts c JOIN crm.customers cu ON cu.id = c.customer_id WHERE c.id = $1",
    )
    .bind(contact.id)
    .bind(input.company_id)
    .fetch_one(&mut *tx)
    .await?;
    let company: Option<(String, Option<String>)> =
        sqlx::query_as("SELECT name, portal_url FROM core.companies WHERE id = $1")
            .bind(input.company_id)
            .fetch_optional(&mut *tx)
            .await?;
    let (Some((company_name, portal_url)), true) = (company, eligible) else {
        return Ok(StatusCode::ACCEPTED);
    };
    let Some(portal_url) = portal_url.filter(|u| !u.trim().is_empty()) else {
        tracing::warn!(company = %input.company_id, "portal login requested but the company has no portal_url");
        return Ok(StatusCode::ACCEPTED);
    };
    let recent: bool = sqlx::query_scalar(
        "SELECT EXISTS (SELECT 1 FROM portal.login_links WHERE contact_id = $1
                        AND created_at > now() - make_interval(secs => $2))",
    )
    .bind(contact.id)
    .bind(LINK_THROTTLE_SECONDS as f64)
    .fetch_one(&mut *tx)
    .await?;
    if recent {
        return Ok(StatusCode::ACCEPTED);
    }
    // Old links are of no use any more.
    sqlx::query("DELETE FROM portal.login_links WHERE expires_at < now() - interval '1 day'")
        .execute(&mut *tx)
        .await?;
    let (token, hash) = new_token(LINK_PREFIX);
    sqlx::query(
        "INSERT INTO portal.login_links (id, contact_id, company_id, token_hash, expires_at)
         VALUES ($1, $2, $3, $4, now() + make_interval(mins => $5))",
    )
    .bind(new_id())
    .bind(contact.id)
    .bind(input.company_id)
    .bind(hash)
    .bind(LINK_MINUTES as i32)
    .execute(&mut *tx)
    .await?;
    // The token travels in the fragment, which browsers do not send to servers or in referrers.
    let link = format!("{}/login#token={token}", portal_url.trim_end_matches('/'));
    let to = input.email.trim().to_lowercase();
    let (subject, body) = mail::login_mail(
        &contact.effective_language,
        &contact.greeting,
        &company_name,
        &link,
        LINK_MINUTES,
    );
    traydcraft_core::mail::enqueue(&mut tx, input.company_id, &to, &subject, &body).await?;
    tx.commit().await?;
    Ok(StatusCode::ACCEPTED)
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct SessionInput {
    /// The token from the login link.
    pub token: String,
}

/// Who is logged in, as the portal shows it.
#[derive(Debug, Serialize, ToSchema)]
pub struct PortalProfile {
    pub contact_id: Uuid,
    pub customer_name: String,
    pub first_name: String,
    pub last_name: String,
    pub full_name: String,
    pub email: Option<String>,
    pub job_title: String,
    /// mr | ms | none
    pub title: String,
    /// formal | informal
    pub address_form: String,
    /// The person's own language; null means the same as the company.
    pub language: Option<String>,
    pub customer_language: String,
    /// The language the portal and our e-mails use for this person.
    pub effective_language: String,
    pub greeting: String,
    pub roles: Vec<String>,
    /// own | customer
    pub scope: String,
}

impl From<Contact> for PortalProfile {
    fn from(c: Contact) -> Self {
        PortalProfile {
            email: c.primary_email().map(str::to_string),
            contact_id: c.id,
            customer_name: c.customer_name,
            first_name: c.first_name,
            last_name: c.last_name,
            full_name: c.full_name,
            job_title: c.job_title,
            title: c.title,
            address_form: c.address_form,
            language: c.language,
            customer_language: c.customer_language,
            effective_language: c.effective_language,
            greeting: c.greeting,
            roles: c.roles,
            scope: c.portal_scope,
        }
    }
}

#[derive(Debug, Serialize, ToSchema)]
pub struct PortalSession {
    /// Send as `Authorization: Bearer <token>` on every portal request.
    pub token: String,
    pub expires_at: DateTime<Utc>,
    pub profile: PortalProfile,
}

/// Exchanges a login link for a session. A link works once.
#[utoipa::path(post, path = "/portal/sessions", tag = "portal", security(()), request_body = SessionInput,
    responses((status = 201, body = PortalSession), (status = 401, body = ErrorBody)))]
async fn create_session(
    State(state): State<AppState>,
    Json(input): Json<SessionInput>,
) -> AppResult<(StatusCode, Json<PortalSession>)> {
    if !input.token.trim().starts_with(LINK_PREFIX) {
        return Err(AppError::Unauthorized);
    }
    let mut tx = state.db.begin().await?;
    // Marking it used and checking it is one statement: two requests cannot both succeed.
    let link: Option<(Uuid, Uuid)> = sqlx::query_as(
        "UPDATE portal.login_links SET used_at = now()
         WHERE token_hash = $1 AND used_at IS NULL AND expires_at > now()
         RETURNING contact_id, company_id",
    )
    .bind(session::hash_token(&input.token))
    .fetch_optional(&mut *tx)
    .await?;
    let (contact_id, company_id) = link.ok_or(AppError::Unauthorized)?;
    let contact = contacts::get_contact(&mut tx, contact_id).await?;
    let customer_active: bool =
        sqlx::query_scalar("SELECT active FROM crm.customers WHERE id = $1")
            .bind(contact.customer_id)
            .fetch_one(&mut *tx)
            .await?;
    if !(contact.active && contact.portal_access && customer_active) {
        return Err(AppError::Unauthorized);
    }
    // Other links sent in the meantime are void once one is used.
    sqlx::query(
        "UPDATE portal.login_links SET used_at = now() WHERE contact_id = $1 AND used_at IS NULL",
    )
    .bind(contact_id)
    .execute(&mut *tx)
    .await?;
    let (token, hash) = new_token(SESSION_PREFIX);
    let expires_at = Utc::now() + Duration::hours(SESSION_HOURS);
    let session_id = new_id();
    sqlx::query(
        "INSERT INTO portal.sessions (id, contact_id, company_id, token_hash, expires_at) VALUES ($1, $2, $3, $4, $5)",
    )
    .bind(session_id)
    .bind(contact_id)
    .bind(company_id)
    .bind(hash)
    .bind(expires_at)
    .execute(&mut *tx)
    .await?;
    audit::record_system(
        &mut tx,
        company_id,
        "contact",
        contact_id,
        "portal_login",
        serde_json::json!({ "session_id": session_id }),
    )
    .await?;
    tx.commit().await?;
    Ok((
        StatusCode::CREATED,
        Json(PortalSession {
            token,
            expires_at,
            profile: contact.into(),
        }),
    ))
}

/// Logs out: the session token stops working.
#[utoipa::path(delete, path = "/portal/session", tag = "portal",
    responses((status = 204), (status = 401, body = ErrorBody)))]
async fn end_session(State(state): State<AppState>, user: PortalUser) -> AppResult<StatusCode> {
    sqlx::query("UPDATE portal.sessions SET revoked_at = now() WHERE id = $1")
        .bind(user.session_id)
        .execute(&state.db)
        .await?;
    Ok(StatusCode::NO_CONTENT)
}

#[utoipa::path(get, path = "/portal/me", tag = "portal",
    responses((status = 200, body = PortalProfile), (status = 401, body = ErrorBody)))]
async fn get_me(State(state): State<AppState>, user: PortalUser) -> AppResult<Json<PortalProfile>> {
    let mut conn = state.db.acquire().await?;
    Ok(Json(
        contacts::get_contact(&mut conn, user.contact_id)
            .await?
            .into(),
    ))
}

/// What a customer may change about themselves: how they want to be addressed.
#[derive(Debug, Deserialize, ToSchema)]
pub struct ProfileInput {
    /// nl | fr | en | de | es; null = same as the company.
    pub language: Option<String>,
    /// formal | informal
    pub address_form: String,
    /// mr | ms | none
    pub title: String,
}

#[utoipa::path(put, path = "/portal/me", tag = "portal", request_body = ProfileInput,
    responses((status = 200, body = PortalProfile), (status = 401, body = ErrorBody), (status = 422, body = ErrorBody)))]
async fn update_me(
    State(state): State<AppState>,
    user: PortalUser,
    Json(input): Json<ProfileInput>,
) -> AppResult<Json<PortalProfile>> {
    let language = input.language.as_deref().map(str::to_lowercase);
    if language.as_deref().is_some_and(|l| !is_language(l)) {
        return Err(AppError::Validation(format!(
            "language must be one of {}",
            LANGUAGES.join(", ")
        )));
    }
    if !ADDRESS_FORMS.contains(&input.address_form.as_str()) {
        return Err(AppError::Validation(format!(
            "address_form must be one of {}",
            ADDRESS_FORMS.join(", ")
        )));
    }
    if !TITLES.contains(&input.title.as_str()) {
        return Err(AppError::Validation(format!(
            "title must be one of {}",
            TITLES.join(", ")
        )));
    }
    let mut tx = state.db.begin().await?;
    sqlx::query(
        "UPDATE crm.contacts SET language = $2, address_form = $3, title = $4, updated_at = now() WHERE id = $1",
    )
    .bind(user.contact_id)
    .bind(&language)
    .bind(&input.address_form)
    .bind(&input.title)
    .execute(&mut *tx)
    .await?;
    audit::record_system(
        &mut tx,
        user.company_id,
        "contact",
        user.contact_id,
        "profile_updated_in_portal",
        serde_json::json!({ "language": language, "address_form": input.address_form, "title": input.title }),
    )
    .await?;
    let contact = contacts::get_contact(&mut tx, user.contact_id).await?;
    tx.commit().await?;
    Ok(Json(contact.into()))
}

#[utoipa::path(get, path = "/portal/tickets", tag = "portal", operation_id = "list_portal_tickets",
    responses((status = 200, body = Vec<PortalTicket>), (status = 401, body = ErrorBody)))]
async fn list_tickets(
    State(state): State<AppState>,
    user: PortalUser,
) -> AppResult<Json<Vec<PortalTicket>>> {
    let mut conn = state.db.acquire().await?;
    Ok(Json(portal::list(&mut conn, &user.viewer()).await?))
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct NewTicket {
    pub subject: String,
    /// question | service | complaint | other
    #[serde(default = "default_category")]
    pub category: String,
    pub body: String,
}

fn default_category() -> String {
    "question".into()
}

#[utoipa::path(post, path = "/portal/tickets", tag = "portal", operation_id = "create_portal_ticket", request_body = NewTicket,
    responses((status = 201, body = PortalTicketDetail), (status = 401, body = ErrorBody), (status = 422, body = ErrorBody)))]
async fn create_ticket(
    State(state): State<AppState>,
    user: PortalUser,
    Json(input): Json<NewTicket>,
) -> AppResult<(StatusCode, Json<PortalTicketDetail>)> {
    let mut tx = state.db.begin().await?;
    let d = portal::open(
        &mut tx,
        &user.viewer(),
        &input.subject,
        &input.category,
        &input.body,
    )
    .await?;
    tx.commit().await?;
    Ok((StatusCode::CREATED, Json(d)))
}

#[utoipa::path(get, path = "/portal/tickets/{id}", tag = "portal", operation_id = "get_portal_ticket", params(("id" = Uuid, Path)),
    responses((status = 200, body = PortalTicketDetail), (status = 401, body = ErrorBody), (status = 404, body = ErrorBody)))]
async fn get_ticket(
    State(state): State<AppState>,
    user: PortalUser,
    Path(id): Path<Uuid>,
) -> AppResult<Json<PortalTicketDetail>> {
    let mut conn = state.db.acquire().await?;
    Ok(Json(portal::get(&mut conn, &user.viewer(), id).await?))
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct MessageInput {
    pub body: String,
}

/// Adds a message to a ticket. A closed ticket is reopened.
#[utoipa::path(post, path = "/portal/tickets/{id}/messages", tag = "portal", operation_id = "add_portal_message",
    params(("id" = Uuid, Path)), request_body = MessageInput,
    responses((status = 201, body = PortalTicketDetail), (status = 401, body = ErrorBody), (status = 404, body = ErrorBody), (status = 422, body = ErrorBody)))]
async fn add_message(
    State(state): State<AppState>,
    user: PortalUser,
    Path(id): Path<Uuid>,
    Json(input): Json<MessageInput>,
) -> AppResult<(StatusCode, Json<PortalTicketDetail>)> {
    let mut tx = state.db.begin().await?;
    let d = portal::add_message(&mut tx, &user.viewer(), id, &input.body).await?;
    tx.commit().await?;
    Ok((StatusCode::CREATED, Json(d)))
}

// ---------------------------------------------------------------------------------------------
// Repairs
// ---------------------------------------------------------------------------------------------

#[utoipa::path(get, path = "/portal/repairs", tag = "portal", operation_id = "list_portal_repairs",
    responses((status = 200, body = Vec<PortalRepair>), (status = 401, body = ErrorBody)))]
async fn list_repairs(
    State(state): State<AppState>,
    user: PortalUser,
) -> AppResult<Json<Vec<PortalRepair>>> {
    let mut conn = state.db.acquire().await?;
    Ok(Json(repair_portal::list(&mut conn, &user.viewer()).await?))
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct AnnounceRepair {
    /// The product in the customer's words, e.g. "Pump 5 kW, blue".
    #[serde(default)]
    pub product_description: String,
    #[serde(default)]
    pub serial_number: String,
    pub fault_description: String,
    /// The customer's own reference (RMA or purchase order).
    #[serde(default)]
    pub customer_reference: String,
}

/// Announces a repair that the customer is going to send in. Photos can be added afterwards.
#[utoipa::path(post, path = "/portal/repairs", tag = "portal", operation_id = "announce_portal_repair", request_body = AnnounceRepair,
    responses((status = 201, body = PortalRepairDetail), (status = 401, body = ErrorBody), (status = 422, body = ErrorBody)))]
async fn announce_repair(
    State(state): State<AppState>,
    user: PortalUser,
    Json(input): Json<AnnounceRepair>,
) -> AppResult<(StatusCode, Json<PortalRepairDetail>)> {
    let mut tx = state.db.begin().await?;
    let d = repair_portal::announce(
        &mut tx,
        &user.viewer(),
        Announcement {
            product_description: &input.product_description,
            serial_number: &input.serial_number,
            fault_description: &input.fault_description,
            customer_reference: &input.customer_reference,
        },
    )
    .await?;
    tx.commit().await?;
    Ok((StatusCode::CREATED, Json(d)))
}

#[utoipa::path(get, path = "/portal/repairs/{id}", tag = "portal", operation_id = "get_portal_repair", params(("id" = Uuid, Path)),
    responses((status = 200, body = PortalRepairDetail), (status = 401, body = ErrorBody), (status = 404, body = ErrorBody)))]
async fn get_repair(
    State(state): State<AppState>,
    user: PortalUser,
    Path(id): Path<Uuid>,
) -> AppResult<Json<PortalRepairDetail>> {
    let mut conn = state.db.acquire().await?;
    Ok(Json(
        repair_portal::get(&mut conn, &user.viewer(), id).await?,
    ))
}

#[derive(Debug, Deserialize, IntoParams)]
pub struct PhotoParams {
    pub caption: Option<String>,
    pub filename: Option<String>,
    /// A client-chosen id: sending the same id again returns the first upload.
    pub client_id: Option<Uuid>,
}

/// Adds a photo to a repair: the request body is the image (JPEG, PNG or WebP, at most 12 MB).
#[utoipa::path(post, path = "/portal/repairs/{id}/photos", tag = "portal", operation_id = "upload_portal_repair_photo",
    params(("id" = Uuid, Path), PhotoParams), request_body(content = String, content_type = "application/octet-stream"),
    responses((status = 201, body = PortalRepairDetail), (status = 401, body = ErrorBody), (status = 422, body = ErrorBody)))]
async fn upload_repair_photo(
    State(state): State<AppState>,
    user: PortalUser,
    Path(id): Path<Uuid>,
    Query(p): Query<PhotoParams>,
    body: Bytes,
) -> AppResult<(StatusCode, Json<PortalRepairDetail>)> {
    let mut tx = state.db.begin().await?;
    let d = repair_portal::add_photo(
        &mut tx,
        &user.viewer(),
        id,
        p.filename.as_deref().unwrap_or(""),
        p.caption.as_deref().unwrap_or(""),
        p.client_id,
        &body,
    )
    .await?;
    tx.commit().await?;
    Ok((StatusCode::CREATED, Json(d)))
}

#[utoipa::path(get, path = "/portal/repairs/{id}/photos/{photo_id}", tag = "portal", operation_id = "get_portal_repair_photo",
    params(("id" = Uuid, Path), ("photo_id" = Uuid, Path)),
    responses((status = 200, content_type = "image/*", body = String), (status = 401, body = ErrorBody), (status = 404, body = ErrorBody)))]
async fn get_repair_photo(
    State(state): State<AppState>,
    user: PortalUser,
    Path((id, photo_id)): Path<(Uuid, Uuid)>,
) -> AppResult<Response> {
    let mut conn = state.db.acquire().await?;
    let (content_type, data) =
        repair_portal::photo_data(&mut conn, &user.viewer(), id, photo_id).await?;
    Ok(traydcraft_core::files::image_response(&content_type, data))
}

pub fn router() -> OpenApiRouter<AppState> {
    OpenApiRouter::new()
        .routes(routes!(request_login_link))
        .routes(routes!(create_session))
        .routes(routes!(end_session))
        .routes(routes!(get_me, update_me))
        .routes(routes!(list_tickets, create_ticket))
        .routes(routes!(get_ticket))
        .routes(routes!(add_message))
        .routes(routes!(list_repairs, announce_repair))
        .routes(routes!(get_repair))
        .routes(routes!(get_repair_photo))
        // Photos are large: raise the body limit for the upload route only.
        .merge(
            OpenApiRouter::new()
                .routes(routes!(upload_repair_photo))
                .layer(DefaultBodyLimit::max(
                    traydcraft_core::files::MAX_FILE_BYTES + 64 * 1024,
                )),
        )
}
