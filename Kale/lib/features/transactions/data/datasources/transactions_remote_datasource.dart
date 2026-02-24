import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/transactions/data/models/transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for transactions API calls.
abstract class TransactionsRemoteDataSource {
  /// GET: Fetches all transactions from the server.
  Future<List<TransactionModel>> getAllTransactions();

  /// GET: Fetches a single transaction by ID.
  Future<TransactionModel> getTransactionById(String id);

  /// POST: Creates a new transaction on the server.
  /// Returns the created model with server-assigned fields.
  Future<TransactionModel> createTransaction(TransactionModel model);

  /// PUT: Updates an existing transaction on the server.
  Future<TransactionModel> updateTransaction(TransactionModel model);

  /// DELETE: Deletes a transaction on the server.
  Future<void> deleteTransaction(String id);
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
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final data = await _table
          .select()
          .eq('user_id', _userId)
          .order('date', ascending: false);
      return data
          .cast<Map<String, dynamic>>()
          .map(TransactionModel.fromJson)
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<TransactionModel> getTransactionById(String id) async {
    try {
      final data = await _table
          .select()
          .eq('id', id)
          .eq('user_id', _userId)
          .single();
      return TransactionModel.fromJson(data);
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

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await _table.delete().eq('id', id).eq('user_id', _userId);
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
class MockTransactionsRemoteDataSource
    implements TransactionsRemoteDataSource {
  static const _delay = Duration(milliseconds: 500);

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    await Future<void>.delayed(_delay);
    return [];
  }

  @override
  Future<TransactionModel> getTransactionById(String id) async {
    await Future<void>.delayed(_delay);
    throw const ServerException(
      message: 'Transaction not found',
      statusCode: 404,
    );
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

  @override
  Future<void> deleteTransaction(String id) async {
    await Future<void>.delayed(_delay);
  }
}
