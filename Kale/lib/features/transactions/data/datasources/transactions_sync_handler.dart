import 'dart:convert';

import 'package:kale/core/sync/sync_engine.dart';
import 'package:kale/features/transactions/data/datasources/transactions_local_datasource.dart';
import 'package:kale/features/transactions/data/datasources/transactions_remote_datasource.dart';
import 'package:kale/features/transactions/data/models/transaction_model.dart';

/// [SyncHandler] implementation for transactions.
///
/// Bridges between the [SyncEngine] and the transaction data sources
/// to push/pull transaction data during sync cycles.
class TransactionsSyncHandler implements SyncHandler {
  /// Creates a [TransactionsSyncHandler].
  const TransactionsSyncHandler({
    required TransactionsRemoteDataSource remoteDataSource,
    required TransactionsLocalDataSource localDataSource,
  })  : _remote = remoteDataSource,
        _local = localDataSource;

  final TransactionsRemoteDataSource _remote;
  final TransactionsLocalDataSource _local;

  @override
  String get entityType => 'transaction';

  @override
  Future<String> pushCreate(String entityId, String payload) async {
    final json = jsonDecode(payload) as Map<String, dynamic>;
    final model = TransactionModel.fromJson(json);
    final created = await _remote.createTransaction(model);

    // Update local record with server-assigned ID and mark as synced.
    await _local.markSynced(entityId, serverId: created.serverId);

    return created.serverId ?? created.id;
  }

  @override
  Future<void> pushUpdate(String entityId, String payload) async {
    final json = jsonDecode(payload) as Map<String, dynamic>;
    final model = TransactionModel.fromJson(json);
    await _remote.updateTransaction(model);

    // Mark local record as synced after successful push.
    await _local.markSynced(entityId);
  }

  @override
  Future<void> pushDelete(String entityId) async {
    await _remote.deleteTransaction(entityId);
  }

  @override
  Future<String?> fetchRemote(String entityId) async {
    try {
      final model = await _remote.getTransactionById(entityId);
      return jsonEncode(model.toJson());
    } catch (_) {
      // Entity doesn't exist on server.
      return null;
    }
  }

  @override
  Future<void> applyServerVersion(
    String entityId,
    String serverPayload,
  ) async {
    final json = jsonDecode(serverPayload) as Map<String, dynamic>;
    final model = TransactionModel.fromJson(json);
    await _local.saveTransaction(model);
    await _local.markSynced(entityId, serverId: model.serverId);
  }
}
