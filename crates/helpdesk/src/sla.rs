//! Service levels: how quickly a ticket must get a first response and be resolved, per priority.
//!
//! Plain elapsed time (business hours are not modelled yet). The clock stops while the ticket
//! waits for the customer (`pending_customer`) and the time spent waiting is added to the due
//! times when the ticket moves on. The computation is a set of pure functions at the top of this
//! file; the rest reads and writes the database around them.

use axum::extract::State;
use axum::Json;
use chrono::{DateTime, Duration, Utc};
use serde::{Deserialize, Serialize};
use sqlx::{FromRow, PgConnection, PgPool};
use traydcraft_core::{audit, AppError, AppResult, AppState, CurrentUser, Permission};
use utoipa::ToSchema;
use utoipa_axum::router::OpenApiRouter;
use utoipa_axum::routes;
use uuid::Uuid;

type ErrorBody = traydcraft_core::error::ErrorBody;

/// Default windows (priority, first response minutes, resolution minutes).
pub const DEFAULT_POLICIES: [(&str, i32, i32); 4] = [
    ("urgent", 60, 480),
    ("high", 240, 1440),
    ("normal", 480, 4320),
    ("low", 1440, 7200),
];

/// A ticket is "at risk" when less than this share (percent) of a window is left.
pub const AT_RISK_PERCENT: i64 = 25;

// ---------------------------------------------------------------------------------------------
// Pure computation
// ---------------------------------------------------------------------------------------------

/// When the clock was stopped and how long it has been stopped in total.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
pub struct PauseState {
    pub paused_at: Option<DateTime<Utc>>,
    pub paused_seconds: i64,
}

/// The due time for a window of `minutes` from `created_at`, shifted by the time the clock was
/// stopped (not counting a pause that is still running).
pub fn due_at(created_at: DateTime<Utc>, minutes: i32, paused_seconds: i64) -> DateTime<Utc> {
    created_at + Duration::minutes(i64::from(minutes)) + Duration::seconds(paused_seconds)
}

/// The pause state after the ticket got `status` at `now`: waiting for the customer stops the
/// clock; any other status restarts it and adds the waiting time.
pub fn advance_pause(status: &str, now: DateTime<Utc>, p: PauseState) -> PauseState {
    match (status == "pending_customer", p.paused_at) {
        (true, None) => PauseState {
            paused_at: Some(now),
            ..p
        },
        (false, Some(since)) => PauseState {
            paused_at: None,
            paused_seconds: p.paused_seconds + (now - since).num_seconds().max(0),
        },
        _ => p,
    }
}

/// What one target (first response or resolution) looks like at `now`.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, ToSchema)]
pub struct TargetState {
    /// When it is due; empty when the ticket has no service level (internal tickets).
    pub due_at: Option<DateTime<Utc>>,
    /// The due time passed before it was met (or, if still open, it has passed).
    pub breached: bool,
    /// Not breached, not met yet and less than 25 % of the window is left.
    pub at_risk: bool,
    /// Whole minutes left (negative when overdue). Empty once the target is met.
    pub minutes_remaining: Option<i64>,
    /// When it was met (first response sent, ticket closed).
    pub met_at: Option<DateTime<Utc>>,
}

impl TargetState {
    pub fn none() -> Self {
        TargetState {
            due_at: None,
            breached: false,
            at_risk: false,
            minutes_remaining: None,
            met_at: None,
        }
    }
}

/// The state of one target. While the clock is stopped, time does not advance: the reference
/// point is the moment it stopped, so a ticket that had run out before the pause stays breached
/// and one that had time left keeps it.
pub fn target_state(
    due: Option<DateTime<Utc>>,
    window_minutes: Option<i32>,
    met_at: Option<DateTime<Utc>>,
    paused_at: Option<DateTime<Utc>>,
    now: DateTime<Utc>,
) -> TargetState {
    let Some(due) = due else {
        return TargetState::none();
    };
    let reference = met_at.or(paused_at).unwrap_or(now);
    let remaining_seconds = (due - reference).num_seconds();
    let breached = due < reference;
    let at_risk = !breached
        && met_at.is_none()
        && window_minutes
            .is_some_and(|w| remaining_seconds < i64::from(w) * 60 * AT_RISK_PERCENT / 100);
    TargetState {
        due_at: Some(due),
        breached,
        at_risk,
        minutes_remaining: met_at.is_none().then(|| remaining_seconds.div_euclid(60)),
        met_at,
    }
}

