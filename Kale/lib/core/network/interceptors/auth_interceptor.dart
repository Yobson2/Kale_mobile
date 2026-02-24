import 'dart:async';

import 'package:dio/dio.dart';
import 'package:kale/core/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Attaches the Supabase access token to outgoing requests and
/// handles automatic token refresh on 401 responses.
///
/// Uses [QueuedInterceptor] so concurrent requests wait for
/// the token refresh to complete before retrying.
class AuthInterceptor extends QueuedInterceptor {
  /// Creates an [AuthInterceptor].
  AuthInterceptor({
    required SupabaseClient supabaseClient,
    required Dio dio,
  })  : _supabase = supabaseClient,
        _dio = dio;

  final SupabaseClient _supabase;
  final Dio _dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }
    // Supabase RLS requires the apikey header.
    final apiKey = _supabase.rest.headers['apikey'];
    if (apiKey != null) {
      options.headers['apikey'] = apiKey;
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      try {
        final response = await _supabase.auth.refreshSession();
        if (response.session != null) {
          final retryResponse = await _retryRequest(err.requestOptions);
          return handler.resolve(retryResponse);
        }
      } catch (e) {
        AppLogger.error('Supabase token refresh failed', error: e);
      }
    }
    handler.next(err);
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions options) async {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }
    return _dio.fetch<dynamic>(options);
  }
}
