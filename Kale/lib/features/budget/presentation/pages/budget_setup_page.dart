import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/money/money.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';
import 'package:kale/core/widgets/layout/app_step_indicator.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/presentation/providers/budgets_notifier.dart';
import 'package:kale/features/profile/presentation/providers/profile_providers.dart';

/// Multi-step budget setup wizard.
///
/// Steps:
/// 1. Choose strategy (50/30/20, 80/20, Envelope, Custom)
/// 2. Set period and optional income amount
/// 3. Review/customize category allocations per group
/// 4. Confirm and create
class BudgetSetupPage extends ConsumerStatefulWidget {
  /// Creates a [BudgetSetupPage].
  ///
  /// When [existingBudget] is provided, the wizard opens in edit mode
  /// with fields pre-filled from the existing budget.
  const BudgetSetupPage({super.key, this.existingBudget});

  /// The budget to edit, or `null` for create mode.
  final Budget? existingBudget;

  @override
  ConsumerState<BudgetSetupPage> createState() => _BudgetSetupPageState();
}

class _BudgetSetupPageState extends ConsumerState<BudgetSetupPage> {
  int _currentStep = 0;
  final _pageController = PageController();

  // Step 1: Strategy.
  BudgetStrategy _selectedStrategy = BudgetStrategy.fiftyThirtyTwenty;

  // Step 2: Period & Money to budget.
  BudgetPeriod _selectedPeriod = BudgetPeriod.monthly;
  final _budgetAmountController = TextEditingController();

  /// Money to budget, in minor units of the base currency.
  int _budgetMinor = 0;

  // Step 3: Category allocations.
  late List<_CategoryAllocationData> _allocations;

  bool _isCreating = false;
  bool _amountFilled = false;

  bool get _isEditMode => widget.existingBudget != null;

  Currency get _currency => ref.read(baseCurrencyProvider);

  String get _locale => Localizations.localeOf(context).toString();