/// The SLA of a ticket as the API shows it.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, ToSchema)]
pub struct TicketSla {
    /// none (no service level) | on_time | at_risk | breached
    pub state: String,
    /// The clock is stopped: the ticket waits for the customer.
    pub paused: bool,
    pub first_response: TargetState,
    pub resolution: TargetState,
    pub first_response_breached: bool,
    pub resolution_breached: bool,
}

impl Default for TicketSla {
    fn default() -> Self {
        TicketSla {
            state: "none".into(),
            paused: false,
            first_response: TargetState::none(),
            resolution: TargetState::none(),
            first_response_breached: false,
            resolution_breached: false,
        }
    }
}

/// The raw SLA columns of a ticket.
#[derive(Debug, Clone)]
pub struct SlaInput {
    pub first_response_due_at: Option<DateTime<Utc>>,
    pub resolution_due_at: Option<DateTime<Utc>>,
    pub first_response_minutes: Option<i32>,
    pub resolution_minutes: Option<i32>,
    pub paused_at: Option<DateTime<Utc>>,
    pub first_response_at: Option<DateTime<Utc>>,
    pub closed_at: Option<DateTime<Utc>>,
}

/// Evaluates both targets. A ticket that is closed without any response counts as having
/// answered at the moment it was closed.
pub fn evaluate(i: &SlaInput, now: DateTime<Utc>) -> TicketSla {
    let first_response = target_state(
        i.first_response_due_at,
        i.first_response_minutes,
        i.first_response_at.or(i.closed_at),
        i.paused_at,
        now,
    );
    let resolution = target_state(
        i.resolution_due_at,
        i.resolution_minutes,
        i.closed_at,
        i.paused_at,
        now,
    );
    let state = if first_response.due_at.is_none() && resolution.due_at.is_none() {
        "none"
    } else if first_response.breached || resolution.breached {
        "breached"
    } else if first_response.at_risk || resolution.at_risk {
        "at_risk"
    } else {
        "on_time"
    };
    TicketSla {
        state: state.into(),
        paused: i.paused_at.is_some() && i.closed_at.is_none(),
        first_response_breached: first_response.breached,
        resolution_breached: resolution.breached,
        first_response,
        resolution,
    }
}

/// SQL for the same rules, on the ticket alias `t`: used by the list filter and the worker.
/// Keep in step with [`evaluate`].
pub mod sql {
    const FR_MET: &str = "coalesce(t.first_response_at, t.closed_at)";
    const FR_REF: &str = "coalesce(t.first_response_at, t.closed_at, t.sla_paused_at, now())";
    const RES_REF: &str = "coalesce(t.closed_at, t.sla_paused_at, now())";

    pub fn breached() -> String {
        format!(
            "(NOT t.internal AND ((t.first_response_due_at IS NOT NULL AND t.first_response_due_at < {FR_REF})
               OR (t.resolution_due_at IS NOT NULL AND t.resolution_due_at < {RES_REF})))"
        )
    }

    pub fn at_risk() -> String {
        format!(
            "(NOT t.internal AND NOT {b} AND (
                (t.first_response_due_at IS NOT NULL AND {FR_MET} IS NULL
                 AND t.first_response_due_at - {FR_REF} < t.sla_first_response_minutes * interval '15 seconds')
             OR (t.resolution_due_at IS NOT NULL AND t.closed_at IS NULL
                 AND t.resolution_due_at - {RES_REF} < t.sla_resolution_minutes * interval '15 seconds')))",
            b = breached()
        )
    }
}

// ---------------------------------------------------------------------------------------------
// Policies
// ---------------------------------------------------------------------------------------------

