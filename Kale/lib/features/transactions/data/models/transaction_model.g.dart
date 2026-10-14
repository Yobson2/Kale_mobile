// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      id: json['id'] as String,
      amountMinor: (json['amount_minor'] as num).toInt(),
      type: json['type'] as String,
      categoryId: json['category_id'] as String,
      date: DateTime.parse(json['date'] as String),
      paymentMethod: json['payment_method'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      serverId: json['server_id'] as String?,
      description: json['description'] as String?,
      isRecurring: json['is_recurring'] as bool? ?? false,
      recurringRuleId: json['recurring_rule_id'] as String?,
      mobileMoneyProvider: json['mobile_money_provider'] as String?,
      mobileMoneyRef: json['mobile_money_ref'] as String?,
      accountId: json['account_id'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount_minor': instance.amountMinor,
      'type': instance.type,
      'category_id': instance.categoryId,
      'date': instance.date.toIso8601String(),
      'payment_method': instance.paymentMethod,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'server_id': instance.serverId,
      'description': instance.description,
      'is_recurring': instance.isRecurring,
      'recurring_rule_id': instance.recurringRuleId,
      'mobile_money_provider': instance.mobileMoneyProvider,
      'mobile_money_ref': instance.mobileMoneyRef,
      'account_id': instance.accountId,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
