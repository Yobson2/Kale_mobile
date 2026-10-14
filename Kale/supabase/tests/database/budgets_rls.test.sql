-- RLS and shape of the reset budgets and budget_category_allocations
-- tables (issue #6). Run with `npx supabase test db` against the local
-- stack (needs Docker).
BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap WITH SCHEMA extensions;

SELECT plan(29);

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
SELECT col_type_is('public', 'budgets', 'start_date', 'date',
    'a period starts on a date, with no time');
SELECT col_type_is('public', 'budgets', 'end_date', 'date',
    'a period ends on a date, with no time');
SELECT col_type_is('public', 'budgets', 'period_start_day', 'smallint',
    'the period start day is stored');
SELECT col_default_is('public', 'budgets', 'period_start_day', '1',
    'the start day defaults to the calendar month');
SELECT col_type_is('public', 'budgets', 'total_income_minor', 'bigint',
    'income is integer minor units');
SELECT hasnt_column('public', 'budgets', 'total_income', 'no float income');
SELECT col_type_is('public', 'budget_category_allocations', 'allocated_minor', 'bigint',
    'allocations are integer minor units');
SELECT hasnt_column('public', 'budget_category_allocations', 'allocated_amount',
    'no float allocation');
SELECT col_is_null('public', 'budgets', 'deleted_at', 'budgets have a nullable deleted_at');
SELECT col_is_null('public', 'budget_category_allocations', 'deleted_at',
    'allocations have a nullable deleted_at');
SELECT has_index('public', 'budgets', 'idx_budgets_user_updated',
    ARRAY['user_id', 'updated_at'], 'index on (user_id, updated_at)');
SELECT is_empty($$
    SELECT tgname FROM pg_trigger
    WHERE NOT tgisinternal
      AND tgrelid IN ('public.budgets'::regclass, 'public.budget_category_allocations'::regclass)
$$, 'no trigger rewrites client-owned columns');

-- ── Alice writes her own budget and allocation ──────────────────────────────
SELECT pg_temp.act_as('11111111-1111-1111-1111-111111111111');
SET LOCAL ROLE authenticated;

SELECT lives_ok($$
    INSERT INTO public.budgets (id, user_id, name, strategy, period, start_date, end_date, total_income_minor)
    VALUES ('aaaaaaaa-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111',
            'October', 'custom', 'monthly', '2026-10-01', '2026-10-31', 250000)
$$, 'a user can insert her own budget');

SELECT lives_ok($$
    INSERT INTO public.budget_category_allocations (id, budget_id, category_id, group_name, allocated_minor)
    VALUES ('aaaaaaaa-1111-0000-0000-000000000001', 'aaaaaaaa-0000-0000-0000-000000000001',
            'cat_food', 'Needs', 50000)
$$, 'a user can allocate within her own budget');

SELECT lives_ok($$
    INSERT INTO public.budget_category_allocations (id, budget_id, category_id, group_name, allocated_minor)
    VALUES ('aaaaaaaa-1111-0000-0000-000000000001', 'aaaaaaaa-0000-0000-0000-000000000001',
            'cat_food', 'Needs', 50000)
    ON CONFLICT (id) DO UPDATE SET allocated_minor = EXCLUDED.allocated_minor
$$, 're-sending an allocation (a sync retry) is a harmless upsert');

SELECT throws_ok($$
    INSERT INTO public.budgets (id, user_id, name, strategy, period, start_date, end_date)
    VALUES ('aaaaaaaa-0000-0000-0000-000000000002', '22222222-2222-2222-2222-222222222222',
            'Not mine', 'custom', 'monthly', '2026-10-01', '2026-10-31')
$$, '42501', NULL, 'a user cannot insert a budget owned by someone else');

SELECT results_eq(
    $$ SELECT start_date::text, end_date::text, period_start_day, total_income_minor
       FROM public.budgets $$,
    $$ VALUES ('2026-10-01', '2026-10-31', 1::smallint, 250000::bigint) $$,
    'the owner reads her budget back: plain dates, default start day, exact amount'
);

-- ── Bob (anonymous) cannot touch Alice's rows ───────────────────────────────
RESET ROLE;
SELECT pg_temp.act_as('22222222-2222-2222-2222-222222222222', true);
SET LOCAL ROLE authenticated;

SELECT is((SELECT count(*) FROM public.budgets), 0::bigint,
    'another user cannot read the budget');
SELECT is((SELECT count(*) FROM public.budget_category_allocations), 0::bigint,
    'another user cannot read its allocations');

SELECT is_empty($$
    UPDATE public.budget_category_allocations SET allocated_minor = 1
    WHERE id = 'aaaaaaaa-1111-0000-0000-000000000001' RETURNING id
$$, 'another user cannot update an allocation');

SELECT is_empty($$
    DELETE FROM public.budget_category_allocations
    WHERE id = 'aaaaaaaa-1111-0000-0000-000000000001' RETURNING id
$$, 'another user cannot delete an allocation');

SELECT throws_ok($$
    INSERT INTO public.budget_category_allocations (id, budget_id, category_id, group_name, allocated_minor)
    VALUES ('bbbbbbbb-1111-0000-0000-000000000001', 'aaaaaaaa-0000-0000-0000-000000000001',
            'cat_food', 'Needs', 1)
$$, '42501', NULL, 'a user cannot add an allocation to someone else''s budget');

SELECT lives_ok($$
    INSERT INTO public.budgets (id, user_id, name, strategy, period, start_date, end_date, period_start_day)
    VALUES ('bbbbbbbb-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222',
            'Payday', 'custom', 'monthly', '2026-09-25', '2026-10-24', 25)
$$, 'an anonymous user can write his own budget, with a start day');

SELECT lives_ok($$
    INSERT INTO public.budget_category_allocations (id, budget_id, category_id, group_name, allocated_minor)
    VALUES ('bbbbbbbb-1111-0000-0000-000000000002', 'bbbbbbbb-0000-0000-0000-000000000001',
            'cat_rent', 'Needs', 700)
$$, 'an anonymous user can allocate within his own budget');

SELECT throws_ok($$
    INSERT INTO public.budget_category_allocations (id, budget_id, category_id, group_name, allocated_minor)
    VALUES ('aaaaaaaa-1111-0000-0000-000000000001', 'bbbbbbbb-0000-0000-0000-000000000001',
            'cat_food', 'Needs', 1)
    ON CONFLICT (id) DO UPDATE SET allocated_minor = EXCLUDED.allocated_minor
$$, '42501', NULL, 'a user cannot take over someone else''s allocation by upserting its id');

SELECT throws_ok($$
    UPDATE public.budget_category_allocations
    SET budget_id = 'aaaaaaaa-0000-0000-0000-000000000001'
    WHERE id = 'bbbbbbbb-1111-0000-0000-000000000002'
$$, '42501', NULL, 'a user cannot move an allocation into someone else''s budget');

-- ── Not signed in ───────────────────────────────────────────────────────────
RESET ROLE;
SELECT set_config('request.jwt.claims', '{"role": "anon"}', true);
SET LOCAL ROLE anon;

SELECT throws_ok($$ SELECT count(*) FROM public.budget_category_allocations $$, '42501', NULL,
    'the anon role cannot read allocations');

-- ── Alice still sees exactly her own rows, untouched ────────────────────────
RESET ROLE;
SELECT pg_temp.act_as('11111111-1111-1111-1111-111111111111');
SET LOCAL ROLE authenticated;

SELECT results_eq(
    $$ SELECT id::text, allocated_minor FROM public.budget_category_allocations $$,
    $$ VALUES ('aaaaaaaa-1111-0000-0000-000000000001', 50000::bigint) $$,
    'the owner sees only her allocation, unchanged by the other user'
);

SELECT throws_ok($$
    INSERT INTO public.budgets (id, user_id, name, strategy, period, start_date, end_date)
    VALUES ('aaaaaaaa-0000-0000-0000-000000000003', '11111111-1111-1111-1111-111111111111',
            'Backwards', 'custom', 'monthly', '2026-10-31', '2026-10-01')
$$, '23514', NULL, 'a period cannot end before it starts');

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
