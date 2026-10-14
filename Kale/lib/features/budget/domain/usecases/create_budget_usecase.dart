import 'package:dartz/dartz.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/domain/entities/budget_period_range.dart';
import 'package:kale/features/budget/domain/repositories/budgets_repository.dart';

/// Creates a new budget for the period that contains [CreateBudgetParams.today],
/// computed from the period type and start day.
/// Works offline via local save + sync queue.
class CreateBudgetUseCase extends UseCase<Budget, CreateBudgetParams> {
  const CreateBudgetUseCase(this._repository);

  final BudgetsRepository _repository;

  @override
  Future<Either<Failure, Budget>> call(CreateBudgetParams params) {
    final range = BudgetPeriodRange.containing(
      params.today,
      period: params.period,
      startDay: params.periodStartDay,
    );
    return _repository.createBudget(
      name: params.name,
      strategy: params.strategy,
      period: params.period,
      startDate: range.start,
      endDate: range.end,
      periodStartDay: params.periodStartDay,
      totalIncomeMinor: params.totalIncomeMinor,
      isPercentageBased: params.isPercentageBased,
      categories: params.categories,
    );
  }
}

/// Parameters for [CreateBudgetUseCase].
class CreateBudgetParams {
  const CreateBudgetParams({
    required this.name,
    required this.strategy,
    required this.period,
    required this.today,
    required this.categories,
    this.periodStartDay = BudgetPeriodRange.defaultStartDay,
    this.totalIncomeMinor,
    this.isPercentageBased = true,
  });

  final String name;
  final BudgetStrategy strategy;
  final BudgetPeriod period;

  /// The day the budget is created on; its period is the one containing it.
  final CalendarDate today;

  /// See [BudgetPeriodRange.containing].
  final int periodStartDay;

  /// Expected income for the period, in minor units of the base currency.
  final int? totalIncomeMinor;
  final bool isPercentageBased;
  final List<BudgetCategoryAllocation> categories;
}
