//! Authentication (who are you) and authorisation (what may you do).
//!
//! Production uses OpenID Connect: clients send an access token issued by the
//! identity provider (e.g. Microsoft Entra ID or Keycloak) and the API verifies
//! its signature against the provider's JWKS. Development mode trusts an
//! `X-Dev-User` header and must never be enabled on a reachable server.
//!
//! The active legal entity is chosen with the `X-Company-Id` header and
//! defaults to the user's default membership.

use std::collections::HashMap;

use axum::extract::FromRequestParts;
use axum::http::request::Parts;
use jsonwebtoken::jwk::JwkSet;
use jsonwebtoken::{decode, decode_header, DecodingKey, Validation};
use serde::Deserialize;
use tokio::sync::RwLock;
use uuid::Uuid;

use crate::{AppError, AppState};

pub const DEV_USER_HEADER: &str = "x-dev-user";
pub const COMPANY_HEADER: &str = "x-company-id";

pub enum AuthConfig {
    Dev { default_email: Option<String> },
    Oidc(OidcVerifier),
}

/// Permissions are checked in code; roles are granted per company and map to permissions.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Permission {
    CustomersRead,
    CustomersWrite,
    ProductsRead,
    ProductsWrite,
    PricesWrite,
    QuotationsRead,
    QuotationsWrite,
    OpportunitiesRead,
    OpportunitiesWrite,
    BomRead,
    BomWrite,
    SerialsRead,
    SerialsWrite,
    /// Create and change customer rebates.
    RebatesWrite,
    /// Price a quotation on an earlier price list than its quote date.
    PricesBackdate,
    HelpdeskRead,
    /// Create tickets, write internal notes, change status and links.
    HelpdeskWrite,
    /// Send e-mails to customers.
    HelpdeskReply,
    /// Manage SLA policies, teams and helpdesk settings.
    HelpdeskAdmin,
    /// Manage prepared answers.
    AnswersWrite,
    /// Read the knowledge base, including internal and draft entries.
    KbRead,
    /// Write knowledge base entries (drafts, edits, images, versions).
    KbWrite,
    /// Manage knowledge base categories and publish, unpublish or archive entries.
    KbAdmin,
    OrdersRead,
    OrdersWrite,
    /// Create and change the people at customers (contacts) and their portal access.
    ContactsWrite,
    /// See repairs and their photos.
    RepairsRead,
    /// Register repairs, change their status, add notes and photos (in one's own departments).
    RepairsWrite,
    /// Route a repair to a department, and work on repairs of any department.
    RepairsRoute,
    /// Create and change the workshop departments and who belongs to them (site admin).
    DepartmentsWrite,
    /// See field jobs: one's own as a technician, all as a planner or read-only role.
    FieldRead,
    /// Work on one's own jobs: start, complete, tick tasks, log work, add photos.
    FieldWork,
    /// Plan jobs and assign technicians.
    FieldPlan,
    /// See stock, moves and availability.
    InventoryRead,
    /// Receive, issue, transfer, reserve and count stock.
    InventoryWrite,
    /// Warehouses, locations, units of measure, reversals, posting counts and adjustments.
    InventoryAdmin,
    /// See and change standard cost (and anything derived from it).
    InventoryCost,
}

impl Permission {
    pub const ALL: [Permission; 37] = [
        Permission::CustomersRead,
        Permission::CustomersWrite,
        Permission::ProductsRead,
        Permission::ProductsWrite,
        Permission::PricesWrite,
        Permission::QuotationsRead,
        Permission::QuotationsWrite,
        Permission::OpportunitiesRead,
        Permission::OpportunitiesWrite,
        Permission::BomRead,
        Permission::BomWrite,
        Permission::SerialsRead,
        Permission::SerialsWrite,
        Permission::RebatesWrite,
        Permission::PricesBackdate,
        Permission::HelpdeskRead,
        Permission::HelpdeskWrite,
        Permission::HelpdeskReply,
        Permission::HelpdeskAdmin,
        Permission::AnswersWrite,
        Permission::KbRead,
        Permission::KbWrite,
        Permission::KbAdmin,
        Permission::OrdersRead,
        Permission::OrdersWrite,
        Permission::ContactsWrite,
        Permission::RepairsRead,
        Permission::RepairsWrite,
        Permission::RepairsRoute,
        Permission::DepartmentsWrite,
        Permission::FieldRead,
        Permission::FieldWork,
        Permission::FieldPlan,
        Permission::InventoryRead,
        Permission::InventoryWrite,
        Permission::InventoryAdmin,
        Permission::InventoryCost,
    ];

