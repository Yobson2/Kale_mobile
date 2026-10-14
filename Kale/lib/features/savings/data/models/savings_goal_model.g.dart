// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavingsGoalModel _$SavingsGoalModelFromJson(Map<String, dynamic> json) =>
    _SavingsGoalModel(
      id: json['id'] as String,
      name: json['name'] as String,
      targetAmountMinor: (json['target_amount_minor'] as num).toInt(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      serverId: json['server_id'] as String?,
      currentAmountMinor: (json['current_amount_minor'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      iconName: json['icon_name'] as String?,
      colorHex: json['color_hex'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$SavingsGoalModelToJson(_SavingsGoalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'target_amount_minor': instance.targetAmountMinor,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'server_id': instance.serverId,
      'current_amount_minor': instance.currentAmountMinor,
      'description': instance.description,
      'deadline': instance.deadline?.toIso8601String(),
      'icon_name': instance.iconName,
      'color_hex': instance.colorHex,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
