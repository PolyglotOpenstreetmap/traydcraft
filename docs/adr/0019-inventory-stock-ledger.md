# 0019 — Inventory: stock ledger, balances, lots, reservations and counts

**Status:** Accepted. Supersedes the stock part of [ADR 0007](0007-ledgers.md); the money and
finance ledgers in 0007 stay *Proposed*.

**Context.** Purchasing (B2), delivery (B3), production (C1) and MRP (C2) all move or reserve
stock, and repairs and field service (A3) will consume parts. They must build on one shape, so the
tables below are explicit. The crate is `crates/inventory`, schema `inventory`, migration
`20261201000001_inventory`.

## Decision

### Locations
* **Warehouses** (`inventory.warehouses`): `code` and `name` unique per company, `kind`
  `warehouse | van`, an optional `assigned_user_id` (the technician of a service van), `active`.
  A van is a warehouse of kind `van` with its own locations, so replenishing a van is an ordinary
  transfer. Vans do not count towards availability for orders (see *Availability*).
* **Locations** (`inventory.locations`): bins inside a warehouse, `code` unique per warehouse,
  `kind = internal`. A warehouse is deactivated, a location is deactivated only when its balance is
  zero; neither is ever deleted once it has moves.
* **Virtual locations** (`warehouse_id IS NULL`, one per company and kind): `supplier`, `customer`,
  `production`, `adjustment`, `scrap`. They are the other side of a move, so **every move has a
  `from` and a `to`** (double entry): for each product the balances over all locations of a company
  add up to zero. Virtual locations may go negative, internal ones may not
  (`stock_balances.allow_negative` + a check). They are created on first use.

