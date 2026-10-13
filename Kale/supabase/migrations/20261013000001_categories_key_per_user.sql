-- ============================================================================
-- Categories are keyed per user.
--
-- `categories.id` alone was the primary key, but every new user is seeded
-- with the same default ids ('cat_food', ...). The second user ever created
-- hit a unique violation in `handle_new_user()`, which aborted the sign-up.
-- With anonymous sign-in, every fresh install creates a user, so this broke
-- first launch for everyone but the first install.
-- ============================================================================

ALTER TABLE public.categories DROP CONSTRAINT categories_pkey;
ALTER TABLE public.categories ADD PRIMARY KEY (user_id, id);

-- The new key's leading column covers lookups by user.
DROP INDEX IF EXISTS public.idx_categories_user_id;
