import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/mascot/kai_pose.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/validators.dart';
import 'package:kale/core/widgets/buttons/app_primary_button.dart';
import 'package:kale/core/widgets/inputs/app_text_field.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/auth/presentation/widgets/auth_header.dart';

/// Forgot password page — enter email to receive a reset code.
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
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingHorizontalXl,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthHeader(
                  title: context.l10n.authResetPassword,
                  subtitle: context.l10n.authForgotPasswordSubtitle,
                  mascotPose: KaiPose.thinking,
                ),
                AppTextField(
                  controller: _emailController,
                  label: context.l10n.authEmail,
                  hint: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.email],
                  validator: Validators.email,
                  prefixIcon: const Icon(Icons.email_outlined),
                  onSubmitted: (_) => _onSubmit(),
                ),
                AppSpacing.verticalXl,
                AppPrimaryButton(
                  text: context.l10n.commonNext,
                  onPressed: _onSubmit,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
