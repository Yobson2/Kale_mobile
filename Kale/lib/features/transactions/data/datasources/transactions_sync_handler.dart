import 'dart:convert';

import 'package:kale/core/sync/pull.dart';
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
  Future<PulledPage> pullPage({
    required PullCursor? after,
    required int limit,
  }) async {
    final page = await _remote.fetchPage(after: after, limit: limit);
    await _local.mergeFromServer(page.rows);
    return PulledPage(rowCount: page.rows.length, last: page.last);
  }
}
