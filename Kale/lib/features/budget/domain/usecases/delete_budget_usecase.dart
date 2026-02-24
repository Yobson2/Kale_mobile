import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/budget/domain/repositories/budgets_repository.dart';

/// Deletes a budget by ID.
class DeleteBudgetUseCase extends UseCase<void, String> {
  const DeleteBudgetUseCase(this._repository);

  final BudgetsRepository _repository;

  @override
  Future<Either<Failure, void>> call(String params) {
    return _repository.deleteBudget(params);
  }
}
