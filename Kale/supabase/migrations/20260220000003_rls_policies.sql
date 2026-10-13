-- ============================================================================
-- Row Level Security Policies
-- Every user can only access their own data.
-- ============================================================================

ALTER TABLE public.profiles                    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories                  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions                ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.budgets                     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.budget_category_allocations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.savings_goals               ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.savings_contributions       ENABLE ROW LEVEL SECURITY;

-- ---------------------------------------------------------------------------
-- PROFILES  (id = auth.uid())
-- ---------------------------------------------------------------------------
CREATE POLICY "Users can view own profile"
    ON public.profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- ---------------------------------------------------------------------------
-- CATEGORIES  (user_id = auth.uid())
-- ---------------------------------------------------------------------------
CREATE POLICY "Users can view own categories"
    ON public.categories FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own categories"
    ON public.categories FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own categories"
    ON public.categories FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own categories"
    ON public.categories FOR DELETE
    USING (auth.uid() = user_id);

-- ---------------------------------------------------------------------------
-- TRANSACTIONS  (user_id = auth.uid())
-- ---------------------------------------------------------------------------
CREATE POLICY "Users can view own transactions"
    ON public.transactions FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own transactions"
    ON public.transactions FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own transactions"
    ON public.transactions FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own transactions"
    ON public.transactions FOR DELETE
    USING (auth.uid() = user_id);

-- ---------------------------------------------------------------------------
-- BUDGETS  (user_id = auth.uid())
-- ---------------------------------------------------------------------------
CREATE POLICY "Users can view own budgets"
    ON public.budgets FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own budgets"
    ON public.budgets FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own budgets"
    ON public.budgets FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own budgets"
    ON public.budgets FOR DELETE
    USING (auth.uid() = user_id);

-- ---------------------------------------------------------------------------
-- BUDGET CATEGORY ALLOCATIONS  (via parent budget ownership)
-- ---------------------------------------------------------------------------
CREATE POLICY "Users can view own budget allocations"
    ON public.budget_category_allocations FOR SELECT
    USING (EXISTS (
        SELECT 1 FROM public.budgets
        WHERE id = budget_category_allocations.budget_id
          AND user_id = auth.uid()
    ));

CREATE POLICY "Users can insert own budget allocations"
    ON public.budget_category_allocations FOR INSERT
    WITH CHECK (EXISTS (
        SELECT 1 FROM public.budgets
        WHERE id = budget_category_allocations.budget_id
          AND user_id = auth.uid()
    ));

CREATE POLICY "Users can update own budget allocations"
    ON public.budget_category_allocations FOR UPDATE
    USING (EXISTS (
        SELECT 1 FROM public.budgets
        WHERE id = budget_category_allocations.budget_id
          AND user_id = auth.uid()
    ))
    WITH CHECK (EXISTS (
        SELECT 1 FROM public.budgets
        WHERE id = budget_category_allocations.budget_id
          AND user_id = auth.uid()
    ));

CREATE POLICY "Users can delete own budget allocations"
    ON public.budget_category_allocations FOR DELETE
    USING (EXISTS (
        SELECT 1 FROM public.budgets
        WHERE id = budget_category_allocations.budget_id
          AND user_id = auth.uid()
    ));

-- ---------------------------------------------------------------------------
-- SAVINGS GOALS  (user_id = auth.uid())
-- ---------------------------------------------------------------------------
CREATE POLICY "Users can view own savings goals"
    ON public.savings_goals FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own savings goals"
    ON public.savings_goals FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own savings goals"
    ON public.savings_goals FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own savings goals"
    ON public.savings_goals FOR DELETE
    USING (auth.uid() = user_id);

-- ---------------------------------------------------------------------------
-- SAVINGS CONTRIBUTIONS  (via parent goal ownership)
-- ---------------------------------------------------------------------------
CREATE POLICY "Users can view own contributions"
    ON public.savings_contributions FOR SELECT
    USING (EXISTS (
        SELECT 1 FROM public.savings_goals
        WHERE id = savings_contributions.goal_id
          AND user_id = auth.uid()
    ));

CREATE POLICY "Users can insert own contributions"
    ON public.savings_contributions FOR INSERT
    WITH CHECK (EXISTS (
        SELECT 1 FROM public.savings_goals
        WHERE id = savings_contributions.goal_id
          AND user_id = auth.uid()
    ));

CREATE POLICY "Users can delete own contributions"
    ON public.savings_contributions FOR DELETE
    USING (EXISTS (
        SELECT 1 FROM public.savings_goals
        WHERE id = savings_contributions.goal_id
          AND user_id = auth.uid()
    ));
