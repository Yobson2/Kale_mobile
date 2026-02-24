// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetModel {
  String get id;
  @JsonKey(name: 'server_id')
  String? get serverId;
  String get name;
  String get strategy;
  String get period;
  @JsonKey(name: 'start_date')
  DateTime get startDate;
  @JsonKey(name: 'end_date')
  DateTime get endDate;
  @JsonKey(name: 'total_income')
  double? get totalIncome;
  @JsonKey(name: 'is_percentage_based')
  bool get isPercentageBased;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isSynced;

  /// Create a copy of BudgetModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetModelCopyWith<BudgetModel> get copyWith =>
      _$BudgetModelCopyWithImpl<BudgetModel>(this as BudgetModel, _$identity);

  /// Serializes this BudgetModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.isPercentageBased, isPercentageBased) ||
                other.isPercentageBased == isPercentageBased) &&
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
      strategy,
      period,
      startDate,
      endDate,
      totalIncome,
      isPercentageBased,
      createdAt,
      updatedAt,
      isSynced);

  @override
  String toString() {
    return 'BudgetModel(id: $id, serverId: $serverId, name: $name, strategy: $strategy, period: $period, startDate: $startDate, endDate: $endDate, totalIncome: $totalIncome, isPercentageBased: $isPercentageBased, createdAt: $createdAt, updatedAt: $updatedAt, isSynced: $isSynced)';
  }
}

/// @nodoc
abstract mixin class $BudgetModelCopyWith<$Res> {
  factory $BudgetModelCopyWith(
          BudgetModel value, $Res Function(BudgetModel) _then) =
      _$BudgetModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'server_id') String? serverId,
      String name,
      String strategy,
      String period,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'end_date') DateTime endDate,
      @JsonKey(name: 'total_income') double? totalIncome,
      @JsonKey(name: 'is_percentage_based') bool isPercentageBased,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isSynced});
}

/// @nodoc
class _$BudgetModelCopyWithImpl<$Res> implements $BudgetModelCopyWith<$Res> {
  _$BudgetModelCopyWithImpl(this._self, this._then);

  final BudgetModel _self;
  final $Res Function(BudgetModel) _then;

  /// Create a copy of BudgetModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? name = null,
    Object? strategy = null,
    Object? period = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalIncome = freezed,
    Object? isPercentageBased = null,
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
      strategy: null == strategy
          ? _self.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _self.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalIncome: freezed == totalIncome
          ? _self.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double?,
      isPercentageBased: null == isPercentageBased
          ? _self.isPercentageBased
          : isPercentageBased // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _BudgetModel extends BudgetModel {
  const _BudgetModel(
      {required this.id,
      @JsonKey(name: 'server_id') this.serverId,
      required this.name,
      required this.strategy,
      required this.period,
      @JsonKey(name: 'start_date') required this.startDate,
      @JsonKey(name: 'end_date') required this.endDate,
      @JsonKey(name: 'total_income') this.totalIncome,
      @JsonKey(name: 'is_percentage_based') this.isPercentageBased = true,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.isSynced = false})
      : super._();
  factory _BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'server_id')
  final String? serverId;
  @override
  final String name;
  @override
  final String strategy;
  @override
  final String period;
  @override
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime endDate;
  @override
  @JsonKey(name: 'total_income')
  final double? totalIncome;
  @override
  @JsonKey(name: 'is_percentage_based')
  final bool isPercentageBased;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isSynced;

  /// Create a copy of BudgetModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetModelCopyWith<_BudgetModel> get copyWith =>
      __$BudgetModelCopyWithImpl<_BudgetModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BudgetModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.isPercentageBased, isPercentageBased) ||
                other.isPercentageBased == isPercentageBased) &&
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
      strategy,
      period,
      startDate,
      endDate,
      totalIncome,
      isPercentageBased,
      createdAt,
      updatedAt,
      isSynced);

  @override
  String toString() {
    return 'BudgetModel(id: $id, serverId: $serverId, name: $name, strategy: $strategy, period: $period, startDate: $startDate, endDate: $endDate, totalIncome: $totalIncome, isPercentageBased: $isPercentageBased, createdAt: $createdAt, updatedAt: $updatedAt, isSynced: $isSynced)';
  }
}

/// @nodoc
abstract mixin class _$BudgetModelCopyWith<$Res>
    implements $BudgetModelCopyWith<$Res> {
  factory _$BudgetModelCopyWith(
          _BudgetModel value, $Res Function(_BudgetModel) _then) =
      __$BudgetModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'server_id') String? serverId,
      String name,
      String strategy,
      String period,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'end_date') DateTime endDate,
      @JsonKey(name: 'total_income') double? totalIncome,
      @JsonKey(name: 'is_percentage_based') bool isPercentageBased,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isSynced});
}

/// @nodoc
class __$BudgetModelCopyWithImpl<$Res> implements _$BudgetModelCopyWith<$Res> {
  __$BudgetModelCopyWithImpl(this._self, this._then);

  final _BudgetModel _self;
  final $Res Function(_BudgetModel) _then;

  /// Create a copy of BudgetModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? name = null,
    Object? strategy = null,
    Object? period = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalIncome = freezed,
    Object? isPercentageBased = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isSynced = null,
  }) {
    return _then(_BudgetModel(
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
      strategy: null == strategy
          ? _self.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _self.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalIncome: freezed == totalIncome
          ? _self.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double?,
      isPercentageBased: null == isPercentageBased
          ? _self.isPercentageBased
          : isPercentageBased // ignore: cast_nullable_to_non_nullable
              as bool,
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
