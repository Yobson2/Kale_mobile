import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/data_display/geometric_k_watermark.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';

/// Share App page — share Kale with friends.
class ShareAppPage extends StatelessWidget {
  /// Creates a [ShareAppPage].
  const ShareAppPage({super.key});

  static const _appLink = 'https://kale-app.com/download';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppAppBar(title: context.l10n.moreShareApp),
      body: Stack(
        children: [
          const GeometricKWatermark(
            opacity: 0.03,
            fontSize: 180,
            alignment: Alignment.bottomCenter,
            offset: Offset(0, 20),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingLg,
              child: Column(
                children: [
                  AppSpacing.verticalLg,
                  // Share card
                  ClipRRect(
                    borderRadius: AppRadius.borderRadiusLg,
                    child: Container(
                      width: double.infinity,
                      padding: AppSpacing.paddingXl,
                      decoration: BoxDecoration(
                        gradient: isDark
                            ? AppColors.primaryGradientDark
                            : AppColors.primaryGradientLight,
                        borderRadius: AppRadius.borderRadiusLg,
                      ),
                      child: Stack(
                        children: [
                          const GeometricKWatermark(
                            opacity: 0.05,
                            fontSize: 120,
                            alignment: Alignment.topRight,
                            offset: Offset(20, -15),
                          ),
                          Column(
                            children: [
                              SvgPicture.asset(
                                'assets/images/logo-dark.svg',
                                height: 40,
                              ),
                              AppSpacing.verticalLg,
                              Text(
                                context.l10n.shareAppTitle,
                                style:
                                    context.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              AppSpacing.verticalSm,
                              Text(
                                context.l10n.shareAppDescription,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSpacing.verticalXl,

                  // Share options
                  Text(
                    context.l10n.shareAppShareVia,
                    style: context.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.65,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.verticalMd,

                  // Copy link card
                  Material(
                    color: context.colorScheme.surfaceContainerLow,
                    borderRadius: AppRadius.borderRadiusMd,
                    child: InkWell(
                      onTap: () => _copyLink(context),
                      borderRadius: AppRadius.borderRadiusMd,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: context.colorScheme.primary
                                    .withValues(alpha: 0.12),
                                borderRadius: AppRadius.borderRadiusMd,
                              ),
                              child: Icon(
                                Icons.link,
                                size: 22,
                                color: context.colorScheme.primary,
                              ),
                            ),
                            AppSpacing.horizontalMd,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.shareAppCopyLink,
                                    style:
                                        context.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _appLink,
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      color:
                                          context.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.copy,
                              size: 20,
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.verticalSm,

                  // Share message card
                  Material(
                    color: context.colorScheme.surfaceContainerLow,
                    borderRadius: AppRadius.borderRadiusMd,
                    child: InkWell(
                      onTap: () => _copyMessage(context),
                      borderRadius: AppRadius.borderRadiusMd,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: context.colorScheme.primary
                                    .withValues(alpha: 0.12),
                                borderRadius: AppRadius.borderRadiusMd,
                              ),
                              child: Icon(
                                Icons.message_outlined,
                                size: 22,
                                color: context.colorScheme.primary,
                              ),
                            ),
                            AppSpacing.horizontalMd,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.shareAppCopyMessage,
                                    style:
                                        context.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    context.l10n.moreShareAppMessage,
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      color:
                                          context.colorScheme.onSurfaceVariant,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.copy,
                              size: 20,
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.verticalXxl,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: _appLink));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.shareAppLinkCopied)),
    );
  }

  void _copyMessage(BuildContext context) {
    final message =
        '${context.l10n.moreShareAppMessage}\n$_appLink';
    Clipboard.setData(ClipboardData(text: message));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.shareAppMessageCopied)),
    );
  }
}
