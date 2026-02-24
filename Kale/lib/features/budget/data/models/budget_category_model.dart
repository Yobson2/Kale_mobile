import 'package:drift/drift.dart' as drift;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kale/core/database/app_database.dart' as db;
import 'package:kale/features/budget/domain/entities/budget_category.dart';

part 'budget_category_model.freezed.dart';
part 'budget_category_model.g.dart';

/// Data model for [BudgetCategoryAllocation] with JSON serialization
/// and Drift conversion.
@freezed
abstract class BudgetCategoryModel with _$BudgetCategoryModel {
  const BudgetCategoryModel._();

  const factory BudgetCategoryModel({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'group_name') required String groupName,
    @JsonKey(name: 'allocated_amount') required double allocatedAmount,
    @JsonKey(name: 'allocated_percentage') double? allocatedPercentage,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default(false)
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool isSynced,
  }) = _BudgetCategoryModel;

  /// Creates a [BudgetCategoryModel] from JSON.
  factory BudgetCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetCategoryModelFromJson(json);

  /// Creates a [BudgetCategoryModel] from a Drift [db.BudgetCategory] row.
  factory BudgetCategoryModel.fromDrift(db.BudgetCategory row) =>
      BudgetCategoryModel(
        id: row.id,
        budgetId: row.budgetId,
        categoryId: row.categoryId,
        groupName: row.groupName,
        allocatedAmount: row.allocatedAmount,
        allocatedPercentage: row.allocatedPercentage,
        createdAt: row.createdAt,
        isSynced: row.isSynced,
      );

  /// Converts this model to a domain [BudgetCategoryAllocation] entity.
  ///
  /// [spentAmount] must be provided externally since it is computed
  /// from transactions and not stored in the budget_categories table.
  BudgetCategoryAllocation toEntity(double spentAmount) =>
      BudgetCategoryAllocation(
        id: id,
        budgetId: budgetId,
        categoryId: categoryId,
        groupName: groupName,
        allocatedAmount: allocatedAmount,
        allocatedPercentage: allocatedPercentage,
        spentAmount: spentAmount,
        createdAt: createdAt,
      );

  /// Converts this model to a Drift [db.BudgetCategoriesCompanion]
  /// for upserting.
  db.BudgetCategoriesCompanion toDriftCompanion() =>
      db.BudgetCategoriesCompanion(
        id: drift.Value(id),
        budgetId: drift.Value(budgetId),
        categoryId: drift.Value(categoryId),
        groupName: drift.Value(groupName),
        allocatedAmount: drift.Value(allocatedAmount),
        allocatedPercentage: allocatedPercentage != null
            ? drift.Value(allocatedPercentage)
            : const drift.Value.absent(),
        createdAt: drift.Value(createdAt),
        isSynced: drift.Value(isSynced),
      );
}
