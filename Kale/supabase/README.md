# Kalé Supabase Database Setup

This directory contains all database migrations for the Kalé personal finance app. They are the single source
of truth for the backend: never change a project's schema from the dashboard, write a migration. Restored
from git history (they were deleted in commit `0d589e2`).

Two hosted projects use these migrations: **staging** and **production**. Apply every migration to staging
first. The day-to-day workflow (local stack, `make db-reset`, deploying) is in `docs/development.md`.

## Quick Start

### 1. Install Supabase CLI

```bash
# macOS
brew install supabase/tap/supabase

# Windows (with Scoop)
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
scoop install supabase

# Or via npx (no install needed)
npx supabase --version
```

### 2. Link to Your Supabase Project

```bash
supabase login
supabase link --project-ref YOUR_PROJECT_REF
```

Find your project ref in: `https://supabase.com/dashboard/project/YOUR_PROJECT_REF`

### 3. Run Migrations

```bash
supabase db push
```

## Migration Files

### 20260220000001_core_schema.sql
Core infrastructure:
- `profiles` table (extends `auth.users` with preferred_currency, preferred_language, onboarding_completed)
- `update_updated_at_column()` reusable trigger function
- `handle_new_user()` trigger on `auth.users` INSERT — auto-creates profile and seeds default categories

### 20260220000002_feature_tables.sql
All feature tables matching the Flutter domain entities:
- `categories` — user-scoped transaction categories (TEXT ids matching Dart `DefaultCategories` IDs; keyed per user since `20261013000001`)
- `transactions` — income/expense/transfer records with mobile money support
- `budgets` — budget plans with strategy (50/30/20, 80/20, envelope, custom) and period
- `budget_category_allocations` — per-category allocation within a budget (CASCADE on budget delete)
- `savings_goals` — goal-based savings with status tracking
- `savings_contributions` — individual contributions with auto-update trigger on `savings_goals.current_amount`
  (both savings tables are reset, and the trigger dropped, by `20261014000100`)

**Indexes:** Optimized for user-scoped queries — `(user_id, date DESC)`, `(user_id, type, date)`, `(user_id, status)`, etc.

### 20260220000003_rls_policies.sql
Row Level Security on all 7 tables:
- Direct ownership: `auth.uid() = user_id` for profiles, categories, transactions, budgets, savings_goals
- Parent ownership via `EXISTS` subquery: budget_category_allocations (via budgets), savings_contributions (via savings_goals)
- Full CRUD policies (SELECT, INSERT, UPDATE, DELETE) per table

### 20260220000004_default_categories.sql
`seed_default_categories(user_id)` function — seeds 29 Africa-relevant categories for new users:
- 19 expense categories (Food, Transport, Airtime, Rent, Mobile Money Fees, Family Support, Religious Giving, etc.)
- 10 income categories (Salary, Business Income, Freelance, Side Hustle, Mobile Money Received, etc.)
- IDs match `lib/core/constants/default_categories.dart` for clean local/remote sync

### 20260220000005_harden_functions.sql
Added after the restore, from a security review:
- Revokes `EXECUTE` from `PUBLIC`/`anon`/`authenticated` on every function. `seed_default_categories(user_id)` is
  `SECURITY DEFINER` and was callable over `/rest/v1/rpc/`, letting any client write categories owned by
  another user.
- Pins `search_path = ''` on every function.
- `update_savings_goal_amount` runs one primary-key `UPDATE` as the invoking user (RLS applies) instead of two
  as `SECURITY DEFINER`.

