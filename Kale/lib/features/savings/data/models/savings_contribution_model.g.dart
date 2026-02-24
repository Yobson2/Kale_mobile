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
      amount: (json['amount'] as num).toDouble(),
      source: json['source'] as String,
      note: json['note'] as String?,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$SavingsContributionModelToJson(
        _SavingsContributionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'goal_id': instance.goalId,
      'amount': instance.amount,
      'source': instance.source,
      'note': instance.note,
      'date': instance.date.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
