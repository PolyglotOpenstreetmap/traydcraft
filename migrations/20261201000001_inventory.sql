-- Inventory foundation (ADR 0019): warehouses and locations, units of measure, lots, the
-- immutable stock move ledger with its balance projection, reservations and counts.
CREATE SCHEMA IF NOT EXISTS inventory;

-- ---------------------------------------------------------------------------------------------
-- Product additions (master data, no company_id)
-- ---------------------------------------------------------------------------------------------
ALTER TABLE products.products
    ADD COLUMN standard_cost  numeric(18,4) CHECK (standard_cost >= 0),
    ADD COLUMN reorder_min    numeric(18,4) CHECK (reorder_min >= 0),
    ADD COLUMN reorder_max    numeric(18,4) CHECK (reorder_max >= 0),
    ADD COLUMN lead_time_days integer CHECK (lead_time_days >= 0),
    ADD COLUMN barcode        text CHECK (barcode IS NULL OR btrim(barcode) <> ''),
    ADD CONSTRAINT products_reorder_range CHECK (reorder_max IS NULL OR reorder_min IS NULL OR reorder_max >= reorder_min);
CREATE UNIQUE INDEX products_barcode_idx ON products.products (barcode) WHERE barcode IS NOT NULL;

ALTER TABLE products.products DROP CONSTRAINT IF EXISTS products_tracking_check;
ALTER TABLE products.products
    ADD CONSTRAINT products_tracking_check CHECK (tracking IN ('none', 'serial', 'lot'));

-- ---------------------------------------------------------------------------------------------
-- Units of measure
-- ---------------------------------------------------------------------------------------------
CREATE TABLE inventory.uoms (
    code      text PRIMARY KEY,
    name      text NOT NULL,
    category  text NOT NULL CHECK (category IN ('unit', 'weight', 'length', 'area', 'volume', 'time')),
    -- Size of this unit in the base unit of its category (kg = 1, g = 0.001). Only the measurable
    -- categories convert by factor; units of the category 'unit' (pieces, sets, boxes, every unit
    -- taken over from a product) convert only through inventory.product_uoms, so their factor is 1
    -- and means nothing.
    factor    numeric(24,12) NOT NULL CHECK (factor > 0),
    active    boolean NOT NULL DEFAULT true
);
INSERT INTO inventory.uoms (code, name, category, factor) VALUES
    ('pcs', 'Pieces', 'unit', 1),
    ('set', 'Set', 'unit', 1),
    ('kg', 'Kilogram', 'weight', 1),
    ('g', 'Gram', 'weight', 0.001),
    ('t', 'Tonne', 'weight', 1000),
    ('m', 'Metre', 'length', 1),
    ('cm', 'Centimetre', 'length', 0.01),
    ('mm', 'Millimetre', 'length', 0.001),
    ('km', 'Kilometre', 'length', 1000),
    ('m2', 'Square metre', 'area', 1),
    ('l', 'Litre', 'volume', 1),
    ('ml', 'Millilitre', 'volume', 0.001),
    ('m3', 'Cubic metre', 'volume', 1000),
    ('h', 'Hour', 'time', 1),
    ('min', 'Minute', 'time', 0.016666666667);
-- Units already used by products keep working (as their own base unit).
INSERT INTO inventory.uoms (code, name, category, factor)
SELECT DISTINCT unit, unit, 'unit', 1 FROM products.products ON CONFLICT (code) DO NOTHING;

-- Product-specific units: 1 <uom_code> = <factor> stock units (a box of 12 pieces: 12).
CREATE TABLE inventory.product_uoms (
    product_id  uuid NOT NULL REFERENCES products.products(id),
    uom_code    text NOT NULL REFERENCES inventory.uoms(code),
    factor      numeric(24,12) NOT NULL CHECK (factor > 0),
    PRIMARY KEY (product_id, uom_code)
);

-- ---------------------------------------------------------------------------------------------
-- Warehouses and locations
-- ---------------------------------------------------------------------------------------------
CREATE TABLE inventory.warehouses (
    id                uuid PRIMARY KEY,
    company_id        uuid NOT NULL REFERENCES core.companies(id),
    code              text NOT NULL CHECK (btrim(code) <> ''),
    name              text NOT NULL CHECK (btrim(name) <> ''),
    kind              text NOT NULL DEFAULT 'warehouse' CHECK (kind IN ('warehouse', 'van')),
    assigned_user_id  uuid REFERENCES core.users(id),
    active            boolean NOT NULL DEFAULT true,
    created_at        timestamptz NOT NULL DEFAULT now(),
    UNIQUE (company_id, code)
);

