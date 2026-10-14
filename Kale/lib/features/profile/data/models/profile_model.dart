import 'package:drift/drift.dart' as drift;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kale/core/database/app_database.dart' as db;

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

/// Data model for the account profile, as stored on the device and in the
/// server's `profiles` table (keyed there by the user's id).
@freezed
abstract class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    @JsonKey(name: 'base_currency') required String baseCurrency,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ProfileModel;

  const ProfileModel._();

  /// Creates a [ProfileModel] from server JSON.
  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  /// Creates a [ProfileModel] from the device row.
  factory ProfileModel.fromDrift(db.Profile row) => ProfileModel(
        baseCurrency: row.baseCurrency,
        updatedAt: row.updatedAt,
      );

  /// The id of the single device row, and of its sync queue entries.
  static const localId = 'me';

  /// Converts this model to a Drift companion for the device row.
  db.ProfilesCompanion toDriftCompanion({required bool isSynced}) =>
      db.ProfilesCompanion(
        id: const drift.Value(localId),
        baseCurrency: drift.Value(baseCurrency),
        updatedAt: drift.Value(updatedAt),
        isSynced: drift.Value(isSynced),
      );
}
