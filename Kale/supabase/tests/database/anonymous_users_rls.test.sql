-- ============================================================================
-- Anonymous users get the same isolation as permanent users (#11).
--
-- An anonymous user is a row in auth.users with is_anonymous = true. Its
-- JWT carries role 'authenticated', like a permanent user's, so RLS
-- policies must not (and do not) special-case it.
--
-- Run with: supabase test db   (needs the local stack: supabase start)
-- ============================================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap WITH SCHEMA extensions;

SELECT plan(16);

-- ---------------------------------------------------------------------------
-- Two users: one anonymous, one permanent. Creating both proves that sign-up
-- works for more than one user (default categories used to collide).
-- ---------------------------------------------------------------------------
INSERT INTO auth.users (id, aud, role, email, is_anonymous)
VALUES
    ('00000000-0000-0000-0000-00000000a000', 'authenticated', 'authenticated', NULL, TRUE),
    ('00000000-0000-0000-0000-00000000b000', 'authenticated', 'authenticated', 'ama@example.com', FALSE);

SELECT is(
    (SELECT count(*)::int FROM public.profiles
     WHERE id IN ('00000000-0000-0000-0000-00000000a000',
                  '00000000-0000-0000-0000-00000000b000')),
    2,
    'both the anonymous and the permanent user get a profile'
);

SELECT ok(
    (SELECT count(*) FROM public.categories
     WHERE user_id = '00000000-0000-0000-0000-00000000a000') > 0
    AND
    (SELECT count(*) FROM public.categories
     WHERE user_id = '00000000-0000-0000-0000-00000000b000') > 0,
    'both users get their own default categories'
);

-- ---------------------------------------------------------------------------
-- Act as the anonymous user.
-- ---------------------------------------------------------------------------
SET LOCAL ROLE authenticated;
SELECT set_config(
    'request.jwt.claims',
    '{"sub":"00000000-0000-0000-0000-00000000a000","role":"authenticated","is_anonymous":true}',
    TRUE
);

SELECT lives_ok(
    $$INSERT INTO public.categories (id, user_id, name, icon, color, type, is_default)
      VALUES ('cat_custom', '00000000-0000-0000-0000-00000000a000',
              'Market', 'store', 'FF000000', 'expense', FALSE)$$,
    'the anonymous user can write their own rows'
);

SELECT is(
    (SELECT count(*)::int FROM public.categories
     WHERE user_id <> '00000000-0000-0000-0000-00000000a000'),
    0,
    'the anonymous user cannot read anyone else''s categories'
);

SELECT is(
    (SELECT count(*)::int FROM public.profiles),
    1,
    'the anonymous user sees only their own profile'
);

SELECT throws_ok(
    $$INSERT INTO public.categories (id, user_id, name, icon, color, type, is_default)
      VALUES ('cat_intruder', '00000000-0000-0000-0000-00000000b000',
              'Intruder', 'store', 'FF000000', 'expense', FALSE)$$,
    '42501',
    NULL,
    'the anonymous user cannot write rows owned by another user'
);

SELECT is_empty(
    $$UPDATE public.categories SET name = 'Hacked'
      WHERE user_id = '00000000-0000-0000-0000-00000000b000' RETURNING id$$,
    'the anonymous user cannot update another user''s rows'
);

SELECT is_empty(
    $$DELETE FROM public.categories
      WHERE user_id = '00000000-0000-0000-0000-00000000b000' RETURNING id$$,
    'the anonymous user cannot delete another user''s rows'
);

SELECT is_empty(
    $$UPDATE public.profiles SET full_name = 'Hacked'
      WHERE id = '00000000-0000-0000-0000-00000000b000' RETURNING id$$,
    'the anonymous user cannot update another user''s profile'
);

-- ---------------------------------------------------------------------------
-- Act as the permanent user: the anonymous user's data is just as private.
-- ---------------------------------------------------------------------------
SELECT set_config(
    'request.jwt.claims',
    '{"sub":"00000000-0000-0000-0000-00000000b000","role":"authenticated","is_anonymous":false}',
    TRUE
);

SELECT is(
    (SELECT count(*)::int FROM public.categories
     WHERE user_id = '00000000-0000-0000-0000-00000000a000'),
    0,
    'a permanent user cannot read the anonymous user''s categories'
);

SELECT is(
    (SELECT count(*)::int FROM public.profiles),
    1,
    'a permanent user sees only their own profile'
);

SELECT throws_ok(
    $$INSERT INTO public.categories (id, user_id, name, icon, color, type, is_default)
      VALUES ('cat_intruder', '00000000-0000-0000-0000-00000000a000',
              'Intruder', 'store', 'FF000000', 'expense', FALSE)$$,
    '42501',
    NULL,
    'a permanent user cannot write rows owned by the anonymous user'
);

SELECT is_empty(
    $$DELETE FROM public.categories
      WHERE user_id = '00000000-0000-0000-0000-00000000a000' RETURNING id$$,
    'a permanent user cannot delete the anonymous user''s rows'
);

-- ---------------------------------------------------------------------------
-- Structure: the guarantees above hold for every table, not just the ones
-- exercised.
-- ---------------------------------------------------------------------------
RESET ROLE;

SELECT is_empty(
    $$SELECT c.relname FROM pg_class c
      JOIN pg_namespace n ON n.oid = c.relnamespace
      WHERE n.nspname = 'public' AND c.relkind = 'r' AND NOT c.relrowsecurity$$,
    'every public table has row level security enabled'
);

SELECT is_empty(
    $$SELECT tablename, policyname FROM pg_policies
      WHERE schemaname = 'public'
        AND (coalesce(qual, '') ILIKE '%is_anonymous%'
             OR coalesce(with_check, '') ILIKE '%is_anonymous%')$$,
    'no policy treats anonymous users differently'
);

SELECT is_empty(
    $$SELECT tablename, policyname FROM pg_policies
      WHERE schemaname = 'public'
        AND NOT (roles && ARRAY['public', 'authenticated']::name[])$$,
    'every policy applies to the authenticated role, which anonymous users have'
);

SELECT * FROM finish();
ROLLBACK;
