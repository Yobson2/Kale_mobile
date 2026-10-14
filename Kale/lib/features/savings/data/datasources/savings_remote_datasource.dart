import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/savings/data/models/savings_goal_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote datasource for the `savings_goals` table.
abstract class SavingsRemoteDataSource {
  /// Fetches every goal of the signed-in user.
  Future<List<SavingsGoalModel>> getAllSavingsGoals();

  /// Fetches one goal. Throws [ServerException] if it does not exist.
  Future<SavingsGoalModel> getSavingsGoalById(String id);

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
  Future<List<SavingsGoalModel>> getAllSavingsGoals() async {
    try {
      final data = await _table
          .select()
          .eq('user_id', _userId)
          .order('created_at', ascending: false);
      return data
          .cast<Map<String, dynamic>>()
          .map(SavingsGoalModel.fromJson)
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<SavingsGoalModel> getSavingsGoalById(String id) async {
    try {
      final data =
          await _table.select().eq('id', id).eq('user_id', _userId).single();
      return SavingsGoalModel.fromJson(data);
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
  Future<List<SavingsGoalModel>> getAllSavingsGoals() async {
    await Future<void>.delayed(_delay);
    return [];
  }

  @override
  Future<SavingsGoalModel> getSavingsGoalById(String id) async {
    await Future<void>.delayed(_delay);
    throw const ServerException(
      message: 'Savings goal not found',
      statusCode: 404,
    );
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
