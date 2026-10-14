// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_contribution_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavingsContributionModel _$SavingsContributionModelFromJson(
        Map<String, dynamic> json) =>
    _SavingsContributionModel(
      id: json['id'] as String,
      goalId: json['goal_id'] as String,
      amountMinor: (json['amount_minor'] as num).toInt(),
      source: json['source'] as String,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      serverId: json['server_id'] as String?,
      note: json['note'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$SavingsContributionModelToJson(
        _SavingsContributionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'goal_id': instance.goalId,
      'amount_minor': instance.amountMinor,
      'source': instance.source,
      'date': instance.date.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'server_id': instance.serverId,
      'note': instance.note,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
