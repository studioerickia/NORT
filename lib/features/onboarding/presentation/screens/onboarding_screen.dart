import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../blue/presentation/blue_avatar.dart';
import '../../../../blue/presentation/blue_state.dart';
import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/components/animations/fade_scale_in.dart';
import '../../../../shared/components/buttons/nort_text_button.dart';
import '../../../../shared/components/buttons/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.blueState,
  });

  final String title;
  final String subtitle;
  final BlueState blueState;
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _page = 0;

  static const List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      title: 'Dinheiro não precisa\nser motivo de ansiedade',
      subtitle: 'Aqui, você encontra clareza\nantes de qualquer número.',
      blueState: BlueState.idle,
    ),
    _OnboardingSlide(
      title: 'Você não está\nsozinho nessa',
      subtitle: 'A Blue caminha ao seu lado — pra conversar,\nentender e cuidar do que importa.',
      blueState: BlueState.idle,
    ),
    _OnboardingSlide(
      title: 'Progresso,\nnão perfeição',
      subtitle: 'Cada passo importa.\nO ritmo é seu.',
      blueState: BlueState.celebrating,
    ),
  ];

  bool get _isLastPage => _page == _slides.length - 1;

  void _next() {
    if (_isLastPage) {
      context.go(AppRoutes.login);
      return;
    }
    _pageController.nextPage(
      duration: context.motion.standard,
      curve: context.motion.enter,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors.oceanGradientStart.withOpacity(0.35),
              colors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                  child: AnimatedOpacity(
                    duration: context.motion.micro,
                    opacity: _isLastPage ? 0 : 1,
                    child: NortTextButton(
                      label: 'Pular',
                      onPressed: _isLastPage ? null : () => context.go(AppRoutes.login),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return FadeScaleIn(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: spacing.xl),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BlueAvatar(state: slide.blueState, size: 140),
                            SizedBox(height: spacing.xxl),
                            Text(
                              slide.title,
                              textAlign: TextAlign.center,
                              style: context.textStyles.headlineLarge,
                            ),
                            SizedBox(height: spacing.md),
                            Text(
                              slide.subtitle,
                              textAlign: TextAlign.center,
                              style: context.textStyles.bodyLarge?.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _PageDots(count: _slides.length, current: _page),
              Padding(
                padding: EdgeInsets.fromLTRB(spacing.xl, spacing.xl, spacing.xl, spacing.xl),
                child: PrimaryButton(
                  label: _isLastPage ? 'Começar' : 'Continuar',
                  onPressed: _next,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final motion = context.motion;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: motion.standard,
          curve: motion.enter,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? colors.brand.defaultColor : colors.border,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}