import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';
import 'package:kale/features/savings/domain/repositories/savings_repository.dart';

/// Updates an existing savings goal (its saved amount is unchanged).
class UpdateSavingsGoalUseCase
    extends UseCase<SavingsGoal, UpdateSavingsGoalParams> {
  /// Creates an [UpdateSavingsGoalUseCase].
  const UpdateSavingsGoalUseCase(this._repository);

  final SavingsRepository _repository;

  @override
  Future<Either<Failure, SavingsGoal>> call(
    UpdateSavingsGoalParams params,
  ) {
    return _repository.updateSavingsGoal(
      id: params.id,
      name: params.name,
      targetAmountMinor: params.targetAmountMinor,
      status: params.status,
      description: params.description,
      deadline: params.deadline,
      iconName: params.iconName,
      colorHex: params.colorHex,
    );
  }
}

/// Parameters for [UpdateSavingsGoalUseCase].
class UpdateSavingsGoalParams {
  /// Creates [UpdateSavingsGoalParams].
  const UpdateSavingsGoalParams({
    required this.id,
    required this.name,
    required this.targetAmountMinor,
    required this.status,
    this.description,
    this.deadline,
    this.iconName,
    this.colorHex,
  });

  final String id;
  final String name;

  /// Target, in minor units of the base currency.
  final int targetAmountMinor;
  final SavingsGoalStatus status;
  final String? description;
  final DateTime? deadline;
  final String? iconName;
  final String? colorHex;
}
