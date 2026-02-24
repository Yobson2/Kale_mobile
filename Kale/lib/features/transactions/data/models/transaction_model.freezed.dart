// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionModel {
  String get id;
  @JsonKey(name: 'server_id')
  String? get serverId;
  double get amount;
  String get type;
  @JsonKey(name: 'category_id')
  String get categoryId;
  String? get description;
  DateTime get date;
  @JsonKey(name: 'payment_method')
  String get paymentMethod;
  @JsonKey(name: 'currency_code')
  String get currencyCode;
  @JsonKey(name: 'is_recurring')
  bool get isRecurring;
  @JsonKey(name: 'recurring_rule_id')
  String? get recurringRuleId;
  @JsonKey(name: 'mobile_money_provider')
  String? get mobileMoneyProvider;
  @JsonKey(name: 'mobile_money_ref')
  String? get mobileMoneyRef;
  @JsonKey(name: 'account_id')
  String? get accountId;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isSynced;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionModelCopyWith<TransactionModel> get copyWith =>
      _$TransactionModelCopyWithImpl<TransactionModel>(
          this as TransactionModel, _$identity);

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransactionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.recurringRuleId, recurringRuleId) ||
                other.recurringRuleId == recurringRuleId) &&
            (identical(other.mobileMoneyProvider, mobileMoneyProvider) ||
                other.mobileMoneyProvider == mobileMoneyProvider) &&
            (identical(other.mobileMoneyRef, mobileMoneyRef) ||
                other.mobileMoneyRef == mobileMoneyRef) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      serverId,
      amount,
      type,
      categoryId,
      description,
      date,
      paymentMethod,
      currencyCode,
      isRecurring,
      recurringRuleId,
      mobileMoneyProvider,
      mobileMoneyRef,
      accountId,
      createdAt,
      updatedAt,
      isSynced);

  @override
  String toString() {
    return 'TransactionModel(id: $id, serverId: $serverId, amount: $amount, type: $type, categoryId: $categoryId, description: $description, date: $date, paymentMethod: $paymentMethod, currencyCode: $currencyCode, isRecurring: $isRecurring, recurringRuleId: $recurringRuleId, mobileMoneyProvider: $mobileMoneyProvider, mobileMoneyRef: $mobileMoneyRef, accountId: $accountId, createdAt: $createdAt, updatedAt: $updatedAt, isSynced: $isSynced)';
  }
}

/// @nodoc
abstract mixin class $TransactionModelCopyWith<$Res> {
  factory $TransactionModelCopyWith(
          TransactionModel value, $Res Function(TransactionModel) _then) =
      _$TransactionModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'server_id') String? serverId,
      double amount,
      String type,
      @JsonKey(name: 'category_id') String categoryId,
      String? description,
      DateTime date,
      @JsonKey(name: 'payment_method') String paymentMethod,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'is_recurring') bool isRecurring,
      @JsonKey(name: 'recurring_rule_id') String? recurringRuleId,
      @JsonKey(name: 'mobile_money_provider') String? mobileMoneyProvider,
      @JsonKey(name: 'mobile_money_ref') String? mobileMoneyRef,
      @JsonKey(name: 'account_id') String? accountId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isSynced});
}

