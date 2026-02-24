import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/repositories/budgets_repository.dart';

/// Gets the currently active budget (where today falls within the date range).
class GetActiveBudgetUseCase extends UseCase<Budget?, NoParams> {
  const GetActiveBudgetUseCase(this._repository);

  final BudgetsRepository _repository;

  @override
  Future<Either<Failure, Budget?>> call(NoParams params) {
    return _repository.getActiveBudget();
  }
}
