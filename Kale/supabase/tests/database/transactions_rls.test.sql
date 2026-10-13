-- RLS and shape of the reset transactions table (issue #5).
-- Run with `npx supabase test db` against the local stack (needs Docker).
BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap WITH SCHEMA extensions;

SELECT plan(17);

-- ── Fixtures ────────────────────────────────────────────────────────────────
-- Two users: Alice (permanent) and Bob (anonymous). Their sign-up trigger
-- seeds default categories, which needs categories keyed per user
-- (migration 20261013000001 from PR #25) for the second user to succeed.
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
SELECT col_type_is('public', 'transactions', 'amount_minor', 'bigint',
    'amounts are integer minor units');
SELECT hasnt_column('public', 'transactions', 'amount', 'no float amount');
SELECT hasnt_column('public', 'transactions', 'currency_code', 'no per-entry currency');
SELECT col_is_null('public', 'transactions', 'deleted_at', 'deleted_at is nullable');
SELECT has_index('public', 'transactions', 'idx_transactions_user_updated',
    ARRAY['user_id', 'updated_at'], 'index on (user_id, updated_at)');
SELECT col_type_is('public', 'profiles', 'base_currency', 'text',
    'the base currency is on the profile');

-- ── Alice writes her own transaction ────────────────────────────────────────
SELECT pg_temp.act_as('11111111-1111-1111-1111-111111111111');
SET LOCAL ROLE authenticated;

SELECT lives_ok($$
    INSERT INTO public.transactions (id, user_id, amount_minor, type, category_id, date, payment_method)
    VALUES ('aaaaaaaa-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111',
            1050, 'expense', 'cat_food', '2026-10-01', 'cash')
$$, 'a user can insert her own transaction');

SELECT throws_ok($$
    INSERT INTO public.transactions (id, user_id, amount_minor, type, category_id, date, payment_method)
    VALUES ('aaaaaaaa-0000-0000-0000-000000000002', '22222222-2222-2222-2222-222222222222',
            500, 'expense', 'cat_food', '2026-10-01', 'cash')
$$, '42501', NULL, 'a user cannot insert a transaction owned by someone else');

SELECT is((SELECT amount_minor FROM public.transactions), 1050::bigint,
    'the owner reads her transaction back, exactly');

-- ── Bob (anonymous) cannot touch Alice's rows ───────────────────────────────
RESET ROLE;
SELECT pg_temp.act_as('22222222-2222-2222-2222-222222222222', true);
SET LOCAL ROLE authenticated;

SELECT is((SELECT count(*) FROM public.transactions), 0::bigint,
    'another user cannot read the transaction');

SELECT is_empty($$
    UPDATE public.transactions SET amount_minor = 1
    WHERE id = 'aaaaaaaa-0000-0000-0000-000000000001' RETURNING id
$$, 'another user cannot update the transaction');

SELECT is_empty($$
    DELETE FROM public.transactions
    WHERE id = 'aaaaaaaa-0000-0000-0000-000000000001' RETURNING id
$$, 'another user cannot delete the transaction');

SELECT lives_ok($$
    INSERT INTO public.transactions (id, user_id, amount_minor, type, category_id, date, payment_method)
    VALUES ('bbbbbbbb-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222',
            700, 'income', 'cat_salary', '2026-10-02', 'mobileMoney')
$$, 'an anonymous user can write his own transaction');

SELECT throws_ok($$
    UPDATE public.transactions SET user_id = '11111111-1111-1111-1111-111111111111'
    WHERE id = 'bbbbbbbb-0000-0000-0000-000000000001'
$$, '42501', NULL, 'a user cannot hand a transaction over to someone else');

-- ── Not signed in ───────────────────────────────────────────────────────────
RESET ROLE;
SELECT set_config('request.jwt.claims', '{"role": "anon"}', true);
SET LOCAL ROLE anon;

SELECT throws_ok($$ SELECT count(*) FROM public.transactions $$, '42501', NULL,
    'the anon role cannot read transactions');

-- ── Alice still sees exactly her own row, untouched ─────────────────────────
RESET ROLE;
SELECT pg_temp.act_as('11111111-1111-1111-1111-111111111111');
SET LOCAL ROLE authenticated;

SELECT results_eq(
    $$ SELECT id::text, amount_minor FROM public.transactions $$,
    $$ VALUES ('aaaaaaaa-0000-0000-0000-000000000001', 1050::bigint) $$,
    'the owner sees only her row, unchanged by the other user'
);

SELECT throws_ok($$
    INSERT INTO public.transactions (id, user_id, amount_minor, type, category_id, date, payment_method)
    VALUES ('aaaaaaaa-0000-0000-0000-000000000003', '11111111-1111-1111-1111-111111111111',
            0, 'expense', 'cat_food', '2026-10-01', 'cash')
$$, '23514', NULL, 'amounts must be positive');

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
