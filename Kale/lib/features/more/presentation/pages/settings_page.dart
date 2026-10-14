import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/l10n/app_locale.dart';
import 'package:kale/core/money/currency.dart';
import 'package:kale/core/providers/notification_provider.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/theme/theme_provider.dart';
import 'package:kale/core/widgets/data_display/geometric_k_watermark.dart';
import 'package:kale/features/more/presentation/widgets/backup_status_tile.dart';
import 'package:kale/features/profile/presentation/providers/profile_providers.dart';
import 'package:kale/features/profile/presentation/widgets/base_currency_picker.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/domain/usecases/export_transactions_csv_usecase.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_notifier.dart';
import 'package:kale/l10n/app_localizations.dart';

/// Settings page with card-per-item layout, colored icon circles,
/// and section headers per the Digital Loom design.
class SettingsPage extends ConsumerWidget {
  /// Creates a [SettingsPage].
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final baseCurrency = ref.watch(baseCurrencyProvider);
    final localStorage = ref.watch(localStorageProvider);
    final l10n = context.l10n;

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
          // K watermark at bottom (it positions itself in the Stack).
          const GeometricKWatermark(
            opacity: 0.03,
            fontSize: 180,
            alignment: Alignment.bottomCenter,
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Preferences ──
                  _SectionHeader(
                    title: l10n.settingsCurrency.isEmpty
                        ? 'Preferences'
                        : 'Preferences',
                  ),
                  AppSpacing.verticalMd,

                  _SettingsCard(
                    icon: Icons.currency_exchange,
                    iconColor: context.colorScheme.primary,
                    title: l10n.baseCurrencyLabel,
                    subtitle: '${baseCurrency.code} - '
                        '${baseCurrency.name.toUpperCase()}',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    onTap: () =>
                        _showCurrencyPicker(context, ref, baseCurrency),
                  ),
                  AppSpacing.verticalSm,

                  _SettingsCard(
                    icon: Icons.translate,
                    iconColor: context.colorScheme.primary,
                    title: l10n.settingsLanguage,
                    subtitle: switch (ref.watch(appLanguageProvider)) {
                      'fr' => l10n.settingsLanguageFr,
                      'en' => l10n.settingsLanguageEn,
                      _ => l10n.settingsLanguageSystem,
                    },
                    trailing: Icon(
                      Icons.chevron_right,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    onTap: () => _showLanguagePicker(context, ref),
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
                    // Opt-in: off until turned on; tapping changes the time.
                    subtitle: localStorage.isDailyReminderEnabled
                        ? _reminderTime(localStorage.dailyReminderMinuteOfDay)
                            .format(context)
                        : l10n.settingsDisabled,
                    trailing: Switch.adaptive(
                      value: localStorage.isDailyReminderEnabled,
                      onChanged: (on) => on
                          ? _pickReminderTime(context, ref)
                          : _disableReminder(ref),
                    ),
                    onTap: localStorage.isDailyReminderEnabled
                        ? () => _pickReminderTime(context, ref)
                        : null,
                  ),

                  AppSpacing.verticalXl,

                  // ── Backup ──
                  _SectionHeader(title: l10n.settingsBackup),
                  AppSpacing.verticalMd,
                  const BackupStatusTile(),

                  AppSpacing.verticalXl,

                  // ── Data ──
                  _SectionHeader(title: l10n.settingsData),
                  AppSpacing.verticalMd,

                  _SettingsCard(
                    icon: Icons.file_download_outlined,
                    iconColor: context.colorScheme.primary,
                    title: l10n.exportCsvTitle,
                    subtitle: l10n.exportCsvSubtitle,
                    trailing: Icon(
                      Icons.chevron_right,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    onTap: () => _exportCsv(context, ref),
                  ),
                  AppSpacing.verticalSm,

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
    Currency current,
  ) {
    // The page's context: still mounted after the sheet closes, to show
    // the relabel warning.
    final sheetParent = context;
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
              child: BaseCurrencyList(
                controller: scrollController,
                selected: current,
                onSelected: (currency) async {
                  Navigator.pop(context);
                  await requestBaseCurrencyChange(sheetParent, ref, currency);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static TimeOfDay _reminderTime(int minuteOfDay) =>
      TimeOfDay(hour: minuteOfDay ~/ 60, minute: minuteOfDay % 60);

  /// Asks for the reminder time, then turns the daily reminder on at it.
  Future<void> _pickReminderTime(BuildContext context, WidgetRef ref) async {
    final reminder = ref.read(dailyReminderProvider);
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime(reminder.minuteOfDay),
    );
    if (picked == null) return;
    await reminder.enable(picked.hour * 60 + picked.minute);
    ref.invalidate(localStorageProvider);
  }

  Future<void> _disableReminder(WidgetRef ref) async {
    await ref.read(dailyReminderProvider).disable();
    ref.invalidate(localStorageProvider);
  }

  /// Asks for the range (everything, or chosen dates), then exports the
  /// transactions as CSV to the share sheet.
  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final allTime = await showModalBottomSheet<bool>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.all_inclusive),
              title: Text(l10n.exportCsvAll),
              onTap: () => Navigator.pop(sheetContext, true),
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(l10n.exportCsvDateRange),
              onTap: () => Navigator.pop(sheetContext, false),
            ),
          ],
        ),
      ),
    );
    if (allTime == null || !context.mounted) return;

    DateTimeRange? range;
    if (!allTime) {
      range = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
      );
      if (range == null || !context.mounted) return;
    }

    final today = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    final count = await ref
        .read(transactionsNotifierProvider.notifier)
        .exportCsv(
          labels: CsvLabels(
            date: l10n.csvDate,
            type: l10n.csvType,
            category: l10n.csvCategory,
            description: l10n.csvDescription,
            amount: l10n.csvAmount,
            currency: l10n.csvCurrency,
            paymentMethod: l10n.csvPaymentMethod,
            mobileMoneyProvider: l10n.csvMobileMoneyProvider,
            types: {
              TransactionType.income: l10n.transactionsIncome,
              TransactionType.expense: l10n.transactionsExpense,
            },
            paymentMethods: {
              PaymentMethod.cash: l10n.transactionsPaymentCash,
              PaymentMethod.mobileMoney: l10n.transactionsPaymentMobileMoney,
              PaymentMethod.bank: l10n.transactionsPaymentBank,
              PaymentMethod.card: l10n.transactionsPaymentCard,
            },
          ),
          fileName: 'kale-transactions-${today.year}-'
              '${two(today.month)}-${two(today.day)}.csv',
          startDate: range?.start,
          // The whole last day.
          endDate: range?.end.add(const Duration(days: 1, microseconds: -1)),
        );
    if (!context.mounted) return;
    if (count == null) {
      context.showSnackBar(l10n.exportCsvFailed, isError: true);
    } else if (count == 0) {
      context.showSnackBar(l10n.exportCsvEmpty);
    }
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final notifier = ref.read(appLanguageProvider.notifier);
    final options = <(String?, String)>[
      (null, l10n.settingsLanguageSystem),
      ('fr', l10n.settingsLanguageFr),
      ('en', l10n.settingsLanguageEn),
    ];
    showDialog<void>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(l10n.settingsLanguage),
        children: [
          for (final (language, label) in options)
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext);
                notifier.select(language);
              },
              child: Text(label),
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
                  color: isDestructive ? context.colorScheme.error : iconColor,
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
                        color: isDestructive ? context.colorScheme.error : null,
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
