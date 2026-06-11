-- Umrah Packages schema
-- Creates tables to manage packages, departures (per-date pricing), hotels, flights, and inclusions.
-- Idempotent: safe to run multiple times (uses IF NOT EXISTS checks where appropriate).

-- Ensure extension for UUIDs
create extension if not exists "uuid-ossp";

-- =====================================================
-- ENUMS
-- =====================================================

-- Package tier / type (allows adding more tiers in future)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'package_tier') THEN
    CREATE TYPE public.package_tier AS ENUM ('economy','premium','vip');
  ELSE
    BEGIN
      ALTER TYPE public.package_tier ADD VALUE 'economy';
    EXCEPTION WHEN duplicate_object THEN NULL; END;
    BEGIN
      ALTER TYPE public.package_tier ADD VALUE 'premium';
    EXCEPTION WHEN duplicate_object THEN NULL; END;
    BEGIN
      ALTER TYPE public.package_tier ADD VALUE 'vip';
    EXCEPTION WHEN duplicate_object THEN NULL; END;
  END IF;
END
$$ LANGUAGE plpgsql;

-- City enum for hotels (expandable)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'city_enum') THEN
    CREATE TYPE public.city_enum AS ENUM ('makkah','madinah','jeddah','other');
  ELSE
    BEGIN
      ALTER TYPE public.city_enum ADD VALUE 'makkah';
    EXCEPTION WHEN duplicate_object THEN NULL; END;
    BEGIN
      ALTER TYPE public.city_enum ADD VALUE 'madinah';
    EXCEPTION WHEN duplicate_object THEN NULL; END;
    BEGIN
      ALTER TYPE public.city_enum ADD VALUE 'jeddah';
    EXCEPTION WHEN duplicate_object THEN NULL; END;
    BEGIN
      ALTER TYPE public.city_enum ADD VALUE 'other';
    EXCEPTION WHEN duplicate_object THEN NULL; END;
  END IF;
END
$$ LANGUAGE plpgsql;

-- =====================================================
-- PACKAGES
-- =====================================================

