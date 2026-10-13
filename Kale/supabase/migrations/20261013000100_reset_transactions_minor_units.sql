-- ============================================================================
-- Base currency + minor-unit transactions (issue #5).
--
-- Schema RESET, not a migration (decision Q11: no external users exist).
-- The transactions table is dropped with its data and recreated:
--   * amounts are integer minor units of the account's base currency;
--   * no per-entry currency (decision Q4);
--   * client-owned updated_at (no trigger rewrites it, decision Q6) and a
--     nullable deleted_at soft-delete marker (decision Q17);
--   * an index on (user_id, updated_at) for paged restore (decision Q23);
--   * one RLS policy: a row is readable and writable only by its owner,
--     anonymous users included (they have the `authenticated` role).
-- The base currency lives on the profile, constrained by a currencies
-- reference table that mirrors `lib/core/money/currency.dart`.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- CURRENCIES (reference data, read-only for clients)
-- ---------------------------------------------------------------------------
CREATE TABLE public.currencies (
    code            TEXT PRIMARY KEY CHECK (code ~ '^[A-Z]{3}$'),
    symbol          TEXT NOT NULL,
    decimal_places  SMALLINT NOT NULL CHECK (decimal_places BETWEEN 0 AND 4)
);

INSERT INTO public.currencies (code, symbol, decimal_places) VALUES
    ('XOF', 'FCFA', 0),
    ('XAF', 'FCFA', 0),
    ('NGN', '₦',    2),
    ('GHS', 'GH₵',  2),
    ('KES', 'KSh',  2),
    ('UGX', 'USh',  0),
    ('TZS', 'TSh',  0),
    ('RWF', 'RF',   0),
    ('ZAR', 'R',    2),
    ('ETB', 'Br',   2),
    ('EGP', 'E£',   2),
    ('MAD', 'MAD',  2),
    ('USD', '$',    2),
    ('EUR', '€',    2);

ALTER TABLE public.currencies ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read currencies"
    ON public.currencies FOR SELECT
    TO anon, authenticated
    USING (true);

REVOKE INSERT, UPDATE, DELETE, TRUNCATE ON public.currencies FROM anon, authenticated;

-- ---------------------------------------------------------------------------
-- PROFILES: the base currency replaces preferred_currency.
-- NULL until the user picks it at onboarding.
-- ---------------------------------------------------------------------------
ALTER TABLE public.profiles DROP COLUMN preferred_currency;
ALTER TABLE public.profiles
    ADD COLUMN base_currency TEXT REFERENCES public.currencies(code);

-- ---------------------------------------------------------------------------
-- TRANSACTIONS (reset)
-- category_id has no foreign key: categories are keyed per user (see the
-- categories migration from #11/#25), and default categories are seeded on
-- the device and on the server independently.
-- ---------------------------------------------------------------------------
DROP TABLE IF EXISTS public.transactions CASCADE;

CREATE TABLE public.transactions (
    id                      UUID PRIMARY KEY,
    user_id                 UUID NOT NULL DEFAULT auth.uid()
                                REFERENCES auth.users(id) ON DELETE CASCADE,
    amount_minor            BIGINT NOT NULL CHECK (amount_minor > 0),
    type                    TEXT NOT NULL CHECK (type IN ('income', 'expense', 'transfer')),
    category_id             TEXT NOT NULL,
    description             TEXT,
    date                    TIMESTAMPTZ NOT NULL,
    payment_method          TEXT NOT NULL CHECK (
                                payment_method IN ('cash', 'mobileMoney', 'bank', 'card')
                            ),
    is_recurring            BOOLEAN NOT NULL DEFAULT FALSE,
    recurring_rule_id       TEXT,
    mobile_money_provider   TEXT,
    mobile_money_ref        TEXT,
    account_id              TEXT,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    -- Written by the client: the pull merge compares it (decision Q8), so
    -- no trigger may rewrite it.
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at              TIMESTAMPTZ
);

CREATE INDEX idx_transactions_user_updated ON public.transactions (user_id, updated_at);
CREATE INDEX idx_transactions_user_date    ON public.transactions (user_id, date DESC);

ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Owners can read and write their transactions"
    ON public.transactions FOR ALL
    TO authenticated
    USING ((SELECT auth.uid()) = user_id)
    WITH CHECK ((SELECT auth.uid()) = user_id);

REVOKE ALL ON public.transactions FROM anon;
