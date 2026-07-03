import 'package:flutter/material.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../shared/components/empty_states/empty_error_offline_states.dart';
import '../../../../shared/components/inputs/search_input.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';

/// Tela de Transações — placeholder navegável. Estado vazio por
/// padrão nesta sprint (nenhum dado real ainda).
class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const NortTopAppBar(title: 'Transações'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            children: [
              const SearchInput(placeholder: 'Buscar transação...'),
              SizedBox(height: spacing.xl),
              const Expanded(
                child: EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'Nenhuma transação ainda',
                  description: 'Suas transações vão aparecer aqui.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
