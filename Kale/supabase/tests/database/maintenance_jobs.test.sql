-- Server maintenance jobs (issue #14).
-- Run with `npx supabase test db` against the local stack (needs Docker).
BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap WITH SCHEMA extensions;

SELECT plan(19);

-- ── Fixtures ────────────────────────────────────────────────────────────────
-- Alice: permanent, inactive for a year. Bob: anonymous, inactive for 100
-- days. Carol: anonymous, signed up long ago but her session was refreshed
-- yesterday. Dan: anonymous, created 10 days ago.
INSERT INTO auth.users (id, aud, role, email, is_anonymous, created_at, last_sign_in_at)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'authenticated', 'authenticated', 'alice@example.com', false,
     now() - interval '400 days', now() - interval '365 days'),
    ('22222222-2222-2222-2222-222222222222', 'authenticated', 'authenticated', NULL, true,
     now() - interval '200 days', now() - interval '100 days'),
    ('33333333-3333-3333-3333-333333333333', 'authenticated', 'authenticated', NULL, true,
     now() - interval '200 days', now() - interval '200 days'),
    ('44444444-4444-4444-4444-444444444444', 'authenticated', 'authenticated', NULL, true,
     now() - interval '10 days', NULL);

INSERT INTO auth.sessions (id, user_id, created_at, updated_at, refreshed_at)
VALUES ('55555555-5555-5555-5555-555555555555', '33333333-3333-3333-3333-333333333333',
        now() - interval '200 days', now() - interval '1 day', now() - interval '1 day');

