import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';

/// Abstract budgets repository defined in the domain layer.
abstract class BudgetsRepository {
  /// Gets all budgets.
  Future<Either<Failure, List<Budget>>> getBudgets();

  /// Watches budgets reactively.
  Stream<List<Budget>> watchBudgets();

  /// Gets the currently active budget (where today is within the date range).
  Future<Either<Failure, Budget?>> getActiveBudget();

  /// Creates a new budget with category allocations.
  Future<Either<Failure, Budget>> createBudget({
    required String name,
    required BudgetStrategy strategy,
    required BudgetPeriod period,
    required DateTime startDate,
    required DateTime endDate,
    required List<BudgetCategoryAllocation> categories,
    double? totalIncome,
    bool isPercentageBased = true,
  });

  /// Updates an existing budget.
  Future<Either<Failure, Budget>> updateBudget({
    required String id,
    required String name,
    required BudgetStrategy strategy,
    required BudgetPeriod period,
    required DateTime startDate,
    required DateTime endDate,
    required List<BudgetCategoryAllocation> categories,
    double? totalIncome,
    bool isPercentageBased = true,
  });

  /// Deletes a budget by ID.
  Future<Either<Failure, void>> deleteBudget(String id);

  /// Triggers a full refresh from the server.
  Future<Either<Failure, void>> refreshFromServer();
}
