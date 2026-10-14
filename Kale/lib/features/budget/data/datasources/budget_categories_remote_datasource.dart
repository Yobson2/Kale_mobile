import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/budget/data/models/budget_category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote datasource for the `budget_category_allocations` table.
///
/// Allocations have no `user_id`: they are owned through their budget, and
/// the server's RLS only exposes allocations of budgets the user owns.
abstract class BudgetCategoriesRemoteDataSource {
  /// Fetches every allocation of the signed-in user's budgets.
  Future<List<BudgetCategoryModel>> getAllBudgetCategories();

  /// Fetches one allocation. Throws [ServerException] if it does not exist.
  Future<BudgetCategoryModel> getBudgetCategoryById(String id);

  /// Creates an allocation. Keyed by the client UUID, so a retry is
  /// harmless.
  Future<BudgetCategoryModel> createBudgetCategory(BudgetCategoryModel model);

  /// Updates an allocation.
  Future<BudgetCategoryModel> updateBudgetCategory(BudgetCategoryModel model);

  /// Deletes an allocation.
  Future<void> deleteBudgetCategory(String id);
}

/// Implementation of [BudgetCategoriesRemoteDataSource] using Supabase.
class SupabaseBudgetCategoriesRemoteDataSource
    implements BudgetCategoriesRemoteDataSource {
  /// Creates a [SupabaseBudgetCategoriesRemoteDataSource].
  const SupabaseBudgetCategoriesRemoteDataSource(this._supabase);

  final SupabaseClient _supabase;

  String get _userId => _supabase.auth.currentUser!.id;
  SupabaseQueryBuilder get _table =>
      _supabase.from('budget_category_allocations');

  /// Columns of an allocation, plus its budget's owner to scope by user.
  static const _columns = '*, budgets!inner(user_id)';

  static BudgetCategoryModel _fromRow(Map<String, dynamic> row) =>
      BudgetCategoryModel.fromJson(Map.of(row)..remove('budgets'));

  @override
  Future<List<BudgetCategoryModel>> getAllBudgetCategories() async {
    try {
      final data = await _table.select(_columns).eq('budgets.user_id', _userId);
      return data.cast<Map<String, dynamic>>().map(_fromRow).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<BudgetCategoryModel> getBudgetCategoryById(String id) async {
    try {
      final data = await _table
          .select(_columns)
          .eq('id', id)
          .eq('budgets.user_id', _userId)
          .single();
      return _fromRow(data);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<BudgetCategoryModel> createBudgetCategory(
    BudgetCategoryModel model,
  ) async {
    try {
      final data = await _table.upsert(model.toJson()).select().single();
      return BudgetCategoryModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<BudgetCategoryModel> updateBudgetCategory(
    BudgetCategoryModel model,
  ) async {
    try {
      final data = await _table
          .update(model.toJson())
          .eq('id', model.id)
          .select()
          .single();
      return BudgetCategoryModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<void> deleteBudgetCategory(String id) async {
    try {
      await _table.delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  static int? _parseCode(PostgrestException e) =>
      e.code != null ? int.tryParse(e.code!) : null;
}

// coverage:ignore-start

/// Mock implementation for development (`USE_MOCK_BUDGETS`).
class MockBudgetCategoriesRemoteDataSource
    implements BudgetCategoriesRemoteDataSource {
  static const _delay = Duration(milliseconds: 500);

  @override
  Future<List<BudgetCategoryModel>> getAllBudgetCategories() async {
    await Future<void>.delayed(_delay);
    return [];
  }

  @override
  Future<BudgetCategoryModel> getBudgetCategoryById(String id) async {
    await Future<void>.delayed(_delay);
    throw const ServerException(
      message: 'Budget category not found',
      statusCode: 404,
    );
  }

  @override
  Future<BudgetCategoryModel> createBudgetCategory(
    BudgetCategoryModel model,
  ) async {
    await Future<void>.delayed(_delay);
    return model;
  }

  @override
  Future<BudgetCategoryModel> updateBudgetCategory(
    BudgetCategoryModel model,
  ) async {
    await Future<void>.delayed(_delay);
    return model;
  }

  @override
  Future<void> deleteBudgetCategory(String id) async {
    await Future<void>.delayed(_delay);
  }
}

// coverage:ignore-end
