import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/features/savings/data/tables/savings_contributions_table.dart';

part 'savings_contributions_dao.g.dart';

/// DAO for savings contributions.
///
/// Every read excludes soft-deleted rows (`deletedAt` set). Sums are
/// integer minor units of the base currency.
@DriftAccessor(tables: [SavingsContributions])
class SavingsContributionsDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsContributionsDaoMixin {
  /// Creates a [SavingsContributionsDao].
  SavingsContributionsDao(super.db);

  /// Watches the live contributions of a goal, newest first.
  Stream<List<SavingsContribution>> watchByGoalId(String goalId) =>
      _liveForGoal(goalId).watch();

  /// Gets the live contributions of a goal, newest first.
  Future<List<SavingsContribution>> getByGoalId(String goalId) =>
      _liveForGoal(goalId).get();

  SimpleSelectStatement<$SavingsContributionsTable, SavingsContribution>
      _liveForGoal(String goalId) => select(savingsContributions)
        ..where((t) => t.goalId.equals(goalId) & t.deletedAt.isNull())
        ..orderBy([(t) => OrderingTerm.desc(t.date)]);

  /// The total contributed to a goal, in minor units.
  Future<int> getTotalByGoalId(String goalId) async {
    final sumExpr = savingsContributions.amountMinor.sum();
    final query = selectOnly(savingsContributions)
      ..addColumns([sumExpr])
      ..where(savingsContributions.goalId.equals(goalId))
      ..where(savingsContributions.deletedAt.isNull());
    final row = await query.getSingle();
    return row.read(sumExpr) ?? 0;
  }

  /// Inserts or updates a contribution.
  Future<void> upsert(SavingsContributionsCompanion entry) =>
      into(savingsContributions).insertOnConflictUpdate(entry);

  /// Deletes every contribution of a goal.
  Future<void> deleteByGoalId(String goalId) =>
      (delete(savingsContributions)..where((t) => t.goalId.equals(goalId)))
          .go();

  /// Marks a contribution as synced.
  Future<void> markSynced(String id, {String? serverId}) =>
      (update(savingsContributions)..where((t) => t.id.equals(id))).write(
        SavingsContributionsCompanion(
          isSynced: const Value(true),
          serverId: serverId != null ? Value(serverId) : const Value.absent(),
        ),
      );

  /// Replaces the synced contributions with the server's copy (server
  /// refresh).
  ///
  /// Contributions not yet pushed are kept as they are.
  Future<void> replaceAll(List<SavingsContributionsCompanion> entries) {
    return transaction(() async {
      final unsynced = (await (selectOnly(savingsContributions)
                ..addColumns([savingsContributions.id])
                ..where(savingsContributions.isSynced.equals(false)))
              .map((row) => row.read(savingsContributions.id)!)
              .get())
          .toSet();
      await (delete(savingsContributions)
            ..where((t) => t.isSynced.equals(true)))
          .go();
      await batch(
        (b) => b.insertAllOnConflictUpdate(
          savingsContributions,
          entries.where((e) => !unsynced.contains(e.id.value)),
        ),
      );
    });
  }
}
