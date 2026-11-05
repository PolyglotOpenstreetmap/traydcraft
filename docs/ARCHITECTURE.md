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
  core · crm · products/pricing · sales · (inventory · production · service · helpdesk · finance)
        │  SQLx, one transaction per business operation
PostgreSQL — one database, one schema per module
  + object storage (documents, photos)  + background worker (outbox: e-mail, PDF, Peppol, Exact sync)
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
  stock will be a movement ledger plus a balance projection ([ADR 0007](adr/0007-ledgers.md)).

## Modules

| Module | Status | Owns (schema) |
|---|---|---|
| core | slice | companies, users, memberships/roles, numbering, audit |
| crm | slice | customers, per-company terms (zone, general rebate, payment terms), product/family rebates, opportunities / pipeline |
| products / pricing | slice | products, families, pricing types (list/net/indicative), price zones, dated zone prices, bulk price changes ([ADR 0012](adr/0012-rebates-price-dates-and-price-changes.md)) |
| sales | slice | quotations and lines (snapshots, price date, revisions keeping or updating prices), linked to opportunities |
| documents | slice | PDF rendering (Typst) |
| engineering | slice | BOM revisions (multi-level via subassemblies), explosion, serial units and as-built genealogy ([ADR 0011](adr/0011-bom-revisions-and-serial-genealogy.md)); routings and configurator planned |
| purchasing | planned | suppliers, purchase orders, receipts |
| inventory | planned | warehouses, locations (incl. service vans), movements, reservations |
| production | planned | production orders, work orders, consumption, MTS/MTO planning |
| quality | planned | inspections, non-conformances, traceability |
| service | planned | installed assets (builds on serial units), repairs, warranties |
| field service | planned | planning board, mobile app with offline sync ([ADR 0006](adr/0006-offline-sync.md)) |
| helpdesk | planned | tickets, SLA, e-mail-to-ticket, portal |
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
2. **Engineering & inventory** — BOM revisions and serial numbers (done); next: routings, configurator, warehouses, stock ledger, purchasing.
3. **Manufacturing** — MRP for MTS and MTO, production orders, labour, quality.
4. **Service** — installed assets, repairs, field service planning, mobile app with offline sync.
5. **Helpdesk & portal** — tickets, SLA, e-mail integration, customer portal.
6. **Finance** — invoicing, Peppol, payments, Exact integration.

Each release runs alongside Salesforce/Exact, with one system clearly owning each kind of record
during the transition.
