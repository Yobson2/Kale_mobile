import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/features/savings/data/tables/savings_contributions_table.dart';

part 'savings_contributions_dao.g.dart';

/// DAO for savings contribution CRUD operations.
@DriftAccessor(tables: [SavingsContributions])
class SavingsContributionsDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsContributionsDaoMixin {
  /// Creates a [SavingsContributionsDao].
  SavingsContributionsDao(super.db);

  /// Watches contributions for a specific goal.
  Stream<List<SavingsContribution>> watchByGoalId(String goalId) {
    return (select(savingsContributions)
          ..where((t) => t.goalId.equals(goalId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  /// Gets all contributions for a specific goal.
  Future<List<SavingsContribution>> getByGoalId(String goalId) {
    return (select(savingsContributions)
          ..where((t) => t.goalId.equals(goalId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  /// Gets total contributed for a goal.
  Future<double> getTotalByGoalId(String goalId) async {
    final sumExpr = savingsContributions.amount.sum();
    final query = selectOnly(savingsContributions)
      ..addColumns([sumExpr])
      ..where(savingsContributions.goalId.equals(goalId));
    final row = await query.getSingle();
    return row.read(sumExpr) ?? 0.0;
  }

  /// Inserts a contribution.
  Future<void> insert(SavingsContributionsCompanion entry) =>
      into(savingsContributions).insertOnConflictUpdate(entry);

  /// Deletes contributions for a goal.
  Future<void> deleteByGoalId(String goalId) =>
      (delete(savingsContributions)..where((t) => t.goalId.equals(goalId)))
          .go();

  /// Replaces all contributions for a goal (server refresh).
  Future<void> replaceForGoal(
    String goalId,
    List<SavingsContributionsCompanion> entries,
  ) {
    return transaction(() async {
      await (delete(savingsContributions)
            ..where((t) => t.goalId.equals(goalId)))
          .go();
      await batch((b) => b.insertAll(savingsContributions, entries));
    });
  }
}
