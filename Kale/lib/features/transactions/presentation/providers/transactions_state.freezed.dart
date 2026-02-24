// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transactions_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionsState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is TransactionsState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TransactionsState()';
  }
}

/// @nodoc
class $TransactionsStateCopyWith<$Res> {
  $TransactionsStateCopyWith(
      TransactionsState _, $Res Function(TransactionsState) __);
}

/// @nodoc

class TransactionsInitial implements TransactionsState {
  const TransactionsInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is TransactionsInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TransactionsState.initial()';
  }
}

/// @nodoc

class TransactionsLoading implements TransactionsState {
  const TransactionsLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is TransactionsLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TransactionsState.loading()';
  }
}

/// @nodoc

class TransactionsSuccess implements TransactionsState {
  const TransactionsSuccess({this.message});

  final String? message;

  /// Create a copy of TransactionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionsSuccessCopyWith<TransactionsSuccess> get copyWith =>
      _$TransactionsSuccessCopyWithImpl<TransactionsSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransactionsSuccess &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'TransactionsState.success(message: $message)';
  }
}

/// @nodoc
abstract mixin class $TransactionsSuccessCopyWith<$Res>
    implements $TransactionsStateCopyWith<$Res> {
  factory $TransactionsSuccessCopyWith(
          TransactionsSuccess value, $Res Function(TransactionsSuccess) _then) =
      _$TransactionsSuccessCopyWithImpl;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class _$TransactionsSuccessCopyWithImpl<$Res>
    implements $TransactionsSuccessCopyWith<$Res> {
  _$TransactionsSuccessCopyWithImpl(this._self, this._then);

  final TransactionsSuccess _self;
  final $Res Function(TransactionsSuccess) _then;

  /// Create a copy of TransactionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = freezed,
  }) {
    return _then(TransactionsSuccess(
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class TransactionsLoaded implements TransactionsState {
  const TransactionsLoaded(this.transaction);

  final Transaction transaction;

  /// Create a copy of TransactionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionsLoadedCopyWith<TransactionsLoaded> get copyWith =>
      _$TransactionsLoadedCopyWithImpl<TransactionsLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransactionsLoaded &&
            (identical(other.transaction, transaction) ||
                other.transaction == transaction));
  }

  @override
  int get hashCode => Object.hash(runtimeType, transaction);

  @override
  String toString() {
    return 'TransactionsState.loaded(transaction: $transaction)';
  }
}

/// @nodoc
abstract mixin class $TransactionsLoadedCopyWith<$Res>
    implements $TransactionsStateCopyWith<$Res> {
  factory $TransactionsLoadedCopyWith(
          TransactionsLoaded value, $Res Function(TransactionsLoaded) _then) =
      _$TransactionsLoadedCopyWithImpl;
  @useResult
  $Res call({Transaction transaction});
}

/// @nodoc
class _$TransactionsLoadedCopyWithImpl<$Res>
    implements $TransactionsLoadedCopyWith<$Res> {
  _$TransactionsLoadedCopyWithImpl(this._self, this._then);

  final TransactionsLoaded _self;
  final $Res Function(TransactionsLoaded) _then;

  /// Create a copy of TransactionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? transaction = null,
  }) {
    return _then(TransactionsLoaded(
      null == transaction
          ? _self.transaction
          : transaction // ignore: cast_nullable_to_non_nullable
              as Transaction,
    ));
  }
}

/// @nodoc

class TransactionsError implements TransactionsState {
  const TransactionsError(this.message);

  final String message;

  /// Create a copy of TransactionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionsErrorCopyWith<TransactionsError> get copyWith =>
      _$TransactionsErrorCopyWithImpl<TransactionsError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransactionsError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'TransactionsState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $TransactionsErrorCopyWith<$Res>
    implements $TransactionsStateCopyWith<$Res> {
  factory $TransactionsErrorCopyWith(
          TransactionsError value, $Res Function(TransactionsError) _then) =
      _$TransactionsErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$TransactionsErrorCopyWithImpl<$Res>
    implements $TransactionsErrorCopyWith<$Res> {
  _$TransactionsErrorCopyWithImpl(this._self, this._then);

  final TransactionsError _self;
  final $Res Function(TransactionsError) _then;

  /// Create a copy of TransactionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(TransactionsError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