    pub fn as_str(self) -> &'static str {
        match self {
            Permission::CustomersRead => "customers.read",
            Permission::CustomersWrite => "customers.write",
            Permission::ProductsRead => "products.read",
            Permission::ProductsWrite => "products.write",
            Permission::PricesWrite => "prices.write",
            Permission::QuotationsRead => "quotations.read",
            Permission::QuotationsWrite => "quotations.write",
            Permission::OpportunitiesRead => "opportunities.read",
            Permission::OpportunitiesWrite => "opportunities.write",
            Permission::BomRead => "bom.read",
            Permission::BomWrite => "bom.write",
            Permission::SerialsRead => "serials.read",
            Permission::SerialsWrite => "serials.write",
            Permission::RebatesWrite => "rebates.write",
            Permission::PricesBackdate => "prices.backdate",
            Permission::HelpdeskRead => "helpdesk.read",
            Permission::HelpdeskWrite => "helpdesk.write",
            Permission::HelpdeskReply => "helpdesk.reply",
            Permission::HelpdeskAdmin => "helpdesk.admin",
            Permission::AnswersWrite => "answers.write",
            Permission::KbRead => "kb.read",
            Permission::KbWrite => "kb.write",
            Permission::KbAdmin => "kb.admin",
            Permission::OrdersRead => "orders.read",
            Permission::OrdersWrite => "orders.write",
            Permission::ContactsWrite => "contacts.write",
            Permission::RepairsRead => "repairs.read",
            Permission::RepairsWrite => "repairs.write",
            Permission::RepairsRoute => "repairs.route",
            Permission::DepartmentsWrite => "departments.write",
            Permission::FieldRead => "field.read",
            Permission::FieldWork => "field.work",
            Permission::FieldPlan => "field.plan",
            Permission::InventoryRead => "inventory.read",
            Permission::InventoryWrite => "inventory.write",
            Permission::InventoryAdmin => "inventory.admin",
            Permission::InventoryCost => "inventory.cost",
        }
    }
}

/// Role → permission mapping. Kept in code (reviewed, tested) rather than data for now.
pub fn role_grants(role: &str, p: Permission) -> bool {
    use Permission::*;
    match role {
        "admin" => true,
        "sales_manager" => {
            role_grants("sales", p)
                || matches!(
                    p,
                    RebatesWrite | PricesBackdate | AnswersWrite | RepairsRoute | FieldPlan
                )
        }
        "sales" => matches!(
            p,
            CustomersRead
                | CustomersWrite
                | ProductsRead
                | QuotationsRead
                | QuotationsWrite
                | OpportunitiesRead
                | OpportunitiesWrite
                | BomRead
                | SerialsRead
                | HelpdeskRead
                | HelpdeskWrite
                | HelpdeskReply
                | KbRead
                | OrdersRead
                | OrdersWrite
                | ContactsWrite
                | RepairsRead
                | RepairsWrite
                | FieldRead
                | InventoryRead
        ),
        // First-line customer service: answers e-mails, maintains prepared answers.
        "support" => matches!(
            p,
            CustomersRead
                | ProductsRead
                | QuotationsRead
                | OpportunitiesRead
                | OpportunitiesWrite
                | BomRead
                | SerialsRead
                | HelpdeskRead
                | HelpdeskWrite
                | HelpdeskReply
                | AnswersWrite
                | KbRead
                | KbWrite
                | ContactsWrite
                | RepairsRead
                | RepairsWrite
                | RepairsRoute
                | OrdersRead
                | InventoryRead
        ),
        // Production asks questions through internal notes; sales talks to the customer.
        "production" => matches!(
            p,
            CustomersRead
                | ProductsRead
                | BomRead
                | SerialsRead
                | SerialsWrite
                | OrdersRead
                | HelpdeskRead
                | HelpdeskWrite
                | KbRead
                | InventoryRead
                | InventoryWrite
        ),
        // Stores: receives, issues, transfers and counts stock; never sees cost.
        "warehouse" => matches!(
            p,
            ProductsRead | BomRead | SerialsRead | OrdersRead | InventoryRead | InventoryWrite
        ),
        "product_manager" => matches!(
            p,
            CustomersRead
                | ProductsRead
                | ProductsWrite
                | PricesWrite
                | QuotationsRead
                | OpportunitiesRead
                | BomRead
                | BomWrite
                | SerialsRead
                | SerialsWrite
                | OrdersRead
                | HelpdeskRead
                | KbRead
                | KbWrite
                | InventoryRead
                | InventoryCost
        ),
        // The workshop: works on repairs routed to the departments one belongs to.
        "workshop" => matches!(
            p,
            CustomersRead
                | ProductsRead
                | RepairsRead
                | RepairsWrite
                | BomRead
                | SerialsRead
                | InventoryRead
        ),
        // Field technician: sees and works on their own jobs only.
        "technician" => matches!(p, FieldRead | FieldWork),
        "dispatcher" => matches!(
            p,
            CustomersRead | FieldRead | FieldPlan | RepairsRead | HelpdeskRead | ContactsWrite
        ),
        "viewer" => matches!(
            p,
            RepairsRead
                | FieldRead
                | CustomersRead
                | ProductsRead
                | QuotationsRead
                | OpportunitiesRead
                | BomRead
                | SerialsRead
                | HelpdeskRead
                | KbRead
                | OrdersRead
                | InventoryRead
        ),
        _ => false,
    }
}

