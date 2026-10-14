import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/savings/data/models/savings_contribution_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote datasource for the `savings_contributions` table.
///
/// Contributions have no `user_id`: they are owned through their goal, and
/// the server's RLS only exposes contributions of goals the user owns.
abstract class SavingsContributionsRemoteDataSource {
  /// Fetches every contribution of the signed-in user's goals.
  Future<List<SavingsContributionModel>> getAllContributions();

  /// Fetches one contribution. Throws [ServerException] if it does not
  /// exist.
  Future<SavingsContributionModel> getContributionById(String id);

  /// Creates a contribution. Keyed by the client UUID, so a retry is
  /// harmless. The server does not touch the goal's saved amount.
  Future<SavingsContributionModel> createContribution(
    SavingsContributionModel model,
  );

  /// Updates a contribution.
  Future<SavingsContributionModel> updateContribution(
    SavingsContributionModel model,
  );
}

/// Implementation of [SavingsContributionsRemoteDataSource] using Supabase.
class SupabaseSavingsContributionsRemoteDataSource
    implements SavingsContributionsRemoteDataSource {
  /// Creates a [SupabaseSavingsContributionsRemoteDataSource].
  const SupabaseSavingsContributionsRemoteDataSource(this._supabase);

  final SupabaseClient _supabase;

  String get _userId => _supabase.auth.currentUser!.id;
  SupabaseQueryBuilder get _table => _supabase.from('savings_contributions');

  /// Columns of a contribution, plus its goal's owner to scope by user.
  static const _columns = '*, savings_goals!inner(user_id)';

  static SavingsContributionModel _fromRow(Map<String, dynamic> row) =>
      SavingsContributionModel.fromJson(
        Map.of(row)..remove('savings_goals'),
      );

  @override
  Future<List<SavingsContributionModel>> getAllContributions() async {
    try {
      final data = await _table
          .select(_columns)
          .eq('savings_goals.user_id', _userId)
          .order('date', ascending: false);
      return data.cast<Map<String, dynamic>>().map(_fromRow).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<SavingsContributionModel> getContributionById(String id) async {
    try {
      final data = await _table
          .select(_columns)
          .eq('id', id)
          .eq('savings_goals.user_id', _userId)
          .single();
      return _fromRow(data);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<SavingsContributionModel> createContribution(
    SavingsContributionModel model,
  ) async {
    try {
      final payload = model.toJson()..remove('server_id');
      final data = await _table.upsert(payload).select().single();
      return SavingsContributionModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<SavingsContributionModel> updateContribution(
    SavingsContributionModel model,
  ) async {
    try {
      final payload = model.toJson()..remove('server_id');
      final data =
          await _table.update(payload).eq('id', model.id).select().single();
      return SavingsContributionModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  static int? _parseCode(PostgrestException e) =>
      e.code != null ? int.tryParse(e.code!) : null;
}

/// Mock implementation for development (`USE_MOCK_SAVINGS`).
class MockSavingsContributionsRemoteDataSource
    implements SavingsContributionsRemoteDataSource {
  static const _delay = Duration(milliseconds: 500);

  @override
  Future<List<SavingsContributionModel>> getAllContributions() async {
    await Future<void>.delayed(_delay);
    return [];
  }

  @override
  Future<SavingsContributionModel> getContributionById(String id) async {
    await Future<void>.delayed(_delay);
    throw const ServerException(
      message: 'Contribution not found',
      statusCode: 404,
    );
  }

  @override
  Future<SavingsContributionModel> createContribution(
    SavingsContributionModel model,
  ) async {
    await Future<void>.delayed(_delay);
    return model;
  }

  @override
  Future<SavingsContributionModel> updateContribution(
    SavingsContributionModel model,
  ) async {
    await Future<void>.delayed(_delay);
    return model;
  }
}
