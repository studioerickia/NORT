import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/buttons/nort_text_button.dart';
import '../../../../shared/components/buttons/secondary_button.dart';
import '../../../../shared/components/dialogs/bottom_sheet.dart';
import '../../../../shared/components/dialogs/confirmation_dialog.dart';
import '../../../../shared/components/layout/statistic_row.dart';
import '../../domain/entities/goal.dart';
import '../providers/goals_providers.dart';
import 'goal_form_sheet.dart';

class GoalDetailSheet extends ConsumerWidget {
  const GoalDetailSheet({super.key, required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;

    return NortBottomSheet(
      title: goal.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatisticRow(
            label: 'Guardado',
            value: formatCurrencyBRL(goal.currentAmount),
            valueIsNumeric: true,
          ),
          StatisticRow(
            label: 'Meta',
            value: formatCurrencyBRL(goal.targetAmount),
            valueIsNumeric: true,
          ),
          if (goal.targetDate != null)
            StatisticRow(label: 'Data alvo', value: formatMonthYear(goal.targetDate!)),
          SizedBox(height: spacing.lg),
          SecondaryButton(
            label: 'Editar',
            onPressed: () {
              Navigator.of(context).pop();
              showModalBottomSheet<void>(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => GoalFormSheet(existingGoal: goal),
              );
            },
          ),
          SizedBox(height: spacing.sm),
          Center(
            child: NortTextButton(
              label: 'Excluir meta',
              onPressed: () => _confirmDelete(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const ConfirmationDialog(
        title: 'Excluir meta?',
        message: 'Ela fica guardada por 30 dias antes de ser removida de vez — dá pra restaurar até lá.',
        confirmLabel: 'Excluir',
      ),
    );

    if (confirmed == true) {
      await ref.read(goalsRepositoryProvider).softDeleteGoal(goal.id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}