#[derive(Debug, Clone, Serialize, Deserialize, FromRow, ToSchema)]
pub struct SlaPolicy {
    /// low | normal | high | urgent
    pub priority: String,
    pub first_response_minutes: i32,
    pub resolution_minutes: i32,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct SlaPoliciesInput {
    pub policies: Vec<SlaPolicy>,
}

/// Makes sure the company has a policy for every priority (new companies start with the defaults).
pub async fn ensure_policies(conn: &mut PgConnection, company_id: Uuid) -> Result<(), sqlx::Error> {
    for (priority, fr, res) in DEFAULT_POLICIES {
        sqlx::query(
            "INSERT INTO helpdesk.sla_policies (company_id, priority, first_response_minutes, resolution_minutes)
             VALUES ($1, $2, $3, $4) ON CONFLICT DO NOTHING",
        )
        .bind(company_id)
        .bind(priority)
        .bind(fr)
        .bind(res)
        .execute(&mut *conn)
        .await?;
    }
    Ok(())
}

async fn load_policies(conn: &mut PgConnection, company_id: Uuid) -> AppResult<Vec<SlaPolicy>> {
    ensure_policies(conn, company_id).await?;
    Ok(sqlx::query_as(
        "SELECT priority, first_response_minutes, resolution_minutes FROM helpdesk.sla_policies
         WHERE company_id = $1
         ORDER BY CASE priority WHEN 'urgent' THEN 0 WHEN 'high' THEN 1 WHEN 'normal' THEN 2 ELSE 3 END",
    )
    .bind(company_id)
    .fetch_all(conn)
    .await?)
}

/// Computes the due times of a ticket from its priority and status and stores them. Safe to call
/// after any change to the ticket (creation, priority, status): it restarts or stops the clock
/// as the status requires. Internal tickets have no service level.
pub async fn sync(conn: &mut PgConnection, ticket_id: Uuid) -> AppResult<()> {
    #[derive(FromRow)]
    struct Row {
        company_id: Uuid,
        status: String,
        priority: String,
        internal: bool,
        created_at: DateTime<Utc>,
        sla_paused_at: Option<DateTime<Utc>>,
        sla_paused_seconds: i64,
    }
    let Some(t): Option<Row> = sqlx::query_as(
        "SELECT company_id, status, priority, internal, created_at, sla_paused_at, sla_paused_seconds
         FROM helpdesk.tickets WHERE id = $1 FOR UPDATE",
    )
    .bind(ticket_id)
    .fetch_optional(&mut *conn)
    .await?
    else {
        return Ok(());
    };
    if t.internal {
        sqlx::query(
            "UPDATE helpdesk.tickets SET first_response_due_at = NULL, resolution_due_at = NULL,
                    sla_first_response_minutes = NULL, sla_resolution_minutes = NULL, sla_paused_at = NULL
             WHERE id = $1",
        )
        .bind(ticket_id)
        .execute(conn)
        .await?;
        return Ok(());
    }
    let policy = load_policies(conn, t.company_id)
        .await?
        .into_iter()
        .find(|p| p.priority == t.priority)
        .ok_or_else(|| AppError::Validation("unknown priority".into()))?;
    let pause = advance_pause(
        &t.status,
        Utc::now(),
        PauseState {
            paused_at: t.sla_paused_at,
            paused_seconds: t.sla_paused_seconds,
        },
    );
    sqlx::query(
        "UPDATE helpdesk.tickets SET sla_first_response_minutes = $2, sla_resolution_minutes = $3,
                first_response_due_at = $4, resolution_due_at = $5, sla_paused_at = $6, sla_paused_seconds = $7
         WHERE id = $1",
    )
    .bind(ticket_id)
    .bind(policy.first_response_minutes)
    .bind(policy.resolution_minutes)
    .bind(due_at(
        t.created_at,
        policy.first_response_minutes,
        pause.paused_seconds,
    ))
    .bind(due_at(
        t.created_at,
        policy.resolution_minutes,
        pause.paused_seconds,
    ))
    .bind(pause.paused_at)
    .bind(pause.paused_seconds)
    .execute(conn)
    .await?;
    Ok(())
}

#[utoipa::path(get, path = "/helpdesk/sla-policies", tag = "helpdesk", responses((status = 200, body = Vec<SlaPolicy>), (status = 403, body = ErrorBody)))]
async fn get_policies(
    State(state): State<AppState>,
    user: CurrentUser,
) -> AppResult<Json<Vec<SlaPolicy>>> {
    user.require(Permission::HelpdeskAdmin)?;
    let mut conn = state.db.acquire().await?;
    Ok(Json(load_policies(&mut conn, user.company_id).await?))
}

/// Replaces the windows for the given priorities. Open tickets get new due times.
#[utoipa::path(put, path = "/helpdesk/sla-policies", tag = "helpdesk", request_body = SlaPoliciesInput,
    responses((status = 200, body = Vec<SlaPolicy>), (status = 403, body = ErrorBody), (status = 422, body = ErrorBody)))]
