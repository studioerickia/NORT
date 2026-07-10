import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../blue/presentation/blue_avatar.dart';
import '../../../../blue/presentation/blue_state.dart';
import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/components/animations/fade_scale_in.dart';
import '../../../../shared/components/buttons/nort_text_button.dart';
import '../../../../shared/components/buttons/primary_button.dart';
import '../../../../shared/components/common/pressable_scale.dart';
import '../../../../shared/components/inputs/text_input.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _showEmailForm = false;
  bool _isSignUp = false;
  bool _loading = false;
  String? _errorMessage;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Preencha e-mail e senha.');
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final authService = ref.read(authServiceProvider);

    try {
      if (_isSignUp) {
        await authService.signUpWithEmail(email: email, password: password);
      } else {
        await authService.signInWithEmail(email: email, password: password);
      }
      if (mounted) context.go(AppRoutes.home);
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'Algo deu errado. Tente de novo.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Em breve — login social ainda não está disponível.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: spacing.xl, vertical: spacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: spacing.xxxl),
              FadeScaleIn(
                child: Column(
                  children: [
                    const BlueAvatar(state: BlueState.idle, size: 64, showGlow: false),
                    SizedBox(height: spacing.lg),
                    Text(
                      'Entrar no NORT',
                      textAlign: TextAlign.center,
                      style: context.textStyles.headlineMedium,
                    ),
                    SizedBox(height: spacing.xs),
                    Text(
                      'Continue de onde parou, com calma.',
                      textAlign: TextAlign.center,
                      style: context.textStyles.bodyLarge?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing.xxxl),
              FadeScaleIn(
                delay: const Duration(milliseconds: 80),
                child: Column(
                  children: [
                    _AppleSignInButton(onTap: _showComingSoon),
                    SizedBox(height: spacing.sm),
                    _GoogleSignInButton(onTap: _showComingSoon),
                  ],
                ),
              ),
              SizedBox(height: spacing.xl),
              Center(
                child: NortTextButton(
                  label: _showEmailForm ? 'Ocultar e-mail' : 'Continuar com e-mail',
                  onPressed: () => setState(() => _showEmailForm = !_showEmailForm),
                ),
              ),
              AnimatedSize(
                duration: context.motion.standard,
                curve: context.motion.enter,
                alignment: Alignment.topCenter,
                child: _showEmailForm
                    ? Padding(
                        padding: EdgeInsets.only(top: spacing.lg),
                        child: Column(
                          children: [
                            NortTextInput(
                              label: 'E-mail',
                              placeholder: 'voce@email.com',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: spacing.md),
                            NortTextInput(
                              label: 'Senha',
                              obscureText: true,
                              controller: _passwordController,
                            ),
                            if (_errorMessage != null) ...[
                              SizedBox(height: spacing.sm),
                              Text(
                                _errorMessage!,
                                style: context.textStyles.bodySmall?.copyWith(color: colors.danger),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            SizedBox(height: spacing.lg),
                            PrimaryButton(
                              label: _isSignUp ? 'Criar conta' : 'Entrar',
                              loading: _loading,
                              onPressed: _loading ? null : _submit,
                            ),
                            SizedBox(height: spacing.md),
                            PressableScale(
                              onTap: () => setState(() {
                                _isSignUp = !_isSignUp;
                                _errorMessage = null;
                              }),
                              child: Center(
                                child: Text(
                                  _isSignUp
                                      ? 'Já tem conta? Entrar'
                                      : 'Ainda não tem conta? Criar conta',
                                  style: context.textStyles.labelLarge?.copyWith(
                                    color: colors.brand.defaultColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppleSignInButton extends StatelessWidget {
  const _AppleSignInButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final radii = context.radii;

    return PressableScale(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: spacing.md + 2),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: radii.smRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.apple, color: Colors.white, size: 20),
            SizedBox(width: spacing.sm),
            Text(
              'Continuar com Apple',
              style: context.textStyles.titleMedium?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return PressableScale(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: spacing.md + 2),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: radii.smRadius,
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.g_mobiledata, color: colors.textPrimary, size: 26),
            SizedBox(width: spacing.sm),
            Text(
              'Continuar com Google',
              style: context.textStyles.titleMedium?.copyWith(color: colors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}