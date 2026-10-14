import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/features/budget/data/tables/budgets_table.dart';

part 'budgets_dao.g.dart';

/// DAO for budgets table operations.
///
/// Every read excludes soft-deleted rows (`deletedAt` set).
@DriftAccessor(tables: [Budgets])
class BudgetsDao extends DatabaseAccessor<AppDatabase> with _$BudgetsDaoMixin {
  BudgetsDao(super.db);

  /// Watches all budgets ordered by creation date descending.
  Stream<List<Budget>> watchAll() {
    return (select(budgets)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Gets all budgets.
  Future<List<Budget>> getAll() {
    return (select(budgets)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Gets the most recently created budget whose period covers [day].
  Future<Budget?> getActiveOn(CalendarDate day) {
    // ISO dates compare as text in date order.
    final iso = day.toIso();
    return (select(budgets)
          ..where((t) => t.deletedAt.isNull())
          ..where(
            (t) =>
                t.startDate.isSmallerOrEqualValue(iso) &
                t.endDate.isBiggerOrEqualValue(iso),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Gets a single budget by ID.
  Future<Budget?> getById(String id) {
    return (select(budgets)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Inserts or replaces a budget.
  Future<void> upsert(BudgetsCompanion entry) {
    return into(budgets).insertOnConflictUpdate(entry);
  }

  /// Deletes a budget by ID.
  Future<void> deleteById(String id) {
    return (delete(budgets)..where((t) => t.id.equals(id))).go();
  }

  /// Marks a budget as synced.
  Future<void> markSynced(String id, {String? serverId}) {
    return (update(budgets)..where((t) => t.id.equals(id))).write(
      BudgetsCompanion(
        isSynced: const Value(true),
        serverId: serverId != null ? Value(serverId) : const Value.absent(),
      ),
    );
  }
}