/// @nodoc
class _$TransactionModelCopyWithImpl<$Res>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._self, this._then);

  final TransactionModel _self;
  final $Res Function(TransactionModel) _then;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? amount = null,
    Object? type = null,
    Object? categoryId = null,
    Object? description = freezed,
    Object? date = null,
    Object? paymentMethod = null,
    Object? currencyCode = null,
    Object? isRecurring = null,
    Object? recurringRuleId = freezed,
    Object? mobileMoneyProvider = freezed,
    Object? mobileMoneyRef = freezed,
    Object? accountId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isSynced = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serverId: freezed == serverId
          ? _self.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      isRecurring: null == isRecurring
          ? _self.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      recurringRuleId: freezed == recurringRuleId
          ? _self.recurringRuleId
          : recurringRuleId // ignore: cast_nullable_to_non_nullable
              as String?,
      mobileMoneyProvider: freezed == mobileMoneyProvider
          ? _self.mobileMoneyProvider
          : mobileMoneyProvider // ignore: cast_nullable_to_non_nullable
              as String?,
      mobileMoneyRef: freezed == mobileMoneyRef
          ? _self.mobileMoneyRef
          : mobileMoneyRef // ignore: cast_nullable_to_non_nullable
              as String?,
      accountId: freezed == accountId
          ? _self.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSynced: null == isSynced
          ? _self.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TransactionModel extends TransactionModel {
  const _TransactionModel(
      {required this.id,
      @JsonKey(name: 'server_id') this.serverId,
      required this.amount,
      required this.type,
      @JsonKey(name: 'category_id') required this.categoryId,
      this.description,
      required this.date,
      @JsonKey(name: 'payment_method') required this.paymentMethod,
      @JsonKey(name: 'currency_code') required this.currencyCode,
      @JsonKey(name: 'is_recurring') this.isRecurring = false,
      @JsonKey(name: 'recurring_rule_id') this.recurringRuleId,
      @JsonKey(name: 'mobile_money_provider') this.mobileMoneyProvider,
      @JsonKey(name: 'mobile_money_ref') this.mobileMoneyRef,
      @JsonKey(name: 'account_id') this.accountId,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.isSynced = true})
      : super._();
  factory _TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'server_id')
  final String? serverId;
  @override
  final double amount;
  @override
  final String type;
  @override
  @JsonKey(name: 'category_id')
  final String categoryId;
  @override
  final String? description;
  @override
  final DateTime date;
  @override
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @override
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  @override
  @JsonKey(name: 'is_recurring')
  final bool isRecurring;
  @override
  @JsonKey(name: 'recurring_rule_id')
  final String? recurringRuleId;
  @override
  @JsonKey(name: 'mobile_money_provider')
  final String? mobileMoneyProvider;
  @override
  @JsonKey(name: 'mobile_money_ref')
  final String? mobileMoneyRef;
  @override
  @JsonKey(name: 'account_id')
  final String? accountId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isSynced;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransactionModelCopyWith<_TransactionModel> get copyWith =>
      __$TransactionModelCopyWithImpl<_TransactionModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransactionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransactionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.recurringRuleId, recurringRuleId) ||
                other.recurringRuleId == recurringRuleId) &&
            (identical(other.mobileMoneyProvider, mobileMoneyProvider) ||
                other.mobileMoneyProvider == mobileMoneyProvider) &&
            (identical(other.mobileMoneyRef, mobileMoneyRef) ||
                other.mobileMoneyRef == mobileMoneyRef) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      serverId,
      amount,
      type,
      categoryId,
      description,
      date,
      paymentMethod,
      currencyCode,
      isRecurring,
      recurringRuleId,
      mobileMoneyProvider,
      mobileMoneyRef,
      accountId,
      createdAt,
      updatedAt,
      isSynced);

  @override
  String toString() {
    return 'TransactionModel(id: $id, serverId: $serverId, amount: $amount, type: $type, categoryId: $categoryId, description: $description, date: $date, paymentMethod: $paymentMethod, currencyCode: $currencyCode, isRecurring: $isRecurring, recurringRuleId: $recurringRuleId, mobileMoneyProvider: $mobileMoneyProvider, mobileMoneyRef: $mobileMoneyRef, accountId: $accountId, createdAt: $createdAt, updatedAt: $updatedAt, isSynced: $isSynced)';
  }
}

/// @nodoc
abstract mixin class _$TransactionModelCopyWith<$Res>
    implements $TransactionModelCopyWith<$Res> {
  factory _$TransactionModelCopyWith(
          _TransactionModel value, $Res Function(_TransactionModel) _then) =
      __$TransactionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'server_id') String? serverId,
      double amount,
      String type,
      @JsonKey(name: 'category_id') String categoryId,
      String? description,
      DateTime date,
      @JsonKey(name: 'payment_method') String paymentMethod,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'is_recurring') bool isRecurring,
      @JsonKey(name: 'recurring_rule_id') String? recurringRuleId,
      @JsonKey(name: 'mobile_money_provider') String? mobileMoneyProvider,
      @JsonKey(name: 'mobile_money_ref') String? mobileMoneyRef,
      @JsonKey(name: 'account_id') String? accountId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isSynced});
}

/// @nodoc
class __$TransactionModelCopyWithImpl<$Res>
    implements _$TransactionModelCopyWith<$Res> {
  __$TransactionModelCopyWithImpl(this._self, this._then);

  final _TransactionModel _self;
  final $Res Function(_TransactionModel) _then;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? amount = null,
    Object? type = null,
    Object? categoryId = null,
    Object? description = freezed,
    Object? date = null,
    Object? paymentMethod = null,
    Object? currencyCode = null,
    Object? isRecurring = null,
    Object? recurringRuleId = freezed,
    Object? mobileMoneyProvider = freezed,
    Object? mobileMoneyRef = freezed,
    Object? accountId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isSynced = null,
  }) {
    return _then(_TransactionModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serverId: freezed == serverId
          ? _self.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      isRecurring: null == isRecurring
          ? _self.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      recurringRuleId: freezed == recurringRuleId
          ? _self.recurringRuleId
          : recurringRuleId // ignore: cast_nullable_to_non_nullable
              as String?,
      mobileMoneyProvider: freezed == mobileMoneyProvider
          ? _self.mobileMoneyProvider
          : mobileMoneyProvider // ignore: cast_nullable_to_non_nullable
              as String?,
      mobileMoneyRef: freezed == mobileMoneyRef
          ? _self.mobileMoneyRef
          : mobileMoneyRef // ignore: cast_nullable_to_non_nullable
              as String?,
      accountId: freezed == accountId
          ? _self.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSynced: null == isSynced
          ? _self.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
