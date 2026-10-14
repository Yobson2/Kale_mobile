import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/sync/pull.dart';
import 'package:kale/core/sync/supabase_pull.dart';
import 'package:kale/features/budget/data/models/budget_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for budgets API calls.
abstract class BudgetsRemoteDataSource {
  /// Fetches the rows changed after [after], at most [limit], in pull
  /// order (see `pullPageQuery`). Includes tombstones.
  Future<RemotePage<BudgetModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  });

  /// POST a new budget.
  Future<BudgetModel> createBudget(BudgetModel model);

  /// PUT an existing budget.
  Future<BudgetModel> updateBudget(BudgetModel model);
}

/// Implementation of [BudgetsRemoteDataSource] using Supabase.
class SupabaseBudgetsRemoteDataSource implements BudgetsRemoteDataSource {
  /// Creates a [SupabaseBudgetsRemoteDataSource].
  const SupabaseBudgetsRemoteDataSource(this._supabase);

  final SupabaseClient _supabase;

  String get _userId => _supabase.auth.currentUser!.id;
  SupabaseQueryBuilder get _table => _supabase.from('budgets');

  @override
  Future<RemotePage<BudgetModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  }) async {
    try {
      final data = await pullPageQuery(
        _table.select().eq('user_id', _userId),
        after: after,
        limit: limit,
      );
      return toRemotePage(data, BudgetModel.fromJson);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<BudgetModel> createBudget(BudgetModel model) async {
    try {
      final payload = model.toJson()
        ..['user_id'] = _userId
        ..remove('server_id');
      final data = await _table.insert(payload).select().single();
      return BudgetModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<BudgetModel> updateBudget(BudgetModel model) async {
    try {
      final payload = model.toJson()
        ..remove('server_id')
        ..remove('user_id');
      final data = await _table
          .update(payload)
          .eq('id', model.id)
          .eq('user_id', _userId)
          .select()
          .single();
      return BudgetModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  static int? _parseCode(PostgrestException e) =>
      e.code != null ? int.tryParse(e.code!) : null;
}

// coverage:ignore-file

/// Mock implementation of [BudgetsRemoteDataSource] for local testing.
class MockBudgetsRemoteDataSource implements BudgetsRemoteDataSource {
  static const _delay = Duration(milliseconds: 500);

  @override
  Future<RemotePage<BudgetModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  }) async {
    await Future<void>.delayed(_delay);
    return const RemotePage([]);
  }

  @override
  Future<BudgetModel> createBudget(BudgetModel model) async {
    await Future<void>.delayed(_delay);
    return model.copyWith(serverId: 'mock-server-${model.id}');
  }

  @override
  Future<BudgetModel> updateBudget(BudgetModel model) async {
    await Future<void>.delayed(_delay);
    return model;
  }
}
