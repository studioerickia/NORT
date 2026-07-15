import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/animations/fade_scale_in.dart';
import '../../../../shared/components/buttons/nort_icon_button.dart';
import '../../../../shared/components/common/pressable_scale.dart';
import '../../../../shared/components/empty_states/empty_error_offline_states.dart';
import '../../../../shared/components/inputs/search_input.dart';
import '../../../../shared/components/layout/section_and_divider.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transactions_providers.dart';
import '../widgets/transaction_form_sheet.dart';
import '../widgets/transaction_list_tile_skeleton.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  void _openCreateForm(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const TransactionFormSheet(),
    );
  }

  void _openEditForm(BuildContext context, Transaction transaction) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => TransactionFormSheet(existingTransaction: transaction),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    final categoryById = <String, Category>{
      for (final c in categoriesAsync.valueOrNull ?? const <Category>[])
        c.id: c,
    };

    return Scaffold(
      backgroundColor: colors.background,
      appBar: NortTopAppBar(
        title: 'Transações',
        trailing: [
          NortIconButton(
              icon: Icons.add, onPressed: () => _openCreateForm(context)),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.md,
            spacing.lg,
            spacing.xxxl,
          ),
          children: [
            FadeScaleIn(
              child: Text(
                'Aqui você acompanha, sem julgamento.',
                style: context.textStyles.bodyLarge?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
            SizedBox(height: spacing.lg),
            const SearchInput(placeholder: 'Buscar transação...'),
            SizedBox(height: spacing.xl),
            transactionsAsync.when(
              loading: () => Column(
                children:
                    List.generate(4, (_) => const TransactionRowSkeleton()),
              ),
              error: (error, _) => Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.xl),
                child: ErrorState(
                  onAction: () => ref.invalidate(transactionsStreamProvider),
                ),
              ),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: spacing.xxl),
                    child: EmptyState(
                      icon: Icons.receipt_long_outlined,
                      title: 'Nenhuma transação ainda',
                      description: 'Suas transações vão aparecer aqui.',
                      actionLabel: 'Adicionar transação',
                      onAction: () => _openCreateForm(context),
                    ),
                  );
                }

                final groups = _groupByDay(transactions);

                return Column(
                  children: [
                    for (final group in groups)
                      _DayGroup(
                        date: group.key,
                        transactions: group.value,
                        categoryById: categoryById,
                        onTapTransaction: (t) => _openEditForm(context, t),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<MapEntry<DateTime, List<Transaction>>> _groupByDay(
      List<Transaction> transactions) {
    final map = <DateTime, List<Transaction>>{};
    for (final t in transactions) {
      final key =
          DateTime(t.occurredAt.year, t.occurredAt.month, t.occurredAt.day);
      map.putIfAbsent(key, () => []).add(t);
    }
    final entries = map.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    return entries;
  }
}

class _DayGroup extends StatelessWidget {
  const _DayGroup({
    required this.date,
    required this.transactions,
    required this.categoryById,
    required this.onTapTransaction,
  });

  final DateTime date;
  final List<Transaction> transactions;
  final Map<String, Category> categoryById;
  final ValueChanged<Transaction> onTapTransaction;

  String get _dayLabel {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = today.difference(date).inDays;
    if (diff == 0) return 'Hoje';
    if (diff == 1) return 'Ontem';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }

  String get _countLabel {
    return transactions.length == 1
        ? '1 transação'
        : '${transactions.length} transações';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Section(
      header: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(_dayLabel, style: context.textStyles.titleMedium),
          SizedBox(width: spacing.xs),
          Text(
            '· $_countLabel',
            style: context.textStyles.bodySmall
                ?.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < transactions.length; i++) ...[
            _TransactionRow(
              transaction: transactions[i],
              category: transactions[i].categoryId != null
                  ? categoryById[transactions[i].categoryId]
                  : null,
              onTap: () => onTapTransaction(transactions[i]),
            ),
            if (i != transactions.length - 1) const NortDivider(),
          ],
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({
    required this.transaction,
    required this.category,
    required this.onTap,
  });

  final Transaction transaction;
  final Category? category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final isIncome = transaction.type == TransactionType.income;

    final title = (transaction.description?.isNotEmpty ?? false)
        ? transaction.description!
        : (category?.name ?? 'Transação');

    final time = '${transaction.occurredAt.hour.toString().padLeft(2, '0')}:'
        '${transaction.occurredAt.minute.toString().padLeft(2, '0')}';

    return PressableScale(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.sm + 2),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration:
                  BoxDecoration(color: colors.surface, shape: BoxShape.circle),
              child: Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                size: 16,
                color: colors.textSecondary,
              ),
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textStyles.titleSmall),
                  Text(time, style: context.textStyles.bodySmall),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : ''}${formatCurrencyBRL(transaction.amount)}',
              style: context.numericStyles.small.copyWith(
                color: isIncome
                    ? colors.positive.defaultColor
                    : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
