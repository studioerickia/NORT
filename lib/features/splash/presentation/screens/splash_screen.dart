import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../blue/presentation/blue_avatar.dart';
import '../../../../blue/presentation/blue_state.dart';
import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/components/animations/breathing_scale.dart';
import '../../../../shared/components/animations/fade_scale_in.dart';
import '../../../../shared/components/whale_labs_signature.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) context.go(AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      body: GestureDetector(
        onTap: () => context.go(AppRoutes.onboarding),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: FadeScaleIn(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'NORT',
                  style: context.textStyles.displayLarge?.copyWith(
                    letterSpacing: 8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: spacing.xl),
                const BreathingScale(
                  child: BlueAvatar(
                    state: BlueState.idle,
                    size: 48,
                    showGlow: false,
                  ),
                ),
                SizedBox(height: spacing.md),
                const WhaleLabsSignature(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}