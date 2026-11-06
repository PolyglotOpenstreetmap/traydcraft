# Architecture

## Goal

One integrated platform for the full lifecycle of a manufacturing and service business
(20–50 users, make-to-stock and make-to-order, in-house repairs, installation and maintenance teams):

enquiry → quotation → sales order → engineering → purchasing → production → stock → delivery →
installation → maintenance → repair → helpdesk → invoicing

It replaces Salesforce (CRM, quotations) first and Exact Online's operational parts (components,
stock, production, invoicing) later. Statutory accounting stays in Exact until the operational
system is proven (see [ADR 0008](adr/0008-accounting-stays-external.md)).

## Shape

```
Flutter app (Windows desktop for office, Android/iOS for technicians, web optional)
        │  HTTPS · REST/JSON · OpenAPI (generated Dart client)
Rust API (Axum) — modular monolith
  core · crm · products/pricing · sales · inventory · helpdesk · portal · (production · service · finance)
        │  SQLx, one transaction per business operation
PostgreSQL — one database, one schema per module
  + object storage (documents, photos)
  + worker (apps/worker): IMAP polling, e-mail outbox; later PDF, Peppol, Exact sync
```

* **Modular monolith** ([ADR 0001](adr/0001-modular-monolith.md)): one deployable, modules as crates.
  A module owns its schema; other modules call its public Rust functions, never its tables.
  Example: `sales` uses `crm::get_customer_for_quoting` and `products::get_products_for_quoting`,
  and accepting a quotation calls `crm::opportunities::mark_won` in the same transaction.
  Read-only joins to another module's tables for display (names, codes) are allowed;
  writes and business rules always go through the owning module.
* **Pricing is authoritative on the server** ([ADR 0002](adr/0002-money-and-pricing.md)).
  The app calls `POST /pricing/preview` while editing; it never calculates prices.
* **Multi-company from day one** ([ADR 0003](adr/0003-multi-company.md)).
* **Documents are snapshots**: a sent quotation never changes; changes create a revision.
* **History is never overwritten**: prices are dated rows, audit events are append-only;
  stock is a movement ledger plus a balance projection ([ADR 0019](adr/0019-inventory-stock-ledger.md), [ADR 0007](adr/0007-ledgers.md)).

## Modules

| Module | Status | Owns (schema) |
|---|---|---|
| core | slice | companies, users, memberships/roles, numbering, audit |
| crm | slice | customers, **contacts** (people with roles, language, form of address, e-mails and phones; lookup by e-mail and phone — [ADR 0014](adr/0014-contacts-calls-and-customer-portal.md)), per-company terms (zone, general rebate, payment terms), product/family rebates, opportunities / pipeline |
| products / pricing | slice | products, families, pricing types (list/net/indicative), price zones, dated zone prices, bulk price changes ([ADR 0012](adr/0012-rebates-price-dates-and-price-changes.md)) |
| sales | slice | quotations (snapshots, price date, revisions keeping or updating prices), linked to opportunities; sales orders from an accepted revision with a draft → sent → confirmed lifecycle, revisions, order confirmation PDF by e-mail, customer confirmation (staff or portal) and priority with history ([ADR 0016](adr/0016-order-lifecycle.md)) |
| documents | slice | PDF rendering (Typst) |
| engineering | slice | BOM revisions (multi-level via subassemblies), explosion, serial units and as-built genealogy ([ADR 0011](adr/0011-bom-revisions-and-serial-genealogy.md)); routings and configurator planned |
| purchasing | planned | suppliers, purchase orders, receipts |
| inventory | slice | warehouses and locations (incl. service vans), units of measure, lot and serial tracking, an append-only stock move ledger with a balance projection, transfers, adjustments and counts, reservations for confirmed order lines and availability (ATP) on the order ([ADR 0019](adr/0019-inventory-stock-ledger.md)); other modules post moves through `inventory::post_move`; purchasing receipts, delivery, valuation and MRP planned |
| production | planned | production orders, work orders, consumption, MTS/MTO planning |
| quality | planned | inspections, non-conformances, traceability |
| service | planned | installed assets (builds on serial units), warranties |
| helpdesk | slice | e-mail-to-ticket (IMAP) with threading and matching, replies via outbox (SMTP), prepared answers in 5 languages, leads / orders / production questions from tickets ([ADR 0013](adr/0013-helpdesk-email-and-languages.md)), phone calls logged on tickets; SLA with escalation, teams, attachments, tags, merge, time entries and satisfaction surveys ([ADR 0017](adr/0017-helpdesk-sla-teams-attachments.md)); automation rules, split, reporting and business hours planned |
| repairs | slice | repairs customers send in (announced → received → routed → worked → shipped), workshop departments made by the admin, photos ([ADR 0015](adr/0015-repairs-field-service-and-photos.md)) |
| field service | slice | jobs at customer sites: address and navigation, instructions, task checklist, work logs, photos; technicians see only their own jobs ([ADR 0015](adr/0015-repairs-field-service-and-photos.md)); offline queue and planning board planned |
| kb | slice | knowledge base: categories and articles in 5 languages with Markdown, full-text search per language, versions, tags and related articles, images, suggestions on tickets, helpful votes, reading for staff, portal contacts and the public ([ADR 0018](adr/0018-knowledge-base.md)); attachments other than images, comments, analytics, semantic search, translation workflow and SEO export planned |
| portal | slice | customer portal: passwordless login for contacts, their tickets and profile; Flutter web entry point ([ADR 0014](adr/0014-contacts-calls-and-customer-portal.md)) |
| finance | planned | invoices, credit notes, Peppol via access point, Exact integration |

## Conventions

* Primary keys: UUIDv7 (`core::new_id`), safe to generate on offline devices.
* Money: `NUMERIC` in PostgreSQL, `rust_decimal::Decimal` in Rust, **strings** in JSON.
* Every business table that belongs to a legal entity has `company_id`.
* Every change of business significance writes `audit.events` in the same transaction.
* Errors: JSON `{ "error": "<code>", "message": "..." }` with 401/403/404/409/422/500.
* Permissions are checked in handlers (`user.require(Permission::...)`); roles map to permissions
  per company.

## Roadmap

1. **Foundation & sales** — customers, opportunities, quotations; next: contacts, activities, sales orders, e-mailing quotes.
2. **Engineering & inventory** — BOM revisions and serial numbers, warehouses, stock ledger, lots, reservations and counts (done); next: routings, configurator, purchasing.
3. **Manufacturing** — MRP for MTS and MTO, production orders, labour, quality.
4. **Service** — installed assets, repairs, field service planning, mobile app with offline sync.
5. **Helpdesk & portal** — tickets from e-mail, prepared answers, orders, contacts, phone calls and a ticket portal (done); SLA, teams, attachments, tags, merge, time entries and satisfaction surveys (done, ADR 0017); knowledge base with portal help and ticket deflection (done, ADR 0018; remaining: attachments other than images, comments and ratings text, analytics, AI/semantic search, translation workflow, SEO export); next: automation rules, ticket split, reporting, business hours in the SLA, quotations in the portal.
6. **Finance** — invoicing, Peppol, payments, Exact integration.

Each release runs alongside Salesforce/Exact, with one system clearly owning each kind of record
during the transition.
