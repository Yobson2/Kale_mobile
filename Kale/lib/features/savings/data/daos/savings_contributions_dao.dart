import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/core/sync/pull.dart';
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

  /// Gets every live contribution.
  Future<List<SavingsContribution>> getAllLive() =>
      (select(savingsContributions)..where((t) => t.deletedAt.isNull())).get();

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

  /// Soft-deletes every live contribution of a goal: sets `deletedAt` and
  /// `updatedAt` to [at] and marks them unsynced. Returns the deleted rows.
  Future<List<SavingsContribution>> markDeletedByGoalId(
    String goalId,
    DateTime at,
  ) {
    return transaction(() async {
      final live = await _liveForGoal(goalId).get();
      if (live.isEmpty) return const [];
      final ids = [for (final row in live) row.id];
      await (update(savingsContributions)..where((t) => t.id.isIn(ids))).write(
        SavingsContributionsCompanion(
          deletedAt: Value(at),
          updatedAt: Value(at),
          isSynced: const Value(false),
        ),
      );
      return (select(savingsContributions)..where((t) => t.id.isIn(ids))).get();
    });
  }

  /// The merge state of the rows with these [ids], deleted ones included.
  Future<Map<String, LocalRowState>> statesByIds(Iterable<String> ids) async {
    final rows = await (select(savingsContributions)
          ..where((t) => t.id.isIn(ids)))
        .get();
    return {
      for (final row in rows)
        row.id: (updatedAt: row.updatedAt, isSynced: row.isSynced),
    };
  }

  /// Inserts or replaces [entries] (rows pulled from the server).
  Future<void> upsertAll(List<SavingsContributionsCompanion> entries) =>
      batch((b) => b.insertAllOnConflictUpdate(savingsContributions, entries));

  /// Marks a contribution as synced.
  Future<void> markSynced(String id, {String? serverId}) =>
      (update(savingsContributions)..where((t) => t.id.equals(id))).write(
        SavingsContributionsCompanion(
          isSynced: const Value(true),
          serverId: serverId != null ? Value(serverId) : const Value.absent(),
        ),
      );
}