#[derive(Debug, Clone)]
pub struct CurrentUser {
    pub user_id: Uuid,
    pub email: String,
    pub display_name: String,
    pub company_id: Uuid,
    pub roles: Vec<String>,
}

impl CurrentUser {
    pub fn can(&self, p: Permission) -> bool {
        self.roles.iter().any(|r| role_grants(r, p))
    }

    pub fn require(&self, p: Permission) -> Result<(), AppError> {
        if self.can(p) {
            Ok(())
        } else {
            Err(AppError::Forbidden(format!(
                "missing permission {}",
                p.as_str()
            )))
        }
    }

    pub fn permissions(&self) -> Vec<Permission> {
        Permission::ALL
            .into_iter()
            .filter(|p| self.can(*p))
            .collect()
    }
}

#[derive(sqlx::FromRow)]
struct UserRow {
    id: Uuid,
    email: String,
    display_name: String,
    oidc_subject: Option<String>,
}

#[derive(sqlx::FromRow)]
struct MembershipRow {
    company_id: Uuid,
    roles: Vec<String>,
}

impl FromRequestParts<AppState> for CurrentUser {
    type Rejection = AppError;

    async fn from_request_parts(
        parts: &mut Parts,
        state: &AppState,
    ) -> Result<Self, Self::Rejection> {
        let user = match state.auth.as_ref() {
            AuthConfig::Dev { default_email } => {
                let email = header(parts, DEV_USER_HEADER)
                    .map(str::to_string)
                    .or_else(|| default_email.clone())
                    .ok_or(AppError::Unauthorized)?;
                find_user_by_email(state, &email)
                    .await?
                    .ok_or(AppError::Unauthorized)?
            }
            AuthConfig::Oidc(verifier) => {
                let token = header(parts, "authorization")
                    .and_then(|h| h.strip_prefix("Bearer "))
                    .ok_or(AppError::Unauthorized)?;
                let claims = verifier.verify(token).await?;
                resolve_oidc_user(state, &claims).await?
            }
        };

        let requested_company = match header(parts, COMPANY_HEADER) {
            Some(v) => Some(
                Uuid::parse_str(v)
                    .map_err(|_| AppError::Validation("invalid X-Company-Id".into()))?,
            ),
            None => None,
        };
        let membership: Option<MembershipRow> = sqlx::query_as(
            "SELECT company_id, roles FROM core.user_companies
             WHERE user_id = $1 AND (company_id = $2 OR ($2 IS NULL AND is_default))",
        )
        .bind(user.id)
        .bind(requested_company)
        .fetch_optional(&state.db)
        .await?;
        let membership = membership
            .ok_or_else(|| AppError::Forbidden("no access to the requested company".into()))?;

        Ok(CurrentUser {
            user_id: user.id,
            email: user.email,
            display_name: user.display_name,
            company_id: membership.company_id,
            roles: membership.roles,
        })
    }
}

fn header<'a>(parts: &'a Parts, name: &str) -> Option<&'a str> {
    parts
        .headers
        .get(name)
        .and_then(|v| v.to_str().ok())
        .map(str::trim)
        .filter(|v| !v.is_empty())
}

