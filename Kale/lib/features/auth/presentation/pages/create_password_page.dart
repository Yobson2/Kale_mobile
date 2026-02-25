import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/validators.dart';
import 'package:kale/core/widgets/buttons/app_primary_button.dart';
import 'package:kale/core/widgets/inputs/app_password_field.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/auth/presentation/widgets/auth_header.dart';

/// Final registration step — set a password for the new account.
class CreatePasswordPage extends ConsumerStatefulWidget {
  /// Creates a [CreatePasswordPage].
  const CreatePasswordPage({
    required this.name,
    required this.email,
    super.key,
  });

  /// User's full name from step 1.
  final String name;

  /// User's email from step 1.
  final String email;

  @override
  ConsumerState<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends ConsumerState<CreatePasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.unfocus();
      ref.read(authNotifierProvider.notifier).register(
            name: widget.name,
            email: widget.email,
            password: _passwordController.text,
          );
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
      if (state is AuthAuthenticated) {
        context.go(RouteNames.dashboard);
      }
    });

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingHorizontalXl,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthHeader(
                      title: context.l10n.authCreatePassword,
                      subtitle: context.l10n.authCreatePasswordSubtitle,
                    ),
                    AppPasswordField(
                      controller: _passwordController,
                      label: context.l10n.authPassword,
                      validator: Validators.password,
                      textInputAction: TextInputAction.next,
                    ),
                    AppSpacing.verticalLg,
                    AppPasswordField(
                      controller: _confirmPasswordController,
                      label: context.l10n.authConfirmPassword,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return context.l10n.validationPasswordMatch;
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _onSubmit(),
                    ),
                    AppSpacing.verticalXl,
                    AppPrimaryButton(
                      text: context.l10n.authRegister,
                      onPressed: _onSubmit,
                      isLoading: isLoading,
                    ),
                    AppSpacing.verticalMd,
                    Center(
                      child: Text(
                        context.l10n.authTerms,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodySmall,
                      ),
                    ),
                    AppSpacing.verticalXl,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
