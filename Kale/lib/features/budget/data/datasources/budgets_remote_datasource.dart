import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/budget/data/models/budget_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for budgets API calls.
abstract class BudgetsRemoteDataSource {
  /// GET all budgets from the server.
  Future<List<BudgetModel>> getAllBudgets();

  /// GET a single budget by ID.
  Future<BudgetModel> getBudgetById(String id);

  /// POST a new budget.
  Future<BudgetModel> createBudget(BudgetModel model);

  /// PUT an existing budget.
  Future<BudgetModel> updateBudget(BudgetModel model);

  /// DELETE a budget by ID.
  Future<void> deleteBudget(String id);
}

/// Implementation of [BudgetsRemoteDataSource] using Supabase.
class SupabaseBudgetsRemoteDataSource implements BudgetsRemoteDataSource {
  /// Creates a [SupabaseBudgetsRemoteDataSource].
  const SupabaseBudgetsRemoteDataSource(this._supabase);

  final SupabaseClient _supabase;

  String get _userId => _supabase.auth.currentUser!.id;
  SupabaseQueryBuilder get _table => _supabase.from('budgets');

  @override
  Future<List<BudgetModel>> getAllBudgets() async {
    try {
      final data = await _table
          .select()
          .eq('user_id', _userId)
          .order('start_date', ascending: false);
      return data
          .cast<Map<String, dynamic>>()
          .map(BudgetModel.fromJson)
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<BudgetModel> getBudgetById(String id) async {
    try {
      final data = await _table
          .select()
          .eq('id', id)
          .eq('user_id', _userId)
          .single();
      return BudgetModel.fromJson(data);
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

  @override
  Future<void> deleteBudget(String id) async {
    try {
      await _table.delete().eq('id', id).eq('user_id', _userId);
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
  Future<List<BudgetModel>> getAllBudgets() async {
    await Future<void>.delayed(_delay);
    return [];
  }

  @override
  Future<BudgetModel> getBudgetById(String id) async {
    await Future<void>.delayed(_delay);
    throw const ServerException(message: 'Mock: budget not found');
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

  @override
  Future<void> deleteBudget(String id) async {
    await Future<void>.delayed(_delay);
  }
}
