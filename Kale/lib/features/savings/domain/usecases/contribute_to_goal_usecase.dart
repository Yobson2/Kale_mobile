import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/savings/domain/entities/savings_contribution.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';
import 'package:kale/features/savings/domain/repositories/savings_repository.dart';

/// Contributes money to an existing savings goal.
class ContributeToGoalUseCase
    extends UseCase<SavingsContribution, ContributeToGoalParams> {
  /// Creates a [ContributeToGoalUseCase].
  const ContributeToGoalUseCase(this._repository);

  final SavingsRepository _repository;

  @override
  Future<Either<Failure, SavingsContribution>> call(
    ContributeToGoalParams params,
  ) {
    return _repository.contributeToGoal(
      goalId: params.goalId,
      amountMinor: params.amountMinor,
      source: params.source,
      note: params.note,
    );
  }
}

/// Parameters for [ContributeToGoalUseCase].
class ContributeToGoalParams {
  /// Creates [ContributeToGoalParams].
  const ContributeToGoalParams({
    required this.goalId,
    required this.amountMinor,
    this.source = ContributionSource.manual,
    this.note,
  });

  final String goalId;

  /// Amount, in minor units of the base currency.
  final int amountMinor;
  final ContributionSource source;
  final String? note;
}
