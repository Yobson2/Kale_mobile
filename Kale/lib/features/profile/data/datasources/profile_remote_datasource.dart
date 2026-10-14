import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/profile/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for the signed-in user's `profiles` row.
abstract class ProfileRemoteDataSource {
  /// Fetches the current user's profile, or null if the base currency was
  /// never chosen on the server.
  Future<ProfileModel?> getProfile();

  /// Writes the current user's profile.
  Future<ProfileModel> updateProfile(ProfileModel model);
}

/// [ProfileRemoteDataSource] backed by Supabase. The `profiles` row is
/// created by the server's sign-up trigger; this only reads and updates it.
class SupabaseProfileRemoteDataSource implements ProfileRemoteDataSource {
  const SupabaseProfileRemoteDataSource(this._supabase);

  final SupabaseClient _supabase;

  String get _userId => _supabase.auth.currentUser!.id;
  SupabaseQueryBuilder get _table => _supabase.from('profiles');

  @override
  Future<ProfileModel?> getProfile() async {
    try {
      final data = await _table
          .select('base_currency, updated_at')
          .eq('id', _userId)
          .maybeSingle();
      if (data == null || data['base_currency'] == null) return null;
      return ProfileModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel model) async {
    try {
      final data = await _table
          .update(model.toJson())
          .eq('id', _userId)
          .select('base_currency, updated_at')
          .single();
      return ProfileModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: _parseCode(e));
    }
  }

  static int? _parseCode(PostgrestException e) =>
      e.code != null ? int.tryParse(e.code!) : null;
}

/// In-memory [ProfileRemoteDataSource], used whenever auth is mocked
/// (`USE_MOCK_AUTH`), since there is then no real server user.
class MockProfileRemoteDataSource implements ProfileRemoteDataSource {
  ProfileModel? _profile;

  @override
  Future<ProfileModel?> getProfile() async => _profile;

  @override
  Future<ProfileModel> updateProfile(ProfileModel model) async =>
      _profile = model;
}
