import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/buttons/app_primary_button.dart';
import 'package:kale/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:kale/features/onboarding/presentation/widgets/onboarding_step.dart';

/// Onboarding page with 3 swipeable finance-themed steps.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  static const _totalPages = 3;
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onComplete() async {
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
