import 'package:drift/drift.dart' as drift;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kale/core/database/app_database.dart' as db;
import 'package:kale/features/savings/domain/entities/savings_enums.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';

part 'savings_goal_model.freezed.dart';
part 'savings_goal_model.g.dart';

/// Data model for savings goals.
///
/// Amounts are integer minor units of the account's base currency. There
/// is no per-goal currency. `current_amount_minor` is computed on the
/// device from the goal's contributions and pushed as-is.
@freezed
abstract class SavingsGoalModel with _$SavingsGoalModel {
  const factory SavingsGoalModel({
    required String id,
    required String name,
    @JsonKey(name: 'target_amount_minor') required int targetAmountMinor,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'server_id') String? serverId,
    @JsonKey(name: 'current_amount_minor') @Default(0) int currentAmountMinor,
    String? description,
    DateTime? deadline,
    @JsonKey(name: 'icon_name') String? iconName,
    @JsonKey(name: 'color_hex') String? colorHex,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @Default(true)
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool isSynced,
  }) = _SavingsGoalModel;
  const SavingsGoalModel._();

  factory SavingsGoalModel.fromJson(Map<String, dynamic> json) =>
      _$SavingsGoalModelFromJson(json);

  /// Creates a model from a Drift database row.
  factory SavingsGoalModel.fromDrift(db.SavingsGoal row) => SavingsGoalModel(
        id: row.id,
        serverId: row.serverId,
        name: row.name,
        targetAmountMinor: row.targetAmountMinor,
        currentAmountMinor: row.currentAmountMinor,
        description: row.description,
        deadline: row.deadline,
        iconName: row.iconName,
        colorHex: row.colorHex,
        status: row.status,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        isSynced: row.isSynced,
      );

  /// Converts to a domain entity.
  SavingsGoal toEntity() => SavingsGoal(
        id: id,
        name: name,
        targetAmountMinor: targetAmountMinor,
        currentAmountMinor: currentAmountMinor,
        description: description,
        deadline: deadline,
        iconName: iconName,
        colorHex: colorHex,
        status: SavingsGoalStatus.values.firstWhere(
          (e) => e.name == status,
          orElse: () => SavingsGoalStatus.active,
        ),
        createdAt: createdAt,
        updatedAt: updatedAt,
        isSynced: isSynced,
      );

  /// Converts to a Drift companion for upsert.
  db.SavingsGoalsCompanion toDriftCompanion({required bool isSynced}) =>
      db.SavingsGoalsCompanion(
        id: drift.Value(id),
        serverId: serverId != null
            ? drift.Value(serverId)
            : const drift.Value.absent(),
        name: drift.Value(name),
        targetAmountMinor: drift.Value(targetAmountMinor),
        currentAmountMinor: drift.Value(currentAmountMinor),
        description: drift.Value(description),
        deadline: drift.Value(deadline),
        iconName: drift.Value(iconName),
        colorHex: drift.Value(colorHex),
        status: drift.Value(status),
        createdAt: drift.Value(createdAt),
        updatedAt: drift.Value(updatedAt),
        deletedAt: drift.Value(deletedAt),
        isSynced: drift.Value(isSynced),
      );
}
