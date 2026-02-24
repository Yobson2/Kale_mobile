import 'dart:convert';

import 'package:kale/core/sync/sync_engine.dart';
import 'package:kale/features/budget/data/datasources/budgets_local_datasource.dart';
import 'package:kale/features/budget/data/datasources/budgets_remote_datasource.dart';
import 'package:kale/features/budget/data/models/budget_model.dart';

/// [SyncHandler] implementation for budgets.
///
/// Handles pushing local budget mutations to the server
/// and applying server versions during conflict resolution.
class BudgetsSyncHandler implements SyncHandler {
  const BudgetsSyncHandler({
    required BudgetsRemoteDataSource remoteDataSource,
    required BudgetsLocalDataSource localDataSource,
  })  : _remote = remoteDataSource,
        _local = localDataSource;

  final BudgetsRemoteDataSource _remote;
  final BudgetsLocalDataSource _local;

  @override
  String get entityType => 'budget';

  @override
  Future<String> pushCreate(String entityId, String payload) async {
    final json = jsonDecode(payload) as Map<String, dynamic>;
    final model = BudgetModel.fromJson(json);
    final serverModel = await _remote.createBudget(model);
    await _local.markSynced(entityId, serverId: serverModel.serverId);
    return serverModel.serverId ?? serverModel.id;
  }

  @override
  Future<void> pushUpdate(String entityId, String payload) async {
    final json = jsonDecode(payload) as Map<String, dynamic>;
    final model = BudgetModel.fromJson(json);
    await _remote.updateBudget(model);
    await _local.markSynced(entityId);
  }

  @override
  Future<void> pushDelete(String entityId) async {
    await _remote.deleteBudget(entityId);
  }

  @override
  Future<String?> fetchRemote(String entityId) async {
    try {
      final model = await _remote.getBudgetById(entityId);
      return jsonEncode(model.toJson());
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> applyServerVersion(
    String entityId,
    String serverPayload,
  ) async {
    final json = jsonDecode(serverPayload) as Map<String, dynamic>;
    final model = BudgetModel.fromJson(json).copyWith(isSynced: true);
    await _local.saveBudget(model);
  }
}
