-- Shape, ownership and absence of server-side derived values for the reset
-- savings tables (issue #7).
-- Run with `npx supabase test db` against the local stack (needs Docker).
BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap WITH SCHEMA extensions;

SELECT plan(25);

-- ── Fixtures ────────────────────────────────────────────────────────────────
-- Two users: Alice (permanent) and Bob (anonymous).
INSERT INTO auth.users (id, aud, role, email, is_anonymous)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'authenticated', 'authenticated', 'alice@example.com', false),
    ('22222222-2222-2222-2222-222222222222', 'authenticated', 'authenticated', NULL, true);

CREATE FUNCTION pg_temp.act_as(uid uuid, anonymous boolean DEFAULT false)
RETURNS void LANGUAGE sql AS $$
    SELECT set_config(
        'request.jwt.claims',
        json_build_object('sub', uid, 'role', 'authenticated', 'is_anonymous', anonymous)::text,
        true
    );
$$;

-- ── Shape ───────────────────────────────────────────────────────────────────
SELECT col_type_is('public', 'savings_goals', 'target_amount_minor', 'bigint',
    'goal targets are integer minor units');
SELECT col_type_is('public', 'savings_goals', 'current_amount_minor', 'bigint',
    'goal saved amounts are integer minor units');
SELECT hasnt_column('public', 'savings_goals', 'currency_code', 'no per-goal currency');
SELECT col_is_null('public', 'savings_goals', 'deleted_at', 'goal deleted_at is nullable');
SELECT col_type_is('public', 'savings_contributions', 'amount_minor', 'bigint',
    'contributions are integer minor units');
SELECT hasnt_column('public', 'savings_contributions', 'amount', 'no float contribution amount');
SELECT col_is_null('public', 'savings_contributions', 'deleted_at',
    'contribution deleted_at is nullable');
SELECT has_column('public', 'savings_contributions', 'updated_at',
    'contributions carry updated_at');
SELECT has_index('public', 'savings_goals', 'idx_savings_goals_user_updated',
    ARRAY['user_id', 'updated_at'], 'index on goals (user_id, updated_at)');

-- ── No server code writes a goal's saved amount ─────────────────────────────
SELECT hasnt_function('public', 'update_savings_goal_amount',
    'the function that added contributions to goals is dropped');
SELECT is_empty($$
    SELECT tgname FROM pg_trigger
    WHERE tgrelid IN ('public.savings_goals'::regclass,
                      'public.savings_contributions'::regclass)
      AND NOT tgisinternal
$$, 'no trigger on the savings tables');

-- ── Alice writes her own goal and a contribution ────────────────────────────
SELECT pg_temp.act_as('11111111-1111-1111-1111-111111111111');
SET LOCAL ROLE authenticated;

SELECT lives_ok($$
    INSERT INTO public.savings_goals (id, user_id, name, target_amount_minor)
    VALUES ('aaaaaaaa-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111',
            'Laptop', 300000)
$$, 'a user can create her own goal');

SELECT lives_ok($$
    INSERT INTO public.savings_contributions (id, goal_id, amount_minor, date)
    VALUES ('cccccccc-0000-0000-0000-000000000001', 'aaaaaaaa-0000-0000-0000-000000000001',
            2500, '2026-10-01')
$$, 'a user can add a contribution to her own goal');

SELECT is(
    (SELECT current_amount_minor FROM public.savings_goals
     WHERE id = 'aaaaaaaa-0000-0000-0000-000000000001'),
    0::bigint,
    'inserting a contribution leaves the goal amount as the device pushed it'
);

SELECT lives_ok($$
    UPDATE public.savings_goals SET current_amount_minor = 2500
    WHERE id = 'aaaaaaaa-0000-0000-0000-000000000001'
$$, 'the device pushes the derived amount as a goal update');

SELECT is(
    (SELECT current_amount_minor FROM public.savings_goals
     WHERE id = 'aaaaaaaa-0000-0000-0000-000000000001'),
    2500::bigint,
    'the goal amount is the sum of contributions, counted once'
);

-- ── Bob (anonymous) cannot reach Alice's contributions ──────────────────────
RESET ROLE;
SELECT pg_temp.act_as('22222222-2222-2222-2222-222222222222', true);
SET LOCAL ROLE authenticated;

SELECT is((SELECT count(*) FROM public.savings_contributions), 0::bigint,
    'another user cannot read contributions of a goal he does not own');

SELECT throws_ok($$
    INSERT INTO public.savings_contributions (id, goal_id, amount_minor, date)
    VALUES ('cccccccc-0000-0000-0000-000000000002', 'aaaaaaaa-0000-0000-0000-000000000001',
            100, '2026-10-02')
$$, '42501', NULL, 'another user cannot add a contribution to a goal he does not own');

SELECT is_empty($$
    UPDATE public.savings_contributions SET amount_minor = 1
    WHERE id = 'cccccccc-0000-0000-0000-000000000001' RETURNING id
$$, 'another user cannot update the contribution');

SELECT is_empty($$
    DELETE FROM public.savings_contributions
    WHERE id = 'cccccccc-0000-0000-0000-000000000001' RETURNING id
$$, 'another user cannot delete the contribution');

SELECT lives_ok($$
    INSERT INTO public.savings_goals (id, user_id, name, target_amount_minor)
    VALUES ('bbbbbbbb-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222',
            'Phone', 50000);
    INSERT INTO public.savings_contributions (id, goal_id, amount_minor, date)
    VALUES ('cccccccc-0000-0000-0000-000000000003', 'bbbbbbbb-0000-0000-0000-000000000001',
            700, '2026-10-02')
$$, 'an anonymous user can save toward his own goal');

SELECT throws_ok($$
    UPDATE public.savings_contributions
    SET goal_id = 'aaaaaaaa-0000-0000-0000-000000000001'
    WHERE id = 'cccccccc-0000-0000-0000-000000000003'
$$, '42501', NULL, 'a contribution cannot be moved to someone else''s goal');

-- ── Not signed in ───────────────────────────────────────────────────────────
RESET ROLE;
SELECT set_config('request.jwt.claims', '{"role": "anon"}', true);
SET LOCAL ROLE anon;

SELECT throws_ok($$ SELECT count(*) FROM public.savings_contributions $$, '42501', NULL,
    'the anon role cannot read contributions');

-- ── Alice still sees exactly her own contribution ───────────────────────────
RESET ROLE;
SELECT pg_temp.act_as('11111111-1111-1111-1111-111111111111');
SET LOCAL ROLE authenticated;

SELECT results_eq(
    $$ SELECT id::text, amount_minor FROM public.savings_contributions $$,
    $$ VALUES ('cccccccc-0000-0000-0000-000000000001', 2500::bigint) $$,
    'the owner sees only her contribution, unchanged by the other user'
);

SELECT throws_ok($$
    INSERT INTO public.savings_contributions (id, goal_id, amount_minor, date)
    VALUES ('cccccccc-0000-0000-0000-000000000004', 'aaaaaaaa-0000-0000-0000-000000000001',
            0, '2026-10-03')
$$, '23514', NULL, 'contributions must be positive');

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
