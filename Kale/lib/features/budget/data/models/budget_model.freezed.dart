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
  String get name;
  String get strategy;
  String get period;
  @CalendarDateJsonConverter()
  @JsonKey(name: 'start_date')
  CalendarDate get startDate;
  @CalendarDateJsonConverter()
  @JsonKey(name: 'end_date')
  CalendarDate get endDate;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @JsonKey(name: 'server_id')
  String? get serverId;
  @JsonKey(name: 'period_start_day')
  int get periodStartDay;
  @JsonKey(name: 'total_income_minor')
  int? get totalIncomeMinor;
  @JsonKey(name: 'is_percentage_based')
  bool get isPercentageBased;
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt;
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
            (identical(other.name, name) || other.name == name) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.periodStartDay, periodStartDay) ||
                other.periodStartDay == periodStartDay) &&
            (identical(other.totalIncomeMinor, totalIncomeMinor) ||
                other.totalIncomeMinor == totalIncomeMinor) &&
            (identical(other.isPercentageBased, isPercentageBased) ||
                other.isPercentageBased == isPercentageBased) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      strategy,
      period,
      startDate,
      endDate,
      createdAt,
      updatedAt,
      serverId,
      periodStartDay,
      totalIncomeMinor,
      isPercentageBased,
      deletedAt,
      isSynced);

  @override
  String toString() {
    return 'BudgetModel(id: $id, name: $name, strategy: $strategy, period: $period, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt, serverId: $serverId, periodStartDay: $periodStartDay, totalIncomeMinor: $totalIncomeMinor, isPercentageBased: $isPercentageBased, deletedAt: $deletedAt, isSynced: $isSynced)';
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
      String name,
      String strategy,
      String period,
      @CalendarDateJsonConverter()
      @JsonKey(name: 'start_date')
      CalendarDate startDate,
      @CalendarDateJsonConverter()
      @JsonKey(name: 'end_date')
      CalendarDate endDate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'server_id') String? serverId,
      @JsonKey(name: 'period_start_day') int periodStartDay,
      @JsonKey(name: 'total_income_minor') int? totalIncomeMinor,
      @JsonKey(name: 'is_percentage_based') bool isPercentageBased,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
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
    Object? name = null,
    Object? strategy = null,
    Object? period = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? serverId = freezed,
    Object? periodStartDay = null,
    Object? totalIncomeMinor = freezed,
    Object? isPercentageBased = null,
    Object? deletedAt = freezed,
    Object? isSynced = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
              as CalendarDate,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as CalendarDate,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      serverId: freezed == serverId
          ? _self.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
      periodStartDay: null == periodStartDay
          ? _self.periodStartDay
          : periodStartDay // ignore: cast_nullable_to_non_nullable
              as int,
      totalIncomeMinor: freezed == totalIncomeMinor
          ? _self.totalIncomeMinor
          : totalIncomeMinor // ignore: cast_nullable_to_non_nullable
              as int?,
      isPercentageBased: null == isPercentageBased
          ? _self.isPercentageBased
          : isPercentageBased // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      required this.name,
      required this.strategy,
      required this.period,
      @CalendarDateJsonConverter()
      @JsonKey(name: 'start_date')
      required this.startDate,
      @CalendarDateJsonConverter()
      @JsonKey(name: 'end_date')
      required this.endDate,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'server_id') this.serverId,
      @JsonKey(name: 'period_start_day')
      this.periodStartDay = BudgetPeriodRange.defaultStartDay,
      @JsonKey(name: 'total_income_minor') this.totalIncomeMinor,
      @JsonKey(name: 'is_percentage_based') this.isPercentageBased = true,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.isSynced = false})
      : super._();
  factory _BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String strategy;
  @override
  final String period;
  @override
  @CalendarDateJsonConverter()
  @JsonKey(name: 'start_date')
  final CalendarDate startDate;
  @override
  @CalendarDateJsonConverter()
  @JsonKey(name: 'end_date')
  final CalendarDate endDate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'server_id')
  final String? serverId;
  @override
  @JsonKey(name: 'period_start_day')
  final int periodStartDay;
  @override
  @JsonKey(name: 'total_income_minor')
  final int? totalIncomeMinor;
  @override
  @JsonKey(name: 'is_percentage_based')
  final bool isPercentageBased;
  @override
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;
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
            (identical(other.name, name) || other.name == name) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.periodStartDay, periodStartDay) ||
                other.periodStartDay == periodStartDay) &&
            (identical(other.totalIncomeMinor, totalIncomeMinor) ||
                other.totalIncomeMinor == totalIncomeMinor) &&
            (identical(other.isPercentageBased, isPercentageBased) ||
                other.isPercentageBased == isPercentageBased) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      strategy,
      period,
      startDate,
      endDate,
      createdAt,
      updatedAt,
      serverId,
      periodStartDay,
      totalIncomeMinor,
      isPercentageBased,
      deletedAt,
      isSynced);

  @override
  String toString() {
    return 'BudgetModel(id: $id, name: $name, strategy: $strategy, period: $period, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt, serverId: $serverId, periodStartDay: $periodStartDay, totalIncomeMinor: $totalIncomeMinor, isPercentageBased: $isPercentageBased, deletedAt: $deletedAt, isSynced: $isSynced)';
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
      String name,
      String strategy,
      String period,
      @CalendarDateJsonConverter()
      @JsonKey(name: 'start_date')
      CalendarDate startDate,
      @CalendarDateJsonConverter()
      @JsonKey(name: 'end_date')
      CalendarDate endDate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'server_id') String? serverId,
      @JsonKey(name: 'period_start_day') int periodStartDay,
      @JsonKey(name: 'total_income_minor') int? totalIncomeMinor,
      @JsonKey(name: 'is_percentage_based') bool isPercentageBased,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
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
    Object? name = null,
    Object? strategy = null,
    Object? period = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? serverId = freezed,
    Object? periodStartDay = null,
    Object? totalIncomeMinor = freezed,
    Object? isPercentageBased = null,
    Object? deletedAt = freezed,
    Object? isSynced = null,
  }) {
    return _then(_BudgetModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
              as CalendarDate,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as CalendarDate,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      serverId: freezed == serverId
          ? _self.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
      periodStartDay: null == periodStartDay
          ? _self.periodStartDay
          : periodStartDay // ignore: cast_nullable_to_non_nullable
              as int,
      totalIncomeMinor: freezed == totalIncomeMinor
          ? _self.totalIncomeMinor
          : totalIncomeMinor // ignore: cast_nullable_to_non_nullable
              as int?,
      isPercentageBased: null == isPercentageBased
          ? _self.isPercentageBased
          : isPercentageBased // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isSynced: null == isSynced
          ? _self.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
