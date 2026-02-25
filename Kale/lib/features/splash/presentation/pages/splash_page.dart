import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/mascot/kai_mascot.dart';
import 'package:kale/core/mascot/kai_pose.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/loading/app_progress.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/splash/presentation/providers/splash_provider.dart';

/// Splash page shown at app launch.
///
/// Displays the Kalé compass coin logo with Kai the Chameleon mascot
/// emerging alongside it during the init phase.
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
  late final Animation<double> _mascotSlide;
  late final Animation<double> _mascotFade;

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

    // Kai slides in from right.
    _mascotSlide = Tween<double>(begin: 60, end: 0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOutBack),
      ),
    );

    // Kai fades in.
    _mascotFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.35, 0.65, curve: Curves.easeIn),
      ),
    );

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
          if (value != SplashResult.onboarding) {
            ref.read(authNotifierProvider.notifier).checkAuthStatus();
          }
          switch (value) {
            case SplashResult.onboarding:
              context.go('/onboarding');
            case SplashResult.authenticated:
              context.go('/dashboard');
            case SplashResult.unauthenticated:
              context.go('/login');
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
            // Logo + Mascot composition.
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
                  // Kai emerges from behind the logo.
                  Transform.translate(
                    offset: Offset(_mascotSlide.value, 0),
                    child: Opacity(
                      opacity: _mascotFade.value,
                      child: const KaiMascot(
                        pose: KaiPose.welcome,
                        size: 80,
                      ),
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
