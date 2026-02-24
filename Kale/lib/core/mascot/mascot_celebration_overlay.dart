import 'package:flutter/material.dart';
import 'package:kale/core/mascot/confetti_painter.dart';
import 'package:kale/core/mascot/kai_mascot.dart';
import 'package:kale/core/mascot/kai_pose.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/theme/app_typography.dart';

/// Full-screen celebration overlay with Kai in celebration pose + confetti.
///
/// Shows when a savings goal is achieved, budget month completed under budget,
/// or other milestone events.
///
/// Auto-dismisses after [duration] or when the user taps the button.
class MascotCelebrationOverlay extends StatefulWidget {
  const MascotCelebrationOverlay({
    required this.title,
    required this.onDismiss,
    super.key,
    this.subtitle,
    this.buttonText = 'Continue',
    this.duration = const Duration(seconds: 5),
  });

  final String title;
  final String? subtitle;
  final String buttonText;
  final VoidCallback onDismiss;
  final Duration duration;

  /// Shows the overlay as a full-screen dialog.
  static Future<void> show(
    BuildContext context, {
    required String title,
    String? subtitle,
    String buttonText = 'Continue',
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Celebration',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return MascotCelebrationOverlay(
          title: title,
          subtitle: subtitle,
          buttonText: buttonText,
          onDismiss: () => Navigator.of(context).pop(),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<MascotCelebrationOverlay> createState() =>
      _MascotCelebrationOverlayState();
}

class _MascotCelebrationOverlayState extends State<MascotCelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Confetti animation.
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                painter: ConfettiPainter(progress: _controller.value),
              ),
            ),
          ),

          // Content.
          Center(
            child: Padding(
              padding: AppSpacing.paddingHorizontalXl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Kai celebrating.
                  const KaiMascot(
                    pose: KaiPose.celebration,
                    colorTint: AppColors.incomeLight,
                  ),

                  AppSpacing.verticalXl,

                  // Title.
                  Text(
                    widget.title,
                    style: AppTypography.mascotDisplayLarge(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  if (widget.subtitle != null) ...[
                    AppSpacing.verticalSm,
                    Text(
                      widget.subtitle!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  AppSpacing.verticalXxl,

                  // Dismiss button.
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: widget.onDismiss,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.kaiBody,
                      ),
                      child: Text(widget.buttonText),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
