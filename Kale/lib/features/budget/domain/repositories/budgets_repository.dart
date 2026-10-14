import 'package:dartz/dartz.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/domain/entities/budget_period_range.dart';

/// Abstract budgets repository defined in the domain layer.
///
/// Amounts are integer minor units of the account's base currency.
/// Periods are calendar days, `startDate` to `endDate` both included.
abstract class BudgetsRepository {
  /// Gets all budgets.
  Future<Either<Failure, List<Budget>>> getBudgets();

  /// Watches budgets reactively.
  Stream<List<Budget>> watchBudgets();

  /// Gets the budget whose period covers [today] (the most recently
  /// created one if several do), or null.
  Future<Either<Failure, Budget?>> getActiveBudget({
    required CalendarDate today,
  });

  /// Creates a new budget with category allocations.
  Future<Either<Failure, Budget>> createBudget({
    required String name,
    required BudgetStrategy strategy,
    required BudgetPeriod period,
    required CalendarDate startDate,
    required CalendarDate endDate,
    required List<BudgetCategoryAllocation> categories,
    int periodStartDay = BudgetPeriodRange.defaultStartDay,
    int? totalIncomeMinor,
    bool isPercentageBased = true,
  });

  /// Updates an existing budget.
  Future<Either<Failure, Budget>> updateBudget({
    required String id,
    required String name,
    required BudgetStrategy strategy,
    required BudgetPeriod period,
    required CalendarDate startDate,
    required CalendarDate endDate,
    required List<BudgetCategoryAllocation> categories,
    int periodStartDay = BudgetPeriodRange.defaultStartDay,
    int? totalIncomeMinor,
    bool isPercentageBased = true,
  });

  /// Deletes a budget by ID.
  Future<Either<Failure, void>> deleteBudget(String id);

  /// Triggers a full refresh from the server.
  Future<Either<Failure, void>> refreshFromServer();
}
