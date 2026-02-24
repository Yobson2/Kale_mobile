-- ============================================================================
-- Default Categories Seed Function
-- Replaces the stub created in migration 1.
-- IDs match DefaultCategories in lib/core/constants/default_categories.dart.
-- ============================================================================

CREATE OR REPLACE FUNCTION public.seed_default_categories(p_user_id UUID)
RETURNS void AS $$
DECLARE
    v_count INTEGER;
BEGIN
    -- Only seed if the user has no categories yet (idempotent).
    SELECT COUNT(*) INTO v_count
    FROM public.categories
    WHERE user_id = p_user_id;

    IF v_count > 0 THEN
        RETURN;
    END IF;

    INSERT INTO public.categories
        (id, user_id, name, icon, color, type, is_default, sort_order)
    VALUES
        -- Expense categories
        ('cat_food',            p_user_id, 'Food & Groceries',     'restaurant',             'FF4CAF50', 'expense', TRUE,  0),
        ('cat_transport',       p_user_id, 'Transport',            'directions_bus',          'FF2196F3', 'expense', TRUE,  1),
        ('cat_airtime',         p_user_id, 'Airtime & Data',       'phone_android',           'FF9C27B0', 'expense', TRUE,  2),
        ('cat_rent',            p_user_id, 'Rent',                 'home',                    'FF795548', 'expense', TRUE,  3),
        ('cat_utilities',       p_user_id, 'Utilities',            'electrical_services',     'FFFF9800', 'expense', TRUE,  4),
        ('cat_momo_fees',       p_user_id, 'Mobile Money Fees',    'account_balance_wallet',  'FFFF5722', 'expense', TRUE,  5),
        ('cat_business',        p_user_id, 'Business Expenses',    'business_center',         'FF607D8B', 'expense', TRUE,  6),
        ('cat_education',       p_user_id, 'Education',            'school',                  'FF3F51B5', 'expense', TRUE,  7),
        ('cat_health',          p_user_id, 'Health',               'local_hospital',          'FFF44336', 'expense', TRUE,  8),
        ('cat_clothing',        p_user_id, 'Clothing',             'checkroom',               'FFE91E63', 'expense', TRUE,  9),
        ('cat_entertainment',   p_user_id, 'Entertainment',        'movie',                   'FF00BCD4', 'expense', TRUE, 10),
        ('cat_family_support',  p_user_id, 'Family Support',       'family_restroom',         'FFFF6F00', 'expense', TRUE, 11),
        ('cat_religious',       p_user_id, 'Religious Giving',     'volunteer_activism',      'FF8D6E63', 'expense', TRUE, 12),
        ('cat_savings_contrib', p_user_id, 'Savings Contribution', 'savings',                 'FF009688', 'expense', TRUE, 13),
        ('cat_debt',            p_user_id, 'Debt Repayment',       'money_off',               'FF616161', 'expense', TRUE, 14),
        ('cat_personal_care',   p_user_id, 'Personal Care',        'spa',                     'FFAB47BC', 'expense', TRUE, 15),
        ('cat_household',       p_user_id, 'Household Items',      'weekend',                 'FF8BC34A', 'expense', TRUE, 16),
        ('cat_insurance',       p_user_id, 'Insurance',            'security',                'FF455A64', 'expense', TRUE, 17),
        ('cat_other_expense',   p_user_id, 'Other Expense',        'more_horiz',              'FF9E9E9E', 'expense', TRUE, 18),
        -- Income categories
        ('cat_salary',              p_user_id, 'Salary',                    'payments',          'FF4CAF50', 'income', TRUE, 19),
        ('cat_business_income',     p_user_id, 'Business Income',           'storefront',        'FF2196F3', 'income', TRUE, 20),
        ('cat_freelance',           p_user_id, 'Freelance / Gig Work',      'laptop',            'FF00BCD4', 'income', TRUE, 21),
        ('cat_side_hustle',         p_user_id, 'Side Hustle',               'trending_up',       'FFFF9800', 'income', TRUE, 22),
        ('cat_momo_received',       p_user_id, 'Mobile Money Received',     'phone_iphone',      'FF9C27B0', 'income', TRUE, 23),
        ('cat_family_received',     p_user_id, 'Family Support Received',   'people',            'FFE91E63', 'income', TRUE, 24),
        ('cat_rental_income',       p_user_id, 'Rental Income',             'apartment',         'FF795548', 'income', TRUE, 25),
        ('cat_investment_returns',  p_user_id, 'Investment Returns',        'show_chart',        'FF009688', 'income', TRUE, 26),
        ('cat_govt_aid',            p_user_id, 'Government Aid',            'account_balance',   'FF607D8B', 'income', TRUE, 27),
        ('cat_other_income',        p_user_id, 'Other Income',              'more_horiz',        'FF9E9E9E', 'income', TRUE, 28);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
