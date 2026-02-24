# Kalé Supabase Database Setup

This directory contains all database migrations for the Kalé personal finance app.

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
- `categories` — user-scoped transaction categories (TEXT PK matching Dart `DefaultCategories` IDs)
- `transactions` — income/expense/transfer records with mobile money support
- `budgets` — budget plans with strategy (50/30/20, 80/20, envelope, custom) and period
- `budget_category_allocations` — per-category allocation within a budget (CASCADE on budget delete)
- `savings_goals` — goal-based savings with status tracking
- `savings_contributions` — individual contributions with auto-update trigger on `savings_goals.current_amount`

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
            └── savings_contributions (1:many, CASCADE delete)
                    └── trigger: auto-updates current_amount + auto-completes goal
```

## Environment Variables

Your `.env` file must contain:

```env
BASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

## Manual Migration (Alternative)

If you prefer the Supabase Dashboard:

1. Go to **SQL Editor**
2. Run each file in order:
   - `20260220000001_core_schema.sql`
   - `20260220000002_feature_tables.sql`
   - `20260220000003_rls_policies.sql`
   - `20260220000004_default_categories.sql`

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
