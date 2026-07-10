import 'package:flutter/material.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../shared/components/animations/fade_scale_in.dart';
import '../../../../shared/components/whale_labs_signature.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const NortTopAppBar(title: 'Sobre o NORT', showBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FadeScaleIn(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'NORT é um produto da Whale Labs.',
                        style: context.textStyles.headlineSmall,
                      ),
                      SizedBox(height: spacing.lg),
                      Text(
                        'A Whale Labs cria aplicativos que eliminam preocupações.',
                        style: context.textStyles.bodyLarge?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: spacing.md),
                      Text(
                        'NORT existe para trazer mais calma, clareza e direção para a vida financeira das pessoas.',
                        style: context.textStyles.bodyLarge?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Center(
                child: WhaleLabsSignature(
                  variant: WhaleLabsSignatureVariant.footer,
                ),
              ),
              SizedBox(height: spacing.md),
            ],
          ),
        ),
      ),
    );
  }
}