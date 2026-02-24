import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/constants/currencies.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/providers/notification_provider.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/theme/theme_provider.dart';
import 'package:kale/core/widgets/data_display/app_list_tile.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';

/// Settings page with currency, theme, notifications, language, and data
/// management.
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
      appBar: AppAppBar(title: l10n.settingsTitle),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Currency section ──
              _SectionHeader(title: 'Currency'),
              AppSpacing.verticalMd,
              AppListTile(
                leading: const Icon(Icons.attach_money),
                title: 'Currency',
                subtitle: currency != null
                    ? '${currency.flag} ${currency.code} — ${currency.name}'
                    : currencyCode,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showCurrencyPicker(context, ref, currencyCode),
              ),

              AppSpacing.verticalXl,

              // ── Appearance section ──
              _SectionHeader(title: l10n.settingsAppearance),
              AppSpacing.verticalMd,
              AppListTile(
                leading: const Icon(Icons.palette_outlined),
                title: l10n.settingsTheme,
                subtitle: _themeLabel(themeMode, l10n),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showThemePicker(context, ref, themeMode),
              ),
              AppSpacing.verticalSm,
              AppListTile(
                leading: const Icon(Icons.language),
                title: l10n.settingsLanguage,
                subtitle: l10n.settingsLanguageEn,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguagePicker(context),
              ),

              AppSpacing.verticalXl,

              // ── Notifications section ──
              _SectionHeader(title: 'Notifications'),
              AppSpacing.verticalMd,
              AppListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: 'Push Notifications',
                subtitle: localStorage.isNotificationsEnabled
                    ? 'Enabled'
                    : 'Disabled',
                trailing: Switch.adaptive(
                  value: localStorage.isNotificationsEnabled,
                  onChanged: (value) {
                    localStorage.setNotificationsEnabled(enabled: value);
                    // Force rebuild.
                    ref.invalidate(localStorageProvider);
                  },
                ),
              ),
              AppSpacing.verticalSm,
              AppListTile(
                leading: const Icon(Icons.alarm_outlined),
                title: 'Daily Reminder',
                subtitle: localStorage.isDailyReminderEnabled
                    ? 'Remind me to log transactions'
                    : 'Disabled',
                trailing: Switch.adaptive(
                  value: localStorage.isDailyReminderEnabled,
                  onChanged: (value) {
                    localStorage.setDailyReminderEnabled(enabled: value);
                    final notifs = ref.read(notificationServiceProvider);
                    if (value) {
                      notifs.scheduleDailyReminder();
                    } else {
                      notifs.cancelDailyReminder();
                    }
                    ref.invalidate(localStorageProvider);
                  },
                ),
              ),
              AppSpacing.verticalSm,
              _BudgetAlertThresholdTile(
                threshold: localStorage.budgetAlertThreshold,
                onChanged: (value) {
                  localStorage.setBudgetAlertThreshold(value);
                  ref.invalidate(localStorageProvider);
                },
              ),

              AppSpacing.verticalXl,

              // ── Data section ──
              _SectionHeader(title: 'Data'),
              AppSpacing.verticalMd,
              AppListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: context.colorScheme.error,
                ),
                title: 'Clear Local Data',
                subtitle: 'Remove all cached data from this device',
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showClearDataDialog(context, ref),
              ),

              AppSpacing.verticalXl,

              // ── About section ──
              _SectionHeader(title: l10n.settingsAbout),
              AppSpacing.verticalMd,
              AppListTile(
                leading: const Icon(Icons.info_outline),
                title: l10n.settingsVersion('1.0.0'),
                trailing: const SizedBox.shrink(),
              ),
              AppSpacing.verticalSm,
              AppListTile(
                leading: const Icon(Icons.description_outlined),
                title: l10n.settingsTerms,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(RouteNames.termsOfService),
              ),
              AppSpacing.verticalSm,
              AppListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: l10n.settingsPrivacy,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(RouteNames.privacyPolicy),
              ),
            ],
          ),
        ),
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
                'Select Currency',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
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

  void _showThemePicker(
    BuildContext context,
    WidgetRef ref,
    ThemeMode current,
  ) {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.settingsTheme),
        children: [
          _ThemeOption(
            title: l10n.settingsThemeSystem,
            mode: ThemeMode.system,
            current: current,
            onTap: () {
              ref.read(themeModeNotifierProvider.notifier).setThemeMode(
                    ThemeMode.system,
                  );
              Navigator.pop(context);
            },
          ),
          _ThemeOption(
            title: l10n.settingsThemeLight,
            mode: ThemeMode.light,
            current: current,
            onTap: () {
              ref.read(themeModeNotifierProvider.notifier).setThemeMode(
                    ThemeMode.light,
                  );
              Navigator.pop(context);
            },
          ),
          _ThemeOption(
            title: l10n.settingsThemeDark,
            mode: ThemeMode.dark,
            current: current,
            onTap: () {
              ref.read(themeModeNotifierProvider.notifier).setThemeMode(
                    ThemeMode.dark,
                  );
              Navigator.pop(context);
            },
          ),
        ],
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
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Local Data'),
        content: const Text(
          'This will remove all cached data from this device. '
          'Your account and synced data on the server will not be affected.\n\n'
          'Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final storage = ref.read(localStorageProvider);
              await storage.clear();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Local data cleared')),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

/// Section header label.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }
}

/// Budget alert threshold tile with a slider.
class _BudgetAlertThresholdTile extends StatefulWidget {
  const _BudgetAlertThresholdTile({
    required this.threshold,
    required this.onChanged,
  });

  final double threshold;
  final ValueChanged<double> onChanged;

  @override
  State<_BudgetAlertThresholdTile> createState() =>
      _BudgetAlertThresholdTileState();
}

class _BudgetAlertThresholdTileState extends State<_BudgetAlertThresholdTile> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.threshold;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (_value * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_outlined),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budget Alert Threshold',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Alert when spending reaches $percentage% of budget',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Slider.adaptive(
          value: _value,
          min: 0.5,
          max: 1.0,
          divisions: 10,
          label: '$percentage%',
          onChanged: (v) => setState(() => _value = v),
          onChangeEnd: widget.onChanged,
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.title,
    required this.mode,
    required this.current,
    required this.onTap,
  });

  final String title;
  final ThemeMode mode;
  final ThemeMode current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onTap,
      child: Row(
        children: [
          Expanded(child: Text(title)),
          if (mode == current)
            Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.primary,
            ),
        ],
      ),
    );
  }
}
