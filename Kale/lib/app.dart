import 'package:flutter/material.dart';
import 'package:kale/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kale/core/config/env_provider.dart';
import 'package:kale/core/router/app_router.dart';
import 'package:kale/core/theme/app_theme.dart';
import 'package:kale/core/theme/theme_provider.dart';

/// Root application widget.
///
/// Configures [MaterialApp.router] with GoRouter, theme, and localization.
class App extends ConsumerWidget {
  /// Creates an [App].
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);
    final env = ref.watch(envProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp.router(
        title: 'Kalé',
        debugShowCheckedModeBanner: env.showDebugBanner,

        // Theme
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        // Router
        routerConfig: router,
        // Localization
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
