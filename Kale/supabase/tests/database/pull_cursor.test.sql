-- The server-stamped pull cursor (issue #10).
-- Run with `npx supabase test db` against the local stack (needs Docker).
BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap WITH SCHEMA extensions;

SELECT plan(12);

INSERT INTO auth.users (id, aud, role, email, is_anonymous)
VALUES ('11111111-1111-1111-1111-111111111111', 'authenticated', 'authenticated', 'alice@example.com', false);

CREATE FUNCTION pg_temp.act_as(uid uuid)
RETURNS void LANGUAGE sql AS $$
    SELECT set_config(
        'request.jwt.claims',
        json_build_object('sub', uid, 'role', 'authenticated')::text,
        true
    );
$$;

-- ── Shape ───────────────────────────────────────────────────────────────────
SELECT col_not_null('public', 'transactions', 'server_updated_at', 'transactions have a cursor');
SELECT col_not_null('public', 'budgets', 'server_updated_at', 'budgets have a cursor');
SELECT col_not_null('public', 'budget_category_allocations', 'server_updated_at', 'allocations have a cursor');
SELECT col_not_null('public', 'savings_goals', 'server_updated_at', 'goals have a cursor');
SELECT col_not_null('public', 'savings_contributions', 'server_updated_at', 'contributions have a cursor');
SELECT has_index('public', 'transactions', 'idx_transactions_user_pull',
    ARRAY['user_id', 'server_updated_at', 'id'], 'transactions are paged by (user_id, cursor, id)');

-- ── The server stamps it, whatever the client sends ─────────────────────────
SELECT pg_temp.act_as('11111111-1111-1111-1111-111111111111');
SET LOCAL ROLE authenticated;

INSERT INTO public.transactions
    (id, user_id, amount_minor, type, category_id, date, payment_method, updated_at, server_updated_at)
VALUES ('aaaaaaaa-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111',
        1050, 'expense', 'cat_food', '2026-10-01', 'cash',
        '2001-01-01T00:00:00Z', '2001-01-01T00:00:00Z');

SELECT ok(
    (SELECT server_updated_at > now() - interval '1 minute' FROM public.transactions),
    'an insert is stamped with the server time, not the client value'
);
SELECT is(
    (SELECT updated_at FROM public.transactions),
    '2001-01-01T00:00:00Z'::timestamptz,
    'updated_at stays what the client wrote'
);

CREATE TEMP TABLE before_update AS SELECT server_updated_at AS at FROM public.transactions;
GRANT SELECT ON before_update TO authenticated;

UPDATE public.transactions
SET amount_minor = 2000, server_updated_at = '2001-01-01T00:00:00Z'
WHERE id = 'aaaaaaaa-0000-0000-0000-000000000001';

SELECT ok(
    (SELECT t.server_updated_at > b.at FROM public.transactions t, before_update b),
    'an update moves the cursor forward, whatever the client sends'
);

-- ── Child tables are stamped too ────────────────────────────────────────────
INSERT INTO public.savings_goals (id, user_id, name, target_amount_minor)
VALUES ('bbbbbbbb-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'Fund', 1000);
INSERT INTO public.savings_contributions (id, goal_id, amount_minor, date, server_updated_at)
VALUES ('cccccccc-0000-0000-0000-000000000001', 'bbbbbbbb-0000-0000-0000-000000000001', 100, '2026-10-01',
        '2001-01-01T00:00:00Z');

SELECT ok(
    (SELECT server_updated_at > now() - interval '1 minute' FROM public.savings_contributions),
    'a contribution is stamped by the server'
);

-- ── A keyset page after the cursor ──────────────────────────────────────────
INSERT INTO public.transactions (id, user_id, amount_minor, type, category_id, date, payment_method)
VALUES ('aaaaaaaa-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111',
        300, 'expense', 'cat_food', '2026-10-02', 'cash');

SELECT is(
    (SELECT array_agg(id ORDER BY server_updated_at, id) FROM public.transactions),
    ARRAY['aaaaaaaa-0000-0000-0000-000000000001', 'aaaaaaaa-0000-0000-0000-000000000002']::uuid[],
    'rows come back in write order'
);
SELECT is(
    (SELECT array_agg(t.id) FROM public.transactions t, public.transactions c
     WHERE c.id = 'aaaaaaaa-0000-0000-0000-000000000001'
       AND (t.server_updated_at, t.id) > (c.server_updated_at, c.id)),
    ARRAY['aaaaaaaa-0000-0000-0000-000000000002']::uuid[],
    'a page after the first row holds only the later row'
);

SELECT * FROM finish();
ROLLBACK;
