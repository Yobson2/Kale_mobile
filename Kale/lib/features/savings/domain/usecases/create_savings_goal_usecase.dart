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
      targetAmount: params.targetAmount,
      currencyCode: params.currencyCode,
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
    required this.targetAmount,
    required this.currencyCode,
    this.description,
    this.deadline,
    this.iconName,
    this.colorHex,
  });

  final String name;
  final double targetAmount;
  final String currencyCode;
  final String? description;
  final DateTime? deadline;
  final String? iconName;
  final String? colorHex;
}
