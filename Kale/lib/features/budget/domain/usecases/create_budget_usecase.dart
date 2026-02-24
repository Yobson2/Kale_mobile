import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/domain/repositories/budgets_repository.dart';

/// Creates a new budget with category allocations.
/// Works offline via local save + sync queue.
class CreateBudgetUseCase extends UseCase<Budget, CreateBudgetParams> {
  const CreateBudgetUseCase(this._repository);

  final BudgetsRepository _repository;

  @override
  Future<Either<Failure, Budget>> call(CreateBudgetParams params) {
    return _repository.createBudget(
      name: params.name,
      strategy: params.strategy,
      period: params.period,
      startDate: params.startDate,
      endDate: params.endDate,
      totalIncome: params.totalIncome,
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
    required this.startDate,
    required this.endDate,
    required this.categories,
    this.totalIncome,
    this.isPercentageBased = true,
  });

  final String name;
  final BudgetStrategy strategy;
  final BudgetPeriod period;
  final DateTime startDate;
  final DateTime endDate;
  final double? totalIncome;
  final bool isPercentageBased;
  final List<BudgetCategoryAllocation> categories;
}
