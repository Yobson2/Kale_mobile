-- ============================================================================
-- Budgets: minor units, date periods, start day (issue #6).
--
-- Schema RESET, not a migration (decision Q11: no external users exist).
-- The budgets and budget_category_allocations tables are dropped with their
-- data and recreated:
--   * amounts are integer minor units of the account's base currency
--     (decision Q4; the currency lives on the profile, see issue #5);
--   * a budget period is two calendar DATEs, both included, plus the
--     period start day (decision Q21): no time component, so no time zone
--     can shift the days a budget covers;
--   * client-generated UUID keys, client-owned updated_at (no trigger
--     rewrites it, decision Q6) and a nullable deleted_at soft-delete
--     marker (decision Q17);
--   * an index on (user_id, updated_at) for paged restore (decision Q23);
--   * RLS: a budget is readable and writable only by its owner, anonymous
--     users included (they have the `authenticated` role); an allocation
--     is owned through its budget.
-- ============================================================================

DROP TABLE IF EXISTS public.budget_category_allocations CASCADE;
DROP TABLE IF EXISTS public.budgets CASCADE;

-- ---------------------------------------------------------------------------
-- BUDGETS
-- ---------------------------------------------------------------------------
CREATE TABLE public.budgets (
    id                  UUID PRIMARY KEY,
    user_id             UUID NOT NULL DEFAULT auth.uid()
                            REFERENCES auth.users(id) ON DELETE CASCADE,
    name                TEXT NOT NULL,
    strategy            TEXT NOT NULL CHECK (
                            strategy IN ('fiftyThirtyTwenty', 'eightyTwenty', 'envelope', 'custom')
                        ),
    period              TEXT NOT NULL CHECK (
                            period IN ('weekly', 'biWeekly', 'monthly')
                        ),
    -- First and last day covered, both included.
    start_date          DATE NOT NULL,
    end_date            DATE NOT NULL,
    -- Day of the month (monthly) or ISO weekday (weekly) periods start on.
    -- 1 = calendar months / weeks starting on Monday.
    period_start_day    SMALLINT NOT NULL DEFAULT 1 CHECK (period_start_day BETWEEN 1 AND 31),
    total_income_minor  BIGINT CHECK (total_income_minor >= 0),
    is_percentage_based BOOLEAN NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    -- Written by the client: the pull merge compares it (decision Q8), so
    -- no trigger may rewrite it.
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    CONSTRAINT budgets_period_order CHECK (end_date >= start_date)
);

CREATE INDEX idx_budgets_user_updated ON public.budgets (user_id, updated_at);
CREATE INDEX idx_budgets_user_dates   ON public.budgets (user_id, start_date, end_date);

ALTER TABLE public.budgets ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Owners can read and write their budgets"
    ON public.budgets FOR ALL
    TO authenticated
    USING ((SELECT auth.uid()) = user_id)
    WITH CHECK ((SELECT auth.uid()) = user_id);

REVOKE ALL ON public.budgets FROM anon;

-- ---------------------------------------------------------------------------
-- BUDGET CATEGORY ALLOCATIONS (owned through their budget)
-- category_id has no foreign key: categories are keyed per user and seeded
-- on the device and on the server independently (see the transactions
-- reset).
-- ---------------------------------------------------------------------------
CREATE TABLE public.budget_category_allocations (
    id                    UUID PRIMARY KEY,
    budget_id             UUID NOT NULL REFERENCES public.budgets(id) ON DELETE CASCADE,
    category_id           TEXT NOT NULL,
    group_name            TEXT NOT NULL,
    allocated_minor       BIGINT NOT NULL DEFAULT 0 CHECK (allocated_minor >= 0),
    -- A share of income, not money.
    allocated_percentage  DOUBLE PRECISION CHECK (allocated_percentage BETWEEN 0 AND 100),
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at            TIMESTAMPTZ
);

-- Allocations have no user_id: restore pages them through their budget.
CREATE INDEX idx_budget_alloc_budget_updated
    ON public.budget_category_allocations (budget_id, updated_at);

ALTER TABLE public.budget_category_allocations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Owners of the budget can read and write its allocations"
    ON public.budget_category_allocations FOR ALL
    TO authenticated
    USING (EXISTS (
        SELECT 1 FROM public.budgets b
        WHERE b.id = budget_category_allocations.budget_id
          AND b.user_id = (SELECT auth.uid())
    ))
    WITH CHECK (EXISTS (
        SELECT 1 FROM public.budgets b
        WHERE b.id = budget_category_allocations.budget_id
          AND b.user_id = (SELECT auth.uid())
    ));

REVOKE ALL ON public.budget_category_allocations FROM anon;