### 20261013000001_categories_key_per_user.sql
`categories` is keyed by `(user_id, id)` instead of `id`. Every user is seeded with the same default ids
(`cat_food`, …), so the second user ever created failed in `handle_new_user()` and their sign-up was aborted.
With anonymous sign-in (#11) every fresh install creates a user.

### 20261013000100_reset_transactions_minor_units.sql
Schema reset for issue #5 (decision Q11: dropped and recreated, data not kept):
- `currencies` reference table (code, symbol, decimal places), readable by everyone, mirroring
  `lib/core/money/currency.dart`
- `profiles.base_currency` (FK to `currencies`, NULL until onboarding) replaces `preferred_currency`
- `transactions` recreated: `amount_minor BIGINT` (minor units of the base currency), no `currency_code`, UUID id,
  client-owned `updated_at` (no trigger), nullable `deleted_at`, index on `(user_id, updated_at)`, and one owner-only
  RLS policy for the `authenticated` role (anonymous users included); `anon` has no access

### 20261014000100_reset_savings_minor_units.sql
Schema reset for issue #7 (data not kept):
- Drops the `on_savings_contribution_insert` trigger and `update_savings_goal_amount()`. The device computes a
  goal's saved amount from its contributions and pushes it; with the trigger, synced contributions would count twice
- `savings_goals` recreated: UUID id, `target_amount_minor` / `current_amount_minor BIGINT`, no `currency_code`,
  client-owned `updated_at` (no trigger), nullable `deleted_at`, index on `(user_id, updated_at)`, owner-only RLS
- `savings_contributions` recreated: UUID id, `goal_id` (CASCADE), `amount_minor BIGINT`, `updated_at`,
  `deleted_at`, index on `(goal_id, updated_at)`. No `user_id`: readable and writable only through a goal the user
  owns (one `EXISTS` RLS policy, also checked on write)

### 20261014000200_reset_budgets_minor_units.sql
Schema reset for issue #6 (decision Q11: dropped and recreated, data not kept):
- `budgets` recreated: `start_date`/`end_date` are `DATE`s (both included, no time zone), `period_start_day
  SMALLINT` (default 1: calendar months), `total_income_minor BIGINT`, UUID id, client-owned `updated_at` (no
  trigger), nullable `deleted_at`, index on `(user_id, updated_at)`, one owner-only RLS policy
- `budget_category_allocations` recreated: `allocated_minor BIGINT`, UUID ids, `updated_at`, `deleted_at`, and one
  RLS policy granting access through the parent budget's owner; `anon` has no access to either table

## Anonymous users

Every fresh install signs in anonymously, so anonymous sign-ins must be **enabled** on each project, and
rate-limited because they are an open sign-up door. `config.toml` configures the local stack
(`enable_anonymous_sign_ins`, `[auth.rate_limit] anonymous_users`). On staging and production set the same in the
dashboard: Authentication > Sign In / Providers > "Allow anonymous sign-ins", and Authentication > Rate Limits >
anonymous sign-ins per hour per IP. RLS policies don't special-case anonymous users (their JWT role is
`authenticated`); `supabase/tests/database/anonymous_users_rls.test.sql` checks it.

## Server tests

SQL tests (pgTAP) live in `supabase/tests/database/`. Run them against the local stack with `make db-test`
(`supabase test db`; needs Docker and `make db-start`).

- `anonymous_users_rls.test.sql`: RLS treats anonymous users like permanent ones.
- `transactions_rls.test.sql`: the reset transactions table's shape, and that one user (permanent or anonymous) can
  neither read nor write another user's transactions. It creates two users, so it relies on
  `20261013000001_categories_key_per_user.sql`.
- `budgets_rls.test.sql`: the reset budget tables' shape (dates, start day, minor units, no triggers), and that
  budgets and their allocations are isolated per owner, allocations through their parent budget.
- `savings_rls.test.sql`: the reset savings tables' shape, that no trigger writes a goal's saved amount, and that
  contributions are reachable only through a goal the user owns.

## Database Schema

```
auth.users (Supabase managed)
    │
    ├── profiles (1:1, auto-created on signup)
    │
    ├── categories (1:many, 29 defaults seeded on signup)
    │
    ├── transactions (1:many)
    │       └── references category_id
    │
    ├── budgets (1:many)
    │       └── budget_category_allocations (1:many, CASCADE delete)
    │               └── references category_id
    │
    └── savings_goals (1:many)
            └── savings_contributions (1:many, CASCADE delete, owned through the goal)
```

## App configuration

The app reads each project's URL and anon key from its define file (`config/staging.json`,
`config/production.json`), never from a bundled `.env`. See `docs/development.md` § Environments.

