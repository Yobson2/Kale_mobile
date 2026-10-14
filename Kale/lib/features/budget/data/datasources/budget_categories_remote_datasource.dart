import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/sync/pull.dart';
import 'package:kale/core/sync/supabase_pull.dart';
import 'package:kale/features/budget/data/models/budget_category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote datasource for the `budget_category_allocations` table.
///
/// Allocations have no `user_id`: they are owned through their budget, and
/// the server's RLS only exposes allocations of budgets the user owns.
abstract class BudgetCategoriesRemoteDataSource {
  /// Fetches the rows changed after [after], at most [limit], in pull
  /// order (see `pullPageQuery`). Includes tombstones.
  Future<RemotePage<BudgetCategoryModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  });

  /// Creates an allocation. Keyed by the client UUID, so a retry is
  /// harmless.
  Future<BudgetCategoryModel> createBudgetCategory(BudgetCategoryModel model);

  /// Updates an allocation.
  Future<BudgetCategoryModel> updateBudgetCategory(BudgetCategoryModel model);
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
  Future<RemotePage<BudgetCategoryModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  }) async {
    try {
      final data = await pullPageQuery(
        _table.select(_columns).eq('budgets.user_id', _userId),
        after: after,
        limit: limit,
      );
      return toRemotePage(data, _fromRow);
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

  static int? _parseCode(PostgrestException e) =>
      e.code != null ? int.tryParse(e.code!) : null;
}

// coverage:ignore-start

/// Mock implementation for development (`USE_MOCK_BUDGETS`).
class MockBudgetCategoriesRemoteDataSource
    implements BudgetCategoriesRemoteDataSource {
  static const _delay = Duration(milliseconds: 500);

  @override
  Future<RemotePage<BudgetCategoryModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  }) async {
    await Future<void>.delayed(_delay);
    return const RemotePage([]);
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
}

// coverage:ignore-end