  @override
  void initState() {
    super.initState();
    final existing = widget.existingBudget;
    if (existing != null) {
      _selectedStrategy = existing.strategy;
      _selectedPeriod = existing.period;
      _budgetMinor = existing.totalIncomeMinor ?? 0;
      _allocations = existing.categories
          .map(
            (c) => _CategoryAllocationData(
              categoryId: c.categoryId,
              name: _categoryName(c.categoryId),
              groupName: c.groupName,
              percentage: c.allocatedPercentage ?? 0,
              amountMinor: c.allocatedMinor,
            ),
          )
          .toList();
    } else {
      _allocations = _buildDefaultAllocations(_selectedStrategy);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The amount is shown in the device locale, known only from here on.
    if (_amountFilled) return;
    _amountFilled = true;
    if (_budgetMinor > 0) {
      _budgetAmountController.text = Money.fromMinorUnits(
        _budgetMinor,
        _currency,
      ).format(locale: _locale, withSymbol: false);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _budgetAmountController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextStep() {
    if (_currentStep < 3) {
      if (_currentStep == 0) {
        // Rebuild allocations when strategy changes.
        setState(() {
          _allocations = _buildDefaultAllocations(_selectedStrategy);
        });
      }
      if (_currentStep == 1) {
        final amount = Money.tryParse(
          _budgetAmountController.text,
          _currency,
          locale: _locale,
        );
        _budgetMinor = amount?.minorUnits ?? 0;
        if (_budgetMinor <= 0) {
          context.showSnackBar(
            'Please enter the amount you want to budget',
            isError: true,
          );
          return;
        }
        _applyIncomeToAllocations();
      }
      _goToStep(_currentStep + 1);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _goToStep(_currentStep - 1);
    }
  }

  static String _categoryName(String categoryId) {
    const names = {
      'cat_food': 'Food & Groceries',
      'cat_rent': 'Rent',
      'cat_transport': 'Transport',
      'cat_utilities': 'Utilities',
      'cat_health': 'Health',
      'cat_entertainment': 'Entertainment',
      'cat_clothing': 'Clothing',
      'cat_airtime': 'Airtime & Data',
      'cat_personal_care': 'Personal Care',
      'cat_family_support': 'Family Support',
      'cat_savings_contrib': 'Savings',
      'cat_debt': 'Debt Repayment',
      'cat_religious': 'Religious Giving',
      'cat_business': 'Business Expenses',
      'cat_momo_fees': 'Mobile Money Fees',
    };
    return names[categoryId] ?? categoryId;
  }

  void _applyIncomeToAllocations() {
    if (_budgetMinor <= 0) return;
    for (final alloc in _allocations) {
      if (alloc.percentage > 0) {
        // Integer share in hundredths of a percent, rounded down, so the
        // allocations never add up to more than the budget.
        final basisPoints = (alloc.percentage * 100).round();
        alloc.amountMinor = _budgetMinor * basisPoints ~/ 10000;
      }
    }
  }

  Future<void> _saveBudget() async {
    if (_isCreating) return;

    // Validate allocations don't exceed budget.
    final totalAllocated = _allocations.fold<int>(
      0,
      (sum, a) => sum + a.amountMinor,
    );
    if (totalAllocated > _budgetMinor) {
      context.showSnackBar(
        'Allocations exceed your budget. Go back and adjust amounts.',
        isError: true,
      );
      return;
    }

    setState(() => _isCreating = true);

    final now = DateTime.now();

    final months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final budgetName = _isEditMode
        ? widget.existingBudget!.name
        : '${months[now.month]} ${now.year} Budget';

    final categories = _allocations
        .where((a) => a.amountMinor > 0)
        .map(
          (a) => BudgetCategoryAllocation(
            id: '',
            budgetId: _isEditMode ? widget.existingBudget!.id : '',
            categoryId: a.categoryId,
            groupName: a.groupName,
            allocatedMinor: a.amountMinor,
            allocatedPercentage: a.percentage > 0 ? a.percentage : null,
            spentMinor: 0,
            createdAt: now,
          ),
        )
        .toList();

    final notifier = ref.read(budgetsNotifierProvider.notifier);
    final bool success;

    final existing = widget.existingBudget;
    if (existing != null) {
      // Editing keeps the budget's period.
      success = await notifier.updateBudget(
        id: existing.id,
        name: budgetName,
        strategy: _selectedStrategy,
        period: _selectedPeriod,
        startDate: existing.startDate,
        endDate: existing.endDate,
        periodStartDay: existing.periodStartDay,
        categories: categories,
        totalIncomeMinor: _budgetMinor,
        isPercentageBased: false,
      );
    } else {
      // The period containing today, from the default start day (the
      // custom start-day choice comes in a later phase).
      success = await notifier.createBudget(
        name: budgetName,
        strategy: _selectedStrategy,
        period: _selectedPeriod,
        categories: categories,
        totalIncomeMinor: _budgetMinor,
        isPercentageBased: false,
      );
    }

    if (mounted) {
      setState(() => _isCreating = false);
      if (success) {
        context.showSnackBar(
          _isEditMode
              ? 'Budget updated successfully!'
              : 'Budget created successfully!',
        );
        if (mounted) context.pop();
      } else {
        context.showSnackBar(
          _isEditMode ? 'Failed to update budget' : 'Failed to create budget',
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(baseCurrencyProvider);
    final budgetAmount = Money.fromMinorUnits(_budgetMinor, currency);
    return Scaffold(
      appBar: AppAppBar(
        title: _isEditMode ? 'Edit Budget' : 'Create Budget',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Text(
              'Step ${_currentStep + 1} of 4',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step indicator.
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.md,
              ),
              child: AppStepIndicator(currentStep: _currentStep, totalSteps: 4),
            ),

            // Page content.
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _StrategyStep(
                    selected: _selectedStrategy,
                    onSelected: (strategy) {
                      setState(() => _selectedStrategy = strategy);
                    },
                  ),
                  _PeriodIncomeStep(
                    selectedPeriod: _selectedPeriod,
                    budgetAmountController: _budgetAmountController,
                    currency: currency,
                    onPeriodChanged: (period) {
                      setState(() => _selectedPeriod = period);
                    },
                  ),
                  _AllocationsStep(
                    allocations: _allocations,
                    budgetAmount: budgetAmount,
                    onChanged: () => setState(() {}),
                  ),
                  _ConfirmStep(
                    strategy: _selectedStrategy,
                    period: _selectedPeriod,
                    budgetAmount: budgetAmount,
                    allocations: _allocations,
                  ),
                ],
              ),
            ),

            // Navigation buttons.
            _NavigationButtons(
              currentStep: _currentStep,
              isCreating: _isCreating,
              isEditMode: _isEditMode,
              onNext: _nextStep,
              onPrevious: _previousStep,
              onConfirm: _saveBudget,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 1: Strategy ────────────────────────────────────────────

class _StrategyStep extends StatelessWidget {
  const _StrategyStep({
    required this.selected,
    required this.onSelected,
  });

  final BudgetStrategy selected;
  final ValueChanged<BudgetStrategy> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Budget',
            style: context.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.verticalSm,
          Text(
            'STRATEGY SELECTION',
            style: context.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1.65,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalSm,
          Text(
            'Pick a budgeting method that fits your lifestyle.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalXl,
          ..._strategies.map((data) {
            final isSelected = data.strategy == selected;
            return _StrategyCard(
              data: data,
              isSelected: isSelected,
              onTap: () => onSelected(data.strategy),
            );
          }),
        ],
      ),
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  final _StrategyData data;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderRadiusLg,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: AppSpacing.paddingLg,
          decoration: BoxDecoration(
            color: isSelected
                ? context.colorScheme.primaryContainer.withValues(alpha: 0.4)
                : context.colorScheme.surfaceContainerLow,
            borderRadius: AppRadius.borderRadiusLg,
            border: isSelected
                ? Border.all(
                    color: context.colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colorScheme.primary.withValues(alpha: 0.15)
                      : context.colorScheme.surfaceContainerHighest,
                  borderRadius: AppRadius.borderRadiusMd,
                ),
                child: Icon(
                  data.icon,
                  color: isSelected
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.horizontalMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isSelected ? context.colorScheme.primary : null,
                      ),
                    ),
                    AppSpacing.verticalXs,
                    Text(
                      data.description,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    AppSpacing.verticalSm,
                    Text(
                      data.breakdown,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: context.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Step 2: Period & Money to Budget ─────────────────────────────

class _PeriodIncomeStep extends StatelessWidget {
  const _PeriodIncomeStep({
    required this.selectedPeriod,
    required this.budgetAmountController,
    required this.currency,
    required this.onPeriodChanged,
  });

  final BudgetPeriod selectedPeriod;
  final TextEditingController budgetAmountController;
  final Currency currency;
  final ValueChanged<BudgetPeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set Your Period',
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.verticalSm,
          Text(
            'How often do you want to budget?',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalXl,

          // Period selection.
          ...BudgetPeriod.values.map((period) {
            final isSelected = period == selectedPeriod;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: InkWell(
                onTap: () => onPeriodChanged(period),
                borderRadius: AppRadius.borderRadiusMd,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.colorScheme.primaryContainer.withValues(
                            alpha: 0.4,
                          )
                        : context.colorScheme.surfaceContainerLow,
                    borderRadius: AppRadius.borderRadiusMd,
                    border: isSelected
                        ? Border.all(
                            color: context.colorScheme.primary,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _periodIcon(period),
                        color: isSelected
                            ? context.colorScheme.primary
                            : context.colorScheme.onSurfaceVariant,
                      ),
                      AppSpacing.horizontalMd,
                      Expanded(
                        child: Text(
                          _periodLabel(period),
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color:
                                isSelected ? context.colorScheme.primary : null,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle_rounded,
                          color: context.colorScheme.primary,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),

          AppSpacing.verticalXl,

          // Money to budget field.
          Text(
            'How much do you want to budget?',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.verticalSm,
          Text(
            'Enter the total amount you have available to budget for this period.',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalMd,
          TextField(
            controller: budgetAmountController,
            keyboardType: TextInputType.numberWithOptions(
              decimal: currency.decimalPlaces > 0,
            ),
            decoration: InputDecoration(
              hintText: '0',
              prefixText: '${currency.symbol} ',
              border: OutlineInputBorder(
                borderRadius: AppRadius.borderRadiusMd,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _periodLabel(BudgetPeriod period) {
    return switch (period) {
      BudgetPeriod.weekly => 'Weekly',
      BudgetPeriod.biWeekly => 'Bi-weekly (Every 2 weeks)',
      BudgetPeriod.monthly => 'Monthly',
    };
  }

  IconData _periodIcon(BudgetPeriod period) {
    return switch (period) {
      BudgetPeriod.weekly => Icons.view_week_rounded,
      BudgetPeriod.biWeekly => Icons.date_range_rounded,
      BudgetPeriod.monthly => Icons.calendar_month_rounded,
    };
  }
}

// ── Step 3: Category Allocations ────────────────────────────────

class _AllocationsStep extends StatelessWidget {
  const _AllocationsStep({
    required this.allocations,
    required this.budgetAmount,
    required this.onChanged,
  });

  final List<_CategoryAllocationData> allocations;
  final Money budgetAmount;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final currency = budgetAmount.currency;

    // Group allocations by groupName.
    final groups = <String, List<_CategoryAllocationData>>{};
    for (final alloc in allocations) {
      groups.putIfAbsent(alloc.groupName, () => []).add(alloc);
    }

    final totalAllocated = _totalOf(allocations, currency);
    final remaining = budgetAmount - totalAllocated;
    final isOverBudget = remaining.isNegative;

    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customize Allocations',
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.verticalSm,
          Text(
            'Adjust amounts for each spending category.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalMd,

          // Live remaining counter.
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: isOverBudget
                  ? context.colorScheme.errorContainer
                  : context.colorScheme.primaryContainer.withValues(alpha: 0.4),
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOverBudget ? 'OVER BUDGET' : 'REMAINING',
                      style: context.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: isOverBudget
                            ? context.colorScheme.error
                            : context.colorScheme.primary,
                      ),
                    ),
                    AppSpacing.verticalXs,
                    Text(
                      context.formatMoney(
                        isOverBudget ? -remaining : remaining,
                      ),
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isOverBudget
                            ? context.colorScheme.error
                            : context.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'ALLOCATED',
                      style: context.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    AppSpacing.verticalXs,
                    Text(
                      '${context.formatMoney(totalAllocated)}'
                      ' / '
                      '${context.formatMoney(budgetAmount)}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.verticalLg,

          ...groups.entries.map((entry) {
            return _AllocationGroup(
              groupName: entry.key,
              allocations: entry.value,
              currency: currency,
              onChanged: onChanged,
            );
          }),
        ],
      ),
    );
  }
}

class _AllocationGroup extends StatelessWidget {
  const _AllocationGroup({
    required this.groupName,
    required this.allocations,
    required this.currency,
    required this.onChanged,
  });

  final String groupName;
  final List<_CategoryAllocationData> allocations;
  final Currency currency;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final groupTotal = _totalOf(allocations, currency);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerLow,
          borderRadius: AppRadius.borderRadiusLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    groupName.toUpperCase(),
                    style: context.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    context.formatMoney(groupTotal),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            ...allocations.map((alloc) {
              return _AllocationRow(
                allocation: alloc,
                currency: currency,
                onChanged: onChanged,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _AllocationRow extends StatefulWidget {
  const _AllocationRow({
    required this.allocation,
    required this.currency,
    required this.onChanged,
  });

  final _CategoryAllocationData allocation;
  final Currency currency;
  final VoidCallback onChanged;

  @override
  State<_AllocationRow> createState() => _AllocationRowState();
}

class _AllocationRowState extends State<_AllocationRow> {
  final _controller = TextEditingController();
  bool _filled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Filled once the locale is known; later typing must not be replaced.
    if (_filled) return;
    _filled = true;
    final amount = widget.allocation.amountIn(widget.currency);
    if (amount.isPositive) {
      _controller.text = amount.format(locale: _locale, withSymbol: false);
    }
  }

  String get _locale => Localizations.localeOf(context).toString();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              widget.allocation.name,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          AppSpacing.horizontalSm,
          if (widget.allocation.percentage > 0)
            SizedBox(
              width: 48,
              child: Text(
                '${widget.allocation.percentage.toStringAsFixed(0)}%',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          AppSpacing.horizontalSm,
          SizedBox(
            width: 120,
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(
                decimal: widget.currency.decimalPlaces > 0,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: '0',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.borderRadiusSm,
                ),
              ),
              controller: _controller,
              onChanged: (value) {
                final amount =
                    Money.tryParse(value, widget.currency, locale: _locale);
                widget.allocation.amountMinor =
                    amount == null || amount.isNegative ? 0 : amount.minorUnits;
                widget.onChanged();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step 4: Confirm ─────────────────────────────────────────────

class _ConfirmStep extends StatelessWidget {
  const _ConfirmStep({
    required this.strategy,
    required this.period,
    required this.budgetAmount,
    required this.allocations,
  });

  final BudgetStrategy strategy;
  final BudgetPeriod period;
  final Money budgetAmount;
  final List<_CategoryAllocationData> allocations;

  @override
  Widget build(BuildContext context) {
    final currency = budgetAmount.currency;
    final totalAllocated = _totalOf(allocations, currency);

    // Group allocations.
    final groups = <String, List<_CategoryAllocationData>>{};
    for (final alloc in allocations) {
      if (alloc.amountMinor > 0) {
        groups.putIfAbsent(alloc.groupName, () => []).add(alloc);
      }
    }

    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Your Budget',
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.verticalSm,
          Text(
            'Confirm the details below to create your budget.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalXl,

          // Summary card.
          Container(
            padding: AppSpacing.paddingLg,
            decoration: BoxDecoration(
              color: context.colorScheme.primaryContainer.withValues(
                alpha: 0.3,
              ),
              borderRadius: AppRadius.borderRadiusLg,
            ),
            child: Column(
              children: [
                _ConfirmRow(
                  label: 'Strategy',
                  value: _strategyLabel(strategy),
                  context: context,
                ),
                AppSpacing.verticalSm,
                _ConfirmRow(
                  label: 'Period',
                  value: _periodLabel(period),
                  context: context,
                ),
                AppSpacing.verticalSm,
                _ConfirmRow(
                  label: 'Money to Budget',
                  value: context.formatMoney(budgetAmount),
                  context: context,
                ),
                AppSpacing.verticalSm,
                _ConfirmRow(
                  label: 'Total Allocated',
                  value: context.formatMoney(totalAllocated),
                  context: context,
                  isBold: true,
                ),
                AppSpacing.verticalSm,
                _ConfirmRow(
                  label: totalAllocated > budgetAmount
                      ? 'Over Budget'
                      : 'Remaining',
                  value: context.formatMoney(
                    Money.fromMinorUnits(
                      (budgetAmount - totalAllocated).minorUnits.abs(),
                      currency,
                    ),
                  ),
                  context: context,
                  isWarning: totalAllocated > budgetAmount,
                ),
              ],
            ),
          ),

          if (totalAllocated > budgetAmount) ...[
            AppSpacing.verticalMd,
            Container(
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: context.colorScheme.errorContainer,
                borderRadius: AppRadius.borderRadiusMd,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: context.colorScheme.error,
                    size: 20,
                  ),
                  AppSpacing.horizontalSm,
                  Expanded(
                    child: Text(
                      'Your allocations exceed your available budget by '
                      '${context.formatMoney(totalAllocated - budgetAmount)}. '
                      'Go back and adjust your amounts.',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          AppSpacing.verticalXl,

          // Category breakdown.
          Text(
            'Category Breakdown',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.verticalMd,

          ...groups.entries.map((entry) {
            final groupTotal = _totalOf(entry.value, currency);
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerLow,
                borderRadius: AppRadius.borderRadiusMd,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        context.formatMoney(groupTotal),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.verticalSm,
                  ...entry.value.map((alloc) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            alloc.name,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            context.formatMoney(alloc.amountIn(currency)),
                            style: context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _strategyLabel(BudgetStrategy strategy) {
    return switch (strategy) {
      BudgetStrategy.fiftyThirtyTwenty => '50/30/20 Rule',
      BudgetStrategy.eightyTwenty => '80/20 Entrepreneur',
      BudgetStrategy.envelope => 'Envelope System',
      BudgetStrategy.custom => 'Custom',
    };
  }

  String _periodLabel(BudgetPeriod period) {
    return switch (period) {
      BudgetPeriod.weekly => 'Weekly',
      BudgetPeriod.biWeekly => 'Bi-weekly',
      BudgetPeriod.monthly => 'Monthly',
    };
  }
}

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow({
    required this.label,
    required this.value,
    required this.context,
    this.isBold = false,
    this.isWarning = false,
  });

  final String label;
  final String value;
  final BuildContext context;
  final bool isBold;
  final bool isWarning;

  @override
  Widget build(BuildContext buildContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: buildContext.textTheme.bodyMedium?.copyWith(
            color: isWarning
                ? buildContext.colorScheme.error
                : buildContext.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: buildContext.textTheme.bodyMedium?.copyWith(
            fontWeight:
                (isBold || isWarning) ? FontWeight.w700 : FontWeight.w500,
            color: isWarning
                ? buildContext.colorScheme.error
                : isBold
                    ? buildContext.colorScheme.primary
                    : null,
          ),
        ),
      ],
    );
  }
}

// ── Navigation Buttons ──────────────────────────────────────────

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons({
    required this.currentStep,
    required this.isCreating,
    required this.isEditMode,
    required this.onNext,
    required this.onPrevious,
    required this.onConfirm,
  });

  final int currentStep;
  final bool isCreating;
  final bool isEditMode;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Row(
          children: [
            if (currentStep > 0)
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: onPrevious,
                    child: const Text('Back'),
                  ),
                ),
              ),
            if (currentStep > 0) AppSpacing.horizontalMd,
            Expanded(
              flex: currentStep == 0 ? 2 : 1,
              child: SizedBox(
                height: 52,
                child: currentStep == 3
                    ? FilledButton(
                        onPressed: isCreating ? null : onConfirm,
                        child: isCreating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                isEditMode ? 'Update Budget' : 'Create Budget'),
                      )
                    : FilledButton(
                        onPressed: onNext,
                        child: const Text('Continue'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data Models ─────────────────────────────────────────────────

class _CategoryAllocationData {
  _CategoryAllocationData({
    required this.categoryId,
    required this.name,
    required this.groupName,
    required this.percentage,
    this.amountMinor = 0,
  });

  final String categoryId;
  final String name;
  final String groupName;
  final double percentage;

  /// Allocated amount, in minor units of the base currency.
  int amountMinor;

  Money amountIn(Currency currency) =>
      Money.fromMinorUnits(amountMinor, currency);
}

/// Sum of [allocations], exactly, in [currency].
Money _totalOf(
  Iterable<_CategoryAllocationData> allocations,
  Currency currency,
) =>
    Money.sum(allocations.map((a) => a.amountIn(currency)), currency);

class _StrategyData {
  const _StrategyData({
    required this.strategy,
    required this.name,
    required this.description,
    required this.breakdown,
    required this.icon,
  });

  final BudgetStrategy strategy;
  final String name;
  final String description;
  final String breakdown;
  final IconData icon;
}

const _strategies = [
  _StrategyData(
    strategy: BudgetStrategy.fiftyThirtyTwenty,
    name: '50/30/20 Rule',
    description:
        'A balanced approach that splits your income into needs, wants, '
        'and savings.',
    breakdown: '50% Needs - 30% Wants - 20% Savings',
    icon: Icons.pie_chart_rounded,
  ),
  _StrategyData(
    strategy: BudgetStrategy.eightyTwenty,
    name: '80/20 Entrepreneur',
    description:
        'For business owners: reinvest 80% into essentials and business, '
        'save 20%.',
    breakdown: '80% Essentials & Business - 20% Savings',
    icon: Icons.business_center_rounded,
  ),
  _StrategyData(
    strategy: BudgetStrategy.envelope,
    name: 'Envelope System',
    description: 'Assign fixed amounts to each category. When the envelope is '
        'empty, stop spending.',
    breakdown: 'Fixed amounts per category',
    icon: Icons.mail_rounded,
  ),
  _StrategyData(
    strategy: BudgetStrategy.custom,
    name: 'Custom',
    description: 'Set your own percentages and amounts for full control over '
        'your budget.',
    breakdown: 'You decide the split',
    icon: Icons.tune_rounded,
  ),
];

/// Builds the default category allocations for a given strategy.
List<_CategoryAllocationData> _buildDefaultAllocations(
  BudgetStrategy strategy,
) {
  switch (strategy) {
    case BudgetStrategy.fiftyThirtyTwenty:
      return [
        // Needs (50%)
        _CategoryAllocationData(
          categoryId: 'cat_food',
          name: 'Food & Groceries',
          groupName: 'Needs',
          percentage: 15,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_rent',
          name: 'Rent',
          groupName: 'Needs',
          percentage: 15,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_transport',
          name: 'Transport',
          groupName: 'Needs',
          percentage: 10,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_utilities',
          name: 'Utilities',
          groupName: 'Needs',
          percentage: 5,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_health',
          name: 'Health',
          groupName: 'Needs',
          percentage: 5,
        ),
        // Wants (30%)
        _CategoryAllocationData(
          categoryId: 'cat_entertainment',
          name: 'Entertainment',
          groupName: 'Wants',
          percentage: 10,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_clothing',
          name: 'Clothing',
          groupName: 'Wants',
          percentage: 5,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_airtime',
          name: 'Airtime & Data',
          groupName: 'Wants',
          percentage: 5,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_personal_care',
          name: 'Personal Care',
          groupName: 'Wants',
          percentage: 5,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_family_support',
          name: 'Family Support',
          groupName: 'Wants',
          percentage: 5,
        ),
        // Savings (20%)
        _CategoryAllocationData(
          categoryId: 'cat_savings_contrib',
          name: 'Savings',
          groupName: 'Savings',
          percentage: 10,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_debt',
          name: 'Debt Repayment',
          groupName: 'Savings',
          percentage: 5,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_religious',
          name: 'Religious Giving',
          groupName: 'Savings',
          percentage: 5,
        ),
      ];

    case BudgetStrategy.eightyTwenty:
      return [
        // Essentials & Business (80%)
        _CategoryAllocationData(
          categoryId: 'cat_food',
          name: 'Food & Groceries',
          groupName: 'Essentials & Business',
          percentage: 15,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_rent',
          name: 'Rent',
          groupName: 'Essentials & Business',
          percentage: 15,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_transport',
          name: 'Transport',
          groupName: 'Essentials & Business',
          percentage: 10,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_business',
          name: 'Business Expenses',
          groupName: 'Essentials & Business',
          percentage: 20,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_utilities',
          name: 'Utilities',
          groupName: 'Essentials & Business',
          percentage: 5,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_airtime',
          name: 'Airtime & Data',
          groupName: 'Essentials & Business',
          percentage: 5,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_momo_fees',
          name: 'Mobile Money Fees',
          groupName: 'Essentials & Business',
          percentage: 5,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_health',
          name: 'Health',
          groupName: 'Essentials & Business',
          percentage: 5,
        ),
        // Savings (20%)
        _CategoryAllocationData(
          categoryId: 'cat_savings_contrib',
          name: 'Savings',
          groupName: 'Savings',
          percentage: 15,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_debt',
          name: 'Debt Repayment',
          groupName: 'Savings',
          percentage: 5,
        ),
      ];

    case BudgetStrategy.envelope:
    case BudgetStrategy.custom:
      return [
        // Needs
        _CategoryAllocationData(
          categoryId: 'cat_food',
          name: 'Food & Groceries',
          groupName: 'Needs',
          percentage: 0,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_rent',
          name: 'Rent',
          groupName: 'Needs',
          percentage: 0,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_transport',
          name: 'Transport',
          groupName: 'Needs',
          percentage: 0,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_utilities',
          name: 'Utilities',
          groupName: 'Needs',
          percentage: 0,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_health',
          name: 'Health',
          groupName: 'Needs',
          percentage: 0,
        ),
        // Wants
        _CategoryAllocationData(
          categoryId: 'cat_entertainment',
          name: 'Entertainment',
          groupName: 'Wants',
          percentage: 0,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_clothing',
          name: 'Clothing',
          groupName: 'Wants',
          percentage: 0,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_airtime',
          name: 'Airtime & Data',
          groupName: 'Wants',
          percentage: 0,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_personal_care',
          name: 'Personal Care',
          groupName: 'Wants',
          percentage: 0,
        ),
        // Savings
        _CategoryAllocationData(
          categoryId: 'cat_savings_contrib',
          name: 'Savings',
          groupName: 'Savings',
          percentage: 0,
        ),
        _CategoryAllocationData(
          categoryId: 'cat_debt',
          name: 'Debt Repayment',
          groupName: 'Savings',
          percentage: 0,
        ),
      ];
  }
}
