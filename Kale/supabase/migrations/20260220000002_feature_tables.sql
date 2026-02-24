-- ============================================================================
-- Kalé Feature Tables
-- Categories, Transactions, Budgets, Savings Goals & Contributions.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- CATEGORIES
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.categories (
    id          TEXT PRIMARY KEY,
    user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name        TEXT NOT NULL,
    icon        TEXT NOT NULL,
    color       TEXT NOT NULL,
    type        TEXT NOT NULL CHECK (type IN ('income', 'expense', 'both')),
    is_default  BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order  INTEGER NOT NULL DEFAULT 0,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_categories_user_id   ON public.categories(user_id);
CREATE INDEX idx_categories_user_type ON public.categories(user_id, type);

-- ---------------------------------------------------------------------------
-- TRANSACTIONS
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.transactions (
    id                      TEXT PRIMARY KEY,
    user_id                 UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    amount                  DOUBLE PRECISION NOT NULL CHECK (amount > 0),
    type                    TEXT NOT NULL CHECK (type IN ('income', 'expense', 'transfer')),
    category_id             TEXT NOT NULL,
    description             TEXT,
    date                    TIMESTAMPTZ NOT NULL,
    payment_method          TEXT NOT NULL CHECK (
                                payment_method IN ('cash', 'mobileMoney', 'bank', 'card')
                            ),
    currency_code           TEXT NOT NULL DEFAULT 'XOF',
    is_recurring            BOOLEAN NOT NULL DEFAULT FALSE,
    recurring_rule_id       TEXT,
    mobile_money_provider   TEXT,
    mobile_money_ref        TEXT,
    account_id              TEXT,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_transactions_user_id            ON public.transactions(user_id);
CREATE INDEX idx_transactions_user_date          ON public.transactions(user_id, date DESC);
CREATE INDEX idx_transactions_user_type_date     ON public.transactions(user_id, type, date DESC);
CREATE INDEX idx_transactions_user_category_date ON public.transactions(user_id, category_id, date DESC);

CREATE TRIGGER update_transactions_updated_at
    BEFORE UPDATE ON public.transactions
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ---------------------------------------------------------------------------
-- BUDGETS
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.budgets (
    id                  TEXT PRIMARY KEY,
    user_id             UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name                TEXT NOT NULL,
    strategy            TEXT NOT NULL CHECK (
                            strategy IN ('fiftyThirtyTwenty', 'eightyTwenty', 'envelope', 'custom')
                        ),
    period              TEXT NOT NULL CHECK (
                            period IN ('weekly', 'biWeekly', 'monthly')
                        ),
    start_date          TIMESTAMPTZ NOT NULL,
    end_date            TIMESTAMPTZ NOT NULL,
    total_income        DOUBLE PRECISION,
    is_percentage_based BOOLEAN NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_budgets_user_id    ON public.budgets(user_id);
CREATE INDEX idx_budgets_user_dates ON public.budgets(user_id, start_date, end_date);

CREATE TRIGGER update_budgets_updated_at
    BEFORE UPDATE ON public.budgets
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ---------------------------------------------------------------------------
-- BUDGET CATEGORY ALLOCATIONS
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.budget_category_allocations (
    id                    TEXT PRIMARY KEY,
    budget_id             TEXT NOT NULL REFERENCES public.budgets(id) ON DELETE CASCADE,
    category_id           TEXT NOT NULL,
    group_name            TEXT NOT NULL,
    allocated_amount      DOUBLE PRECISION NOT NULL DEFAULT 0,
    allocated_percentage  DOUBLE PRECISION,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_budget_alloc_budget_id ON public.budget_category_allocations(budget_id);

-- ---------------------------------------------------------------------------
-- SAVINGS GOALS
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.savings_goals (
    id              TEXT PRIMARY KEY,
    user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name            TEXT NOT NULL,
    target_amount   DOUBLE PRECISION NOT NULL CHECK (target_amount > 0),
    current_amount  DOUBLE PRECISION NOT NULL DEFAULT 0,
    currency_code   TEXT NOT NULL DEFAULT 'XOF',
    description     TEXT,
    deadline        TIMESTAMPTZ,
    icon_name       TEXT,
    color_hex       TEXT,
    status          TEXT NOT NULL DEFAULT 'active' CHECK (
                        status IN ('active', 'completed', 'paused', 'cancelled')
                    ),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_savings_goals_user_id     ON public.savings_goals(user_id);
CREATE INDEX idx_savings_goals_user_status ON public.savings_goals(user_id, status);

CREATE TRIGGER update_savings_goals_updated_at
    BEFORE UPDATE ON public.savings_goals
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ---------------------------------------------------------------------------
-- SAVINGS CONTRIBUTIONS
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.savings_contributions (
    id          TEXT PRIMARY KEY,
    goal_id     TEXT NOT NULL REFERENCES public.savings_goals(id) ON DELETE CASCADE,
    amount      DOUBLE PRECISION NOT NULL CHECK (amount > 0),
    source      TEXT NOT NULL DEFAULT 'manual' CHECK (
                    source IN ('manual', 'auto', 'roundup')
                ),
    date        TIMESTAMPTZ NOT NULL,
    note        TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_savings_contrib_goal_id   ON public.savings_contributions(goal_id);
CREATE INDEX idx_savings_contrib_goal_date ON public.savings_contributions(goal_id, date DESC);

-- Auto-update savings_goals.current_amount when a contribution is inserted.
CREATE OR REPLACE FUNCTION public.update_savings_goal_amount()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.savings_goals
    SET current_amount = current_amount + NEW.amount,
        updated_at     = NOW()
    WHERE id = NEW.goal_id;

    -- Auto-complete if the target is reached.
    UPDATE public.savings_goals
    SET status     = 'completed',
        updated_at = NOW()
    WHERE id = NEW.goal_id
      AND current_amount >= target_amount
      AND status = 'active';

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_savings_contribution_insert
    AFTER INSERT ON public.savings_contributions
    FOR EACH ROW EXECUTE FUNCTION public.update_savings_goal_amount();
