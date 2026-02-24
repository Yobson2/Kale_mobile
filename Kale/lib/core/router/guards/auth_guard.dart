import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Provides the redirect path based on authentication state.
///
/// Returns the login path if the user is not authenticated and trying
/// to access a protected route. Returns null if no redirect is needed.
@riverpod
String? authGuard(Ref ref, String currentPath) {
  final authState = ref.watch(authNotifierProvider);

  // Public routes that don't require authentication.
  const publicPaths = [
    RouteNames.splash,
    RouteNames.onboarding,
    RouteNames.login,
    RouteNames.register,
    RouteNames.forgotPassword,
    RouteNames.otpVerification,
  ];

  final isPublicRoute = publicPaths.contains(currentPath);

  return switch (authState) {
    AuthAuthenticated() when isPublicRoute => RouteNames.dashboard,
    AuthAuthenticated() => null,
    AuthUnauthenticated() when isPublicRoute => null,
    AuthUnauthenticated() => RouteNames.login,
    _ => null,
  };
}
