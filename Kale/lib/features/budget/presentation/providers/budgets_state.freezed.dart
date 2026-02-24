// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budgets_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetsState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BudgetsState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BudgetsState()';
  }
}

/// @nodoc
class $BudgetsStateCopyWith<$Res> {
  $BudgetsStateCopyWith(BudgetsState _, $Res Function(BudgetsState) __);
}

/// @nodoc

class BudgetsInitial implements BudgetsState {
  const BudgetsInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BudgetsInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BudgetsState.initial()';
  }
}

/// @nodoc

class BudgetsLoading implements BudgetsState {
  const BudgetsLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BudgetsLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BudgetsState.loading()';
  }
}

/// @nodoc

class BudgetsSuccess implements BudgetsState {
  const BudgetsSuccess({this.message});

  final String? message;

  /// Create a copy of BudgetsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetsSuccessCopyWith<BudgetsSuccess> get copyWith =>
      _$BudgetsSuccessCopyWithImpl<BudgetsSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetsSuccess &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'BudgetsState.success(message: $message)';
  }
}

/// @nodoc
abstract mixin class $BudgetsSuccessCopyWith<$Res>
    implements $BudgetsStateCopyWith<$Res> {
  factory $BudgetsSuccessCopyWith(
          BudgetsSuccess value, $Res Function(BudgetsSuccess) _then) =
      _$BudgetsSuccessCopyWithImpl;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class _$BudgetsSuccessCopyWithImpl<$Res>
    implements $BudgetsSuccessCopyWith<$Res> {
  _$BudgetsSuccessCopyWithImpl(this._self, this._then);

  final BudgetsSuccess _self;
  final $Res Function(BudgetsSuccess) _then;

  /// Create a copy of BudgetsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = freezed,
  }) {
    return _then(BudgetsSuccess(
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class BudgetsLoaded implements BudgetsState {
  const BudgetsLoaded(this.budget);

  final Budget budget;

  /// Create a copy of BudgetsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetsLoadedCopyWith<BudgetsLoaded> get copyWith =>
      _$BudgetsLoadedCopyWithImpl<BudgetsLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetsLoaded &&
            (identical(other.budget, budget) || other.budget == budget));
  }

  @override
  int get hashCode => Object.hash(runtimeType, budget);

  @override
  String toString() {
    return 'BudgetsState.loaded(budget: $budget)';
  }
}

/// @nodoc
abstract mixin class $BudgetsLoadedCopyWith<$Res>
    implements $BudgetsStateCopyWith<$Res> {
  factory $BudgetsLoadedCopyWith(
          BudgetsLoaded value, $Res Function(BudgetsLoaded) _then) =
      _$BudgetsLoadedCopyWithImpl;
  @useResult
  $Res call({Budget budget});
}

/// @nodoc
class _$BudgetsLoadedCopyWithImpl<$Res>
    implements $BudgetsLoadedCopyWith<$Res> {
  _$BudgetsLoadedCopyWithImpl(this._self, this._then);

  final BudgetsLoaded _self;
  final $Res Function(BudgetsLoaded) _then;

  /// Create a copy of BudgetsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? budget = null,
  }) {
    return _then(BudgetsLoaded(
      null == budget
          ? _self.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as Budget,
    ));
  }
}

/// @nodoc

class BudgetsError implements BudgetsState {
  const BudgetsError(this.message);

  final String message;

  /// Create a copy of BudgetsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetsErrorCopyWith<BudgetsError> get copyWith =>
      _$BudgetsErrorCopyWithImpl<BudgetsError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetsError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'BudgetsState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $BudgetsErrorCopyWith<$Res>
    implements $BudgetsStateCopyWith<$Res> {
  factory $BudgetsErrorCopyWith(
          BudgetsError value, $Res Function(BudgetsError) _then) =
      _$BudgetsErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$BudgetsErrorCopyWithImpl<$Res> implements $BudgetsErrorCopyWith<$Res> {
  _$BudgetsErrorCopyWithImpl(this._self, this._then);

  final BudgetsError _self;
  final $Res Function(BudgetsError) _then;

  /// Create a copy of BudgetsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(BudgetsError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
