-- ============================================================================
-- Pull cursor: a server-stamped change time on every synced table (issue #10).
--
-- Devices pull changes in pages, keyset-ordered on (server_updated_at, id),
-- from a per-table watermark (decisions Q8, Q23). The watermark can't be
-- `updated_at`: that column is written by the client (decision Q6) and the
-- pull merge compares it, so a device with a slow clock would write rows
-- "in the past" and other devices' watermarks would skip them.
--
-- `server_updated_at` is stamped by the server on every insert and update,
-- whatever the client sends. Clients only read it, as the pull cursor. It is
-- not money or user data, so the "no trigger computes a value the client
-- writes" rule (Q6) holds.
-- ============================================================================

CREATE OR REPLACE FUNCTION public.stamp_server_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
BEGIN
    NEW.server_updated_at := clock_timestamp();
    RETURN NEW;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.stamp_server_updated_at() FROM PUBLIC, anon, authenticated;

-- ── transactions ────────────────────────────────────────────────────────────
ALTER TABLE public.transactions
    ADD COLUMN server_updated_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp();
CREATE TRIGGER stamp_transactions_server_updated_at
    BEFORE INSERT OR UPDATE ON public.transactions
    FOR EACH ROW EXECUTE FUNCTION public.stamp_server_updated_at();
CREATE INDEX idx_transactions_user_pull
    ON public.transactions (user_id, server_updated_at, id);

-- ── budgets ─────────────────────────────────────────────────────────────────
ALTER TABLE public.budgets
    ADD COLUMN server_updated_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp();
CREATE TRIGGER stamp_budgets_server_updated_at
    BEFORE INSERT OR UPDATE ON public.budgets
    FOR EACH ROW EXECUTE FUNCTION public.stamp_server_updated_at();
CREATE INDEX idx_budgets_user_pull
    ON public.budgets (user_id, server_updated_at, id);

-- ── budget_category_allocations (owned through the budget; RLS scopes) ──────
ALTER TABLE public.budget_category_allocations
    ADD COLUMN server_updated_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp();
CREATE TRIGGER stamp_budget_allocations_server_updated_at
    BEFORE INSERT OR UPDATE ON public.budget_category_allocations
    FOR EACH ROW EXECUTE FUNCTION public.stamp_server_updated_at();
CREATE INDEX idx_budget_alloc_pull
    ON public.budget_category_allocations (server_updated_at, id);

-- ── savings_goals ───────────────────────────────────────────────────────────
ALTER TABLE public.savings_goals
    ADD COLUMN server_updated_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp();
CREATE TRIGGER stamp_savings_goals_server_updated_at
    BEFORE INSERT OR UPDATE ON public.savings_goals
    FOR EACH ROW EXECUTE FUNCTION public.stamp_server_updated_at();
CREATE INDEX idx_savings_goals_user_pull
    ON public.savings_goals (user_id, server_updated_at, id);

-- ── savings_contributions (owned through the goal; RLS scopes) ──────────────
ALTER TABLE public.savings_contributions
    ADD COLUMN server_updated_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp();
CREATE TRIGGER stamp_savings_contributions_server_updated_at
    BEFORE INSERT OR UPDATE ON public.savings_contributions
    FOR EACH ROW EXECUTE FUNCTION public.stamp_server_updated_at();
CREATE INDEX idx_savings_contributions_pull
    ON public.savings_contributions (server_updated_at, id);