CREATE TABLE inventory.locations (
    id            uuid PRIMARY KEY,
    company_id    uuid NOT NULL REFERENCES core.companies(id),
    warehouse_id  uuid REFERENCES inventory.warehouses(id),
    code          text NOT NULL CHECK (btrim(code) <> ''),
    name          text NOT NULL DEFAULT '',
    -- internal: real stock. The others are virtual: the other side of receipts, issues, adjustments.
    kind          text NOT NULL DEFAULT 'internal'
                  CHECK (kind IN ('internal', 'supplier', 'customer', 'production', 'adjustment', 'scrap')),
    active        boolean NOT NULL DEFAULT true,
    created_at    timestamptz NOT NULL DEFAULT now(),
    CHECK ((kind = 'internal') = (warehouse_id IS NOT NULL)),
    UNIQUE (warehouse_id, code)
);
CREATE UNIQUE INDEX locations_virtual_idx ON inventory.locations (company_id, kind) WHERE warehouse_id IS NULL;
CREATE INDEX locations_company_idx ON inventory.locations (company_id, warehouse_id);

-- ---------------------------------------------------------------------------------------------
-- Lots
-- ---------------------------------------------------------------------------------------------
CREATE TABLE inventory.lots (
    id           uuid PRIMARY KEY,
    company_id   uuid NOT NULL REFERENCES core.companies(id),
    product_id   uuid NOT NULL REFERENCES products.products(id),
    lot_number   text NOT NULL CHECK (btrim(lot_number) <> ''),
    expiry_date  date,
    notes        text NOT NULL DEFAULT '',
    created_at   timestamptz NOT NULL DEFAULT now(),
    UNIQUE (company_id, product_id, lot_number)
);

-- ---------------------------------------------------------------------------------------------
-- The ledger. Rows are never updated or deleted; a correction is a reversal move.
-- ---------------------------------------------------------------------------------------------
CREATE TABLE inventory.stock_moves (
    id                uuid PRIMARY KEY,
    seq               bigint GENERATED ALWAYS AS IDENTITY,
    company_id        uuid NOT NULL REFERENCES core.companies(id),
    product_id        uuid NOT NULL REFERENCES products.products(id),
    quantity          numeric(18,4) NOT NULL CHECK (quantity > 0),
    from_location_id  uuid NOT NULL REFERENCES inventory.locations(id),
    to_location_id    uuid NOT NULL REFERENCES inventory.locations(id),
    lot_id            uuid REFERENCES inventory.lots(id),
    serial_unit_id    uuid REFERENCES engineering.serial_units(id),
    kind              text NOT NULL CHECK (kind IN ('receipt', 'issue', 'transfer', 'adjustment')),
    reason            text NOT NULL CHECK (btrim(reason) <> ''),
    reference_type    text,
    reference_id      uuid,
    note              text NOT NULL DEFAULT '',
    entered_quantity  numeric(18,4),
    entered_uom       text,
    unit_cost         numeric(18,4) CHECK (unit_cost >= 0),
    reversed_of       uuid UNIQUE REFERENCES inventory.stock_moves(id),
    occurred_at       timestamptz NOT NULL DEFAULT now(),
    created_by        uuid NOT NULL REFERENCES core.users(id),
    created_at        timestamptz NOT NULL DEFAULT now(),
    CHECK (from_location_id <> to_location_id),
    CHECK (serial_unit_id IS NULL OR quantity = 1)
);
CREATE UNIQUE INDEX stock_moves_seq_idx ON inventory.stock_moves (seq);
CREATE INDEX stock_moves_product_idx ON inventory.stock_moves (company_id, product_id, seq DESC);
CREATE INDEX stock_moves_from_idx ON inventory.stock_moves (from_location_id);
CREATE INDEX stock_moves_to_idx ON inventory.stock_moves (to_location_id);
CREATE INDEX stock_moves_serial_idx ON inventory.stock_moves (serial_unit_id, seq DESC) WHERE serial_unit_id IS NOT NULL;
CREATE INDEX stock_moves_reference_idx ON inventory.stock_moves (reference_type, reference_id);

CREATE FUNCTION inventory.refuse_ledger_change() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'inventory.stock_moves is append-only: post a reversal move instead'
        USING ERRCODE = 'restrict_violation';
END $$;
CREATE TRIGGER stock_moves_immutable BEFORE UPDATE OR DELETE ON inventory.stock_moves
    FOR EACH ROW EXECUTE FUNCTION inventory.refuse_ledger_change();
CREATE TRIGGER stock_moves_no_truncate BEFORE TRUNCATE ON inventory.stock_moves
    FOR EACH STATEMENT EXECUTE FUNCTION inventory.refuse_ledger_change();

-- Projection of the ledger, updated in the transaction of each move. Can be rebuilt.
CREATE TABLE inventory.stock_balances (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id      uuid NOT NULL REFERENCES core.companies(id),
    product_id      uuid NOT NULL REFERENCES products.products(id),
    location_id     uuid NOT NULL REFERENCES inventory.locations(id),
    lot_id          uuid REFERENCES inventory.lots(id),
    quantity        numeric(18,4) NOT NULL DEFAULT 0,
    allow_negative  boolean NOT NULL DEFAULT false,
    updated_at      timestamptz NOT NULL DEFAULT now(),
    CHECK (quantity >= 0 OR allow_negative)
);
CREATE UNIQUE INDEX stock_balances_key_idx ON inventory.stock_balances
    (company_id, product_id, location_id, (COALESCE(lot_id, '00000000-0000-0000-0000-000000000000'::uuid)));