-- Alice's rows: live, recently deleted, deleted long ago.
INSERT INTO public.transactions (id, user_id, amount_minor, type, category_id, date, payment_method, deleted_at)
VALUES
    ('aaaaaaaa-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 100, 'expense', 'cat_food', '2026-10-01', 'cash', NULL),
    ('aaaaaaaa-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111', 200, 'expense', 'cat_food', '2026-10-01', 'cash', now() - interval '29 days'),
    ('aaaaaaaa-0000-0000-0000-000000000003', '11111111-1111-1111-1111-111111111111', 300, 'expense', 'cat_food', '2026-10-01', 'cash', now() - interval '31 days');

INSERT INTO public.savings_goals (id, user_id, name, target_amount_minor, deleted_at)
VALUES
    ('bbbbbbbb-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'Kept', 1000, NULL),
    ('bbbbbbbb-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111', 'Old', 1000, now() - interval '40 days');
INSERT INTO public.savings_contributions (id, goal_id, amount_minor, date, deleted_at)
VALUES
    ('cccccccc-0000-0000-0000-000000000001', 'bbbbbbbb-0000-0000-0000-000000000001', 10, '2026-10-01', NULL),
    ('cccccccc-0000-0000-0000-000000000002', 'bbbbbbbb-0000-0000-0000-000000000001', 20, '2026-10-01', now() - interval '45 days'),
    ('cccccccc-0000-0000-0000-000000000003', 'bbbbbbbb-0000-0000-0000-000000000002', 30, '2026-10-01', now() - interval '40 days');

INSERT INTO public.budgets (id, user_id, name, strategy, period, start_date, end_date, deleted_at)
VALUES ('dddddddd-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'Old', 'custom', 'monthly',
        '2026-08-01', '2026-08-31', now() - interval '60 days');
INSERT INTO public.budget_category_allocations (id, budget_id, category_id, group_name, deleted_at)
VALUES ('eeeeeeee-0000-0000-0000-000000000001', 'dddddddd-0000-0000-0000-000000000001', 'cat_food', 'Needs',
        now() - interval '60 days');

-- Bob's data, to be deleted with him.
INSERT INTO public.transactions (id, user_id, amount_minor, type, category_id, date, payment_method)
VALUES ('aaaaaaaa-0000-0000-0000-000000000004', '22222222-2222-2222-2222-222222222222', 400, 'expense', 'cat_food', '2026-10-01', 'cash');
INSERT INTO public.savings_goals (id, user_id, name, target_amount_minor)
VALUES ('bbbbbbbb-0000-0000-0000-000000000003', '22222222-2222-2222-2222-222222222222', 'Bob', 1000);
INSERT INTO public.savings_contributions (id, goal_id, amount_minor, date)
VALUES ('cccccccc-0000-0000-0000-000000000004', 'bbbbbbbb-0000-0000-0000-000000000003', 40, '2026-10-01');

-- ── Not callable over the API, scheduled daily ──────────────────────────────
SELECT ok(NOT has_function_privilege('authenticated', 'public.purge_tombstones(interval)', 'EXECUTE'),
    'clients cannot purge tombstones');
SELECT ok(NOT has_function_privilege('anon', 'public.delete_inactive_anonymous_users(interval)', 'EXECUTE'),
    'clients cannot delete users');
SELECT is((SELECT schedule FROM cron.job WHERE jobname = 'purge-tombstones'), '17 3 * * *',
    'the tombstone purge runs daily');
SELECT is((SELECT schedule FROM cron.job WHERE jobname = 'delete-inactive-anonymous-users'), '47 3 * * *',
    'the anonymous cleanup runs daily');

-- ── Tombstone purge ─────────────────────────────────────────────────────────
SELECT is(public.purge_tombstones(), 6::bigint,
    'purges the 6 markers older than 30 days (1 transaction, 2 contributions, 1 goal, 1 budget, 1 allocation)');

SELECT ok(EXISTS (SELECT 1 FROM public.transactions WHERE id = 'aaaaaaaa-0000-0000-0000-000000000001'),
    'a live transaction is untouched');
SELECT ok(EXISTS (SELECT 1 FROM public.transactions WHERE id = 'aaaaaaaa-0000-0000-0000-000000000002'),
    'a transaction deleted 29 days ago is kept');
SELECT ok(NOT EXISTS (SELECT 1 FROM public.transactions WHERE id = 'aaaaaaaa-0000-0000-0000-000000000003'),
    'a transaction deleted 31 days ago is purged');
SELECT ok(EXISTS (SELECT 1 FROM public.savings_contributions WHERE id = 'cccccccc-0000-0000-0000-000000000001'),
    'a live contribution is untouched');
SELECT ok(NOT EXISTS (SELECT 1 FROM public.savings_contributions WHERE id IN
    ('cccccccc-0000-0000-0000-000000000002', 'cccccccc-0000-0000-0000-000000000003')),
    'old contribution markers are purged');
SELECT ok(NOT EXISTS (SELECT 1 FROM public.savings_goals WHERE id = 'bbbbbbbb-0000-0000-0000-000000000002'),
    'an old goal marker is purged');
SELECT ok(NOT EXISTS (SELECT 1 FROM public.budget_category_allocations),
    'an old allocation marker is purged');
SELECT is(public.purge_tombstones(), 0::bigint, 'a second run purges nothing');

-- ── Inactive anonymous users ────────────────────────────────────────────────
SELECT is(public.delete_inactive_anonymous_users(), 1::bigint, 'deletes exactly one user');
SELECT ok(NOT EXISTS (SELECT 1 FROM auth.users WHERE id = '22222222-2222-2222-2222-222222222222'),
    'an anonymous user inactive for 100 days is deleted');
SELECT ok(NOT EXISTS (SELECT 1 FROM public.transactions WHERE user_id = '22222222-2222-2222-2222-222222222222')
      AND NOT EXISTS (SELECT 1 FROM public.savings_contributions WHERE id = 'cccccccc-0000-0000-0000-000000000004')
      AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE id = '22222222-2222-2222-2222-222222222222'),
    'with all of their data');
SELECT ok(EXISTS (SELECT 1 FROM auth.users WHERE id = '11111111-1111-1111-1111-111111111111'),
    'a permanent user is never deleted, however inactive');
SELECT ok(EXISTS (SELECT 1 FROM auth.users WHERE id = '33333333-3333-3333-3333-333333333333'),
    'an anonymous user whose session was refreshed recently is kept');
SELECT ok(EXISTS (SELECT 1 FROM auth.users WHERE id = '44444444-4444-4444-4444-444444444444'),
    'a new anonymous user is kept');

SELECT * FROM finish();
ROLLBACK;
