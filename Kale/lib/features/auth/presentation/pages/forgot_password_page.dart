import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/validators.dart';
import 'package:kale/core/widgets/buttons/app_primary_button.dart';
import 'package:kale/core/widgets/data_display/geometric_k_watermark.dart';
import 'package:kale/core/widgets/inputs/app_text_field.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';

/// Forgot password page — enter email to receive a reset code.
///
/// Design: editorial heading, green accent bar, K watermark,
/// step indicator dots (STEP 1 OF 3), and gradient CTA.
class ForgotPasswordPage extends ConsumerStatefulWidget {
  /// Creates a [ForgotPasswordPage].
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      context.unfocus();
      final success = await ref
          .read(authNotifierProvider.notifier)
          .forgotPassword(email: _emailController.text.trim());
      if (success && mounted) {
        // ignore: unawaited_futures
        context.push(
          '/otp-verification',
          extra: {'email': _emailController.text.trim()},
        );
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
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingHorizontalXl,
                child: Form(
                  key: _formKey,
                  child: Stack(
                    children: [
                      // K watermark top-right
                      const GeometricKWatermark(
                        opacity: 0.04,
                        fontSize: 220,
                        alignment: Alignment.topRight,
                        offset: Offset(40, -20),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSpacing.verticalXxl,

                          // Green accent bar
                          Container(
                            width: 48,
                            height: 4,
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary,
                              borderRadius: AppRadius.borderRadiusFull,
                            ),
                          ),
                          AppSpacing.verticalLg,

                          // Editorial title
                          Text(
                            context.l10n.authResetPassword,
                            style: context.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          AppSpacing.verticalSm,

                          // Subtitle
                          Text(
                            context.l10n.authForgotPasswordSubtitle,
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          AppSpacing.verticalXxl,

                          // Email field
                          AppTextField(
                            controller: _emailController,
                            label: context.l10n.authEmail,
                            hint: 'name@example.com',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.email],
                            validator: Validators.email,
                            prefixIcon: const Icon(Icons.person_outline),
                            onSubmitted: (_) => _onSubmit(),
                          ),
                          AppSpacing.verticalXl,

                          // Gradient CTA
                          AppPrimaryButton(
                            text: 'Send Reset Code',
                            icon: Icons.arrow_forward,
                            onPressed: _onSubmit,
                            isLoading: isLoading,
                          ),
                          AppSpacing.verticalLg,

                          // Back to Login link
                          Center(
                            child: TextButton.icon(
                              onPressed: () => context.pop(),
                              icon: Icon(
                                Icons.arrow_back,
                                size: 18,
                                color: context.colorScheme.primary,
                              ),
                              label: Text(
                                'Back to Login',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: context.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Step indicator at bottom
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: Column(
                children: [
                  // Step dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final isActive = i == 0;
                      return Container(
                        width: isActive ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: isActive
                              ? context.colorScheme.primary
                              : context.colorScheme.primaryContainer
                                  .withValues(alpha: 0.3),
                          borderRadius: AppRadius.borderRadiusFull,
                        ),
                      );
                    }),
                  ),
                  AppSpacing.verticalSm,
                  Text(
                    'STEP 1 OF 3',
                    style: context.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.65,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom accent bar
            Container(
              width: double.infinity,
              height: 4,
              color: context.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
