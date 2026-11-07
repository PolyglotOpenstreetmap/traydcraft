//! The company's business calendar for the SLA: working weekdays with opening hours, a time zone
//! and holidays. The arithmetic is in [`crate::sla`]; this file stores and serves the settings.

use std::collections::BTreeSet;

use axum::extract::{Path, State};
use axum::http::StatusCode;
use axum::Json;
use chrono::{NaiveDate, NaiveTime};
use chrono_tz::Tz;
use serde::{Deserialize, Serialize};
use sqlx::{FromRow, PgConnection};
use traydcraft_core::{audit, new_id, AppError, AppResult, AppState, CurrentUser, Permission};
use utoipa::ToSchema;
use utoipa_axum::router::OpenApiRouter;
use utoipa_axum::routes;
use uuid::Uuid;

use crate::sla::Calendar;

type ErrorBody = traydcraft_core::error::ErrorBody;

pub const DEFAULT_TIME_ZONE: &str = "Europe/Brussels";

#[derive(Debug, Clone, Serialize, Deserialize, ToSchema)]
pub struct WorkingHours {
    /// 1 = Monday ... 7 = Sunday. A weekday that is not listed is closed.
    pub weekday: i16,
    /// `HH:MM`, local time.
    pub start_time: String,
    pub end_time: String,
}

#[derive(Debug, Clone, Serialize, FromRow, ToSchema)]
pub struct Holiday {
    pub id: Uuid,
    pub day: NaiveDate,
    pub name: String,
}

#[derive(Debug, Serialize, ToSchema)]
pub struct BusinessCalendar {
    /// When off, SLA times are plain elapsed time.
    pub enabled: bool,
    /// An IANA name such as `Europe/Brussels`.
    pub time_zone: String,
    pub hours: Vec<WorkingHours>,
    pub holidays: Vec<Holiday>,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct CalendarInput {
    pub enabled: bool,
    pub time_zone: String,
    pub hours: Vec<WorkingHours>,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct HolidayInput {
    #[serde(deserialize_with = "traydcraft_core::serde_util::date")]
    pub day: NaiveDate,
    pub name: String,
}

fn parse_time(s: &str) -> AppResult<NaiveTime> {
    NaiveTime::parse_from_str(s, "%H:%M")
        .or_else(|_| NaiveTime::parse_from_str(s, "%H:%M:%S"))
        .map_err(|_| AppError::Validation(format!("{s:?} is not a time (HH:MM)")))
}

fn fmt_time(t: NaiveTime) -> String {
    t.format("%H:%M").to_string()
}

/// The default week: Monday to Friday, 09:00-17:00.
fn default_hours() -> Vec<WorkingHours> {
    (1..=5)
        .map(|weekday| WorkingHours {
            weekday,
            start_time: "09:00".into(),
            end_time: "17:00".into(),
        })
        .collect()
}

/// The calendar SLA times are measured with, or `None` when the company has none or switched it
/// off (then plain elapsed time applies).
pub async fn load_calendar(
    conn: &mut PgConnection,
    company_id: Uuid,
) -> Result<Option<Calendar>, sqlx::Error> {
    let row: Option<(bool, String)> = sqlx::query_as(
        "SELECT enabled, time_zone FROM helpdesk.business_calendars WHERE company_id = $1",
    )
    .bind(company_id)
    .fetch_optional(&mut *conn)
    .await?;
    let Some((true, zone)) = row else {
        return Ok(None);
    };
    let Ok(tz) = zone.parse::<Tz>() else {
        return Ok(None);
    };
    let hours: Vec<(i16, NaiveTime, NaiveTime)> = sqlx::query_as(
        "SELECT weekday, start_time, end_time FROM helpdesk.business_hours WHERE company_id = $1",
    )
    .bind(company_id)
    .fetch_all(&mut *conn)
    .await?;
    let holidays: Vec<NaiveDate> =
        sqlx::query_scalar("SELECT day FROM helpdesk.holidays WHERE company_id = $1")
            .bind(company_id)
            .fetch_all(conn)
            .await?;
    let mut days = [None; 7];
    for (weekday, start, end) in hours {
        if (1..=7).contains(&weekday) {
            days[(weekday - 1) as usize] = Some((start, end));
        }
    }
    let cal = Calendar {
        tz,
        days,
        holidays: holidays.into_iter().collect::<BTreeSet<_>>(),
    };
    Ok(cal.is_usable().then_some(cal))
}

async fn load_settings(conn: &mut PgConnection, company_id: Uuid) -> AppResult<BusinessCalendar> {
    let row: Option<(bool, String)> = sqlx::query_as(
        "SELECT enabled, time_zone FROM helpdesk.business_calendars WHERE company_id = $1",
    )
    .bind(company_id)
    .fetch_optional(&mut *conn)
    .await?;
    let hours: Vec<(i16, NaiveTime, NaiveTime)> = sqlx::query_as(
        "SELECT weekday, start_time, end_time FROM helpdesk.business_hours
         WHERE company_id = $1 ORDER BY weekday",
    )
    .bind(company_id)
    .fetch_all(&mut *conn)
    .await?;
    let holidays = sqlx::query_as(
        "SELECT id, day, name FROM helpdesk.holidays WHERE company_id = $1 ORDER BY day",
    )
    .bind(company_id)
    .fetch_all(conn)
    .await?;
    let (enabled, time_zone) = row.unwrap_or((false, DEFAULT_TIME_ZONE.into()));
    Ok(BusinessCalendar {
        enabled,
        time_zone,
        hours: if hours.is_empty() && !enabled {
            default_hours()
        } else {
            hours
                .into_iter()
                .map(|(weekday, s, e)| WorkingHours {
                    weekday,
                    start_time: fmt_time(s),
                    end_time: fmt_time(e),
                })
                .collect()
        },
        holidays,
    })
}

/// Gives every open ticket new due times; called when the calendar changes.
async fn recompute_open(conn: &mut PgConnection, company_id: Uuid) -> AppResult<usize> {
    let open: Vec<Uuid> = sqlx::query_scalar(
        "SELECT id FROM helpdesk.tickets WHERE company_id = $1 AND closed_at IS NULL AND NOT internal",
    )
    .bind(company_id)
    .fetch_all(&mut *conn)
    .await?;
    for id in &open {
        crate::sla::sync(conn, *id).await?;
    }
    Ok(open.len())
}

#[utoipa::path(get, path = "/helpdesk/calendar", tag = "helpdesk",
    responses((status = 200, body = BusinessCalendar), (status = 403, body = ErrorBody)))]
