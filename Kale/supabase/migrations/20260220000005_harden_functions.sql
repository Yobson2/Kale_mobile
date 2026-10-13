-- ============================================================================
-- Harden the functions created by migrations 1, 2 and 4.
--
-- 1. Authorization: seed_default_categories(p_user_id) is SECURITY DEFINER
--    and, by Postgres default, executable by PUBLIC. PostgREST exposes it as
--    /rest/v1/rpc/seed_default_categories, so any client (even anon) could
--    insert rows owned by another user, bypassing RLS. Only the
--    handle_new_user trigger needs to call it. Revoke EXECUTE from client
--    roles on every function that is not meant to be called over the API.
--    (Trigger functions don't need EXECUTE at fire time; it is checked only
--    when the trigger is created.)
-- 2. Every function gets a pinned, empty search_path so a SECURITY DEFINER
--    body can't be hijacked through objects in another schema. All bodies
--    already schema-qualify their tables.
-- 3. Denial of service / privilege: update_savings_goal_amount ran two
--    UPDATEs per contribution as SECURITY DEFINER (bypassing RLS). It now
--    runs one primary-key UPDATE as the invoking user, so RLS on
--    savings_goals applies. The trigger itself is dropped by the schema
--    reset (decision Q6); this only closes the gap until then.
-- ============================================================================

ALTER FUNCTION public.update_updated_at_column() SET search_path = '';
ALTER FUNCTION public.handle_new_user() SET search_path = '';
ALTER FUNCTION public.seed_default_categories(UUID) SET search_path = '';

CREATE OR REPLACE FUNCTION public.update_savings_goal_amount()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
BEGIN
    UPDATE public.savings_goals
    SET current_amount = current_amount + NEW.amount,
        status = CASE
            WHEN status = 'active' AND current_amount + NEW.amount >= target_amount
                THEN 'completed'
            ELSE status
        END
    WHERE id = NEW.goal_id;

    RETURN NEW;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.seed_default_categories(UUID)
    FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.handle_new_user()
    FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.update_savings_goal_amount()
    FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.update_updated_at_column()
    FROM PUBLIC, anon, authenticated;