async fn find_user_by_email(state: &AppState, email: &str) -> Result<Option<UserRow>, AppError> {
    Ok(sqlx::query_as(
        "SELECT id, email, display_name, oidc_subject FROM core.users
         WHERE lower(email) = lower($1) AND active",
    )
    .bind(email)
    .fetch_optional(&state.db)
    .await?)
}

/// Users are provisioned in the ERP (with roles); the identity provider only proves who they are.
/// On first login the OIDC subject is bound to the user found by e-mail.
async fn resolve_oidc_user(state: &AppState, claims: &Claims) -> Result<UserRow, AppError> {
    let by_subject: Option<UserRow> = sqlx::query_as(
        "SELECT id, email, display_name, oidc_subject FROM core.users WHERE oidc_subject = $1 AND active",
    )
    .bind(&claims.sub)
    .fetch_optional(&state.db)
    .await?;
    if let Some(u) = by_subject {
        return Ok(u);
    }
    let email = claims
        .email
        .as_deref()
        .or(claims.preferred_username.as_deref())
        .ok_or(AppError::Unauthorized)?;
    let user = find_user_by_email(state, email)
        .await?
        .ok_or(AppError::Unauthorized)?;
    if user.oidc_subject.is_some() {
        // Bound to a different identity: refuse rather than silently re-bind.
        return Err(AppError::Unauthorized);
    }
    sqlx::query("UPDATE core.users SET oidc_subject = $1 WHERE id = $2")
        .bind(&claims.sub)
        .bind(user.id)
        .execute(&state.db)
        .await?;
    Ok(user)
}

#[derive(Debug, Deserialize)]
pub struct Claims {
    pub sub: String,
    pub email: Option<String>,
    pub preferred_username: Option<String>,
}

/// Verifies OIDC access tokens against the issuer's published signing keys.
pub struct OidcVerifier {
    issuer: String,
    audience: String,
    http: reqwest::Client,
    keys: RwLock<HashMap<String, DecodingKey>>,
}

#[derive(Deserialize)]
struct Discovery {
    jwks_uri: String,
}

impl OidcVerifier {
    pub fn new(issuer: String, audience: String) -> Self {
        Self {
            issuer,
            audience,
            http: reqwest::Client::new(),
            keys: RwLock::new(HashMap::new()),
        }
    }

    async fn refresh_keys(&self) -> anyhow::Result<()> {
        let discovery_url = format!(
            "{}/.well-known/openid-configuration",
            self.issuer.trim_end_matches('/')
        );
        let discovery: Discovery = self
            .http
            .get(discovery_url)
            .send()
            .await?
            .error_for_status()?
            .json()
            .await?;
        let jwks: JwkSet = self
            .http
            .get(discovery.jwks_uri)
            .send()
            .await?
            .error_for_status()?
            .json()
            .await?;
        let mut keys = HashMap::new();
        for jwk in &jwks.keys {
            if let (Some(kid), Ok(key)) = (jwk.common.key_id.clone(), DecodingKey::from_jwk(jwk)) {
                keys.insert(kid, key);
            }
        }
        *self.keys.write().await = keys;
        Ok(())
    }