async fn get_calendar(
    State(state): State<AppState>,
    user: CurrentUser,
) -> AppResult<Json<BusinessCalendar>> {
    user.require(Permission::HelpdeskAdmin)?;
    let mut conn = state.db.acquire().await?;
    Ok(Json(load_settings(&mut conn, user.company_id).await?))
}

/// Sets the working week and time zone and switches the calendar on or off. Open tickets get new
/// due times.
#[utoipa::path(put, path = "/helpdesk/calendar", tag = "helpdesk", request_body = CalendarInput,
    responses((status = 200, body = BusinessCalendar), (status = 403, body = ErrorBody), (status = 422, body = ErrorBody)))]
async fn put_calendar(
    State(state): State<AppState>,
    user: CurrentUser,
    Json(input): Json<CalendarInput>,
) -> AppResult<Json<BusinessCalendar>> {
    user.require(Permission::HelpdeskAdmin)?;
    if input.time_zone.parse::<Tz>().is_err() {
        return Err(AppError::Validation(format!(
            "{:?} is not a known time zone (for example {DEFAULT_TIME_ZONE})",
            input.time_zone
        )));
    }
    let mut seen = BTreeSet::new();
    let mut hours = Vec::new();
    for h in &input.hours {
        if !(1..=7).contains(&h.weekday) || !seen.insert(h.weekday) {
            return Err(AppError::Validation(
                "weekday must be 1 (Monday) to 7 (Sunday), once each".into(),
            ));
        }
        let (s, e) = (parse_time(&h.start_time)?, parse_time(&h.end_time)?);
        if e <= s {
            return Err(AppError::Validation(
                "the closing time must be after the opening time".into(),
            ));
        }
        hours.push((h.weekday, s, e));
    }
    if input.enabled && hours.is_empty() {
        return Err(AppError::Validation(
            "a calendar needs at least one working day".into(),
        ));
    }
    let mut tx = state.db.begin().await?;
    sqlx::query(
        "INSERT INTO helpdesk.business_calendars (company_id, enabled, time_zone) VALUES ($1, $2, $3)
         ON CONFLICT (company_id) DO UPDATE SET enabled = $2, time_zone = $3, updated_at = now()",
    )
    .bind(user.company_id)
    .bind(input.enabled)
    .bind(&input.time_zone)
    .execute(&mut *tx)
    .await?;
    sqlx::query("DELETE FROM helpdesk.business_hours WHERE company_id = $1")
        .bind(user.company_id)
        .execute(&mut *tx)
        .await?;
    for (weekday, s, e) in hours {
        sqlx::query(
            "INSERT INTO helpdesk.business_hours (company_id, weekday, start_time, end_time) VALUES ($1, $2, $3, $4)",
        )
        .bind(user.company_id)
        .bind(weekday)
        .bind(s)
        .bind(e)
        .execute(&mut *tx)
        .await?;
    }
    let recomputed = recompute_open(&mut tx, user.company_id).await?;
    audit::record(
        &mut tx,
        &user,
        "helpdesk_settings",
        user.company_id,
        "business_calendar_updated",
        serde_json::json!({ "enabled": input.enabled, "time_zone": input.time_zone, "recomputed": recomputed }),
    )
    .await?;
    let out = load_settings(&mut tx, user.company_id).await?;
    tx.commit().await?;
    Ok(Json(out))
}

