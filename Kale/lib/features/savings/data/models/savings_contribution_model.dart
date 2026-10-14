import 'package:drift/drift.dart' as drift;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kale/core/database/app_database.dart' as db;
import 'package:kale/core/sync/pull.dart';
import 'package:kale/features/savings/domain/entities/savings_contribution.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';

part 'savings_contribution_model.freezed.dart';
part 'savings_contribution_model.g.dart';

/// Data model for savings contributions.
///
/// `amount_minor` is an integer count of minor units of the account's base
/// currency. A contribution is owned through its goal (`goal_id`).
@freezed
abstract class SavingsContributionModel
    with _$SavingsContributionModel
    implements PulledRow {
  const factory SavingsContributionModel({
    required String id,
    @JsonKey(name: 'goal_id') required String goalId,
    @JsonKey(name: 'amount_minor') required int amountMinor,
    required String source,
    required DateTime date,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'server_id') String? serverId,
    String? note,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @Default(true)
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool isSynced,
  }) = _SavingsContributionModel;
  const SavingsContributionModel._();

  factory SavingsContributionModel.fromJson(Map<String, dynamic> json) =>
      _$SavingsContributionModelFromJson(json);

  /// Creates a model from a Drift database row.
  factory SavingsContributionModel.fromDrift(db.SavingsContribution row) =>
      SavingsContributionModel(
        id: row.id,
        serverId: row.serverId,
        goalId: row.goalId,
        amountMinor: row.amountMinor,
        source: row.source,
        note: row.note,
        date: row.date,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        isSynced: row.isSynced,
      );

  /// Converts to a domain entity.
  SavingsContribution toEntity() => SavingsContribution(
        id: id,
        goalId: goalId,
        amountMinor: amountMinor,
        source: ContributionSource.values.firstWhere(
          (e) => e.name == source,
          orElse: () => ContributionSource.manual,
        ),
        date: date,
        note: note,
        createdAt: createdAt,
        isSynced: isSynced,
      );

  /// Converts to a Drift companion for upsert.
  db.SavingsContributionsCompanion toDriftCompanion({
    required bool isSynced,
  }) =>
      db.SavingsContributionsCompanion(
        id: drift.Value(id),
        serverId: serverId != null
            ? drift.Value(serverId)
            : const drift.Value.absent(),
        goalId: drift.Value(goalId),
        amountMinor: drift.Value(amountMinor),
        source: drift.Value(source),
        note: drift.Value(note),
        date: drift.Value(date),
        createdAt: drift.Value(createdAt),
        updatedAt: drift.Value(updatedAt),
        deletedAt: drift.Value(deletedAt),
        isSynced: drift.Value(isSynced),
      );
}
