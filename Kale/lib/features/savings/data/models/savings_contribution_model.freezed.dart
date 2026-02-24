// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'savings_contribution_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavingsContributionModel {
  String get id;
  @JsonKey(name: 'goal_id')
  String get goalId;
  double get amount;
  String get source;
  String? get note;
  DateTime get date;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isSynced;

  /// Create a copy of SavingsContributionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SavingsContributionModelCopyWith<SavingsContributionModel> get copyWith =>
      _$SavingsContributionModelCopyWithImpl<SavingsContributionModel>(
          this as SavingsContributionModel, _$identity);

  /// Serializes this SavingsContributionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SavingsContributionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, goalId, amount, source, note, date, createdAt, isSynced);

  @override
  String toString() {
    return 'SavingsContributionModel(id: $id, goalId: $goalId, amount: $amount, source: $source, note: $note, date: $date, createdAt: $createdAt, isSynced: $isSynced)';
  }
}

/// @nodoc
abstract mixin class $SavingsContributionModelCopyWith<$Res> {
  factory $SavingsContributionModelCopyWith(SavingsContributionModel value,
          $Res Function(SavingsContributionModel) _then) =
      _$SavingsContributionModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'goal_id') String goalId,
      double amount,
      String source,
      String? note,
      DateTime date,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isSynced});
}

/// @nodoc
class _$SavingsContributionModelCopyWithImpl<$Res>
    implements $SavingsContributionModelCopyWith<$Res> {
  _$SavingsContributionModelCopyWithImpl(this._self, this._then);

  final SavingsContributionModel _self;
  final $Res Function(SavingsContributionModel) _then;

  /// Create a copy of SavingsContributionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? goalId = null,
    Object? amount = null,
    Object? source = null,
    Object? note = freezed,
    Object? date = null,
    Object? createdAt = null,
    Object? isSynced = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      goalId: null == goalId
          ? _self.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
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
class _SavingsContributionModel extends SavingsContributionModel {
  const _SavingsContributionModel(
      {required this.id,
      @JsonKey(name: 'goal_id') required this.goalId,
      required this.amount,
      required this.source,
      this.note,
      required this.date,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.isSynced = true})
      : super._();
  factory _SavingsContributionModel.fromJson(Map<String, dynamic> json) =>
      _$SavingsContributionModelFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'goal_id')
  final String goalId;
  @override
  final double amount;
  @override
  final String source;
  @override
  final String? note;
  @override
  final DateTime date;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isSynced;

  /// Create a copy of SavingsContributionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SavingsContributionModelCopyWith<_SavingsContributionModel> get copyWith =>
      __$SavingsContributionModelCopyWithImpl<_SavingsContributionModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SavingsContributionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SavingsContributionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, goalId, amount, source, note, date, createdAt, isSynced);

  @override
  String toString() {
    return 'SavingsContributionModel(id: $id, goalId: $goalId, amount: $amount, source: $source, note: $note, date: $date, createdAt: $createdAt, isSynced: $isSynced)';
  }
}

/// @nodoc
abstract mixin class _$SavingsContributionModelCopyWith<$Res>
    implements $SavingsContributionModelCopyWith<$Res> {
  factory _$SavingsContributionModelCopyWith(_SavingsContributionModel value,
          $Res Function(_SavingsContributionModel) _then) =
      __$SavingsContributionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'goal_id') String goalId,
      double amount,
      String source,
      String? note,
      DateTime date,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isSynced});
}

/// @nodoc
class __$SavingsContributionModelCopyWithImpl<$Res>
    implements _$SavingsContributionModelCopyWith<$Res> {
  __$SavingsContributionModelCopyWithImpl(this._self, this._then);

  final _SavingsContributionModel _self;
  final $Res Function(_SavingsContributionModel) _then;

  /// Create a copy of SavingsContributionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? goalId = null,
    Object? amount = null,
    Object? source = null,
    Object? note = freezed,
    Object? date = null,
    Object? createdAt = null,
    Object? isSynced = null,
  }) {
    return _then(_SavingsContributionModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      goalId: null == goalId
          ? _self.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSynced: null == isSynced
          ? _self.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
