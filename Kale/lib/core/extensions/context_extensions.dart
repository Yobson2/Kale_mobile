import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kale/core/theme/app_colors.dart';

/// Convenience extensions on [BuildContext].
extension BuildContextX on BuildContext {
  /// Current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Current [ColorScheme].
  ColorScheme get colorScheme => theme.colorScheme;

  /// Current [TextTheme].
  TextTheme get textTheme => theme.textTheme;

  /// Whether the current theme is dark mode.
  bool get isDark => theme.brightness == Brightness.dark;

  // ── Surface Tier Convenience ───────────────────────────────

  /// Lowest surface tier (purest white / deepest dark).
  Color get surfaceContainerLowest => colorScheme.surfaceContainerLowest;

  /// Low surface tier.
  Color get surfaceContainerLow => colorScheme.surfaceContainerLow;

  /// Mid surface tier.
  Color get surfaceContainer => colorScheme.surfaceContainer;

  /// High surface tier.
  Color get surfaceContainerHigh => colorScheme.surfaceContainerHigh;

  /// Highest surface tier.
  Color get surfaceContainerHighest => colorScheme.surfaceContainerHighest;

  // ── Gradient Convenience ───────────────────────────────────

  /// Primary gradient for the current theme.
  LinearGradient get primaryGradient => isDark
      ? AppColors.primaryGradientDark
      : AppColors.primaryGradientLight;

  /// Screen size (uses [MediaQuery.sizeOf] for granular rebuilds).
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Screen width.
  double get screenWidth => screenSize.width;

  /// Screen height.
  double get screenHeight => screenSize.height;

  /// View padding (uses [MediaQuery.paddingOf] for granular rebuilds).
  EdgeInsets get viewPadding => MediaQuery.paddingOf(this);

  /// Top safe area padding.
  double get topPadding => viewPadding.top;

  /// Bottom safe area padding.
  double get bottomPadding => viewPadding.bottom;

  /// Whether the device is in landscape orientation.
  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  /// Whether the screen width qualifies as a tablet (>= 600px).
  bool get isTablet => screenWidth >= 600;

  /// Localized strings accessor.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Shows a [SnackBar] with the given [message].
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Unfocuses the current focus node (dismiss keyboard).
  void unfocus() => FocusScope.of(this).unfocus();
}
