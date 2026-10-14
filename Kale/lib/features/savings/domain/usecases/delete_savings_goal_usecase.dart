import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/savings/domain/repositories/savings_repository.dart';

/// Deletes a savings goal, with its contributions. Takes the goal's id.
class DeleteSavingsGoalUseCase extends UseCase<void, String> {
  /// Creates a [DeleteSavingsGoalUseCase].
  const DeleteSavingsGoalUseCase(this._repository);

  final SavingsRepository _repository;

  @override
  Future<Either<Failure, void>> call(String goalId) =>
      _repository.deleteSavingsGoal(goalId);
}
