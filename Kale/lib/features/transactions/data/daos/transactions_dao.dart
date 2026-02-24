import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/features/transactions/data/tables/transactions_table.dart';

part 'transactions_dao.g.dart';

/// DAO for transactions table operations.
@DriftAccessor(tables: [Transactions])
class TransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  /// Watches all transactions ordered by date descending.
  Stream<List<Transaction>> watchAll({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    var query = select(transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    if (startDate != null) {
      query = query
        ..where(
          (t) => t.date.isBiggerOrEqualValue(startDate),
        );
    }
    if (endDate != null) {
      query = query..where((t) => t.date.isSmallerOrEqualValue(endDate));
    }
    return query.watch();
  }

  /// Gets all transactions with optional filters.
  Future<List<Transaction>> getAll({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? categoryId,
    String? paymentMethod,
  }) {
    var query = select(transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    if (startDate != null) {
      query = query
        ..where((t) => t.date.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query = query..where((t) => t.date.isSmallerOrEqualValue(endDate));
    }
    if (type != null) {
      query = query..where((t) => t.type.equals(type));
    }
    if (categoryId != null) {
      query = query..where((t) => t.categoryId.equals(categoryId));
    }
    if (paymentMethod != null) {
      query = query..where((t) => t.paymentMethod.equals(paymentMethod));
    }
    return query.get();
  }

  /// Gets a single transaction by ID.
  Future<Transaction?> getById(String id) {
    return (select(transactions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Inserts or replaces a transaction.
  Future<void> upsert(TransactionsCompanion entry) {
    return into(transactions).insertOnConflictUpdate(entry);
  }

  /// Deletes a transaction by ID.
  Future<void> deleteById(String id) {
    return (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  /// Marks a transaction as synced.
  Future<void> markSynced(String id, {String? serverId}) {
    return (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        isSynced: const Value(true),
        serverId:
            serverId != null ? Value(serverId) : const Value.absent(),
      ),
    );
  }

  /// Replaces all transactions from server (full refresh).
  Future<void> replaceAll(List<TransactionsCompanion> serverTransactions) {
    return transaction(() async {
      await delete(transactions).go();
      await batch((b) => b.insertAll(transactions, serverTransactions));
    });
  }

  /// Gets total amount grouped by category for a period and type.
  Future<List<CategoryTotal>> getCategoryTotals({
    required DateTime startDate,
    required DateTime endDate,
    String? type,
  }) async {
    final query = selectOnly(transactions)
      ..addColumns([transactions.categoryId, transactions.amount.sum()])
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
        total: row.read(transactions.amount.sum()) ?? 0,
      );
    }).toList();
  }

  /// Gets total amount for a specific type within a date range.
  Future<double> getTotalForPeriod({
    required DateTime startDate,
    required DateTime endDate,
    required String type,
  }) async {
    final query = selectOnly(transactions)
      ..addColumns([transactions.amount.sum()])
      ..where(transactions.date.isBiggerOrEqualValue(startDate))
      ..where(transactions.date.isSmallerOrEqualValue(endDate))
      ..where(transactions.type.equals(type));

    final row = await query.getSingle();
    return row.read(transactions.amount.sum()) ?? 0;
  }
}

/// Helper class for category total results.
class CategoryTotal {
  const CategoryTotal({required this.categoryId, required this.total});

  final String categoryId;
  final double total;
}
