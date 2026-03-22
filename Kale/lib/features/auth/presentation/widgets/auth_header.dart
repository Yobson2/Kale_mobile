import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/data_display/geometric_k_watermark.dart';

/// Editorial header widget for authentication pages.
///
/// Features a K logo badge, large editorial title, and geometric K
/// watermark background. Replaces the generic concentric circles pattern.
class AuthHeader extends StatelessWidget {
  /// Creates an [AuthHeader].
  const AuthHeader({
    required this.title,
    super.key,
    this.subtitle,
  });

  /// Main title text (displayed in editorial displaySmall).
  final String title;

  /// Optional subtitle text.
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          // Geometric K watermark behind header
          const GeometricKWatermark(
            opacity: 0.04,
            fontSize: 200,
            alignment: Alignment.topRight,
            offset: Offset(40, -30),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.verticalLg,
              // K logo badge
              SvgPicture.asset(
                isDark
                    ? 'assets/images/logo-dark.svg'
                    : 'assets/images/logo.svg',
                height: 40,
              ),
              AppSpacing.verticalXxl,
              // Editorial title
              Text(
                title,
                style: theme.textTheme.displaySmall,
              ),
              if (subtitle != null) ...[
                AppSpacing.verticalSm,
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              AppSpacing.verticalXxl,
            ],
          ),
        ],
      ),
    );
  }
}
