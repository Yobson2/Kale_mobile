import 'package:dartz/dartz.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_period_range.dart';
import 'package:kale/features/budget/domain/repositories/budgets_repository.dart';

/// Starts an ended budget again for the period containing
/// [RenewBudgetParams.today] (decision Q21): same name, strategy, period
/// type, start day and expected income, and the same allocations. Amounts
/// are copied; nothing is carried over from the ended period.
///
/// Fails with a [ValidationFailure] if a budget already covers today, so a
/// period is never renewed twice.
class RenewBudgetUseCase extends UseCase<Budget, RenewBudgetParams> {
  /// Creates a [RenewBudgetUseCase].
  const RenewBudgetUseCase(this._repository);

  final BudgetsRepository _repository;

  @override
  Future<Either<Failure, Budget>> call(RenewBudgetParams params) async {
    final active = await _repository.getActiveBudget(today: params.today);
    return active.fold(Left.new, (current) {
      if (current != null) {
        return const Left(
          ValidationFailure(message: 'A budget already covers this period'),
        );
      }
      final ended = params.budget;
      final range = BudgetPeriodRange.containing(
        params.today,
        period: ended.period,
        startDay: ended.periodStartDay,
      );
      return _repository.createBudget(
        name: ended.name,
        strategy: ended.strategy,
        period: ended.period,
        startDate: range.start,
        endDate: range.end,
        periodStartDay: ended.periodStartDay,
        totalIncomeMinor: ended.totalIncomeMinor,
        isPercentageBased: ended.isPercentageBased,
        categories: [
          for (final allocation in ended.categories)
            BudgetCategoryAllocation(
              id: '',
              budgetId: '',
              categoryId: allocation.categoryId,
              groupName: allocation.groupName,
              allocatedMinor: allocation.allocatedMinor,
              allocatedPercentage: allocation.allocatedPercentage,
              spentMinor: 0,
              createdAt: allocation.createdAt,
            ),
        ],
      );
    });
  }
}

/// Parameters for [RenewBudgetUseCase].
class RenewBudgetParams {
  /// Creates [RenewBudgetParams].
  const RenewBudgetParams({required this.budget, required this.today});

  /// The ended budget to start again.
  final Budget budget;

  /// Today: the new budget covers the period containing it.
  final CalendarDate today;
}
