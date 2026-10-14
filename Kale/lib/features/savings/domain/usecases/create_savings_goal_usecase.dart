import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';
import 'package:kale/features/savings/domain/repositories/savings_repository.dart';

/// Creates a new savings goal.
class CreateSavingsGoalUseCase
    extends UseCase<SavingsGoal, CreateSavingsGoalParams> {
  /// Creates a [CreateSavingsGoalUseCase].
  const CreateSavingsGoalUseCase(this._repository);

  final SavingsRepository _repository;

  @override
  Future<Either<Failure, SavingsGoal>> call(
    CreateSavingsGoalParams params,
  ) {
    return _repository.createSavingsGoal(
      name: params.name,
      targetAmountMinor: params.targetAmountMinor,
      description: params.description,
      deadline: params.deadline,
      iconName: params.iconName,
      colorHex: params.colorHex,
    );
  }
}

/// Parameters for [CreateSavingsGoalUseCase].
class CreateSavingsGoalParams {
  /// Creates [CreateSavingsGoalParams].
  const CreateSavingsGoalParams({
    required this.name,
    required this.targetAmountMinor,
    this.description,
    this.deadline,
    this.iconName,
    this.colorHex,
  });

  final String name;

  /// Target, in minor units of the base currency.
  final int targetAmountMinor;
  final String? description;
  final DateTime? deadline;
  final String? iconName;
  final String? colorHex;
}
