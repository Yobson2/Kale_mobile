// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetModel _$BudgetModelFromJson(Map<String, dynamic> json) => _BudgetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      strategy: json['strategy'] as String,
      period: json['period'] as String,
      startDate: const CalendarDateJsonConverter()
          .fromJson(json['start_date'] as String),
      endDate: const CalendarDateJsonConverter()
          .fromJson(json['end_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      serverId: json['server_id'] as String?,
      periodStartDay: (json['period_start_day'] as num?)?.toInt() ??
          BudgetPeriodRange.defaultStartDay,
      totalIncomeMinor: (json['total_income_minor'] as num?)?.toInt(),
      isPercentageBased: json['is_percentage_based'] as bool? ?? true,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$BudgetModelToJson(_BudgetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'strategy': instance.strategy,
      'period': instance.period,
      'start_date':
          const CalendarDateJsonConverter().toJson(instance.startDate),
      'end_date': const CalendarDateJsonConverter().toJson(instance.endDate),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'server_id': instance.serverId,
      'period_start_day': instance.periodStartDay,
      'total_income_minor': instance.totalIncomeMinor,
      'is_percentage_based': instance.isPercentageBased,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
