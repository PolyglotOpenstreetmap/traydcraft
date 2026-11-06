# traydcraft

An integrated business platform for a manufacturing and service company:
CRM, quotations, products, inventory, production, repairs, field service, helpdesk and invoicing,
built to progressively replace Salesforce and Exact Online. Inspired by Odoo's breadth, built around
our own processes.

**Stack:** Rust (Axum, SQLx) · PostgreSQL · Flutter (Windows, Android, iOS, web) · Typst for PDFs.

> Status: **vertical slice**. Customers and opportunities, products with families and five price
> zones, customer rebates (product / family / general), net and indicative prices, bulk price
> changes, quotations with revisions and server-side pricing (incl. earlier price lists), sales
> orders, a helpdesk (e-mail tickets, phone calls, prepared answers in five languages, production questions),
> contacts with their own language and form of address, a customer portal, PDF output, multi-level bills of materials
> with revisions, serial numbers with as-built genealogy, generated Dart API client and a Flutter app.
> See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the target architecture and roadmap.

## Repository layout

```
apps/api/            HTTP server: wires modules, OpenAPI, migrations, integration tests
crates/core/         errors, auth (OIDC / dev), companies, numbering, audit trail
crates/pricing/      pure pricing engine (no I/O): zone prices, discounts, rounding, VAT
crates/crm/          customers, contacts (people), per-company commercial terms, opportunities
crates/products/     products, price zones, price history
crates/sales/        quotations: drafts, snapshots, revisions, PDF data
crates/engineering/  BOM revisions, explosion, serial units and genealogy
crates/helpdesk/     tickets from e-mail and phone, threading, prepared answers, outbox, IMAP
crates/portal/       customer portal: passwordless login for contacts, their tickets and profile
apps/worker/         background worker: IMAP polling and sending the e-mail outbox
crates/documents/    Typst PDF rendering, Belgian number formatting
migrations/          SQLx migrations (one PostgreSQL schema per module)
templates/           Typst document templates (nl / fr / en)
seed/                development seed data (fictitious)
api/openapi.json     generated API contract (source of the Dart client)
app/                 Flutter application
docs/                architecture and decision records
```

## Running locally

Prerequisites: Rust (stable), PostgreSQL 16, [Typst](https://typst.app) CLI, Flutter SDK.

```bash
docker compose up --build
```

or without Docker, against a local PostgreSQL:

```bash
cp .env.example .env    # adjust DATABASE_URL
set -a; source .env; set +a
cargo run -p traydcraft-api
```

The API listens on `http://localhost:8080`; interactive API docs are at `/docs`.
With `SEED_DEV_DATA=true` a demo company is created with users `admin@example.com`,
`sales@example.com`, `manager@example.com` (sales manager), `support@example.com`,
`production@example.com` and `viewer@example.com`
(development authentication only).

Worker (helpdesk e-mail). By default outgoing mail is written to `./outbox` as `.eml` files;
set `MAIL_TRANSPORT=smtp` and `SMTP_*`, and `IMAP_*` to fetch incoming mail (see `.env.example`):

```bash
cargo run -p traydcraft-worker
```

Flutter app (in Dutch, French, English, German or Spanish; choose in the account menu):

```bash
cd app
flutter run -d windows     # or: -d chrome, -d <android device>
```

Sign in with server `http://localhost:8080` and a development user e-mail.

Customer portal (a separate web build; the demo data has portal users such as
`jan.peeters@alpha.example`). The login link is e-mailed by the worker, so with
`MAIL_TRANSPORT=files` open the newest `.eml` in `./outbox`. The company needs a `portal_url`
(the demo company has one):

```bash
cd app
flutter run -d chrome --web-port 8081 -t lib/portal/portal_main.dart \
  --dart-define=PORTAL_API_URL=http://localhost:8080 \
  --dart-define=PORTAL_COMPANY_ID=00000000-0000-7000-8000-000000000001
```

Staff manage the people at a customer under Customers → Contacts, look up a caller with
"Who is calling?" in the helpdesk, and give a contact portal access in the contact form.

## Tests

```bash
cargo test                                   # unit tests + API tests (needs DATABASE_URL, typst)
cd app && flutter analyze && flutter test
```

API integration tests use `sqlx::test`, which creates a throw-away database per test, so
`DATABASE_URL` must point at a server where that user may create databases.

## Changing the API

The Dart client is generated from the Rust code. After changing endpoints or types:

```bash
./scripts/generate-api-client.sh
```

CI fails if `api/openapi.json` or the generated client is out of date.

## License

GPL-3.0-or-later. See [LICENSE](LICENSE).
