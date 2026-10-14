import 'package:dartz/dartz.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/domain/entities/budget_period_range.dart';
import 'package:kale/features/budget/domain/repositories/budgets_repository.dart';

/// Updates an existing budget with category allocations. The period's
/// dates are kept as given.
class UpdateBudgetUseCase extends UseCase<Budget, UpdateBudgetParams> {
  const UpdateBudgetUseCase(this._repository);

  final BudgetsRepository _repository;

  @override
  Future<Either<Failure, Budget>> call(UpdateBudgetParams params) {
    return _repository.updateBudget(
      id: params.id,
      name: params.name,
      strategy: params.strategy,
      period: params.period,
      startDate: params.startDate,
      endDate: params.endDate,
      periodStartDay: params.periodStartDay,
      totalIncomeMinor: params.totalIncomeMinor,
      isPercentageBased: params.isPercentageBased,
      categories: params.categories,
    );
  }
}

/// Parameters for [UpdateBudgetUseCase].
class UpdateBudgetParams {
  const UpdateBudgetParams({
    required this.id,
    required this.name,
    required this.strategy,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.categories,
    this.periodStartDay = BudgetPeriodRange.defaultStartDay,
    this.totalIncomeMinor,
    this.isPercentageBased = true,
  });

  final String id;
  final String name;
  final BudgetStrategy strategy;
  final BudgetPeriod period;
  final CalendarDate startDate;
  final CalendarDate endDate;
  final int periodStartDay;

  /// Expected income for the period, in minor units of the base currency.
  final int? totalIncomeMinor;
  final bool isPercentageBased;
  final List<BudgetCategoryAllocation> categories;
}
