import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';
import 'package:kale/core/widgets/layout/app_step_indicator.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/presentation/providers/budgets_notifier.dart';

/// Multi-step budget setup wizard.
///
/// Steps:
/// 1. Choose strategy (50/30/20, 80/20, Envelope, Custom)
/// 2. Set period and optional income amount
/// 3. Review/customize category allocations per group
/// 4. Confirm and create
class BudgetSetupPage extends ConsumerStatefulWidget {
  /// Creates a [BudgetSetupPage].
  const BudgetSetupPage({super.key});

  @override
  ConsumerState<BudgetSetupPage> createState() => _BudgetSetupPageState();
}

class _BudgetSetupPageState extends ConsumerState<BudgetSetupPage> {
  int _currentStep = 0;
  final _pageController = PageController();

  // Step 1: Strategy.
  BudgetStrategy _selectedStrategy = BudgetStrategy.fiftyThirtyTwenty;

  // Step 2: Period & Income.
  BudgetPeriod _selectedPeriod = BudgetPeriod.monthly;
  final _incomeController = TextEditingController();
  double? _income;

  // Step 3: Category allocations.
  late List<_CategoryAllocationData> _allocations;

  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _allocations = _buildDefaultAllocations(_selectedStrategy);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _incomeController.dispose();
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
        _income = double.tryParse(_incomeController.text);
        if (_income != null && _income! > 0) {
          _applyIncomeToAllocations();
        }
      }
      _goToStep(_currentStep + 1);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _goToStep(_currentStep - 1);
    }
  }

  void _applyIncomeToAllocations() {
    if (_income == null || _income! <= 0) return;
    for (final alloc in _allocations) {
      if (alloc.percentage > 0) {
        alloc.amount = _income! * (alloc.percentage / 100);
      }
    }
  }

  Future<void> _createBudget() async {
    if (_isCreating) return;
    setState(() => _isCreating = true);

    final now = DateTime.now();
    late DateTime startDate;
    late DateTime endDate;

    switch (_selectedPeriod) {
      case BudgetPeriod.weekly:
        final weekday = now.weekday;
        startDate = DateTime(now.year, now.month, now.day - (weekday - 1));
        endDate = startDate.add(const Duration(days: 7));
      case BudgetPeriod.biWeekly:
        startDate = DateTime(now.year, now.month, now.day);
        endDate = startDate.add(const Duration(days: 14));
      case BudgetPeriod.monthly:
        startDate = DateTime(now.year, now.month);
        endDate = DateTime(now.year, now.month + 1);
    }

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
    final budgetName = '${months[now.month]} ${now.year} Budget';

    final categories = _allocations
        .where((a) => a.amount > 0)
        .map(
          (a) => BudgetCategoryAllocation(
            id: '',
            budgetId: '',
            categoryId: a.categoryId,
            groupName: a.groupName,
            allocatedAmount: a.amount,
            allocatedPercentage: a.percentage > 0 ? a.percentage : null,
            spentAmount: 0,
            createdAt: now,
          ),
        )
        .toList();

    final notifier = ref.read(budgetsNotifierProvider.notifier);
    final success = await notifier.createBudget(
      name: budgetName,
      strategy: _selectedStrategy,
      period: _selectedPeriod,
      startDate: startDate,
      endDate: endDate,
      categories: categories,
      totalIncome: _income,
      isPercentageBased: _income == null,
    );

    if (mounted) {
      setState(() => _isCreating = false);
      if (success) {
        context.showSnackBar('Budget created successfully!');
        if (mounted) context.pop();
      } else {
        context.showSnackBar('Failed to create budget', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: 'Create Budget',
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
                    incomeController: _incomeController,
                    currencyCode: ref.watch(userCurrencyCodeProvider),
                    onPeriodChanged: (period) {
                      setState(() => _selectedPeriod = period);
                    },
                  ),
                  _AllocationsStep(
                    allocations: _allocations,
                    onChanged: () => setState(() {}),
                  ),
                  _ConfirmStep(
                    strategy: _selectedStrategy,
                    period: _selectedPeriod,
                    income: _income,
                    allocations: _allocations,
                  ),
                ],
              ),
            ),

            // Navigation buttons.
            _NavigationButtons(
              currentStep: _currentStep,
              isCreating: _isCreating,
              onNext: _nextStep,
              onPrevious: _previousStep,
              onConfirm: _createBudget,
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

// ── Step 2: Period & Income ──────────────────────────────────────

class _PeriodIncomeStep extends StatelessWidget {
  const _PeriodIncomeStep({
    required this.selectedPeriod,
    required this.incomeController,
    required this.currencyCode,
    required this.onPeriodChanged,
  });

  final BudgetPeriod selectedPeriod;
  final TextEditingController incomeController;
  final String currencyCode;
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

          // Income field.
          Text(
            'Expected Income (optional)',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.verticalSm,
          Text(
            'Enter your expected income to auto-calculate allocations.',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalMd,
          TextField(
            controller: incomeController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: '0.00',
              prefixText: '$currencyCode ',
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
    required this.onChanged,
  });

  final List<_CategoryAllocationData> allocations;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    // Group allocations by groupName.
    final groups = <String, List<_CategoryAllocationData>>{};
    for (final alloc in allocations) {
      groups.putIfAbsent(alloc.groupName, () => []).add(alloc);
    }

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
          AppSpacing.verticalXl,
          ...groups.entries.map((entry) {
            return _AllocationGroup(
              groupName: entry.key,
              allocations: entry.value,
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
    required this.onChanged,
  });

  final String groupName;
  final List<_CategoryAllocationData> allocations;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final groupTotal = allocations.fold<double>(
      0,
      (sum, a) => sum + a.amount,
    );

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
                    CurrencyFormatter.format(groupTotal, compact: true),
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
    required this.onChanged,
  });

  final _CategoryAllocationData allocation;
  final VoidCallback onChanged;

  @override
  State<_AllocationRow> createState() => _AllocationRowState();
}

class _AllocationRowState extends State<_AllocationRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.allocation.amount > 0
          ? widget.allocation.amount.toStringAsFixed(0)
          : '',
    );
  }

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
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
                widget.allocation.amount = double.tryParse(value) ?? 0;
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
    required this.income,
    required this.allocations,
  });

  final BudgetStrategy strategy;
  final BudgetPeriod period;
  final double? income;
  final List<_CategoryAllocationData> allocations;

  @override
  Widget build(BuildContext context) {
    final totalAllocated = allocations.fold<double>(
      0,
      (sum, a) => sum + a.amount,
    );

    // Group allocations.
    final groups = <String, List<_CategoryAllocationData>>{};
    for (final alloc in allocations) {
      if (alloc.amount > 0) {
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
                if (income != null && income! > 0) ...[
                  AppSpacing.verticalSm,
                  _ConfirmRow(
                    label: 'Income',
                    value: CurrencyFormatter.format(income!),
                    context: context,
                  ),
                ],
                AppSpacing.verticalSm,
                _ConfirmRow(
                  label: 'Total Budget',
                  value: CurrencyFormatter.format(totalAllocated),
                  context: context,
                  isBold: true,
                ),
              ],
            ),
          ),

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
            final groupTotal = entry.value.fold<double>(
              0,
              (sum, a) => sum + a.amount,
            );
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
                        CurrencyFormatter.format(groupTotal, compact: true),
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
                            CurrencyFormatter.format(
                              alloc.amount,
                              compact: true,
                            ),
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
  });

  final String label;
  final String value;
  final BuildContext context;
  final bool isBold;

  @override
  Widget build(BuildContext buildContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: buildContext.textTheme.bodyMedium?.copyWith(
            color: buildContext.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: buildContext.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isBold ? buildContext.colorScheme.primary : null,
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
    required this.onNext,
    required this.onPrevious,
    required this.onConfirm,
  });

  final int currentStep;
  final bool isCreating;
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
                            : const Text('Create Budget'),
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
    this.amount = 0,
  });

  final String categoryId;
  final String name;
  final String groupName;
  final double percentage;
  double amount;
}

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
