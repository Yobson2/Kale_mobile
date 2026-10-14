// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetCategoryModel _$BudgetCategoryModelFromJson(Map<String, dynamic> json) =>
    _BudgetCategoryModel(
      id: json['id'] as String,
      budgetId: json['budget_id'] as String,
      categoryId: json['category_id'] as String,
      groupName: json['group_name'] as String,
      allocatedMinor: (json['allocated_minor'] as num).toInt(),
      allocatedPercentage: (json['allocated_percentage'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$BudgetCategoryModelToJson(
        _BudgetCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget_id': instance.budgetId,
      'category_id': instance.categoryId,
      'group_name': instance.groupName,
      'allocated_minor': instance.allocatedMinor,
      'allocated_percentage': instance.allocatedPercentage,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
