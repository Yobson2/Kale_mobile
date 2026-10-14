import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kale/features/auth/domain/entities/user.dart';

part 'auth_state.freezed.dart';

/// Represents the authentication state of the application.
@freezed
sealed class AuthState with _$AuthState {
  /// Initial state before any auth check.
  const factory AuthState.initial() = AuthInitial;

  /// Loading state during auth operations.
  const factory AuthState.loading() = AuthLoading;

  /// User is authenticated. Someone trying the app without an account is
  /// authenticated too, as an anonymous user ([User.isAnonymous]).
  const factory AuthState.authenticated(User user) = AuthAuthenticated;

  /// User is not authenticated.
  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  /// An error occurred during an auth operation.
  const factory AuthState.error(String message) = AuthError;
}
