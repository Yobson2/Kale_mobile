// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'savings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavingsState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SavingsState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SavingsState()';
  }
}

/// @nodoc
class $SavingsStateCopyWith<$Res> {
  $SavingsStateCopyWith(SavingsState _, $Res Function(SavingsState) __);
}

/// @nodoc

class SavingsInitial implements SavingsState {
  const SavingsInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SavingsInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SavingsState.initial()';
  }
}

/// @nodoc

class SavingsLoading implements SavingsState {
  const SavingsLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SavingsLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SavingsState.loading()';
  }
}

/// @nodoc

class SavingsSuccess implements SavingsState {
  const SavingsSuccess({this.message});

  final String? message;

  /// Create a copy of SavingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SavingsSuccessCopyWith<SavingsSuccess> get copyWith =>
      _$SavingsSuccessCopyWithImpl<SavingsSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SavingsSuccess &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'SavingsState.success(message: $message)';
  }
}

/// @nodoc
abstract mixin class $SavingsSuccessCopyWith<$Res>
    implements $SavingsStateCopyWith<$Res> {
  factory $SavingsSuccessCopyWith(
          SavingsSuccess value, $Res Function(SavingsSuccess) _then) =
      _$SavingsSuccessCopyWithImpl;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class _$SavingsSuccessCopyWithImpl<$Res>
    implements $SavingsSuccessCopyWith<$Res> {
  _$SavingsSuccessCopyWithImpl(this._self, this._then);

  final SavingsSuccess _self;
  final $Res Function(SavingsSuccess) _then;

  /// Create a copy of SavingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = freezed,
  }) {
    return _then(SavingsSuccess(
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class SavingsError implements SavingsState {
  const SavingsError(this.message);

  final String message;

  /// Create a copy of SavingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SavingsErrorCopyWith<SavingsError> get copyWith =>
      _$SavingsErrorCopyWithImpl<SavingsError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SavingsError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'SavingsState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $SavingsErrorCopyWith<$Res>
    implements $SavingsStateCopyWith<$Res> {
  factory $SavingsErrorCopyWith(
          SavingsError value, $Res Function(SavingsError) _then) =
      _$SavingsErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$SavingsErrorCopyWithImpl<$Res> implements $SavingsErrorCopyWith<$Res> {
  _$SavingsErrorCopyWithImpl(this._self, this._then);

  final SavingsError _self;
  final $Res Function(SavingsError) _then;

  /// Create a copy of SavingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(SavingsError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