async fn put_policies(
    State(state): State<AppState>,
    user: CurrentUser,
    Json(input): Json<SlaPoliciesInput>,
) -> AppResult<Json<Vec<SlaPolicy>>> {
    user.require(Permission::HelpdeskAdmin)?;
    for p in &input.policies {
        if !crate::tickets::PRIORITIES.contains(&p.priority.as_str()) {
            return Err(AppError::Validation(format!(
                "priority must be one of {}",
                crate::tickets::PRIORITIES.join(", ")
            )));
        }
        let limit = 60 * 24 * 365;
        if p.first_response_minutes <= 0 || p.first_response_minutes > limit {
            return Err(AppError::Validation(
                "the first response time must be between 1 minute and a year".into(),
            ));
        }
        if p.resolution_minutes < p.first_response_minutes || p.resolution_minutes > limit {
            return Err(AppError::Validation(
                "the resolution time must not be shorter than the first response time".into(),
            ));
        }
    }
    let mut tx = state.db.begin().await?;
    ensure_policies(&mut tx, user.company_id).await?;
    for p in &input.policies {
        sqlx::query(
            "UPDATE helpdesk.sla_policies SET first_response_minutes = $3, resolution_minutes = $4, updated_at = now()
             WHERE company_id = $1 AND priority = $2",
        )
        .bind(user.company_id)
        .bind(&p.priority)
        .bind(p.first_response_minutes)
        .bind(p.resolution_minutes)
        .execute(&mut *tx)
        .await?;
    }
    let open: Vec<Uuid> = sqlx::query_scalar(
        "SELECT id FROM helpdesk.tickets WHERE company_id = $1 AND closed_at IS NULL AND NOT internal",
    )
    .bind(user.company_id)
    .fetch_all(&mut *tx)
    .await?;
    for id in open {
        sync(&mut tx, id).await?;
    }
    audit::record(
        &mut tx,
        &user,
        "helpdesk_settings",
        user.company_id,
        "sla_policies_updated",
        serde_json::json!({ "policies": input.policies }),
    )
    .await?;
    let policies = load_policies(&mut tx, user.company_id).await?;
    tx.commit().await?;
    Ok(Json(policies))
}

pub fn router() -> OpenApiRouter<AppState> {
    OpenApiRouter::new().routes(routes!(get_policies, put_policies))
}

// ---------------------------------------------------------------------------------------------
// Escalation (called by the worker)
// ---------------------------------------------------------------------------------------------

#[derive(FromRow)]
struct Breach {
    id: Uuid,
    company_id: Uuid,
    number: String,
    subject: String,
    priority: String,
    owner_user_id: Option<Uuid>,
    team_id: Option<Uuid>,
}

fn escalation_mail(language: &str, kind: &str, b: &Breach) -> (String, String) {
    let first = kind == "first_response";
    let (what, line) = match (language, first) {
        ("nl", true) => (
            "eerste reactie",
            "De termijn voor de eerste reactie is overschreden.",
        ),
        ("nl", false) => ("oplossing", "De termijn voor de oplossing is overschreden."),
        ("fr", true) => (
            "première réponse",
            "Le délai de première réponse est dépassé.",
        ),
        ("fr", false) => ("résolution", "Le délai de résolution est dépassé."),
        ("de", true) => (
            "Erstreaktion",
            "Die Frist für die Erstreaktion wurde überschritten.",
        ),
        ("de", false) => ("Lösung", "Die Frist für die Lösung wurde überschritten."),
        ("es", true) => (
            "primera respuesta",
            "Se ha superado el plazo de primera respuesta.",
        ),
        ("es", false) => ("resolución", "Se ha superado el plazo de resolución."),
        (_, true) => (
            "first response",
            "The first response time has been exceeded.",
        ),
        (_, false) => ("resolution", "The resolution time has been exceeded."),
    };
    let subject = format!("SLA {what}: {} - {}", b.number, b.subject);
    let body = format!("{line}\n\n{} - {}\n[{}]\n", b.number, b.subject, b.priority);
    (subject, body)
}

