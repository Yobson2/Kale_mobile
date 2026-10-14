import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/sync/pull.dart';
import 'package:kale/core/sync/supabase_pull.dart';
import 'package:kale/features/savings/data/models/savings_goal_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote datasource for the `savings_goals` table.
abstract class SavingsRemoteDataSource {
  /// Fetches the rows changed after [after], at most [limit], in pull
  /// order (see `pullPageQuery`). Includes tombstones.
  Future<RemotePage<SavingsGoalModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  });

  /// Creates a goal. Keyed by the client UUID, so a retry is harmless.
  Future<SavingsGoalModel> createSavingsGoal(SavingsGoalModel model);

  /// Updates a goal, including its device-computed saved amount.
  Future<SavingsGoalModel> updateSavingsGoal(SavingsGoalModel model);
}

/// Implementation of [SavingsRemoteDataSource] using Supabase.
class SupabaseSavingsRemoteDataSource implements SavingsRemoteDataSource {
  /// Creates a [SupabaseSavingsRemoteDataSource].
  const SupabaseSavingsRemoteDataSource(this._supabase);

  final SupabaseClient _supabase;

  String get _userId => _supabase.auth.currentUser!.id;
  SupabaseQueryBuilder get _table => _supabase.from('savings_goals');

  @override
  Future<RemotePage<SavingsGoalModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  }) async {
    try {
      final data = await pullPageQuery(
        _table.select().eq('user_id', _userId),
        after: after,
        limit: limit,
      );
      return toRemotePage(data, SavingsGoalModel.fromJson);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<SavingsGoalModel> createSavingsGoal(SavingsGoalModel model) async {
    try {
      final payload = model.toJson()
        ..['user_id'] = _userId
        ..remove('server_id');
      final data = await _table.upsert(payload).select().single();
      return SavingsGoalModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<SavingsGoalModel> updateSavingsGoal(SavingsGoalModel model) async {
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
      return SavingsGoalModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  static int? _parseCode(PostgrestException e) =>
      e.code != null ? int.tryParse(e.code!) : null;
}

/// Mock implementation for development (`USE_MOCK_SAVINGS`).
class MockSavingsRemoteDataSource implements SavingsRemoteDataSource {
  static const _delay = Duration(milliseconds: 500);

  @override
  Future<RemotePage<SavingsGoalModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  }) async {
    await Future<void>.delayed(_delay);
    return const RemotePage([]);
  }

  @override
  Future<SavingsGoalModel> createSavingsGoal(SavingsGoalModel model) async {
    await Future<void>.delayed(_delay);
    return model;
  }

  @override
  Future<SavingsGoalModel> updateSavingsGoal(SavingsGoalModel model) async {
    await Future<void>.delayed(_delay);
    return model;
  }
}
