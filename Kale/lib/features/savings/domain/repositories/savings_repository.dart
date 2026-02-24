import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/features/savings/domain/entities/savings_contribution.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';

/// Abstract repository for savings goals.
abstract class SavingsRepository {
  /// Gets all savings goals, optionally filtered by [status].
  Future<Either<Failure, List<SavingsGoal>>> getSavingsGoals({
    SavingsGoalStatus? status,
  });

  /// Watches all savings goals as a reactive stream.
  Stream<List<SavingsGoal>> watchSavingsGoals();

  /// Gets a single savings goal by [id].
  Future<Either<Failure, SavingsGoal>> getSavingsGoalById(String id);

  /// Creates a new savings goal.
  Future<Either<Failure, SavingsGoal>> createSavingsGoal({
    required String name,
    required double targetAmount,
    required String currencyCode,
    String? description,
    DateTime? deadline,
    String? iconName,
    String? colorHex,
  });

  /// Updates an existing savings goal.
  Future<Either<Failure, SavingsGoal>> updateSavingsGoal({
    required String id,
    required String name,
    required double targetAmount,
    required String currencyCode,
    required SavingsGoalStatus status,
    String? description,
    DateTime? deadline,
    String? iconName,
    String? colorHex,
  });

  /// Deletes a savings goal by [id].
  Future<Either<Failure, void>> deleteSavingsGoal(String id);

  /// Adds a contribution to a savings goal.
  Future<Either<Failure, SavingsContribution>> contributeToGoal({
    required String goalId,
    required double amount,
    required ContributionSource source,
    String? note,
  });

  /// Gets contribution history for a goal.
  Future<Either<Failure, List<SavingsContribution>>> getContributions(
    String goalId,
  );

  /// Watches contributions for a goal as a reactive stream.
  Stream<List<SavingsContribution>> watchContributions(String goalId);

  /// Refreshes savings goals from server.
  Future<Either<Failure, void>> refreshFromServer();
}
