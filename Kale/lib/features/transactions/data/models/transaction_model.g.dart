// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      id: json['id'] as String,
      serverId: json['server_id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      categoryId: json['category_id'] as String,
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
      paymentMethod: json['payment_method'] as String,
      currencyCode: json['currency_code'] as String,
      isRecurring: json['is_recurring'] as bool? ?? false,
      recurringRuleId: json['recurring_rule_id'] as String?,
      mobileMoneyProvider: json['mobile_money_provider'] as String?,
      mobileMoneyRef: json['mobile_money_ref'] as String?,
      accountId: json['account_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'server_id': instance.serverId,
      'amount': instance.amount,
      'type': instance.type,
      'category_id': instance.categoryId,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'payment_method': instance.paymentMethod,
      'currency_code': instance.currencyCode,
      'is_recurring': instance.isRecurring,
      'recurring_rule_id': instance.recurringRuleId,
      'mobile_money_provider': instance.mobileMoneyProvider,
      'mobile_money_ref': instance.mobileMoneyRef,
      'account_id': instance.accountId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