    pub async fn verify(&self, token: &str) -> Result<Claims, AppError> {
        let header = decode_header(token).map_err(|_| AppError::Unauthorized)?;
        let kid = header.kid.ok_or(AppError::Unauthorized)?;

        if !self.keys.read().await.contains_key(&kid) {
            // Unknown key id: the provider may have rotated its keys.
            self.refresh_keys().await.map_err(AppError::Internal)?;
        }
        let keys = self.keys.read().await;
        let key = keys.get(&kid).ok_or(AppError::Unauthorized)?;

        let mut validation = Validation::new(header.alg);
        validation.set_issuer(&[&self.issuer]);
        validation.set_audience(&[&self.audience]);
        let data = decode::<Claims>(token, key, &validation).map_err(|e| {
            tracing::debug!(error = %e, "token rejected");
            AppError::Unauthorized
        })?;
        Ok(data.claims)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn sales_cannot_change_prices_or_products() {
        assert!(role_grants("sales", Permission::QuotationsWrite));
        assert!(!role_grants("sales", Permission::PricesWrite));
        assert!(!role_grants("sales", Permission::ProductsWrite));
    }

    #[test]
    fn viewer_is_read_only() {
        for p in Permission::ALL {
            assert_eq!(role_grants("viewer", p), p.as_str().ends_with(".read"));
        }
    }

    #[test]
    fn only_managers_change_rebates_or_backdate_prices() {
        for p in [Permission::RebatesWrite, Permission::PricesBackdate] {
            assert!(role_grants("sales_manager", p));
            assert!(role_grants("admin", p));
            assert!(!role_grants("sales", p));
        }
        assert!(role_grants("sales_manager", Permission::QuotationsWrite));
    }

    #[test]
    fn production_cannot_email_customers() {
        assert!(role_grants("production", Permission::HelpdeskWrite));
        assert!(!role_grants("production", Permission::HelpdeskReply));
        assert!(role_grants("sales", Permission::HelpdeskReply));
    }

    #[test]
    fn only_admins_manage_sla_policies_and_teams() {
        assert!(role_grants("admin", Permission::HelpdeskAdmin));
        for r in ["sales", "sales_manager", "support", "production", "viewer"] {
            assert!(!role_grants(r, Permission::HelpdeskAdmin), "{r}");
        }
    }

    #[test]
    fn knowledge_base_rights_follow_the_roles() {
        for p in [Permission::KbRead, Permission::KbWrite, Permission::KbAdmin] {
            assert!(role_grants("admin", p));
        }
        for r in ["support", "product_manager"] {
            assert!(role_grants(r, Permission::KbRead) && role_grants(r, Permission::KbWrite));
            assert!(!role_grants(r, Permission::KbAdmin), "{r}");
        }
        for r in ["sales", "sales_manager", "production", "viewer"] {
            assert!(role_grants(r, Permission::KbRead), "{r}");
            assert!(!role_grants(r, Permission::KbWrite), "{r}");
        }
        for r in ["technician", "workshop", "dispatcher"] {
            assert!(!role_grants(r, Permission::KbRead), "{r}");
        }
    }

    #[test]
    fn contacts_are_maintained_by_sales_and_support_only() {
        for r in ["admin", "sales", "sales_manager", "support"] {
            assert!(role_grants(r, Permission::ContactsWrite), "{r}");
        }
        for r in ["production", "product_manager", "viewer"] {
            assert!(!role_grants(r, Permission::ContactsWrite), "{r}");
        }
    }

    #[test]
    fn only_admins_create_departments() {
        for r in [
            "sales",
            "sales_manager",
            "support",
            "workshop",
            "dispatcher",
            "technician",
            "viewer",
        ] {
            assert!(!role_grants(r, Permission::DepartmentsWrite), "{r}");
        }
        assert!(role_grants("admin", Permission::DepartmentsWrite));
    }

    #[test]
    fn workshop_and_field_roles_are_narrow() {
        // The workshop works on repairs but does not route them; technicians cannot plan.
        assert!(role_grants("workshop", Permission::RepairsWrite));
        assert!(!role_grants("workshop", Permission::RepairsRoute));
        assert!(role_grants("support", Permission::RepairsRoute));
        assert!(role_grants("technician", Permission::FieldWork));
        assert!(!role_grants("technician", Permission::FieldPlan));
        assert!(!role_grants("technician", Permission::RepairsRead));
        assert!(!role_grants("technician", Permission::CustomersRead));
        assert!(role_grants("dispatcher", Permission::FieldPlan));
        assert!(!role_grants("dispatcher", Permission::FieldWork));
    }

    #[test]
    fn inventory_rights_follow_the_roles() {
        for p in [
            Permission::InventoryRead,
            Permission::InventoryWrite,
            Permission::InventoryAdmin,
            Permission::InventoryCost,
        ] {
            assert!(role_grants("admin", p));
        }
        for r in ["sales", "sales_manager", "support", "viewer", "workshop"] {
            assert!(role_grants(r, Permission::InventoryRead), "{r}");
            assert!(!role_grants(r, Permission::InventoryWrite), "{r}");
        }
        for r in ["production", "warehouse"] {
            assert!(role_grants(r, Permission::InventoryWrite), "{r}");
            assert!(!role_grants(r, Permission::InventoryAdmin), "{r}");
        }
        // Cost is not for sales, the warehouse or production.
        for r in [
            "sales",
            "sales_manager",
            "support",
            "production",
            "warehouse",
            "viewer",
        ] {
            assert!(!role_grants(r, Permission::InventoryCost), "{r}");
        }
        assert!(role_grants("product_manager", Permission::InventoryCost));
        assert!(!role_grants("technician", Permission::InventoryRead));
    }

    #[test]
    fn unknown_role_grants_nothing() {
        assert!(Permission::ALL.iter().all(|p| !role_grants("intern", *p)));
    }
}
