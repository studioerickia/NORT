import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../shared/components/buttons/nort_text_button.dart';
import '../../../../shared/components/dialogs/bottom_sheet.dart';
import '../../../../shared/components/empty_states/empty_error_offline_states.dart';
import '../../../../shared/components/layout/list_tile.dart';
import '../../../../shared/components/layout/section_and_divider.dart';
import '../../../../shared/components/loading/loading_state.dart';
import '../providers/goals_providers.dart';

class TrashSheet extends ConsumerWidget {
  const TrashSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final deletedAsync = ref.watch(deletedGoalsProvider);

    return NortBottomSheet(
      title: 'Lixeira',
      child: deletedAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: LoadingState(),
        ),
        error: (_, __) => Padding(
          padding: EdgeInsets.symmetric(vertical: spacing.lg),
          child: Text(
            'Não foi possível carregar a lixeira.',
            textAlign: TextAlign.center,
            style: context.textStyles.bodyMedium,
          ),
        ),
        data: (goals) {
          if (goals.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: EmptyState(
                icon: Icons.delete_outline,
                title: 'Lixeira vazia',
                description: 'Metas excluídas ficam aqui por 30 dias.',
              ),
            );
          }

          return Column(
            children: [
              for (int i = 0; i < goals.length; i++) ...[
                NortListTile(
                  title: goals[i].title,
                  subtitle: 'Restaura em até 30 dias',
                  trailing: NortTextButton(
                    label: 'Restaurar',
                    onPressed: () async {
                      await ref
                          .read(goalsRepositoryProvider)
                          .restoreGoal(goals[i].id);
                      ref.invalidate(deletedGoalsProvider);
                    },
                  ),
                ),
                if (i != goals.length - 1) const NortDivider(),
              ],
            ],
          );
        },
      ),
    );
  }
}
