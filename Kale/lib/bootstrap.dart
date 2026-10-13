import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/app.dart';
import 'package:kale/core/config/env.dart';
import 'package:kale/core/config/env_provider.dart';
import 'package:kale/core/config/env_validation.dart';
import 'package:kale/core/providers/crash_reporter_provider.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/services/crash_reporter.dart';
import 'package:kale/core/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Bootstraps the application with the given [env] configuration.
///
/// Initializes bindings, storage, crash reporting, and wraps the app
/// in [ProviderScope] with environment-specific overrides.
Future<void> bootstrap(Env env, {CrashReporter? crashReporter}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fail fast when the build was not given a valid define file, or when the
  // define file does not match the native flavor.
  ensureValidEnv(env, appFlavor: appFlavor);
  AppLogger.info(
    'Environment: ${env.name} (flavor: ${appFlavor ?? 'none'})',
    tag: 'AppEngine',
  );

  // Initialize Supabase before anything else that depends on it.
  await Supabase.initialize(
    url: env.baseUrl,
    anonKey: env.supabaseAnonKey,
  );

  // Lock orientation to portrait.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize SharedPreferences before the app starts.
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize crash reporting.
  final reporter = crashReporter ?? DevCrashReporter();
  await reporter.init();

  // Set up error handling — forward to crash reporter.
  FlutterError.onError = (details) {
    AppLogger.error(
      'Flutter error: ${details.exceptionAsString()}',
      error: details.exception,
      stackTrace: details.stack,
    );
    reporter.recordError(
      details.exception,
      details.stack,
      fatal: details.library == null,
    );
  };

  // Catch errors outside of Flutter framework.
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error('Platform error', error: error, stackTrace: stack);
    reporter.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(
    ProviderScope(
      overrides: [
        envProvider.overrideWithValue(env),
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        crashReporterProvider.overrideWithValue(reporter),
      ],
      child: const App(),
    ),
  );
}
