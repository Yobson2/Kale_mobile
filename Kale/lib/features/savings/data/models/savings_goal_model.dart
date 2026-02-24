import 'package:drift/drift.dart' as drift;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kale/core/database/app_database.dart' as db;
import 'package:kale/features/savings/domain/entities/savings_enums.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';

part 'savings_goal_model.freezed.dart';
part 'savings_goal_model.g.dart';

/// Data model for savings goals.
@freezed
abstract class SavingsGoalModel with _$SavingsGoalModel {
  const SavingsGoalModel._();

  const factory SavingsGoalModel({
    required String id,
    @JsonKey(name: 'server_id') String? serverId,
    required String name,
    @JsonKey(name: 'target_amount') required double targetAmount,
    @JsonKey(name: 'current_amount') @Default(0.0) double currentAmount,
    @JsonKey(name: 'currency_code') required String currencyCode,
    String? description,
    DateTime? deadline,
    @JsonKey(name: 'icon_name') String? iconName,
    @JsonKey(name: 'color_hex') String? colorHex,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @Default(true)
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool isSynced,
  }) = _SavingsGoalModel;

  factory SavingsGoalModel.fromJson(Map<String, dynamic> json) =>
      _$SavingsGoalModelFromJson(json);

  /// Creates a model from a Drift database row.
  factory SavingsGoalModel.fromDrift(db.SavingsGoal row) => SavingsGoalModel(
        id: row.id,
        serverId: row.serverId,
        name: row.name,
        targetAmount: row.targetAmount,
        currentAmount: row.currentAmount,
        currencyCode: row.currencyCode,
        description: row.description,
        deadline: row.deadline,
        iconName: row.iconName,
        colorHex: row.colorHex,
        status: row.status,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        isSynced: row.isSynced,
      );

  /// Converts to a domain entity.
  SavingsGoal toEntity() => SavingsGoal(
        id: id,
        name: name,
        targetAmount: targetAmount,
        currentAmount: currentAmount,
        currencyCode: currencyCode,
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
  db.SavingsGoalsCompanion toDriftCompanion() => db.SavingsGoalsCompanion(
        id: drift.Value(id),
        serverId: serverId != null
            ? drift.Value(serverId)
            : const drift.Value.absent(),
        name: drift.Value(name),
        targetAmount: drift.Value(targetAmount),
        currentAmount: drift.Value(currentAmount),
        currencyCode: drift.Value(currencyCode),
        description: drift.Value(description),
        deadline: deadline != null
            ? drift.Value(deadline)
            : const drift.Value.absent(),
        iconName: drift.Value(iconName),
        colorHex: drift.Value(colorHex),
        status: drift.Value(status),
        createdAt: drift.Value(createdAt),
        updatedAt: drift.Value(updatedAt),
        isSynced: drift.Value(isSynced),
      );
}
