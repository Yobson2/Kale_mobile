import 'dart:convert';

import 'package:kale/core/sync/pull.dart';
import 'package:kale/core/sync/sync_engine.dart';
import 'package:kale/features/budget/data/datasources/budget_categories_local_datasource.dart';
import 'package:kale/features/budget/data/datasources/budget_categories_remote_datasource.dart';
import 'package:kale/features/budget/data/models/budget_category_model.dart';

/// [SyncHandler] for budget category allocations (entity type
/// `budget_category`).
///
/// Payloads are [BudgetCategoryModel] JSON. An allocation is queued after
/// its budget, so the budget reaches the server first.
class BudgetCategoriesSyncHandler implements SyncHandler {
  /// Creates a [BudgetCategoriesSyncHandler].
  const BudgetCategoriesSyncHandler({
    required BudgetCategoriesRemoteDataSource remoteDataSource,
    required BudgetCategoriesLocalDataSource localDataSource,
  })  : _remote = remoteDataSource,
        _local = localDataSource;

  final BudgetCategoriesRemoteDataSource _remote;
  final BudgetCategoriesLocalDataSource _local;

  @override
  String get entityType => 'budget_category';

  @override
  Future<String> pushCreate(String entityId, String payload) async {
    final created = await _remote.createBudgetCategory(_decode(payload));
    await _local.markSynced(entityId);
    return created.id;
  }

  @override
  Future<void> pushUpdate(String entityId, String payload) async {
    await _remote.updateBudgetCategory(_decode(payload));
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

  @override
  Future<void> requeueAllAsCreates() => _local.enqueueAllAsCreates();

  static BudgetCategoryModel _decode(String payload) =>
      BudgetCategoryModel.fromJson(jsonDecode(payload) as Map<String, dynamic>);
}