Don't apply migrations by pasting them into the dashboard SQL editor: that bypasses the CLI's migration
history, and `db push` then tries to apply them again. Use `npx supabase db push`.

## Drift against the live project

The migrations were restored from git history; the live project may have been changed from the dashboard since.
Before the schema reset (decision Q11), the live project must be diffed against these migrations, and each
difference either turned into a migration or recorded below as intentionally dropped.

**Status: not yet run.** It needs the live project's database password and Docker (for the shadow database):

```bash
npx supabase link --project-ref <live-project-ref>
make db-diff-live        # writes supabase/live_drift.sql; empty means no drift
npx supabase db dump --linked --schema public -f supabase/live_schema.sql   # full snapshot, for the record
```

Also compare by hand what `db diff` does not cover: Auth settings (providers, anonymous sign-ins, rate limits,
redirect URLs), Storage buckets and policies, Database → Webhooks, Edge Functions, scheduled jobs (`cron`
schema), and installed extensions.

### What the code already tells us

Checked statically against the app's remote datasources (no live access):

- The app writes only `transactions`, `budgets` and `savings_goals`, and the columns it sends (model `toJson`
  minus `server_id`, plus `user_id`) all exist in these migrations. `categories`, `budget_category_allocations`,
  `savings_contributions` and `profiles` are never written by the app; the app only relies on `profiles` and
  `categories` being filled by the `handle_new_user` trigger.
- **`categories.id` is a global `TEXT` primary key, but `seed_default_categories` inserts the same fixed IDs
  (`cat_food`, …) for every user.** With these migrations as written, the second user to sign up hits a
  primary-key violation inside `handle_new_user`, and that sign-up fails. Either the live project differs here
  (look for a composite key or a changed seed function in the diff), or only one account was ever created.
  Fixed by `20261013000001_categories_key_per_user.sql` (key `(user_id, id)`), because anonymous sign-in
  creates a user on every fresh install. If the live project already has a composite key, that migration fails
  on `DROP CONSTRAINT categories_pkey` there: adjust it before `db push`.
- `on_savings_contribution_insert` adds each contribution to `savings_goals.current_amount`. It is harmless
  today (contributions never sync) but would double-count once they do; dropped by
  `20261014000100_reset_savings_minor_units.sql` (decision Q6).

### Recorded differences

Fill in after running the diff. One row per difference; "Decision" is *migrated* (name the migration) or
*dropped* (say why).

| Object | Live project | Migrations | Decision |
|---|---|---|---|
| _pending_ | | | |

## Testing the Setup

After running migrations:

1. **Create a test user** via Supabase Auth
2. **Verify auto-creation** of:
   - 1 profile in `profiles`
   - 29 default categories in `categories`
3. **Test CRUD** — create a transaction, budget, or savings goal via the app
4. **Verify RLS** — confirm users cannot access each other's data

```sql
-- Check a user's auto-created data
SELECT * FROM public.profiles WHERE id = 'USER_UUID';
SELECT COUNT(*) FROM public.categories WHERE user_id = 'USER_UUID';  -- should be 29
```

## Troubleshooting

### Migration fails with "relation already exists"
```bash
# Reset local database (dev only!)
supabase db reset
```

### RLS policies blocking queries
- Ensure the user is authenticated (`auth.uid()` returns a valid UUID)
- Use the authenticated Supabase client (anon key), not the service role key
- Check that `user_id` is set correctly on INSERT

### Default categories not created
The `handle_new_user()` trigger calls `seed_default_categories()`. Verify:
```sql
SELECT * FROM public.profiles WHERE id = 'USER_UUID';
SELECT * FROM public.categories WHERE user_id = 'USER_UUID';
```

## Useful Commands

```bash
supabase migration list        # Check migration status
supabase migration new name    # Create new migration
supabase db pull               # Pull remote schema changes
supabase db push               # Push local migrations to remote
supabase db reset              # Reset local DB (dev only)
```

## Security

- RLS enabled on all 7 tables
- Users can only access their own data
- Auth required for all operations
- CHECK constraints on amounts, enums, and percentages
- CASCADE deletes for child records (budget allocations, contributions)
- Triggers enforce business logic (updated_at, current_amount, auto-complete)
