import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/buttons/app_primary_button.dart';
import 'package:kale/core/widgets/inputs/app_otp_field.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/auth/presentation/widgets/auth_header.dart';

/// OTP verification page — enter the 6-digit code.
///
/// Used in the registration flow (navigates to dashboard on success)
/// and the forgot-password flow (navigates to login on success).
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

  bool get _isRegistrationFlow => widget.name != null;

  Future<void> _onVerify() async {
    if (_otpCode.length < 6) return;
    context.unfocus();
    final success = await ref
        .read(authNotifierProvider.notifier)
        .verifyOtp(email: widget.email, code: _otpCode);
    if (success && mounted) {
      if (_isRegistrationFlow) {
        // OTP verified → user is now authenticated → go to dashboard.
        context.go(RouteNames.dashboard);
      } else {
        // Forgot-password flow — return to login.
        context.go(RouteNames.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authNotifierProvider, (_, state) {
      if (state is AuthError) {
        context.showSnackBar(state.message, isError: true);
      }
      // Safety net: navigate on auth state change.
      if (state is AuthAuthenticated) {
        context.go(RouteNames.dashboard);
      }
    });

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingHorizontalXl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthHeader(
                title: context.l10n.authOtpTitle,
                subtitle: context.l10n.authOtpSubtitle(widget.email),
              ),
              AppOtpField(
                onChanged: (code) => setState(() => _otpCode = code),
                onCompleted: (_) => _onVerify(),
              ),
              AppSpacing.verticalXl,
              AppPrimaryButton(
                text: context.l10n.commonDone,
                onPressed: _onVerify,
                isLoading: isLoading,
              ),
              AppSpacing.verticalLg,
              Center(
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          // For forgot-password flow, re-send the reset email.
                          // For registration flow, Supabase requires re-calling
                          // signUp to resend the confirmation OTP.
                          ref
                              .read(authNotifierProvider.notifier)
                              .forgotPassword(email: widget.email);
                          context.showSnackBar(
                            'OTP resent to ${widget.email}',
                          );
                        },
                  child: Text(context.l10n.authOtpResend),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
