import 'package:drift/drift.dart' as drift;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kale/core/database/app_database.dart' as db;
import 'package:kale/core/sync/pull.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';

part 'budget_category_model.freezed.dart';
part 'budget_category_model.g.dart';

/// Data model for [BudgetCategoryAllocation] with JSON serialization
/// and Drift conversion.
///
/// `allocated_minor` is an integer count of minor units of the account's
/// base currency.
@freezed
abstract class BudgetCategoryModel
    with _$BudgetCategoryModel
    implements PulledRow {
  const factory BudgetCategoryModel({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'group_name') required String groupName,
    @JsonKey(name: 'allocated_minor') required int allocatedMinor,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'allocated_percentage') double? allocatedPercentage,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @Default(false)
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool isSynced,
  }) = _BudgetCategoryModel;
  const BudgetCategoryModel._();

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
        allocatedMinor: row.allocatedMinor,
        allocatedPercentage: row.allocatedPercentage,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        isSynced: row.isSynced,
      );

  /// Converts this model to a domain [BudgetCategoryAllocation] entity.
  ///
  /// [spentMinor] must be provided externally since it is computed from
  /// transactions and not stored in the budget_categories table.
  BudgetCategoryAllocation toEntity(int spentMinor) => BudgetCategoryAllocation(
        id: id,
        budgetId: budgetId,
        categoryId: categoryId,
        groupName: groupName,
        allocatedMinor: allocatedMinor,
        allocatedPercentage: allocatedPercentage,
        spentMinor: spentMinor,
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
        allocatedMinor: drift.Value(allocatedMinor),
        allocatedPercentage: drift.Value(allocatedPercentage),
        createdAt: drift.Value(createdAt),
        updatedAt: drift.Value(updatedAt),
        deletedAt: drift.Value(deletedAt),
        isSynced: drift.Value(isSynced),
      );
}
