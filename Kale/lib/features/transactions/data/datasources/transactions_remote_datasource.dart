import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/sync/pull.dart';
import 'package:kale/core/sync/supabase_pull.dart';
import 'package:kale/features/transactions/data/models/transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for transactions API calls.
abstract class TransactionsRemoteDataSource {
  /// GET: Fetches the user's transactions changed after [after], at most
  /// [limit], in pull order (see `pullPageQuery`). Includes tombstones.
  Future<RemotePage<TransactionModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  });

  /// POST: Creates a new transaction on the server.
  /// Returns the created model with server-assigned fields.
  Future<TransactionModel> createTransaction(TransactionModel model);

  /// PUT: Updates an existing transaction on the server.
  Future<TransactionModel> updateTransaction(TransactionModel model);
}

/// Implementation of [TransactionsRemoteDataSource] using Supabase.
class SupabaseTransactionsRemoteDataSource
    implements TransactionsRemoteDataSource {
  /// Creates a [SupabaseTransactionsRemoteDataSource].
  const SupabaseTransactionsRemoteDataSource(this._supabase);

  final SupabaseClient _supabase;

  String get _userId => _supabase.auth.currentUser!.id;
  SupabaseQueryBuilder get _table => _supabase.from('transactions');

  @override
  Future<RemotePage<TransactionModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  }) async {
    try {
      final data = await pullPageQuery(
        _table.select().eq('user_id', _userId),
        after: after,
        limit: limit,
      );
      return toRemotePage(data, TransactionModel.fromJson);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<TransactionModel> createTransaction(TransactionModel model) async {
    try {
      final payload = model.toJson()
        ..['user_id'] = _userId
        ..remove('server_id');
      final data = await _table.insert(payload).select().single();
      return TransactionModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<TransactionModel> updateTransaction(TransactionModel model) async {
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
      return TransactionModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  static int? _parseCode(PostgrestException e) =>
      e.code != null ? int.tryParse(e.code!) : null;
}

/// Mock implementation of [TransactionsRemoteDataSource] for development.
///
/// Returns mock data without making real network calls.
class MockTransactionsRemoteDataSource implements TransactionsRemoteDataSource {
  static const _delay = Duration(milliseconds: 500);

  @override
  Future<RemotePage<TransactionModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  }) async {
    await Future<void>.delayed(_delay);
    return const RemotePage([]);
  }

  @override
  Future<TransactionModel> createTransaction(TransactionModel model) async {
    await Future<void>.delayed(_delay);
    return model;
  }

  @override
  Future<TransactionModel> updateTransaction(TransactionModel model) async {
    await Future<void>.delayed(_delay);
    return model;
  }
}
