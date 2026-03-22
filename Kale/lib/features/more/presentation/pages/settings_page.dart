import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/constants/currencies.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/providers/notification_provider.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/theme/theme_provider.dart';
import 'package:kale/core/widgets/data_display/geometric_k_watermark.dart';

/// Settings page with card-per-item layout, colored icon circles,
/// and section headers per the Digital Loom design.
class SettingsPage extends ConsumerWidget {
  /// Creates a [SettingsPage].
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final currencyCode = ref.watch(userCurrencyCodeProvider);
    final localStorage = ref.watch(localStorageProvider);
    final l10n = context.l10n;
    final currency = SupportedCurrencies.byCode(currencyCode);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const BackButton(),
        title: Text(
          l10n.settingsTitle,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          // K watermark at bottom
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: GeometricKWatermark(
              opacity: 0.03,
              fontSize: 180,
              alignment: Alignment.bottomCenter,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Preferences ──
                  _SectionHeader(title: l10n.settingsCurrency.isEmpty
                      ? 'Preferences'
                      : 'Preferences'),
                  AppSpacing.verticalMd,

                  _SettingsCard(
                    icon: Icons.currency_exchange,
                    iconColor: context.colorScheme.primary,
                    title: l10n.settingsCurrency,
                    subtitle: currency != null
                        ? '${currency.code} - ${currency.name.toUpperCase()}'
                        : currencyCode,
                    trailing: Icon(
                      Icons.chevron_right,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    onTap: () =>
                        _showCurrencyPicker(context, ref, currencyCode),
                  ),
                  AppSpacing.verticalSm,

                  _SettingsCard(
                    icon: Icons.translate,
                    iconColor: context.colorScheme.primary,
                    title: l10n.settingsLanguage,
                    subtitle: l10n.settingsLanguageEn.toUpperCase(),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    onTap: () => _showLanguagePicker(context),
                  ),
                  AppSpacing.verticalSm,

                  _SettingsCard(
                    icon: Icons.brightness_6_outlined,
                    iconColor: context.colorScheme.primary,
                    title: l10n.settingsTheme,
                    subtitle: _themeLabel(themeMode, l10n).toUpperCase(),
                    trailing: Switch.adaptive(
                      value: themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        ref
                            .read(themeModeNotifierProvider.notifier)
                            .setThemeMode(
                              value ? ThemeMode.dark : ThemeMode.light,
                            );
                      },
                    ),
                  ),

                  AppSpacing.verticalXl,

                  // ── Notifications ──
                  const _SectionHeader(title: 'Notifications'),
                  AppSpacing.verticalMd,

                  _SettingsCard(
                    icon: Icons.notifications_outlined,
                    iconColor: context.colorScheme.primary,
                    title: l10n.settingsPushNotifications,
                    trailing: Switch.adaptive(
                      value: localStorage.isNotificationsEnabled,
                      onChanged: (value) {
                        localStorage.setNotificationsEnabled(enabled: value);
                        ref.invalidate(localStorageProvider);
                      },
                    ),
                  ),
                  AppSpacing.verticalSm,

                  _SettingsCard(
                    icon: Icons.access_time,
                    iconColor: context.colorScheme.primary,
                    title: l10n.settingsDailyReminder,
                    subtitle: localStorage.isDailyReminderEnabled
                        ? '08:00 AM'
                        : null,
                    trailing: Icon(
                      Icons.chevron_right,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {
                      final newValue = !localStorage.isDailyReminderEnabled;
                      localStorage.setDailyReminderEnabled(enabled: newValue);
                      final notifs = ref.read(notificationServiceProvider);
                      if (newValue) {
                        notifs.scheduleDailyReminder();
                      } else {
                        notifs.cancelDailyReminder();
                      }
                      ref.invalidate(localStorageProvider);
                    },
                  ),

                  AppSpacing.verticalXl,

                  // ── Data ──
                  const _SectionHeader(title: 'Data'),
                  AppSpacing.verticalMd,

                  _SettingsCard(
                    icon: Icons.close,
                    iconColor: context.colorScheme.error,
                    title: l10n.settingsClearLocalData,
                    trailing: Icon(
                      Icons.info_outline,
                      size: 20,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    onTap: () => _showClearDataDialog(context, ref),
                    isDestructive: true,
                  ),

                  AppSpacing.verticalXl,

                  // ── About ──
                  const _SectionHeader(title: 'About'),
                  AppSpacing.verticalMd,

                  // Version row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Version',
                          style: context.textTheme.bodyLarge,
                        ),
                        Text(
                          '2.4.1 (Build 102)',
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Terms row
                  _AboutRow(
                    title: l10n.settingsTerms,
                    onTap: () => context.push(RouteNames.termsOfService),
                  ),

                  // Privacy row
                  _AboutRow(
                    title: l10n.settingsPrivacy,
                    onTap: () => context.push(RouteNames.privacyPolicy),
                  ),

                  AppSpacing.verticalXxxl,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode, AppLocalizations l10n) {
    return switch (mode) {
      ThemeMode.light => l10n.settingsThemeLight,
      ThemeMode.dark => l10n.settingsThemeDark,
      ThemeMode.system => l10n.settingsThemeSystem,
    };
  }

  void _showCurrencyPicker(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                context.l10n.settingsSelectCurrency,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: SupportedCurrencies.all.length,
                itemBuilder: (context, index) {
                  final currency = SupportedCurrencies.all[index];
                  final isSelected = currency.code == current;
                  return ListTile(
                    leading: Text(
                      currency.flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(currency.code),
                    subtitle: Text(currency.name),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      ref
                          .read(userCurrencyCodeProvider.notifier)
                          .setCurrency(currency.code);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.settingsLanguage),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.settingsLanguageEn),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.settingsLanguageFr),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsClearLocalData),
        content: Text(l10n.settingsClearLocalDataConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () async {
              final storage = ref.read(localStorageProvider);
              await storage.clear();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.settingsClearLocalDataSuccess),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.commonClear),
          ),
        ],
      ),
    );
  }
}

/// Section header with headlineSmall bold text.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

/// Settings card with colored icon circle, title, subtitle, and trailing.
class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.surfaceContainerLow,
      borderRadius: AppRadius.borderRadiusMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderRadiusMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              // Colored icon circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? context.colorScheme.errorContainer
                      : iconColor.withValues(alpha: 0.12),
                  borderRadius: AppRadius.borderRadiusMd,
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isDestructive
                      ? context.colorScheme.error
                      : iconColor,
                ),
              ),
              AppSpacing.horizontalMd,

              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isDestructive
                            ? context.colorScheme.error
                            : null,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Trailing
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

/// About section row with external link icon.
class _AboutRow extends StatelessWidget {
  const _AboutRow({
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: context.textTheme.bodyLarge),
            Icon(
              Icons.open_in_new,
              size: 20,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
