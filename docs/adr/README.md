# Architecture decision records

Short records of decisions that are expensive to reverse. Add a new file instead of rewriting an
accepted one; mark superseded records as such.

| # | Decision | Status |
|---|---|---|
| [0001](0001-modular-monolith.md) | Modular monolith in Rust, one PostgreSQL database | Accepted |
| [0002](0002-money-and-pricing.md) | Decimal money and a pure, server-side pricing engine | Accepted |
| [0003](0003-multi-company.md) | Multi-company data model from day one | Accepted |
| [0004](0004-authentication.md) | OIDC authentication, roles per company in the ERP | Accepted |
| [0005](0005-api-contract-and-codegen.md) | OpenAPI generated from Rust, Dart client generated from OpenAPI | Accepted |
| [0006](0006-offline-sync.md) | Narrow, append-only offline sync for technicians | Proposed |
| [0007](0007-ledgers.md) | Ledgers with projections for stock and money | Proposed |
| [0008](0008-accounting-stays-external.md) | Statutory accounting stays in Exact; Peppol via an access point | Accepted |
| [0009](0009-pdf-with-typst.md) | PDF documents with Typst | Accepted |
| [0010](0010-flutter-desktop-first.md) | Flutter, desktop-first for the office | Accepted |
| [0011](0011-bom-revisions-and-serial-genealogy.md) | BOM revisions and serial-number genealogy | Accepted |
| [0012](0012-rebates-price-dates-and-price-changes.md) | Rebates, pricing types, price dates and price changes | Accepted |
