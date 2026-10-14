-- ============================================================================
-- Server maintenance jobs (issue #14).
--
-- 1. Tombstone purge (decision Q17): a deleted row keeps its `deleted_at`
--    marker so every device learns about the deletion on its next pull.
--    Markers older than 30 days are purged. The window must exceed any
--    expected offline period: a device that last pulled more than 30 days
--    ago never sees the deletion, so it keeps the row (see
--    docs/offline_sync.md, "Deletes").
-- 2. Anonymous cleanup (decisions Q3, Q10): anonymous users inactive for 90
--    days are deleted with all their data. Activity is the latest of the
--    account's creation, its last sign-in and its last session refresh
--    (the app refreshes its session whenever it is opened online).
--    Deleting the auth user cascades to every row it owns: profile,
--    categories, transactions, budgets (and their allocations), savings
--    goals (and their contributions).
--
-- Both are plain functions, scheduled daily with pg_cron. They are not
-- callable over the API: EXECUTE is revoked from client roles.
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA pg_catalog;

-- ── 1. Tombstone purge ──────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.purge_tombstones(
    older_than INTERVAL DEFAULT INTERVAL '30 days'
)
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
    cutoff TIMESTAMPTZ := now() - older_than;
    purged BIGINT := 0;
    n BIGINT;
BEGIN
    -- Children first, so the count is per row actually purged; a purged
    -- parent would cascade to them anyway.
    DELETE FROM public.savings_contributions WHERE deleted_at < cutoff;
    GET DIAGNOSTICS n = ROW_COUNT; purged := purged + n;
    DELETE FROM public.budget_category_allocations WHERE deleted_at < cutoff;
    GET DIAGNOSTICS n = ROW_COUNT; purged := purged + n;
    DELETE FROM public.savings_goals WHERE deleted_at < cutoff;
    GET DIAGNOSTICS n = ROW_COUNT; purged := purged + n;
    DELETE FROM public.budgets WHERE deleted_at < cutoff;
    GET DIAGNOSTICS n = ROW_COUNT; purged := purged + n;
    DELETE FROM public.transactions WHERE deleted_at < cutoff;
    GET DIAGNOSTICS n = ROW_COUNT; purged := purged + n;
    RETURN purged;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.purge_tombstones(INTERVAL) FROM PUBLIC, anon, authenticated;

-- ── 2. Inactive anonymous users ─────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.delete_inactive_anonymous_users(
    inactive_for INTERVAL DEFAULT INTERVAL '90 days'
)
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
    deleted BIGINT;
BEGIN
    DELETE FROM auth.users u
    WHERE u.is_anonymous
      AND greatest(
            u.created_at,
            u.last_sign_in_at,
            (SELECT max(greatest(s.updated_at, s.refreshed_at))
             FROM auth.sessions s
             WHERE s.user_id = u.id)
          ) < now() - inactive_for;
    GET DIAGNOSTICS deleted = ROW_COUNT;
    RETURN deleted;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.delete_inactive_anonymous_users(INTERVAL) FROM PUBLIC, anon, authenticated;

-- ── Schedules (daily, off-peak UTC) ─────────────────────────────────────────
-- cron.schedule replaces a job with the same name, so re-running is safe.
SELECT cron.schedule(
    'purge-tombstones',
    '17 3 * * *',
    $$SELECT public.purge_tombstones()$$
);
SELECT cron.schedule(
    'delete-inactive-anonymous-users',
    '47 3 * * *',
    $$SELECT public.delete_inactive_anonymous_users()$$
);
