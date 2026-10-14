import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/sync/pull.dart';
import 'package:kale/core/sync/supabase_pull.dart';
import 'package:kale/features/savings/data/models/savings_contribution_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote datasource for the `savings_contributions` table.
///
/// Contributions have no `user_id`: they are owned through their goal, and
/// the server's RLS only exposes contributions of goals the user owns.
abstract class SavingsContributionsRemoteDataSource {
  /// Fetches the rows changed after [after], at most [limit], in pull
  /// order (see `pullPageQuery`). Includes tombstones.
  Future<RemotePage<SavingsContributionModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  });

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
  Future<RemotePage<SavingsContributionModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  }) async {
    try {
      final data = await pullPageQuery(
        _table.select(_columns).eq('savings_goals.user_id', _userId),
        after: after,
        limit: limit,
      );
      return toRemotePage(data, _fromRow);
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
  Future<RemotePage<SavingsContributionModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  }) async {
    await Future<void>.delayed(_delay);
    return const RemotePage([]);
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
