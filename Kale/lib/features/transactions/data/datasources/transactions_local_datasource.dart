import 'package:kale/core/database/daos/sync_queue_dao.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/transactions/data/daos/transactions_dao.dart';
import 'package:kale/features/transactions/data/models/transaction_model.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';

/// Local data source for transactions stored in the Drift database.
abstract class TransactionsLocalDataSource {
  /// Watches transactions reactively with optional date filters.
  Stream<List<Transaction>> watchTransactions({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Gets transactions with optional filters.
  Future<List<Transaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    String? categoryId,
    PaymentMethod? paymentMethod,
  });

  /// Gets a single transaction by ID.
  Future<Transaction> getTransactionById(String id);

  /// Saves a transaction locally (insert or update).
  Future<void> saveTransaction(TransactionModel model);

  /// Deletes a transaction locally.
  Future<void> deleteTransaction(String id);

  /// Enqueues a sync operation for a transaction.
  Future<void> enqueueSync({
    required String entityId,
    required String operation,
    String? payload,
  });

  /// Replaces all local transactions with server data (full refresh).
  Future<void> replaceAllFromServer(List<TransactionModel> models);

  /// Marks a transaction as synced, optionally setting the server ID.
  Future<void> markSynced(String id, {String? serverId});

  /// Gets total amounts grouped by category for a period.
  Future<Map<String, double>> getCategoryTotals({
    required DateTime startDate,
    required DateTime endDate,
    TransactionType? type,
  });

  /// Gets the total amount for a period and type.
  Future<double> getTotalForPeriod({
    required DateTime startDate,
    required DateTime endDate,
    required TransactionType type,
  });
}

/// Implementation of [TransactionsLocalDataSource] using
/// [TransactionsDao] and [SyncQueueDao].
class TransactionsLocalDataSourceImpl implements TransactionsLocalDataSource {
  /// Creates a [TransactionsLocalDataSourceImpl].
  const TransactionsLocalDataSourceImpl({
    required TransactionsDao transactionsDao,
    required SyncQueueDao syncQueueDao,
  })  : _transactionsDao = transactionsDao,
        _syncQueueDao = syncQueueDao;

  final TransactionsDao _transactionsDao;
  final SyncQueueDao _syncQueueDao;

  /// The entity type used in the sync queue for transactions.
  static const _entityType = 'transaction';

  @override
  Stream<List<Transaction>> watchTransactions({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _transactionsDao
        .watchAll(startDate: startDate, endDate: endDate)
        .map(
          (rows) =>
              rows.map((row) => TransactionModel.fromDrift(row).toEntity())
                  .toList(),
        );
  }

  @override
  Future<List<Transaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    String? categoryId,
    PaymentMethod? paymentMethod,
  }) async {
    try {
      final rows = await _transactionsDao.getAll(
        startDate: startDate,
        endDate: endDate,
        type: type?.name,
        categoryId: categoryId,
        paymentMethod: paymentMethod?.name,
      );
      return rows
          .map((row) => TransactionModel.fromDrift(row).toEntity())
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get transactions: $e');
    }
  }

  @override
  Future<Transaction> getTransactionById(String id) async {
    try {
      final row = await _transactionsDao.getById(id);
      if (row == null) {
        throw const CacheException(message: 'Transaction not found');
      }
      return TransactionModel.fromDrift(row).toEntity();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'Failed to get transaction: $e');
    }
  }

  @override
  Future<void> saveTransaction(TransactionModel model) async {
    try {
      await _transactionsDao.upsert(
        model.toDriftCompanion(isSynced: false),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to save transaction: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await _transactionsDao.deleteById(id);
    } catch (e) {
      throw CacheException(message: 'Failed to delete transaction: $e');
    }
  }

  @override
  Future<void> enqueueSync({
    required String entityId,
    required String operation,
    String? payload,
  }) async {
    try {
      await _syncQueueDao.enqueue(
        entityType: _entityType,
        entityId: entityId,
        operation: operation,
        payload: payload,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to enqueue sync: $e');
    }
  }

  @override
  Future<void> replaceAllFromServer(List<TransactionModel> models) async {
    try {
      final companions = models
          .map((m) => m.toDriftCompanion(isSynced: true))
          .toList();
      await _transactionsDao.replaceAll(companions);
    } catch (e) {
      throw CacheException(message: 'Failed to replace transactions: $e');
    }
  }

  @override
  Future<void> markSynced(String id, {String? serverId}) async {
    try {
      await _transactionsDao.markSynced(id, serverId: serverId);
    } catch (e) {
      throw CacheException(message: 'Failed to mark synced: $e');
    }
  }

  @override
  Future<Map<String, double>> getCategoryTotals({
    required DateTime startDate,
    required DateTime endDate,
    TransactionType? type,
  }) async {
    try {
      final totals = await _transactionsDao.getCategoryTotals(
        startDate: startDate,
        endDate: endDate,
        type: type?.name,
      );
      return {
        for (final ct in totals) ct.categoryId: ct.total,
      };
    } catch (e) {
      throw CacheException(message: 'Failed to get category totals: $e');
    }
  }

  @override
  Future<double> getTotalForPeriod({
    required DateTime startDate,
    required DateTime endDate,
    required TransactionType type,
  }) async {
    try {
      return await _transactionsDao.getTotalForPeriod(
        startDate: startDate,
        endDate: endDate,
        type: type.name,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to get total for period: $e');
    }
  }
}