### The ledger: `inventory.stock_moves`
* One row per product and lot or serial unit: `id` (client-chosen UUID, see *Idempotency*),
  `seq` (identity; the total order of the ledger), `company_id`, `product_id`, `quantity`
  (`numeric(18,4)`, > 0, **always in the product's stock unit**), `from_location_id`,
  `to_location_id` (different), `lot_id`, `serial_unit_id`, `kind`
  (`receipt | issue | transfer | adjustment`), `reason` (text, validated in code so later modules
  add reasons without a migration: `manual_receipt`, `purchase_receipt`, `production_output`,
  `return`, `shipment`, `consumption`, `repair_use`, `scrap`, `transfer`, `van_replenishment`,
  `count`, `correction`, `reversal`), `reference_type` + `reference_id` (the source document: a
  count, later a purchase receipt, delivery or production order), `note`, `entered_quantity` +
  `entered_uom` (what the user typed, for display), `unit_cost` + `currency` (see *Cost on moves*),
  `reversed_of`, `occurred_at`, `created_by`, `created_at`.
* **Immutable.** A trigger refuses `UPDATE`, `DELETE` and `TRUNCATE` on the table. A correction is
  a **reversal**: a new move with `from` and `to` swapped, `reversed_of` = the original and reason
  `reversal`. A move can be reversed once (unique `reversed_of`); a reversal cannot be reversed
  (post a new move instead). A reversal fails like any move when it would make stock negative.
* Money values use the project's decimals (ADR 0002): `numeric(18,4)` unit cost, strings in JSON,
  `rust_decimal` in Rust. Nothing here rounds money. Quantities are `numeric(18,4)`.

### Balances: `inventory.stock_balances`
* One row per `(company, product, location, lot)` (lot may be `NULL`, unique through an expression
  index), `quantity`, `allow_negative`. It is written **in the same transaction** as each move
  (`INSERT ... ON CONFLICT DO UPDATE`, rows touched in a fixed order to avoid deadlocks).
* It is a projection: `inventory::rebuild_balances` recomputes it from the ledger and
  `inventory::check_balances` reports differences. Both are exposed to the inventory admin.
* Serial-tracked units: a balance of 1 at the unit's location plus a row in
  `inventory.serial_stock (serial_unit_id, location_id)`, also a projection of the last move.

### Idempotency
The move `id` is chosen by the client (like the work-log ids in field service). A retry with the
same id and the same content returns the existing move with `200`; the same id with different
content is a `409`. Reversals take their own client id.

### Units of measure
* `inventory.uoms` (master data, no company): `code`, `name`, `category`
  (`unit | weight | length | area | volume | time`) and `factor`, the size of the unit in the
  category's base unit (`kg` 1, `g` 0.001). Seeded with the usual units; products keep their text
  `unit` (the **stock unit**).
* `inventory.product_uoms (product_id, uom_code, factor)` holds product-specific units (a box of
  12 pcs: factor 12). A move may be *entered* in another unit; it is converted to the stock unit
  and stored in the stock unit with the entered amount kept for display. Conversion rule
  (**decision**): the product-specific factor first; else, for the measurable categories (`weight`,
  `length`, `area`, `volume`, `time`), the ratio of the two `factor`s; units of the category `unit`
  (`pcs`, `set`, and every unit taken over from existing products, such as `box` or `Stk`) **never**
  convert by themselves, because their `factor` of 1 means nothing. "5 set" on a product kept in
  pieces is a 422 that names both units, unless the product has a `product_uoms` entry for `set`. The
  same rule and the same error apply to order availability and to reservations (an order line in
  a unit that does not convert is an error, never a guess). The stock unit of a product cannot be
  changed once it has moves (database trigger).

### Tracking
`products.products.tracking` becomes `none | serial | lot`, and (as before) cannot change once the
product has moves (trigger). Services are not stocked.
* **Lot:** `inventory.lots (company, product, lot_number, expiry_date)`, unique per product. Every
  move of a lot-tracked product names a lot; a receipt creates the lot by number if it is new. A
  balance exists per lot. Reservations pick the earliest expiry first (FEFO).
* **Serial:** one move per unit with `quantity = 1` and `serial_unit_id`. See *Serial units*.

### Serial units and ADR 0011
`engineering.serial_units.status` stays the as-built status; the ledger decides *where* a unit is.
* Receiving a serial product registers the unit through `engineering` (or takes an existing unit
  that is `in_stock` without a location) and puts it at the location.
* Issue reasons change the status in the same transaction: `shipment` → `delivered` (customer
  required), `scrap` → `scrapped`, `consumption` leaves it `in_stock` without a location until it is
  attached to a parent unit (which sets `built_in`, ADR 0011). Reversing restores `in_stock`.
* `engineering` refuses to change the status of, or attach, a unit that currently has a location
  (409, "issue it from stock"), so the two cannot disagree. Units that were registered before
  inventory existed have no location until they are received; they are not counted as stock.
* Counts do not cover serial products (every unit has its own record); a missing unit is issued
  with reason `scrap`.

### Reservations: `inventory.reservations`
* **Generic reference** (**decision**). A row holds stock for `(reference_type, reference_id)`:
  `sales_order_line` today, `production_component` for C1; the CHECK lists the allowed types and a new
  one widens it. There is no foreign key (the owning module checks that the reference exists and
  releases when it goes away): sales checks `sales.order_lines` and calls `release_for_order` on
  cancel, production will call `release_reference`.
* **Shape.** A row is the allocation of one reference and product to one `(location, lot)`:
  `quantity` is what is **still held** while the row is `active`, `consumed_quantity` what was already
  shipped or consumed from it, `status` is `active | released | consumed`, with `closed_at`,
  `closed_by` and `closed_move_id` (the last consuming move). A partial unique index allows **one
  active row per reference, product, location and lot**: more stock at the same place adds to the
  row. Other modules use `reservations::set_reserved(reference, product, quantity, pin)` (all or
  nothing, in their transaction); sales exposes
  `PUT /inventory/order-lines/{id}/reservation {quantity}`, which is idempotent: more allocates from
  available stock (optionally pinned to a warehouse, location or lot; otherwise FEFO, then location
  code, normal warehouses only), less releases the newest allocations first, `0` releases all.
* **Consuming** (**decision**). `NewMove.consume_reservation` (HTTP: `consume_reservation_line` on
  `/inventory/issues`) names the reservation a move ships or consumes. For such a move only that
  reservation's quantity at the source location and lot is exempt from the "reserved for orders" check,
  it may take **at most** what the reservation holds there (more is a 409 naming both quantities),
  and in the same transaction the row's `quantity` shrinks and `consumed_quantity` grows, or the row
  closes as `consumed` when nothing is left. The move gets the reservation as its reference. A reversal
  does **not** recreate the reservation (the stock is free again; reserve again if wanted). Delivery
  (B3) ships with `consume_reservation_line`; without it an issue still cannot touch reserved stock.
* Only lines of **confirmed** orders (status `confirmed` up to `ready_for_shipping`, the confirmed
  revision) of stocked products can be reserved, at most the line quantity (in the stock unit; an
  order line whose unit does not convert is a 422). Cancelling an order releases its reservations in
  the same transaction (`inventory::release_for_order`, called from `sales`). The order lifecycle
  states are unchanged.
* Reserved stock is protected: an issue or transfer cannot take stock that is reserved. Adjustments,
  counts can (physical reality wins); the line then shows a negative available quantity.

### Availability
For a product: `on_hand` = sum of balances in internal locations, `reserved` = active
reservations, `available = on_hand - reserved`. The same three numbers are given per location and
lot. **ATP on an order** counts warehouses of kind `warehouse` only (van stock belongs to the
technician) and is `GET /inventory/orders/{id}/availability`. Open purchase orders and production
orders are not included until B2 and C1 exist.

### Counts and adjustments: `inventory.counts`, `inventory.count_lines`
* A count (`CNT-2026-00001`, `core::numbering`) covers a warehouse or one location, optionally one
  product. Creating it snapshots the expected quantity per product, location and lot; users enter
  counted quantities (and may add lines for stock that was not expected). `status`:
  `counting → posted | cancelled`.
* **Posting** compares the counted quantity with the balance *at that moment* (movements during the
  count do not matter) and creates one adjustment move per difference against the `adjustment`
  virtual location, with reference to the count. Lines that were not counted are left alone.
* A single quick **adjustment** (`POST /inventory/adjustments`, a new quantity or a delta with a
  reason) creates the same kind of move.

### Transfers
A transfer is one move between two internal locations, instant and atomic. Van replenishment is a
transfer with reason `van_replenishment`. A two-step transfer with a transit location is deferred.

### Cost on moves
**Decision.** `stock_moves.unit_cost` is the cost per stock unit and `currency` its currency (both set
or both `NULL`). `NewMove.unit_cost`/`currency` let the posting module book the real cost (purchasing:
the price paid); when absent the move gets the product's standard cost in the currency of the company
(`NULL` when the product has none). A **reversal copies the cost and currency of the original** move
exactly, also when they are empty. The HTTP receipt accepts `unit_cost`/`currency` only with
`inventory.cost` (403 otherwise). Cost and currency are removed from every move in every response for
users without `inventory.cost`. Valuation (FIFO, average, landed cost) stays out of scope.

### Products and cost
`products.products` gains `standard_cost` (`numeric(18,4)`), `reorder_min`, `reorder_max`,
`lead_time_days` and `barcode` (unique when set). **Cost is hidden** (ADR 0004): `standard_cost`
and the `unit_cost` of moves are only returned, and only accepted, with the permission
`inventory.cost` (admin and product manager); everyone else gets `null`, and a product update
without it leaves the stored cost untouched. No margin is shown anywhere today; when one is added it
needs the same permission.

### Permissions
`inventory.read` (stock, moves, availability; sales, sales manager, support, product manager,
production, warehouse, viewer, admin), `inventory.write` (receive, issue, transfer, reserve, count;
production, warehouse, admin), `inventory.admin` (warehouses, locations, units, reversals, posting
counts and adjustments, rebuilding balances; admin) and `inventory.cost`. A new `warehouse` role is
added. Technicians get nothing yet (A3 decides how they use van stock). Every table has `company_id`
and every query filters on it; an id of another company is "not found".

## Details settled in the implementation
* A new warehouse or van gets one location (`MAIN`, for a van `VAN`) so it is usable at once.
* Order lines now carry their `id` in the order API; reservations are made against it.
* Posting a count and adjusting need `inventory.admin`, counting (entering quantities) only
  `inventory.write`. A date sent as a date-time (what the generated Dart client does) is accepted
  for expiry dates, as for other dates.
* The balance row of a location is locked before an issue or transfer checks the stock and the
  reservations, so two concurrent moves cannot both take the last unit.
* Moves are not audited one by one (the ledger is the record); configuration, reversals,
  adjustments, counts, reservation changes and balance rebuilds write `audit.events`.
* `sales` calls `inventory::release_for_order` when an order is cancelled; `inventory` reads the
  sales tables with SQL only, so the crate dependency points one way (sales to inventory).

## Consequences
* Availability is a cheap read of the balance table; history is complete and auditable
  (`audit.events` for configuration, the ledger itself for moves).
* Valuation is limited to the snapshot of the standard cost; FIFO/average costing, landed cost and
  the export to Exact are later work.

## Not yet
Purchasing receipts (B2) and delivery consumption (B3) will post moves with their own reasons and
references; production (C1) posts `production_output` and `consumption`. Deferred: two-step
transfers, putaway rules, bin capacity, quarantine locations, stock on open POs/MOs in ATP, returns
of delivered serial units, cycle-count scheduling, valuation, reorder proposals (MRP, C2).
