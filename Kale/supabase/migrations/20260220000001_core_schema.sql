-- ============================================================================
-- Kalé Core Schema
-- Extensions, reusable trigger functions, and profiles table.
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Reusable trigger function: auto-update `updated_at` on row modification.
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------------------------
-- Profiles table (extends auth.users with app-specific fields)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.profiles (
    id              UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email           TEXT,
    full_name       TEXT,
    avatar_url      TEXT,
    preferred_currency TEXT NOT NULL DEFAULT 'XOF',
    preferred_language TEXT NOT NULL DEFAULT 'en',
    onboarding_completed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ---------------------------------------------------------------------------
-- Auto-create profile + seed categories when a new user signs up.
-- Called by the trigger on auth.users INSERT.
-- seed_default_categories() is defined in migration 4.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name, avatar_url)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(
            NEW.raw_user_meta_data->>'display_name',
            NEW.raw_user_meta_data->>'name',
            NEW.raw_user_meta_data->>'full_name',
            ''
        ),
        NEW.raw_user_meta_data->>'avatar_url'
    );

    -- Default categories are seeded after migration 4 is applied.
    -- The function is created as a no-op here and replaced in migration 4.
    PERFORM public.seed_default_categories(NEW.id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Stub so migration 1 can reference it before migration 4 defines it.
CREATE OR REPLACE FUNCTION public.seed_default_categories(p_user_id UUID)
RETURNS void AS $$
BEGIN
    -- Replaced by migration 20260220000004_default_categories.sql
    NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