CREATE INDEX stock_balances_location_idx ON inventory.stock_balances (location_id);

-- Where a serialised unit currently is (projection of its last move). Absent: not in stock.
CREATE TABLE inventory.serial_stock (
    serial_unit_id  uuid PRIMARY KEY REFERENCES engineering.serial_units(id),
    company_id      uuid NOT NULL REFERENCES core.companies(id),
    product_id      uuid NOT NULL REFERENCES products.products(id),
    location_id     uuid NOT NULL REFERENCES inventory.locations(id),
    since           timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX serial_stock_location_idx ON inventory.serial_stock (location_id);

-- Tracking and the stock unit cannot change once a product has moves.
CREATE FUNCTION inventory.guard_product_stock_setup() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF (NEW.tracking IS DISTINCT FROM OLD.tracking OR NEW.unit IS DISTINCT FROM OLD.unit)
       AND EXISTS (SELECT 1 FROM inventory.stock_moves WHERE product_id = OLD.id) THEN
        RAISE EXCEPTION 'tracking and unit of % cannot change: it has stock moves', OLD.code
            USING ERRCODE = 'check_violation';
    END IF;
    RETURN NEW;
END $$;
CREATE TRIGGER products_guard_stock_setup BEFORE UPDATE OF tracking, unit ON products.products
    FOR EACH ROW EXECUTE FUNCTION inventory.guard_product_stock_setup();

-- ---------------------------------------------------------------------------------------------
-- Reservations: one row is one allocation of an order line to a location and lot.
-- ---------------------------------------------------------------------------------------------
CREATE TABLE inventory.reservations (
    id             uuid PRIMARY KEY,
    company_id     uuid NOT NULL REFERENCES core.companies(id),
    order_line_id  uuid NOT NULL REFERENCES sales.order_lines(id),
    product_id     uuid NOT NULL REFERENCES products.products(id),
    location_id    uuid NOT NULL REFERENCES inventory.locations(id),
    lot_id         uuid REFERENCES inventory.lots(id),
    quantity       numeric(18,4) NOT NULL CHECK (quantity > 0),
    status         text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'released', 'consumed')),
    created_by     uuid REFERENCES core.users(id),
    created_at     timestamptz NOT NULL DEFAULT now(),
    closed_at      timestamptz,
    closed_by      uuid REFERENCES core.users(id),
    closed_move_id uuid REFERENCES inventory.stock_moves(id)
);
CREATE INDEX reservations_line_idx ON inventory.reservations (order_line_id) WHERE status = 'active';
CREATE INDEX reservations_stock_idx ON inventory.reservations (company_id, product_id, location_id) WHERE status = 'active';

-- ---------------------------------------------------------------------------------------------
-- Stock counts
-- ---------------------------------------------------------------------------------------------
CREATE TABLE inventory.counts (
    id            uuid PRIMARY KEY,
    company_id    uuid NOT NULL REFERENCES core.companies(id),
    number        text NOT NULL,
    warehouse_id  uuid NOT NULL REFERENCES inventory.warehouses(id),
    location_id   uuid REFERENCES inventory.locations(id),
    product_id    uuid REFERENCES products.products(id),
    status        text NOT NULL DEFAULT 'counting' CHECK (status IN ('counting', 'posted', 'cancelled')),
    note          text NOT NULL DEFAULT '',
    created_by    uuid NOT NULL REFERENCES core.users(id),
    created_at    timestamptz NOT NULL DEFAULT now(),
    closed_by     uuid REFERENCES core.users(id),
    closed_at     timestamptz,
    UNIQUE (company_id, number)
);

CREATE TABLE inventory.count_lines (
    id                  uuid PRIMARY KEY,
    company_id          uuid NOT NULL REFERENCES core.companies(id),
    count_id            uuid NOT NULL REFERENCES inventory.counts(id),
    product_id          uuid NOT NULL REFERENCES products.products(id),
    location_id         uuid NOT NULL REFERENCES inventory.locations(id),
    lot_id              uuid REFERENCES inventory.lots(id),
    expected_quantity   numeric(18,4) NOT NULL,
    counted_quantity    numeric(18,4) CHECK (counted_quantity >= 0),
    adjustment_move_id  uuid REFERENCES inventory.stock_moves(id)
);
CREATE UNIQUE INDEX count_lines_key_idx ON inventory.count_lines
    (count_id, product_id, location_id, (COALESCE(lot_id, '00000000-0000-0000-0000-000000000000'::uuid)));
