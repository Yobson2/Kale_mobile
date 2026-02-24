// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'savings_goal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavingsGoalModel {
  String get id;
  @JsonKey(name: 'server_id')
  String? get serverId;
  String get name;
  @JsonKey(name: 'target_amount')
  double get targetAmount;
  @JsonKey(name: 'current_amount')
  double get currentAmount;
  @JsonKey(name: 'currency_code')
  String get currencyCode;
  String? get description;
  DateTime? get deadline;
  @JsonKey(name: 'icon_name')
  String? get iconName;
  @JsonKey(name: 'color_hex')
  String? get colorHex;
  String get status;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isSynced;

  /// Create a copy of SavingsGoalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SavingsGoalModelCopyWith<SavingsGoalModel> get copyWith =>
      _$SavingsGoalModelCopyWithImpl<SavingsGoalModel>(
          this as SavingsGoalModel, _$identity);

  /// Serializes this SavingsGoalModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SavingsGoalModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.currentAmount, currentAmount) ||
                other.currentAmount == currentAmount) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.status, status) || other.status == status) &&
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
      name,
      targetAmount,
      currentAmount,
      currencyCode,
      description,
      deadline,
      iconName,
      colorHex,
      status,
      createdAt,
      updatedAt,
      isSynced);

  @override
  String toString() {
    return 'SavingsGoalModel(id: $id, serverId: $serverId, name: $name, targetAmount: $targetAmount, currentAmount: $currentAmount, currencyCode: $currencyCode, description: $description, deadline: $deadline, iconName: $iconName, colorHex: $colorHex, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, isSynced: $isSynced)';
  }
}

/// @nodoc
abstract mixin class $SavingsGoalModelCopyWith<$Res> {
  factory $SavingsGoalModelCopyWith(
          SavingsGoalModel value, $Res Function(SavingsGoalModel) _then) =
      _$SavingsGoalModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'server_id') String? serverId,
      String name,
      @JsonKey(name: 'target_amount') double targetAmount,
      @JsonKey(name: 'current_amount') double currentAmount,
      @JsonKey(name: 'currency_code') String currencyCode,
      String? description,
      DateTime? deadline,
      @JsonKey(name: 'icon_name') String? iconName,
      @JsonKey(name: 'color_hex') String? colorHex,
      String status,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isSynced});
}

/// @nodoc
class _$SavingsGoalModelCopyWithImpl<$Res>
    implements $SavingsGoalModelCopyWith<$Res> {
  _$SavingsGoalModelCopyWithImpl(this._self, this._then);

  final SavingsGoalModel _self;
  final $Res Function(SavingsGoalModel) _then;

  /// Create a copy of SavingsGoalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? name = null,
    Object? targetAmount = null,
    Object? currentAmount = null,
    Object? currencyCode = null,
    Object? description = freezed,
    Object? deadline = freezed,
    Object? iconName = freezed,
    Object? colorHex = freezed,
    Object? status = null,
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
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      targetAmount: null == targetAmount
          ? _self.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currentAmount: null == currentAmount
          ? _self.currentAmount
          : currentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      deadline: freezed == deadline
          ? _self.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      iconName: freezed == iconName
          ? _self.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      colorHex: freezed == colorHex
          ? _self.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
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
class _SavingsGoalModel extends SavingsGoalModel {
  const _SavingsGoalModel(
      {required this.id,
      @JsonKey(name: 'server_id') this.serverId,
      required this.name,
      @JsonKey(name: 'target_amount') required this.targetAmount,
      @JsonKey(name: 'current_amount') this.currentAmount = 0.0,
      @JsonKey(name: 'currency_code') required this.currencyCode,
      this.description,
      this.deadline,
      @JsonKey(name: 'icon_name') this.iconName,
      @JsonKey(name: 'color_hex') this.colorHex,
      required this.status,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.isSynced = true})
      : super._();
  factory _SavingsGoalModel.fromJson(Map<String, dynamic> json) =>
      _$SavingsGoalModelFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'server_id')
  final String? serverId;
  @override
  final String name;
  @override
  @JsonKey(name: 'target_amount')
  final double targetAmount;
  @override
  @JsonKey(name: 'current_amount')
  final double currentAmount;
  @override
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  @override
  final String? description;
  @override
  final DateTime? deadline;
  @override
  @JsonKey(name: 'icon_name')
  final String? iconName;
  @override
  @JsonKey(name: 'color_hex')
  final String? colorHex;
  @override
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isSynced;

  /// Create a copy of SavingsGoalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SavingsGoalModelCopyWith<_SavingsGoalModel> get copyWith =>
      __$SavingsGoalModelCopyWithImpl<_SavingsGoalModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SavingsGoalModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SavingsGoalModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.currentAmount, currentAmount) ||
                other.currentAmount == currentAmount) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.status, status) || other.status == status) &&
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
      name,
      targetAmount,
      currentAmount,
      currencyCode,
      description,
      deadline,
      iconName,
      colorHex,
      status,
      createdAt,
      updatedAt,
      isSynced);

  @override
  String toString() {
    return 'SavingsGoalModel(id: $id, serverId: $serverId, name: $name, targetAmount: $targetAmount, currentAmount: $currentAmount, currencyCode: $currencyCode, description: $description, deadline: $deadline, iconName: $iconName, colorHex: $colorHex, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, isSynced: $isSynced)';
  }
}

/// @nodoc
abstract mixin class _$SavingsGoalModelCopyWith<$Res>
    implements $SavingsGoalModelCopyWith<$Res> {
  factory _$SavingsGoalModelCopyWith(
          _SavingsGoalModel value, $Res Function(_SavingsGoalModel) _then) =
      __$SavingsGoalModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'server_id') String? serverId,
      String name,
      @JsonKey(name: 'target_amount') double targetAmount,
      @JsonKey(name: 'current_amount') double currentAmount,
      @JsonKey(name: 'currency_code') String currencyCode,
      String? description,
      DateTime? deadline,
      @JsonKey(name: 'icon_name') String? iconName,
      @JsonKey(name: 'color_hex') String? colorHex,
      String status,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isSynced});
}

/// @nodoc
class __$SavingsGoalModelCopyWithImpl<$Res>
    implements _$SavingsGoalModelCopyWith<$Res> {
  __$SavingsGoalModelCopyWithImpl(this._self, this._then);

  final _SavingsGoalModel _self;
  final $Res Function(_SavingsGoalModel) _then;

  /// Create a copy of SavingsGoalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? name = null,
    Object? targetAmount = null,
    Object? currentAmount = null,
    Object? currencyCode = null,
    Object? description = freezed,
    Object? deadline = freezed,
    Object? iconName = freezed,
    Object? colorHex = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isSynced = null,
  }) {
    return _then(_SavingsGoalModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serverId: freezed == serverId
          ? _self.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      targetAmount: null == targetAmount
          ? _self.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currentAmount: null == currentAmount
          ? _self.currentAmount
          : currentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      deadline: freezed == deadline
          ? _self.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      iconName: freezed == iconName
          ? _self.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      colorHex: freezed == colorHex
          ? _self.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
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
