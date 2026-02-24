import 'package:drift/drift.dart' as drift;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kale/core/database/app_database.dart' as db;
import 'package:kale/features/transactions/domain/entities/category.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// Data model for [Category] with JSON serialization and Drift mapping.
@freezed
abstract class CategoryModel with _$CategoryModel {
  const CategoryModel._();

  const factory CategoryModel({
    required String id,
    required String name,
    required String icon,
    required String color,
    required String type,
    @Default(true) @JsonKey(name: 'is_default') bool isDefault,
    @Default(0) @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default(true)
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool isSynced,
  }) = _CategoryModel;

  /// Creates a [CategoryModel] from JSON.
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  /// Creates a [CategoryModel] from a Drift database row.
  factory CategoryModel.fromDrift(db.Category row) => CategoryModel(
        id: row.id,
        name: row.name,
        icon: row.icon,
        color: row.color,
        type: row.type,
        isDefault: row.isDefault,
        sortOrder: row.sortOrder,
        createdAt: row.createdAt,
        isSynced: row.isSynced,
      );

  /// Creates a [CategoryModel] from a domain [Category] entity.
  factory CategoryModel.fromEntity(Category entity) => CategoryModel(
        id: entity.id,
        name: entity.name,
        icon: entity.icon,
        color: entity.color,
        type: entity.type.name,
        isDefault: entity.isDefault,
        sortOrder: entity.sortOrder,
        createdAt: entity.createdAt,
      );

  /// Converts this model to a domain [Category] entity.
  Category toEntity() => Category(
        id: id,
        name: name,
        icon: icon,
        color: color,
        type: CategoryType.values.firstWhere((e) => e.name == type),
        isDefault: isDefault,
        sortOrder: sortOrder,
        createdAt: createdAt,
      );

  /// Converts this model to a Drift companion for insert/update operations.
  db.CategoriesCompanion toDriftCompanion({required bool isSynced}) =>
      db.CategoriesCompanion(
        id: drift.Value(id),
        name: drift.Value(name),
        icon: drift.Value(icon),
        color: drift.Value(color),
        type: drift.Value(type),
        isDefault: drift.Value(isDefault),
        sortOrder: drift.Value(sortOrder),
        createdAt: drift.Value(createdAt),
        isSynced: drift.Value(isSynced),
      );
}