CREATE TABLE IF NOT EXISTS public.packages (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text NOT NULL UNIQUE,
  tier public.package_tier NOT NULL DEFAULT 'economy',
  duration_days int NOT NULL,
  duration_text text,
  description text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- index for fast lookup by tier
CREATE INDEX IF NOT EXISTS idx_packages_tier ON public.packages(tier);

-- =====================================================
-- DEPARTURES (package available dates, with per-departure price)
-- =====================================================

CREATE TABLE IF NOT EXISTS public.package_departures (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  package_id uuid NOT NULL REFERENCES public.packages(id) ON DELETE CASCADE,
  departure_date date NOT NULL,
  price numeric(12,2) NOT NULL,
  currency varchar(8) DEFAULT 'USD',
  seats_available int,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(package_id, departure_date)
);

CREATE INDEX IF NOT EXISTS idx_package_departures_package ON public.package_departures(package_id);
CREATE INDEX IF NOT EXISTS idx_package_departures_date ON public.package_departures(departure_date);

-- =====================================================
-- HOTELS
-- =====================================================

CREATE TABLE IF NOT EXISTS public.hotels (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text NOT NULL,
  city public.city_enum NOT NULL,
  star_rating smallint, -- 1..5
  distance_from_haram numeric(8,2), -- e.g. kilometers or meters depending on your unit
  description text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(name, city)
);

CREATE INDEX IF NOT EXISTS idx_hotels_city ON public.hotels(city);

-- Junction table: which hotels are available for a package
CREATE TABLE IF NOT EXISTS public.package_hotels (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  package_id uuid NOT NULL REFERENCES public.packages(id) ON DELETE CASCADE,
  hotel_id uuid NOT NULL REFERENCES public.hotels(id) ON DELETE CASCADE,
  room_type text,
  hotel_price_modifier numeric(10,2), -- optional price modifier for this hotel relative to package base
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(package_id, hotel_id, room_type)
);

CREATE INDEX IF NOT EXISTS idx_package_hotels_package ON public.package_hotels(package_id);
CREATE INDEX IF NOT EXISTS idx_package_hotels_hotel ON public.package_hotels(hotel_id);

-- =====================================================
-- FLIGHTS
-- =====================================================

CREATE TABLE IF NOT EXISTS public.flights (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  airline_name text NOT NULL,
  flight_number text,
  departure_airport text NOT NULL,
  arrival_airport text NOT NULL,
  baggage_allowance text, -- free-text (e.g. "30kg checked + 7kg cabin")
  flight_details text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_flights_airline ON public.flights(airline_name);

-- Associate flights with a package departure (a departure may have one or more flight options)
CREATE TABLE IF NOT EXISTS public.departure_flights (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  departure_id uuid NOT NULL REFERENCES public.package_departures(id) ON DELETE CASCADE,
  flight_id uuid NOT NULL REFERENCES public.flights(id) ON DELETE CASCADE,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(departure_id, flight_id)
);

CREATE INDEX IF NOT EXISTS idx_departure_flights_departure ON public.departure_flights(departure_id);

-- =====================================================
-- INCLUSIONS / SERVICES
-- =====================================================

CREATE TABLE IF NOT EXISTS public.inclusions (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text NOT NULL UNIQUE,
  description text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Link inclusions to package (a package includes many services)
CREATE TABLE IF NOT EXISTS public.package_inclusions (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  package_id uuid NOT NULL REFERENCES public.packages(id) ON DELETE CASCADE,
  inclusion_id uuid NOT NULL REFERENCES public.inclusions(id) ON DELETE CASCADE,
  details text, -- additional details or limits for this package
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(package_id, inclusion_id)
);

CREATE INDEX IF NOT EXISTS idx_package_inclusions_package ON public.package_inclusions(package_id);

-- =====================================================
-- TRIGGERS: keep updated_at current on update
-- =====================================================
-- Reuse public.handle_updated_at() if exists. If not, create it.

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'handle_updated_at') THEN
    CREATE OR REPLACE FUNCTION public.handle_updated_at()
    RETURNS trigger
    LANGUAGE plpgsql
    AS $func$
    BEGIN
      NEW.updated_at = now();
      RETURN NEW;
    END;
    $func$;
  END IF;
END
$$ LANGUAGE plpgsql;

-- Attach triggers for tables
DROP TRIGGER IF EXISTS packages_updated_at ON public.packages;
CREATE TRIGGER packages_updated_at
BEFORE UPDATE ON public.packages
FOR EACH ROW
EXECUTE PROCEDURE public.handle_updated_at();

DROP TRIGGER IF EXISTS package_departures_updated_at ON public.package_departures;
CREATE TRIGGER package_departures_updated_at
BEFORE UPDATE ON public.package_departures
FOR EACH ROW
EXECUTE PROCEDURE public.handle_updated_at();

DROP TRIGGER IF EXISTS hotels_updated_at ON public.hotels;
CREATE TRIGGER hotels_updated_at
BEFORE UPDATE ON public.hotels
FOR EACH ROW
EXECUTE PROCEDURE public.handle_updated_at();

DROP TRIGGER IF EXISTS package_hotels_updated_at ON public.package_hotels;
CREATE TRIGGER package_hotels_updated_at
BEFORE UPDATE ON public.package_hotels
FOR EACH ROW
EXECUTE PROCEDURE public.handle_updated_at();

DROP TRIGGER IF EXISTS flights_updated_at ON public.flights;
CREATE TRIGGER flights_updated_at
BEFORE UPDATE ON public.flights
FOR EACH ROW
EXECUTE PROCEDURE public.handle_updated_at();

DROP TRIGGER IF EXISTS departure_flights_updated_at ON public.departure_flights;
CREATE TRIGGER departure_flights_updated_at
BEFORE UPDATE ON public.departure_flights
FOR EACH ROW
EXECUTE PROCEDURE public.handle_updated_at();

DROP TRIGGER IF EXISTS inclusions_updated_at ON public.inclusions;
CREATE TRIGGER inclusions_updated_at
BEFORE UPDATE ON public.inclusions
FOR EACH ROW
EXECUTE PROCEDURE public.handle_updated_at();

DROP TRIGGER IF EXISTS package_inclusions_updated_at ON public.package_inclusions;
CREATE TRIGGER package_inclusions_updated_at
BEFORE UPDATE ON public.package_inclusions
FOR EACH ROW
EXECUTE PROCEDURE public.handle_updated_at();

-- =====================================================
-- SAMPLE QUERIES / USAGE NOTES
-- =====================================================
-- Insert a package
-- INSERT INTO public.packages(name, tier, duration_days, duration_text, description)
-- VALUES ('Economy Umrah 10 Days', 'economy', 10, '10 Days', 'Basic Umrah package');

-- Add a departure with price
-- INSERT INTO public.package_departures(package_id, departure_date, price, currency, seats_available)
-- VALUES ('<package_uuid>', '2026-07-30', 499.00, 'USD', 30);

-- Link a hotel to a package
-- INSERT INTO public.package_hotels(package_id, hotel_id, room_type, hotel_price_modifier)
-- VALUES ('<package_uuid>','<hotel_uuid>','Standard', 0.00);

-- Add inclusion and link
-- INSERT INTO public.inclusions(name, description) VALUES ('Visa', 'Visa processing included');
-- INSERT INTO public.package_inclusions(package_id, inclusion_id, details) VALUES ('<package_uuid>','<inclusion_uuid>','Single-entry Visa');

-- Query: Get packages with upcoming departures and hotels
-- SELECT p.*, d.departure_date, d.price, array_agg(h.name) as hotels
-- FROM public.packages p
-- LEFT JOIN public.package_departures d ON d.package_id = p.id
-- LEFT JOIN public.package_hotels ph ON ph.package_id = p.id
-- LEFT JOIN public.hotels h ON h.id = ph.hotel_id
-- GROUP BY p.id, d.departure_date, d.price
-- ORDER BY d.departure_date;

-- End of file
