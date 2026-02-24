import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/repositories/budgets_repository.dart';

/// Gets all budgets.
class GetBudgetsUseCase extends UseCase<List<Budget>, NoParams> {
  const GetBudgetsUseCase(this._repository);

  final BudgetsRepository _repository;

  @override
  Future<Either<Failure, List<Budget>>> call(NoParams params) {
    return _repository.getBudgets();
  }
}
