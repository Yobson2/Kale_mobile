import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/loading/app_progress.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/splash/presentation/providers/splash_provider.dart';

/// Splash page shown at app launch.
///
/// Displays the Kalé compass coin logo during the init phase.
class SplashPage extends ConsumerStatefulWidget {
  /// Creates a [SplashPage].
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Logo pulses then settles.
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.1, end: 0.85)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: ConstantTween(0.85),
        weight: 40,
      ),
    ]).animate(_animController);

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashInitProvider, (_, next) {
      if (!context.mounted) return;
      switch (next) {
        case AsyncData(:final value):
          if (value != SplashResult.onboarding &&
              value != SplashResult.guest) {
            ref.read(authNotifierProvider.notifier).checkAuthStatus();
          }
          switch (value) {
            case SplashResult.onboarding:
              context.go('/onboarding');
            case SplashResult.authenticated:
              context.go('/dashboard');
            case SplashResult.unauthenticated:
              context.go('/login');
            case SplashResult.guest:
              ref.read(authNotifierProvider.notifier).enterGuestMode();
              context.go('/dashboard');
          }
        case AsyncError():
          context.go('/login');
        case _:
          break;
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _animController,
              builder: (context, _) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Adinkra K logo.
                  Transform.scale(
                    scale: _logoScale.value,
                    child: SvgPicture.asset(
                      'assets/images/logo-gradient.svg',
                      width: 80,
                      height: 80,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.verticalXl,
            const AppProgress(),
          ],
        ),
      ),
    );
  }
}
