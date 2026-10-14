import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/core/sync/pull.dart';
import 'package:kale/features/transactions/data/tables/transactions_table.dart';

part 'transactions_dao.g.dart';

/// DAO for transactions table operations.
///
/// Every read excludes soft-deleted rows (`deletedAt` set). Sums are
/// integer minor units of the base currency.
@DriftAccessor(tables: [Transactions])
class TransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  /// Watches all live transactions ordered by date descending.
  Stream<List<Transaction>> watchAll({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final query = select(transactions)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    if (startDate != null) {
      query.where((t) => t.date.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query.where((t) => t.date.isSmallerOrEqualValue(endDate));
    }
    return query.watch();
  }

  /// Gets all live transactions with optional filters.
  Future<List<Transaction>> getAll({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? categoryId,
    String? paymentMethod,
  }) {
    final query = select(transactions)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    if (startDate != null) {
      query.where((t) => t.date.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query.where((t) => t.date.isSmallerOrEqualValue(endDate));
    }
    if (type != null) {
      query.where((t) => t.type.equals(type));
    }
    if (categoryId != null) {
      query.where((t) => t.categoryId.equals(categoryId));
    }
    if (paymentMethod != null) {
      query.where((t) => t.paymentMethod.equals(paymentMethod));
    }
    return query.get();
  }

  /// One page of live transactions, newest first, keyset-ordered on
  /// `(date, id)`: the page after the row with [afterDate] and [afterId]
  /// (from the start when null), at most [limit] rows. Never an offset, so
  /// a deep page costs the same as the first.
  ///
  /// With [untilDate] and [untilId], the page stops at that row (included):
  /// used to reload exactly the rows a list already shows.
  ///
  /// Filters: [type]; and [search], which matches the description
  /// (case-insensitive) or any of [searchCategoryIds].
  Future<List<Transaction>> getPage({
    required int limit,
    DateTime? afterDate,
    String? afterId,
    DateTime? untilDate,
    String? untilId,
    String? type,
    String? search,
    Set<String> searchCategoryIds = const {},
  }) {
    final query = select(transactions)..where((t) => t.deletedAt.isNull());
    if (afterDate != null && afterId != null) {
      query.where(
        (t) =>
            t.date.isSmallerThanValue(afterDate) |
            (t.date.equals(afterDate) & t.id.isSmallerThanValue(afterId)),
      );
    }
    if (untilDate != null && untilId != null) {
      query.where(
        (t) =>
            t.date.isBiggerThanValue(untilDate) |
            (t.date.equals(untilDate) & t.id.isBiggerOrEqualValue(untilId)),
      );
    }
    if (type != null) {
      query.where((t) => t.type.equals(type));
    }
    if (search != null && search.isNotEmpty) {
      final pattern = '%${search.toLowerCase()}%';
      query.where(
        (t) =>
            t.description.lower().like(pattern) |
            t.categoryId.isIn(searchCategoryIds),
      );
    }
    query
      ..orderBy([
        (t) => OrderingTerm.desc(t.date),
        (t) => OrderingTerm.desc(t.id),
      ])
      ..limit(limit);
    return query.get();
  }

  /// Emits whenever the transactions table changes (insert, update,
  /// soft delete), so a loaded list can refresh what it shows.
  Stream<void> watchChanges() =>
      db.tableUpdates(TableUpdateQuery.onTable(transactions));

  /// Gets a single live transaction by ID.
  Future<Transaction?> getById(String id) {
    return (select(transactions)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Counts live transactions.
  Future<int> count() async {
    final countExpr = transactions.id.count();
    final query = selectOnly(transactions)
      ..addColumns([countExpr])
      ..where(transactions.deletedAt.isNull());
    final row = await query.getSingle();
    return row.read(countExpr) ?? 0;
  }

  /// Inserts or replaces a transaction.
  Future<void> upsert(TransactionsCompanion entry) {
    return into(transactions).insertOnConflictUpdate(entry);
  }

  /// Soft-deletes a live transaction: sets `deletedAt` and `updatedAt` to
  /// [at] and marks it unsynced. Returns the deleted row, or null if no
  /// live transaction has this [id].
  Future<Transaction?> markDeleted(String id, DateTime at) {
    return transaction(() async {
      final count = await (update(transactions)
            ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
          .write(
        TransactionsCompanion(
          deletedAt: Value(at),
          updatedAt: Value(at),
          isSynced: const Value(false),
        ),
      );
      if (count == 0) return null;
      return (select(transactions)..where((t) => t.id.equals(id))).getSingle();
    });
  }

  /// Marks a transaction as synced.
  Future<void> markSynced(String id, {String? serverId}) {
    return (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        isSynced: const Value(true),
        serverId: serverId != null ? Value(serverId) : const Value.absent(),
      ),
    );
  }

  /// The merge state of the rows with these [ids], deleted ones included.
  Future<Map<String, LocalRowState>> statesByIds(Iterable<String> ids) async {
    final rows =
        await (select(transactions)..where((t) => t.id.isIn(ids))).get();
    return {
      for (final row in rows)
        row.id: (updatedAt: row.updatedAt, isSynced: row.isSynced),
    };
  }

  /// Inserts or replaces [entries] (rows pulled from the server).
  Future<void> upsertAll(List<TransactionsCompanion> entries) =>
      batch((b) => b.insertAllOnConflictUpdate(transactions, entries));

  /// Gets the total, in minor units, per category for a period and type.
  Future<List<CategoryTotal>> getCategoryTotals({
    required DateTime startDate,
    required DateTime endDate,
    String? type,
  }) async {
    final sum = transactions.amountMinor.sum();
    final query = selectOnly(transactions)
      ..addColumns([transactions.categoryId, sum])
      ..where(transactions.deletedAt.isNull())
      ..where(transactions.date.isBiggerOrEqualValue(startDate))
      ..where(transactions.date.isSmallerOrEqualValue(endDate))
      ..groupBy([transactions.categoryId]);

    if (type != null) {
      query.where(transactions.type.equals(type));
    }

    final rows = await query.get();
    return rows.map((row) {
      return CategoryTotal(
        categoryId: row.read(transactions.categoryId)!,
        totalMinor: row.read(sum) ?? 0,
      );
    }).toList();
  }

  /// Gets the total, in minor units, for a type within a date range.
  Future<int> getTotalForPeriod({
    required DateTime startDate,
    required DateTime endDate,
    required String type,
  }) async {
    final sum = transactions.amountMinor.sum();
    final query = selectOnly(transactions)
      ..addColumns([sum])
      ..where(transactions.deletedAt.isNull())
      ..where(transactions.date.isBiggerOrEqualValue(startDate))
      ..where(transactions.date.isSmallerOrEqualValue(endDate))
      ..where(transactions.type.equals(type));

    final row = await query.getSingle();
    return row.read(sum) ?? 0;
  }
}

/// A category's total, in minor units of the base currency.
class CategoryTotal {
  const CategoryTotal({required this.categoryId, required this.totalMinor});

  final String categoryId;
  final int totalMinor;
}
