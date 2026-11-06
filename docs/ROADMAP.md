# Roadmap: parity with Salesforce, Exact Online and Odoo

Target: the *operational* 80% of Salesforce (CRM, service), Exact Online (stock, purchasing, production)
and Odoo (helpdesk, knowledge base, field service, planning, MRP) for a 20-50 user manufacturing and
service company. Statutory accounting stays in Exact ([ADR 0008](adr/0008-accounting-stays-external.md)).
Module overview: [ARCHITECTURE.md](ARCHITECTURE.md).

## Status

| Item | State |
|---|---|
| Order lifecycle (revisions, confirmation, priority) | Done, [ADR 0016](adr/0016-order-lifecycle.md) |
| A1 Helpdesk SLA, teams, attachments, tags, merge, time, CSAT | Done, ADR 0017 (PR #2) |
| A2 Knowledge base | Done, ADR 0018 (PR #2) |
| A3 Field service completion | Part 1 done (offline queue open), ADR 0019 |
| B1 Inventory foundation | Open |
| B2 Purchasing | Open (needs B1) |
| B3 Delivery | Open (needs B1) |
| C1 Production orders | Open (needs B1) |
| C2 MRP | Open (needs B1, B2, C1) |
| C3 Planning board | Open (field-jobs half has no dependencies) |

## Sequencing

Dependencies drive the order: **stock ledger -> purchasing -> production and MRP -> planning**.
The service track (A) and the field-jobs half of the planning board are independent and can run in
parallel with the supply chain. Each item ends shippable: migrations, API, regenerated OpenAPI and Dart
client, Flutter screens, five-language strings, tests and an ADR.

## Track A - Service

**A3 Field service completion** (medium-large)
- Service report PDF (Typst, pattern `crates/sales/src/order_doc.rs`), customer signature capture.
- Parts used: record-only first; deduction from stock follows B1.
- Job to `engineering.serial_units` link (installed base) and a warranty flag.
- Maintenance contracts: contract, visit template and recurrence that generates jobs; SLA on contracts.
- Offline queue in the Flutter app (the server is already idempotent, [ADR 0006](adr/0006-offline-sync.md)).

Remaining helpdesk gaps (from ADR 0017): automation rules, ticket split, reporting, business hours.
Remaining knowledge base gaps (ADR 0018): non-image attachments, analytics, semantic search, a public web page.

## Track B - Supply chain (sequential)

**B1 Inventory foundation** (large), finalise [ADR 0007](adr/0007-ledgers.md)
- Crate `inventory`: warehouses and locations (including service vans), an immutable `stock_moves` ledger
  with reversal corrections, a balance table updated in the same transaction, units of measure and
  conversions, lot/batch tracking (extend `tracking`), counts, adjustments, transfers.
- Product additions: cost, reorder min/max, lead time, barcode. Cost is hidden from sales ([ADR 0004](adr/0004-authentication.md)).
- Reservations against confirmed orders; availability (ATP) on the order screen.

**B2 Purchasing** (large)
- Crate `purchasing`: suppliers, supplier price lists, product codes, MOQ and lead times;
  RFQ -> PO -> goods receipt; a receipt creates stock moves and serial units ([ADR 0011](adr/0011-bom-revisions-and-serial-genealogy.md)).
- PO PDF and mail to the supplier through the outbox; approval limits; vendor bill matching (two-way first).
- Numbering through `core::numbering::next_number` (new codes PO, GR). Export of bills and valuation to Exact later.

**B3 Delivery** (small-medium)
- Delivery notes and picking from `ready_for_shipping`; shipped status with a tracking reference;
  consumes reservations.

## Track C - Production and planning (needs B1)

**C1 Production orders** (large), Phase 2 of [ADR 0016](adr/0016-order-lifecycle.md)
- Crate `production`: production orders per division, work orders, BOM explosion via
  `crates/engineering/src/explode.rs`, component reservation, backflush consumption, scrap, output creates
  stock and serial units.
- Divisions report a planned-ready date; the order's promised date is the latest one. This drives the order
  statuses `in_planning -> planned -> in_production -> ready_for_shipping` (already allowed by the schema).
  A priority change reorders the queues.

**C2 MRP** (large)
- Reorder rules and an MRP run for make-to-stock and make-to-order: net requirements from orders, stock and
  open POs/MOs; proposals for POs and MOs; lead-time offsetting.

**C3 Planning board** (medium-large)
- One calendar/Gantt component in Flutter for field jobs (drag-assign, availability, absences, skills,
  conflicts, travel-time estimate) and work centres (capacity, finite loading).
  Resource calendars are the shared backend piece.

## Working in parallel

Items that can run at the same time on separate branches: A3, B1, and the field-jobs half of C3.

Shared files that will conflict between branches:
- `crates/core/src/auth.rs` (permissions)
- `api/openapi.json` and `app/lib/api/generated/`
- `app/lib/l10n/*.arb` and the generated l10n Dart files
- `Cargo.toml`, `apps/api/src/lib.rs`, `app/lib/app/router.dart`, `app/lib/app/shell.dart`

Rules:
- One branch and one PR per item. Merge the earlier PRs first so everyone starts from the same base.
- After a rebase, regenerate the generated files (`scripts/generate-api-client.sh`, `flutter gen-l10n`)
  instead of resolving them by hand.
- Give migrations unique timestamps (agree a date prefix per session) so two branches never share a name.
- Agree table shapes in an ADR before another module builds on them (for example B1 before B2 and C1).

## Per-item checklist

- Crate per module, schema per module, `company_id` on every transactional table, a `utoipa` router,
  permissions in `crates/core/src/auth.rs`, audit through `core::audit::record`.
- Tenant isolation: add row-level security, or a test that scans queries for `company_id`, before stock and
  purchasing data lands.
- Strings in all five languages (nl, fr, en, de, es); an ADR; DB-backed tests (`sqlx::test`); widget tests.
- Move file storage off PostgreSQL `bytea` before attachments multiply.

Verification for every item:

```bash
export DATABASE_URL=postgresql://traydcraft:traydcraft@localhost:5433/traydcraft   # docker compose up -d db
cargo fmt --all --check
cargo clippy --workspace --all-targets -- -D warnings
cargo test --workspace
cd app && flutter analyze && flutter test
```

## Out of scope (use Exact or external tools)

Statutory accounting, VAT returns, bank reconciliation, payroll, e-commerce, marketing automation.
