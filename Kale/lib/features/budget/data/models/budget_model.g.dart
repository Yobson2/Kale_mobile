// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetModel _$BudgetModelFromJson(Map<String, dynamic> json) => _BudgetModel(
      id: json['id'] as String,
      serverId: json['server_id'] as String?,
      name: json['name'] as String,
      strategy: json['strategy'] as String,
      period: json['period'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      totalIncome: (json['total_income'] as num?)?.toDouble(),
      isPercentageBased: json['is_percentage_based'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$BudgetModelToJson(_BudgetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'server_id': instance.serverId,
      'name': instance.name,
      'strategy': instance.strategy,
      'period': instance.period,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'total_income': instance.totalIncome,
      'is_percentage_based': instance.isPercentageBased,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