#[utoipa::path(post, path = "/helpdesk/calendar/holidays", tag = "helpdesk", request_body = HolidayInput,
    responses((status = 201, body = Holiday), (status = 409, body = ErrorBody), (status = 422, body = ErrorBody)))]
async fn add_holiday(
    State(state): State<AppState>,
    user: CurrentUser,
    Json(input): Json<HolidayInput>,
) -> AppResult<(StatusCode, Json<Holiday>)> {
    user.require(Permission::HelpdeskAdmin)?;
    if input.name.trim().is_empty() {
        return Err(AppError::Validation("a holiday needs a name".into()));
    }
    let id = new_id();
    let mut tx = state.db.begin().await?;
    sqlx::query(
        "INSERT INTO helpdesk.holidays (id, company_id, day, name) VALUES ($1, $2, $3, $4)",
    )
    .bind(id)
    .bind(user.company_id)
    .bind(input.day)
    .bind(input.name.trim())
    .execute(&mut *tx)
    .await?;
    let recomputed = recompute_open(&mut tx, user.company_id).await?;
    audit::record(
        &mut tx,
        &user,
        "helpdesk_settings",
        id,
        "holiday_added",
        serde_json::json!({ "day": input.day, "name": input.name.trim(), "recomputed": recomputed }),
    )
    .await?;
    tx.commit().await?;
    Ok((
        StatusCode::CREATED,
        Json(Holiday {
            id,
            day: input.day,
            name: input.name.trim().to_string(),
        }),
    ))
}

#[utoipa::path(delete, path = "/helpdesk/calendar/holidays/{id}", tag = "helpdesk", params(("id" = Uuid, Path)),
    responses((status = 204), (status = 404, body = ErrorBody)))]
async fn delete_holiday(
    State(state): State<AppState>,
    user: CurrentUser,
    Path(id): Path<Uuid>,
) -> AppResult<StatusCode> {
    user.require(Permission::HelpdeskAdmin)?;
    let mut tx = state.db.begin().await?;
    let day: Option<NaiveDate> = sqlx::query_scalar(
        "DELETE FROM helpdesk.holidays WHERE id = $1 AND company_id = $2 RETURNING day",
    )
    .bind(id)
    .bind(user.company_id)
    .fetch_optional(&mut *tx)
    .await?;
    let day = day.ok_or(AppError::NotFound("holiday"))?;
    let recomputed = recompute_open(&mut tx, user.company_id).await?;
    audit::record(
        &mut tx,
        &user,
        "helpdesk_settings",
        id,
        "holiday_removed",
        serde_json::json!({ "day": day, "recomputed": recomputed }),
    )
    .await?;
    tx.commit().await?;
    Ok(StatusCode::NO_CONTENT)
}

pub fn router() -> OpenApiRouter<AppState> {
    OpenApiRouter::new()
        .routes(routes!(get_calendar, put_calendar))
        .routes(routes!(add_holiday))
        .routes(routes!(delete_holiday))
}