async fn recipients(conn: &mut PgConnection, b: &Breach) -> Result<Vec<String>, sqlx::Error> {
    let mut out: Vec<String> = Vec::new();
    if let Some(owner) = b.owner_user_id {
        out.extend(
            sqlx::query_scalar::<_, String>(
                "SELECT email FROM core.users WHERE id = $1 AND active",
            )
            .bind(owner)
            .fetch_optional(&mut *conn)
            .await?,
        );
        if let Some(team) = b.team_id {
            out.extend(
                sqlx::query_scalar::<_, String>(
                    "SELECT u.email FROM helpdesk.team_members m JOIN core.users u ON u.id = m.user_id
                     WHERE m.team_id = $1 AND m.is_lead AND u.active",
                )
                .bind(team)
                .fetch_all(&mut *conn)
                .await?,
            );
        }
    } else if let Some(team) = b.team_id {
        out.extend(
            sqlx::query_scalar::<_, String>(
                "SELECT u.email FROM helpdesk.team_members m JOIN core.users u ON u.id = m.user_id
                 WHERE m.team_id = $1 AND u.active",
            )
            .bind(team)
            .fetch_all(&mut *conn)
            .await?,
        );
    }
    if out.is_empty() {
        // Nobody is responsible yet: the company's administrators hear about it.
        out.extend(
            sqlx::query_scalar::<_, String>(
                "SELECT u.email FROM core.user_companies uc JOIN core.users u ON u.id = uc.user_id
                 WHERE uc.company_id = $1 AND 'admin' = ANY(uc.roles) AND u.active",
            )
            .bind(b.company_id)
            .fetch_all(&mut *conn)
            .await?,
        );
    }
    out.sort();
    out.dedup();
    Ok(out)
}

/// Finds open tickets whose first response or resolution time ran out and tells the people
/// responsible, once per ticket and kind. A ticket is claimed with a single UPDATE, so several
/// workers (or repeated polls) never send the same escalation twice. Returns the number of
/// escalations.
pub async fn escalate(db: &PgPool) -> anyhow::Result<usize> {
    let mut done = 0;
    for (kind, column, condition) in [
        (
            "first_response",
            "first_response_breach_notified_at",
            "t.first_response_at IS NULL AND t.first_response_due_at < now()",
        ),
        (
            "resolution",
            "resolution_breach_notified_at",
            "t.resolution_due_at < now()",
        ),
    ] {
        let candidates: Vec<Uuid> = sqlx::query_scalar(&format!(
            "SELECT t.id FROM helpdesk.tickets t
             WHERE t.closed_at IS NULL AND NOT t.internal AND t.sla_paused_at IS NULL
               AND t.{column} IS NULL AND {condition}
             ORDER BY t.created_at LIMIT 100"
        ))
        .fetch_all(db)
        .await?;
        for id in candidates {
            let mut tx = db.begin().await?;
            let claimed: Option<Breach> = sqlx::query_as(&format!(
                "UPDATE helpdesk.tickets t SET {column} = now()
                 WHERE t.id = $1 AND t.{column} IS NULL AND t.closed_at IS NULL AND {condition}
                 RETURNING t.id, t.company_id, t.number, t.subject, t.priority, t.owner_user_id, t.team_id"
            ))
            .bind(id)
            .fetch_optional(&mut *tx)
            .await?;
            let Some(b) = claimed else { continue };
            let language: String = sqlx::query_scalar(
                "SELECT default_language::text FROM core.companies WHERE id = $1",
            )
            .bind(b.company_id)
            .fetch_one(&mut *tx)
            .await?;
            let to = recipients(&mut tx, &b).await?;
            let (subject, body) = escalation_mail(&language, kind, &b);
            for address in &to {
                traydcraft_core::mail::enqueue(&mut tx, b.company_id, address, &subject, &body)
                    .await?;
            }
            audit::record_system(
                &mut tx,
                b.company_id,
                "ticket",
                b.id,
                "sla_breached",
                serde_json::json!({ "kind": kind, "number": b.number, "notified": to }),
            )
            .await?;
            tx.commit().await?;
            done += 1;
        }
    }
    Ok(done)
}

#[cfg(test)]
mod tests {
    use super::*;
    use chrono::TimeZone;

    fn t(h: u32, m: u32) -> DateTime<Utc> {
        Utc.with_ymd_and_hms(2026, 11, 9, h, m, 0).unwrap()
    }

    #[test]
    fn due_time_is_creation_plus_window_plus_paused_time() {
        assert_eq!(due_at(t(9, 0), 60, 0), t(10, 0));
        assert_eq!(due_at(t(9, 0), 60, 1800), t(10, 30));
    }

