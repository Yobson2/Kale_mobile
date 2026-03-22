import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/data_display/geometric_k_watermark.dart';
import 'package:kale/core/widgets/loading/app_progress.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/splash/presentation/providers/splash_provider.dart';

/// Splash page with geometric K watermarks and brand identity.
///
/// Displays the Kale logo, tagline "THE DIGITAL LOOM", a loading spinner,
/// and "SECURE FINANCIAL WEAVING" footer.
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
      body: Stack(
        children: [
          // Background K watermarks
          const GeometricKWatermark(
            opacity: 0.06,
            fontSize: 300,
            alignment: Alignment.topRight,
            offset: Offset(60, -40),
          ),
          const GeometricKWatermark(
            opacity: 0.04,
            fontSize: 250,
            alignment: Alignment.bottomLeft,
            offset: Offset(-50, 40),
          ),
          const GeometricKWatermark(
            opacity: 0.03,
            fontSize: 180,
            alignment: Alignment.centerRight,
            offset: Offset(80, 100),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, _) => Transform.scale(
                    scale: _logoScale.value,
                    child: SvgPicture.asset(
                      'assets/images/logo-gradient.svg',
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
                AppSpacing.verticalLg,
                // Brand name
                Text(
                  'Kal\u00e9',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: colorScheme.onSurface,
                  ),
                ),
                AppSpacing.verticalXs,
                // Tagline
                Text(
                  'THE DIGITAL LOOM',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.verticalXxl,
                const AppProgress(),
              ],
            ),
          ),

          // Footer
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                AppSpacing.verticalXs,
                Text(
                  'SECURE FINANCIAL WEAVING',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
