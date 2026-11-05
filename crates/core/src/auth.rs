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
}

impl Permission {
    pub const ALL: [Permission; 13] = [
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
        }
    }
}

/// Role → permission mapping. Kept in code (reviewed, tested) rather than data for now.
pub fn role_grants(role: &str, p: Permission) -> bool {
    use Permission::*;
    match role {
        "admin" => true,
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
        ),
        "viewer" => matches!(
            p,
            CustomersRead
                | ProductsRead
                | QuotationsRead
                | OpportunitiesRead
                | BomRead
                | SerialsRead
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
    fn unknown_role_grants_nothing() {
        assert!(Permission::ALL.iter().all(|p| !role_grants("intern", *p)));
    }
}
