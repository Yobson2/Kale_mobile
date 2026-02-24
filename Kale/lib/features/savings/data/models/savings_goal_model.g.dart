// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavingsGoalModel _$SavingsGoalModelFromJson(Map<String, dynamic> json) =>
    _SavingsGoalModel(
      id: json['id'] as String,
      serverId: json['server_id'] as String?,
      name: json['name'] as String,
      targetAmount: (json['target_amount'] as num).toDouble(),
      currentAmount: (json['current_amount'] as num?)?.toDouble() ?? 0.0,
      currencyCode: json['currency_code'] as String,
      description: json['description'] as String?,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      iconName: json['icon_name'] as String?,
      colorHex: json['color_hex'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$SavingsGoalModelToJson(_SavingsGoalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'server_id': instance.serverId,
      'name': instance.name,
      'target_amount': instance.targetAmount,
      'current_amount': instance.currentAmount,
      'currency_code': instance.currencyCode,
      'description': instance.description,
      'deadline': instance.deadline?.toIso8601String(),
      'icon_name': instance.iconName,
      'color_hex': instance.colorHex,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
