-- ============================================================================
-- Savings goals and contributions in minor units (issue #7).
--
-- Schema RESET, not a migration (decision Q11: no external users exist).
-- Both savings tables are dropped with their data and recreated:
--   * amounts are integer minor units of the account's base currency, with
--     no per-entry currency (decision Q4);
--   * client-owned updated_at (no trigger rewrites it, decision Q6) and a
--     nullable deleted_at soft-delete marker (decision Q17);
--   * indexes on (owner, updated_at) for paged restore (decision Q23);
--   * contributions are their own synced table, owned through their goal.
--
-- The trigger that added each contribution to its goal's saved amount
-- (on_savings_contribution_insert / update_savings_goal_amount) is DROPPED.
-- The device owns derived values: it computes a goal's current_amount_minor
-- from the goal's contributions and pushes it as a goal update. With the
-- trigger in place, every synced contribution would be counted twice.
-- ============================================================================

DROP TRIGGER IF EXISTS on_savings_contribution_insert ON public.savings_contributions;
DROP FUNCTION IF EXISTS public.update_savings_goal_amount();

DROP TABLE IF EXISTS public.savings_contributions CASCADE;
DROP TABLE IF EXISTS public.savings_goals CASCADE;

-- ---------------------------------------------------------------------------
-- SAVINGS GOALS
-- ---------------------------------------------------------------------------
CREATE TABLE public.savings_goals (
    id                      UUID PRIMARY KEY,
    user_id                 UUID NOT NULL DEFAULT auth.uid()
                                REFERENCES auth.users(id) ON DELETE CASCADE,
    name                    TEXT NOT NULL,
    target_amount_minor     BIGINT NOT NULL CHECK (target_amount_minor > 0),
    -- Derived on the device from the goal's contributions. No server code
    -- writes it.
    current_amount_minor    BIGINT NOT NULL DEFAULT 0 CHECK (current_amount_minor >= 0),
    description             TEXT,
    deadline                TIMESTAMPTZ,
    icon_name               TEXT,
    color_hex               TEXT,
    status                  TEXT NOT NULL DEFAULT 'active' CHECK (
                                status IN ('active', 'completed', 'paused', 'cancelled')
                            ),
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at              TIMESTAMPTZ
);

CREATE INDEX idx_savings_goals_user_updated ON public.savings_goals (user_id, updated_at);

ALTER TABLE public.savings_goals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Owners can read and write their savings goals"
    ON public.savings_goals FOR ALL
    TO authenticated
    USING ((SELECT auth.uid()) = user_id)
    WITH CHECK ((SELECT auth.uid()) = user_id);

REVOKE ALL ON public.savings_goals FROM anon;

-- ---------------------------------------------------------------------------
-- SAVINGS CONTRIBUTIONS (owned through their goal; no user_id of their own)
-- ---------------------------------------------------------------------------
CREATE TABLE public.savings_contributions (
    id              UUID PRIMARY KEY,
    goal_id         UUID NOT NULL
                        REFERENCES public.savings_goals(id) ON DELETE CASCADE,
    amount_minor    BIGINT NOT NULL CHECK (amount_minor > 0),
    source          TEXT NOT NULL DEFAULT 'manual' CHECK (
                        source IN ('manual', 'auto', 'roundup')
                    ),
    note            TEXT,
    date            TIMESTAMPTZ NOT NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ
);

CREATE INDEX idx_savings_contributions_goal_updated
    ON public.savings_contributions (goal_id, updated_at);

ALTER TABLE public.savings_contributions ENABLE ROW LEVEL SECURITY;

-- A contribution is readable and writable only through a goal the user
-- owns. The WITH CHECK also stops moving a contribution to someone else's
-- goal.
CREATE POLICY "Owners of the goal can read and write its contributions"
    ON public.savings_contributions FOR ALL
    TO authenticated
    USING (EXISTS (
        SELECT 1 FROM public.savings_goals g
        WHERE g.id = savings_contributions.goal_id
          AND g.user_id = (SELECT auth.uid())
    ))
    WITH CHECK (EXISTS (
        SELECT 1 FROM public.savings_goals g
        WHERE g.id = savings_contributions.goal_id
          AND g.user_id = (SELECT auth.uid())
    ));

REVOKE ALL ON public.savings_contributions FROM anon;
