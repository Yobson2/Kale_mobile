import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/buttons/app_primary_button.dart';
import 'package:kale/core/widgets/data_display/geometric_k_watermark.dart';
import 'package:kale/core/widgets/inputs/app_otp_field.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';

/// OTP verification page — enter the 6-digit code.
///
/// Design: Kalé branding in app bar, circular OTP inputs,
/// countdown timer, K watermark at bottom-right.
class OtpVerificationPage extends ConsumerStatefulWidget {
  /// Creates an [OtpVerificationPage].
  const OtpVerificationPage({
    required this.email,
    this.name,
    super.key,
  });

  /// Email the OTP was sent to.
  final String email;

  /// User name — present only in the registration flow.
  final String? name;

  @override
  ConsumerState<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  String _otpCode = '';
  int _secondsRemaining = 120;
  Timer? _timer;

  bool get _isRegistrationFlow => widget.name != null;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 120);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _onVerify() async {
    if (_otpCode.length < 6) return;
    context.unfocus();
    final success = await ref
        .read(authNotifierProvider.notifier)
        .verifyOtp(email: widget.email, code: _otpCode);
    if (success && mounted) {
      if (_isRegistrationFlow) {
        context.go(RouteNames.dashboard);
      } else {
        context.go(RouteNames.login);
      }
    }
  }

  void _onResend() {
    ref.read(authNotifierProvider.notifier).forgotPassword(
          email: widget.email,
        );
    context.showSnackBar('OTP resent to ${widget.email}');
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;
    final isDark = context.isDark;

    ref.listen<AuthState>(authNotifierProvider, (_, state) {
      if (state is AuthError) {
        context.showSnackBar(state.message, isError: true);
      }
      if (state is AuthAuthenticated) {
        context.go(RouteNames.dashboard);
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const BackButton(),
        title: Text(
          'Kalé',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: SvgPicture.asset(
              isDark
                  ? 'assets/images/logo-dark.svg'
                  : 'assets/images/logo.svg',
              height: 32,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // K watermark bottom-right
          const Positioned(
            bottom: 40,
            right: -20,
            child: GeometricKWatermark(
              opacity: 0.04,
              fontSize: 200,
              alignment: Alignment.bottomRight,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top content
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppSpacing.paddingHorizontalXl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSpacing.verticalXl,

                        // Title
                        Text(
                          context.l10n.authOtpTitle,
                          style: context.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        AppSpacing.verticalMd,

                        // Subtitle with email
                        Text.rich(
                          TextSpan(
                            text: 'Enter the 6-digit code sent to\n',
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                            children: [
                              TextSpan(
                                text: widget.email,
                                style: context.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: context.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.verticalXxl,

                        // OTP field
                        AppOtpField(
                          onChanged: (code) =>
                              setState(() => _otpCode = code),
                          onCompleted: (_) => _onVerify(),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom pinned section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: Column(
                    children: [
                      // Verify button
                      AppPrimaryButton(
                        text: context.l10n.commonDone,
                        onPressed: _onVerify,
                        isLoading: isLoading,
                      ),
                      AppSpacing.verticalLg,

                      // Resend section
                      Text(
                        "Didn't receive code?",
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      AppSpacing.verticalXs,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed:
                                _secondsRemaining <= 0 && !isLoading
                                    ? _onResend
                                    : null,
                            child: Text(
                              context.l10n.authOtpResend,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: _secondsRemaining <= 0
                                    ? context.colorScheme.primary
                                    : context.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            ' · $_formattedTime',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.verticalXl,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