    #[test]
    fn waiting_for_the_customer_stops_and_restarts_the_clock() {
        let p = advance_pause("pending_customer", t(10, 0), PauseState::default());
        assert_eq!(p.paused_at, Some(t(10, 0)));
        // Still waiting: nothing changes (and the pause start is kept).
        assert_eq!(advance_pause("pending_customer", t(11, 0), p), p);
        // Other statuses without a pause change nothing either.
        assert_eq!(
            advance_pause("open", t(11, 0), PauseState::default()),
            PauseState::default()
        );
        let resumed = advance_pause("open", t(11, 30), p);
        assert_eq!(resumed.paused_at, None);
        assert_eq!(resumed.paused_seconds, 5400);
        // A second pause adds up.
        let again = advance_pause("pending_customer", t(12, 0), resumed);
        let back = advance_pause("closed", t(12, 10), again);
        assert_eq!(back.paused_seconds, 5400 + 600);
        assert_eq!(
            due_at(t(9, 0), 60, back.paused_seconds),
            t(9, 0) + Duration::minutes(60 + 100)
        );
    }

    #[test]
    fn open_target_is_on_time_at_risk_or_breached() {
        let due = Some(t(10, 0));
        // 60 minute window, 2 hours before the end.
        let s = target_state(due, Some(60), None, None, t(8, 0));
        assert!(!s.breached && !s.at_risk);
        assert_eq!(s.minutes_remaining, Some(120));
        // Under 25 % of 60 minutes (15) left.
        let s = target_state(due, Some(60), None, None, t(9, 50));
        assert!(!s.breached && s.at_risk);
        assert_eq!(s.minutes_remaining, Some(10));
        // Exactly 25 % left is not yet at risk.
        let s = target_state(due, Some(60), None, None, t(9, 45));
        assert!(!s.at_risk);
        // Due time passed.
        let s = target_state(due, Some(60), None, None, t(10, 30));
        assert!(s.breached && !s.at_risk);
        assert_eq!(s.minutes_remaining, Some(-30));
    }

    #[test]
    fn a_met_target_is_judged_at_the_moment_it_was_met() {
        let due = Some(t(10, 0));
        let in_time = target_state(due, Some(60), Some(t(9, 59)), None, t(15, 0));
        assert!(!in_time.breached && !in_time.at_risk);
        assert_eq!(in_time.minutes_remaining, None);
        let late = target_state(due, Some(60), Some(t(10, 1)), None, t(10, 2));
        assert!(late.breached);
    }

    #[test]
    fn the_clock_is_frozen_while_paused() {
        let due = Some(t(10, 0));
        // Paused at 09:00 with an hour left: still an hour left at 17:00.
        let s = target_state(due, Some(240), None, Some(t(9, 0)), t(17, 0));
        assert!(!s.breached);
        assert_eq!(s.minutes_remaining, Some(60));
        // Paused after the due time: stays breached.
        let s = target_state(due, Some(240), None, Some(t(10, 5)), t(11, 0));
        assert!(s.breached);
    }

    #[test]
    fn tickets_without_a_service_level_are_neutral() {
        let i = SlaInput {
            first_response_due_at: None,
            resolution_due_at: None,
            first_response_minutes: None,
            resolution_minutes: None,
            paused_at: None,
            first_response_at: None,
            closed_at: None,
        };
        assert_eq!(evaluate(&i, t(12, 0)), TicketSla::default());
    }

    #[test]
    fn overall_state_follows_the_worst_target() {
        let mut i = SlaInput {
            first_response_due_at: Some(t(10, 0)),
            resolution_due_at: Some(t(18, 0)),
            first_response_minutes: Some(60),
            resolution_minutes: Some(540),
            paused_at: None,
            first_response_at: None,
            closed_at: None,
        };
        assert_eq!(evaluate(&i, t(9, 0)).state, "on_time");
        assert_eq!(evaluate(&i, t(9, 50)).state, "at_risk");
        let s = evaluate(&i, t(10, 30));
        assert_eq!(s.state, "breached");
        assert!(s.first_response_breached && !s.resolution_breached);
        // Answered in time: only the resolution target is left.
        i.first_response_at = Some(t(9, 30));
        assert_eq!(evaluate(&i, t(10, 30)).state, "on_time");
        // Closed without any answer counts as answered at closing.
        i.first_response_at = None;
        i.closed_at = Some(t(9, 40));
        let s = evaluate(&i, t(20, 0));
        assert_eq!(s.state, "on_time");
        assert!(!s.paused);
    }
}
