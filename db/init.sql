-- db/init.sql
-- Initial schema for autoservice backend

CREATE TABLE IF NOT EXISTS clients (
  id            BIGSERIAL PRIMARY KEY,
  email         TEXT NOT NULL UNIQUE,
  full_name     TEXT NOT NULL,
  phone         TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS cars (
  id            BIGSERIAL PRIMARY KEY,
  client_id     BIGINT NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  brand         TEXT,
  model         TEXT,
  plate_number  TEXT,
  vin           TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bookings (
  id            BIGSERIAL PRIMARY KEY,
  client_id     BIGINT NOT NULL REFERENCES clients(id) ON DELETE RESTRICT,
  car_id        BIGINT NOT NULL REFERENCES cars(id) ON DELETE RESTRICT,
  description   TEXT,
  status        TEXT NOT NULL DEFAULT 'new',
  scheduled_at  TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS work_orders (
  id            BIGSERIAL PRIMARY KEY,
  booking_id    BIGINT NOT NULL UNIQUE REFERENCES bookings(id) ON DELETE RESTRICT,
  client_id     BIGINT NOT NULL REFERENCES clients(id) ON DELETE RESTRICT,
  car_id        BIGINT NOT NULL REFERENCES cars(id) ON DELETE RESTRICT,
  description   TEXT,
  status        TEXT NOT NULL DEFAULT 'created',
  total_amount  NUMERIC(12,2) NOT NULL DEFAULT 0,
  paid_amount   NUMERIC(12,2) NOT NULL DEFAULT 0,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS work_items (
  id            BIGSERIAL PRIMARY KEY,
  work_order_id BIGINT NOT NULL REFERENCES work_orders(id) ON DELETE CASCADE,
  name          TEXT NOT NULL,
  qty           NUMERIC(12,2) NOT NULL DEFAULT 1,
  unit_price    NUMERIC(12,2) NOT NULL DEFAULT 0,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS material_items (
  id            BIGSERIAL PRIMARY KEY,
  work_order_id BIGINT NOT NULL REFERENCES work_orders(id) ON DELETE CASCADE,
  name          TEXT NOT NULL,
  qty           NUMERIC(12,2) NOT NULL DEFAULT 1,
  unit_price    NUMERIC(12,2) NOT NULL DEFAULT 0,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS payments (
  id            BIGSERIAL PRIMARY KEY,
  work_order_id BIGINT NOT NULL REFERENCES work_orders(id) ON DELETE CASCADE,
  amount        NUMERIC(12,2) NOT NULL,
  method        TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS audit_log (
  id            BIGSERIAL PRIMARY KEY,
  entity        TEXT NOT NULL,
  entity_id     BIGINT NOT NULL,
  action        TEXT NOT NULL,
  payload       JSONB,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_cars_client_id        ON cars(client_id);
CREATE INDEX IF NOT EXISTS idx_bookings_client_id    ON bookings(client_id);
CREATE INDEX IF NOT EXISTS idx_bookings_car_id       ON bookings(car_id);
CREATE INDEX IF NOT EXISTS idx_work_orders_client_id ON work_orders(client_id);
CREATE INDEX IF NOT EXISTS idx_work_orders_car_id    ON work_orders(car_id);
