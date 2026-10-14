// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'logout_outcome.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LogoutOutcome {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LogoutOutcome);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'LogoutOutcome()';
  }
}

/// @nodoc
class $LogoutOutcomeCopyWith<$Res> {
  $LogoutOutcomeCopyWith(LogoutOutcome _, $Res Function(LogoutOutcome) __);
}

/// @nodoc

class LoggedOut implements LogoutOutcome {
  const LoggedOut();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LoggedOut);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'LogoutOutcome.loggedOut()';
  }
}

/// @nodoc

class LogoutBlocked implements LogoutOutcome {
  const LogoutBlocked({required this.unsavedChanges});

  final int unsavedChanges;

  /// Create a copy of LogoutOutcome
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LogoutBlockedCopyWith<LogoutBlocked> get copyWith =>
      _$LogoutBlockedCopyWithImpl<LogoutBlocked>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LogoutBlocked &&
            (identical(other.unsavedChanges, unsavedChanges) ||
                other.unsavedChanges == unsavedChanges));
  }

  @override
  int get hashCode => Object.hash(runtimeType, unsavedChanges);

  @override
  String toString() {
    return 'LogoutOutcome.blocked(unsavedChanges: $unsavedChanges)';
  }
}

/// @nodoc
abstract mixin class $LogoutBlockedCopyWith<$Res>
    implements $LogoutOutcomeCopyWith<$Res> {
  factory $LogoutBlockedCopyWith(
          LogoutBlocked value, $Res Function(LogoutBlocked) _then) =
      _$LogoutBlockedCopyWithImpl;
  @useResult
  $Res call({int unsavedChanges});
}

/// @nodoc
class _$LogoutBlockedCopyWithImpl<$Res>
    implements $LogoutBlockedCopyWith<$Res> {
  _$LogoutBlockedCopyWithImpl(this._self, this._then);

  final LogoutBlocked _self;
  final $Res Function(LogoutBlocked) _then;

  /// Create a copy of LogoutOutcome
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? unsavedChanges = null,
  }) {
    return _then(LogoutBlocked(
      unsavedChanges: null == unsavedChanges
          ? _self.unsavedChanges
          : unsavedChanges // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class LogoutFailed implements LogoutOutcome {
  const LogoutFailed(this.message);

  final String message;

  /// Create a copy of LogoutOutcome
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LogoutFailedCopyWith<LogoutFailed> get copyWith =>
      _$LogoutFailedCopyWithImpl<LogoutFailed>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LogoutFailed &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'LogoutOutcome.failed(message: $message)';
  }
}

/// @nodoc
abstract mixin class $LogoutFailedCopyWith<$Res>
    implements $LogoutOutcomeCopyWith<$Res> {
  factory $LogoutFailedCopyWith(
          LogoutFailed value, $Res Function(LogoutFailed) _then) =
      _$LogoutFailedCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$LogoutFailedCopyWithImpl<$Res> implements $LogoutFailedCopyWith<$Res> {
  _$LogoutFailedCopyWithImpl(this._self, this._then);

  final LogoutFailed _self;
  final $Res Function(LogoutFailed) _then;

  /// Create a copy of LogoutOutcome
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(LogoutFailed(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
