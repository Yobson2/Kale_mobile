import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/auth/data/models/tokens_model.dart';
import 'package:kale/features/auth/data/models/user_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for authentication via Supabase.
abstract class AuthRemoteDataSource {
  /// Signs in with email and password.
  Future<({UserModel user, TokensModel tokens})> login({
    required String email,
    required String password,
  });

  /// Registers a new user. Supabase sends a confirmation OTP automatically.
  /// Does **not** return an authenticated session.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  });

  /// Verifies the OTP [code] sent to [email].
  ///
  /// For the signup flow, completes registration and returns the
  /// authenticated user + tokens. Returns `null` otherwise.
  Future<({UserModel user, TokensModel tokens})?> verifyOtp({
    required String email,
    required String code,
  });

  /// Sends a password-reset email.
  Future<void> forgotPassword({required String email});

  /// Signs out the current user.
  Future<void> logout();

  /// Signs in with Google via Supabase.
  Future<({UserModel user, TokensModel tokens})> signInWithGoogle();

  /// Signs in with Apple via Supabase.
  Future<({UserModel user, TokensModel tokens})> signInWithApple();
}

/// Implementation of [AuthRemoteDataSource] using [SupabaseClient].
class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  /// Creates a [SupabaseAuthRemoteDataSource].
  const SupabaseAuthRemoteDataSource({
    required SupabaseClient supabaseClient,
    required String googleWebClientId,
    String? googleIosClientId,
  })  : _supabase = supabaseClient,
        _googleWebClientId = googleWebClientId,
        _googleIosClientId = googleIosClientId;

  final SupabaseClient _supabase;
  final String _googleWebClientId;
  final String? _googleIosClientId;

  // ---------------------------------------------------------------------------
  // Email / Password
  // ---------------------------------------------------------------------------

  @override
  Future<({UserModel user, TokensModel tokens})> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return _mapAuthResponse(response);
    } on AuthException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: int.tryParse(e.statusCode ?? ''),
      );
    }
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': name},
      );
    } on AuthException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: int.tryParse(e.statusCode ?? ''),
      );
    }
  }

  @override
  Future<({UserModel user, TokensModel tokens})?> verifyOtp({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        email: email,
        token: code,
        type: OtpType.signup,
      );
      if (response.session != null && response.user != null) {
        return _mapAuthResponse(response);
      }
      return null;
    } on AuthException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: int.tryParse(e.statusCode ?? ''),
      );
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  // ---------------------------------------------------------------------------
  // Social Login
  // ---------------------------------------------------------------------------

  @override
  Future<({UserModel user, TokensModel tokens})> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        clientId: _googleIosClientId,
        serverClientId: _googleWebClientId,
      );
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw const ServerException(message: 'Google sign-in was cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw const ServerException(
          message: 'Failed to obtain Google ID token',
        );
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: googleAuth.accessToken,
      );
      return _mapAuthResponse(response);
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<({UserModel user, TokensModel tokens})> signInWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const ServerException(
          message: 'Failed to obtain Apple ID token',
        );
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );
      return _mapAuthResponse(response);
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    } on SignInWithAppleAuthorizationException catch (e) {
      throw ServerException(message: e.message);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Maps a Supabase [AuthResponse] to our data models.
  ({UserModel user, TokensModel tokens}) _mapAuthResponse(
    AuthResponse response,
  ) {
    final session = response.session;
    final user = response.user;
    if (session == null || user == null) {
      throw const ServerException(
        message: 'Authentication succeeded but no session was returned',
      );
    }

    final userModel = UserModel(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['display_name'] as String? ??
          user.userMetadata?['name'] as String? ??
          user.userMetadata?['full_name'] as String? ??
          '',
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
    );

    final tokensModel = TokensModel(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken ?? '',
    );

    return (user: userModel, tokens: tokensModel);
  }

  /// Generates a cryptographically-secure random nonce string.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }
}
