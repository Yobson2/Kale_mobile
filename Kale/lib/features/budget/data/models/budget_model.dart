import 'package:drift/drift.dart' as drift;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kale/core/database/app_database.dart' as db;
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';

part 'budget_model.freezed.dart';
part 'budget_model.g.dart';

/// Data model for [Budget] with JSON serialization and Drift conversion.
@freezed
abstract class BudgetModel with _$BudgetModel {
  const BudgetModel._();

  const factory BudgetModel({
    required String id,
    @JsonKey(name: 'server_id') String? serverId,
    required String name,
    required String strategy,
    required String period,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') required DateTime endDate,
    @JsonKey(name: 'total_income') double? totalIncome,
    @Default(true) @JsonKey(name: 'is_percentage_based') bool isPercentageBased,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @Default(false)
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool isSynced,
  }) = _BudgetModel;

  /// Creates a [BudgetModel] from JSON.
  factory BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);

  /// Creates a [BudgetModel] from a Drift [db.Budget] row.
  factory BudgetModel.fromDrift(db.Budget row) => BudgetModel(
        id: row.id,
        serverId: row.serverId,
        name: row.name,
        strategy: row.strategy,
        period: row.period,
        startDate: row.startDate,
        endDate: row.endDate,
        totalIncome: row.totalIncome,
        isPercentageBased: row.isPercentageBased,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        isSynced: row.isSynced,
      );

  /// Converts this model to a domain [Budget] entity.
  ///
  /// Category allocations must be provided separately since
  /// they come from a different table.
  Budget toEntity({
    List<BudgetCategoryAllocation> categories = const [],
  }) =>
      Budget(
        id: id,
        name: name,
        strategy: _parseStrategy(strategy),
        period: _parsePeriod(period),
        startDate: startDate,
        endDate: endDate,
        totalIncome: totalIncome,
        isPercentageBased: isPercentageBased,
        categories: categories,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isSynced: isSynced,
      );

  /// Converts this model to a Drift [db.BudgetsCompanion] for upserting.
  db.BudgetsCompanion toDriftCompanion() => db.BudgetsCompanion(
        id: drift.Value(id),
        serverId: serverId != null
            ? drift.Value(serverId)
            : const drift.Value.absent(),
        name: drift.Value(name),
        strategy: drift.Value(strategy),
        period: drift.Value(period),
        startDate: drift.Value(startDate),
        endDate: drift.Value(endDate),
        totalIncome: totalIncome != null
            ? drift.Value(totalIncome)
            : const drift.Value.absent(),
        isPercentageBased: drift.Value(isPercentageBased),
        createdAt: drift.Value(createdAt),
        updatedAt: drift.Value(updatedAt),
        isSynced: drift.Value(isSynced),
      );

  /// Creates a [BudgetModel] from a domain [Budget] entity.
  factory BudgetModel.fromEntity(Budget entity) => BudgetModel(
        id: entity.id,
        name: entity.name,
        strategy: entity.strategy.name,
        period: entity.period.name,
        startDate: entity.startDate,
        endDate: entity.endDate,
        totalIncome: entity.totalIncome,
        isPercentageBased: entity.isPercentageBased,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        isSynced: entity.isSynced,
      );

  static BudgetStrategy _parseStrategy(String value) {
    return BudgetStrategy.values.firstWhere(
      (e) => e.name == value,
      orElse: () => BudgetStrategy.custom,
    );
  }

  static BudgetPeriod _parsePeriod(String value) {
    return BudgetPeriod.values.firstWhere(
      (e) => e.name == value,
      orElse: () => BudgetPeriod.monthly,
    );
  }
}
