import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/features/savings/domain/entities/savings_contribution.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';

/// Repository for savings goals and their contributions.
///
/// Amounts are integer minor units of the account's base currency.
abstract class SavingsRepository {
  /// Gets all savings goals, optionally filtered by [status].
  Future<Either<Failure, List<SavingsGoal>>> getSavingsGoals({
    SavingsGoalStatus? status,
  });

  /// Watches all savings goals as a reactive stream.
  Stream<List<SavingsGoal>> watchSavingsGoals();

  /// Gets a single savings goal by [id].
  Future<Either<Failure, SavingsGoal>> getSavingsGoalById(String id);

  /// Creates a new savings goal with nothing saved yet.
  Future<Either<Failure, SavingsGoal>> createSavingsGoal({
    required String name,
    required int targetAmountMinor,
    String? description,
    DateTime? deadline,
    String? iconName,
    String? colorHex,
  });

  /// Updates an existing savings goal. Its saved amount is unchanged.
  Future<Either<Failure, SavingsGoal>> updateSavingsGoal({
    required String id,
    required String name,
    required int targetAmountMinor,
    required SavingsGoalStatus status,
    String? description,
    DateTime? deadline,
    String? iconName,
    String? colorHex,
  });

  /// Deletes a savings goal by [id], with its contributions.
  Future<Either<Failure, void>> deleteSavingsGoal(String id);

  /// Adds a contribution of [amountMinor] to a goal.
  ///
  /// The goal's saved amount becomes the sum of its contributions, and an
  /// active goal that reaches its target is marked completed. Both the
  /// contribution and the goal change are queued for sync.
  Future<Either<Failure, SavingsContribution>> contributeToGoal({
    required String goalId,
    required int amountMinor,
    required ContributionSource source,
    String? note,
  });

  /// Gets contribution history for a goal.
  Future<Either<Failure, List<SavingsContribution>>> getContributions(
    String goalId,
  );

  /// Watches contributions for a goal as a reactive stream.
  Stream<List<SavingsContribution>> watchContributions(String goalId);
}
