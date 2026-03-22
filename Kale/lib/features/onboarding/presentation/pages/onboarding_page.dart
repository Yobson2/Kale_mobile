import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/buttons/app_primary_button.dart';
import 'package:kale/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:kale/features/onboarding/presentation/widgets/onboarding_step.dart';

/// Onboarding page with 4 swipeable finance-themed steps.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  static const _totalPages = 4;
  final _pageController = PageController();

  // Personalization state for step 4
  String _selectedCurrency = 'XOF';
  String _selectedLanguage = 'en';
  String? _selectedGoal;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onComplete() async {
    // Save personalization preferences
    final localStorage = ref.read(localStorageProvider);
    await localStorage.setString('user_currency', _selectedCurrency);
    await localStorage.setString('user_language', _selectedLanguage);
    if (_selectedGoal != null) {
      await localStorage.setString('user_primary_goal', _selectedGoal!);
    }
    // Also update currency provider
    await ref
        .read(userCurrencyCodeProvider.notifier)
        .setCurrency(_selectedCurrency);

    await ref.read(onboardingNotifierProvider.notifier).complete();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(onboardingNotifierProvider);
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: logo + skip ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  // Brand logo
                  SvgPicture.asset(
                    isDark
                        ? 'assets/images/logo-dark.svg'
                        : 'assets/images/logo.svg',
                    height: 32,
                  ),
                  const Spacer(),
                  // Skip button
                  TextButton(
                    onPressed: _onComplete,
                    child: Text(
                      l10n.commonSkip,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Page view ─────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  ref.read(onboardingNotifierProvider.notifier).setPage(page);
                },
                children: [
                  OnboardingStep(
                    stepIndex: 0,
                    title: l10n.onboardingTitle1,
                    description: l10n.onboardingDesc1,
                  ),
                  OnboardingStep(
                    stepIndex: 1,
                    title: l10n.onboardingTitle2,
                    description: l10n.onboardingDesc2,
                  ),
                  OnboardingStep(
                    stepIndex: 2,
                    title: l10n.onboardingTitle3,
                    description: l10n.onboardingDesc3,
                  ),
                  OnboardingStep(
                    stepIndex: 3,
                    title: l10n.onboardingTitle4,
                    description: l10n.onboardingDesc4,
                    child: _PersonalizationForm(
                      selectedCurrency: _selectedCurrency,
                      onCurrencyChanged: (v) =>
                          setState(() => _selectedCurrency = v),
                      selectedLanguage: _selectedLanguage,
                      onLanguageChanged: (v) =>
                          setState(() => _selectedLanguage = v),
                      selectedGoal: _selectedGoal,
                      onGoalChanged: (v) => setState(() => _selectedGoal = v),
                    ),
                  ),
                ],
              ),
            ),

            // ── Dot indicators ────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_totalPages, (index) {
                final isActive = index == currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary
                            .withValues(alpha: isDark ? 0.2 : 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            AppSpacing.verticalXl,

            // ── CTA button ────────────────────────────────────────
            Padding(
              padding: AppSpacing.paddingHorizontalXl,
              child: AppPrimaryButton(
                text: currentPage == _totalPages - 1
                    ? l10n.onboardingGetStarted
                    : l10n.commonNext,
                onPressed: () {
                  if (currentPage < _totalPages - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _onComplete();
                  }
                },
              ),
            ),

            AppSpacing.verticalXxl,
          ],
        ),
      ),
    );
  }
}

/// Personalization form for the 4th onboarding step.
///
/// Allows the user to select their preferred currency, language,
/// and primary financial goal.
class _PersonalizationForm extends StatelessWidget {
  const _PersonalizationForm({
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    required this.selectedLanguage,
    required this.onLanguageChanged,
    required this.selectedGoal,
    required this.onGoalChanged,
  });

  final String selectedCurrency;
  final ValueChanged<String> onCurrencyChanged;
  final String selectedLanguage;
  final ValueChanged<String> onLanguageChanged;
  final String? selectedGoal;
  final ValueChanged<String> onGoalChanged;

  static const _currencies = ['XOF', 'XAF', 'USD', 'EUR', 'GBP', 'NGN'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Currency selector ─────────────────────────────────
        DropdownButtonFormField<String>(
          value: selectedCurrency,
          decoration: InputDecoration(
            labelText: l10n.onboardingCurrency,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
          items: _currencies
              .map(
                (c) => DropdownMenuItem(value: c, child: Text(c)),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onCurrencyChanged(v);
          },
        ),

        AppSpacing.verticalLg,

        // ── Language toggle ───────────────────────────────────
        Text(
          l10n.onboardingLanguage,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        AppSpacing.verticalSm,
        Row(
          children: [
            ChoiceChip(
              label: const Text('English'),
              selected: selectedLanguage == 'en',
              onSelected: (_) => onLanguageChanged('en'),
            ),
            AppSpacing.horizontalSm,
            ChoiceChip(
              label: const Text('Fran\u00e7ais'),
              selected: selectedLanguage == 'fr',
              onSelected: (_) => onLanguageChanged('fr'),
            ),
          ],
        ),

        AppSpacing.verticalLg,

        // ── Goal picker ───────────────────────────────────────
        Text(
          l10n.onboardingGoal,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        AppSpacing.verticalSm,
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _GoalChip(
              label: l10n.onboardingGoalTrackSpending,
              value: 'track_spending',
              selected: selectedGoal == 'track_spending',
              onSelected: onGoalChanged,
            ),
            _GoalChip(
              label: l10n.onboardingGoalSaveMore,
              value: 'save_more',
              selected: selectedGoal == 'save_more',
              onSelected: onGoalChanged,
            ),
            _GoalChip(
              label: l10n.onboardingGoalManageBudgets,
              value: 'manage_budgets',
              selected: selectedGoal == 'manage_budgets',
              onSelected: onGoalChanged,
            ),
          ],
        ),
      ],
    );
  }
}

/// A selectable chip representing a financial goal.
class _GoalChip extends StatelessWidget {
  const _GoalChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final String value;
  final bool selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(value),
    );
  }
}
