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
      allocatedAmount: (json['allocated_amount'] as num).toDouble(),
      allocatedPercentage: (json['allocated_percentage'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$BudgetCategoryModelToJson(
        _BudgetCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget_id': instance.budgetId,
      'category_id': instance.categoryId,
      'group_name': instance.groupName,
      'allocated_amount': instance.allocatedAmount,
      'allocated_percentage': instance.allocatedPercentage,
      'created_at': instance.createdAt.toIso8601String(),
    };
