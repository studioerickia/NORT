import 'package:flutter/material.dart';

import '../../blue/presentation/blue_avatar.dart';
import '../../blue/presentation/blue_state.dart';
import '../../core/extensions/nort_theme_context_x.dart';
import '../components/components.dart';

/// Catálogo interno de componentes — "Storybook" do NORT.
///
/// Não é uma feature de produto (por isso mora em
/// `shared/component_preview/`, não em `features/`) — é ferramenta de
/// desenvolvimento, para validar visualmente cada componente da
/// Component Library sem precisar montar uma tela real.
///
/// Uso local: `flutter run -t lib/main_preview.dart`.
class ComponentPreviewScreen extends StatefulWidget {
  const ComponentPreviewScreen({super.key});

  @override
  State<ComponentPreviewScreen> createState() => _ComponentPreviewScreenState();
}

class _ComponentPreviewScreenState extends State<ComponentPreviewScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _chatController = TextEditingController();
  bool _switchValue = true;
  bool _checkboxValue = false;
  String? _radioValue = 'a';
  String? _dropdownValue = 'Alimentação';
  int _navIndex = 0;
  int _tabIndex = 0;

  @override
  void dispose() {
    _textController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Scaffold(
      appBar: AppBar(title: const Text('NORT — Component Catalog')),
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          _CatalogSection(
            title: 'Botões',
            children: [
              PrimaryButton(label: 'Continuar', onPressed: () {}),
              SizedBox(height: spacing.sm),
              const PrimaryButton(label: 'Desabilitado', onPressed: null),
              SizedBox(height: spacing.sm),
              const PrimaryButton(
                  label: 'Salvando...', loading: true, onPressed: null),
              SizedBox(height: spacing.sm),
              SecondaryButton(label: 'Ver detalhes', onPressed: () {}),
              SizedBox(height: spacing.sm),
              NortTextButton(label: 'Pular', onPressed: () {}),
              SizedBox(height: spacing.sm),
              Row(
                children: [
                  NortIconButton(
                      icon: Icons.notifications_outlined, onPressed: () {}),
                  SizedBox(width: spacing.md),
                  NortFab(onPressed: () {}),
                ],
              ),
            ],
          ),
          _CatalogSection(
            title: 'Cards',
            children: [
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      icon: Icons.savings_outlined,
                      value: 'R\$2.620',
                      label: 'Saldo disponível',
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: SummaryCard(
                      icon: Icons.check_circle_outline,
                      value: '2',
                      label: 'Metas ativas',
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.md),
              GoalCard(
                title: 'Viagem para o Japão',
                currentAmountLabel: 'R\$8.450',
                targetAmountLabel: 'R\$15.000',
                progress: 0.56,
                dateLabel: 'Conclusão: Dez 2025',
              ),
              SizedBox(height: spacing.md),
              InfoCard(
                title: 'Insights da Blue',
                description: 'Sua vida está em harmonia.',
                actionLabel: 'Explorar áreas',
                onAction: () {},
              ),
              SizedBox(height: spacing.md),
              const StatusCard(
                tone: NortStatusTone.positive,
                title: 'Tudo certo',
                description: 'Sem alertas',
              ),
              SizedBox(height: spacing.md),
              const MetricCard(
                title: 'Gastos desta semana',
                value: 'R\$620 de R\$1.400',
                deltaLabel: '44%',
                deltaPositive: false,
              ),
              SizedBox(height: spacing.md),
              NotificationCard(
                title: 'Meta quase lá!',
                description: 'Sua reserva de emergência está em 62%.',
                timeLabel: '2h atrás',
                unread: true,
                onTap: () {},
              ),
            ],
          ),
          _CatalogSection(
            title: 'Chat',
            children: [
              UserMessageBubble(
                text: 'Posso comprar esse tênis de R\$899?',
                time: '09:41',
                status: NortMessageDeliveryStatus.read,
              ),
              SizedBox(height: spacing.sm),
              BlueMessageBubble(
                text: 'Essa compra cabe, mas reduziria seu limite diário.',
                time: '09:41',
                avatar: const BlueAvatar(
                    state: BlueState.idle, size: 28, showGlow: false),
              ),
              SizedBox(height: spacing.sm),
              const Align(
                  alignment: Alignment.centerLeft, child: TypingIndicator()),
              SizedBox(height: spacing.sm),
              Wrap(
                spacing: spacing.sm,
                children: [
                  SuggestionChip(
                      label: 'Quais são minhas prioridades?', onTap: () {}),
                  SuggestionChip(
                      label: 'Como estou esta semana?', onTap: () {}),
                ],
              ),
            ],
          ),
          _CatalogSection(
            title: 'Blue',
            children: [
              Wrap(
                spacing: spacing.lg,
                runSpacing: spacing.lg,
                children: const [
                  BlueAvatar(state: BlueState.idle, size: 80),
                  BlueAvatar(state: BlueState.thinking, size: 80),
                  BlueAvatar(state: BlueState.listening, size: 80),
                  BlueAvatar(state: BlueState.celebrating, size: 80),
                  BlueAvatar(state: BlueState.concerned, size: 80),
                ],
              ),
            ],
          ),
          _CatalogSection(
            title: 'Inputs',
            children: [
              NortTextInput(
                  label: 'Nome',
                  placeholder: 'Digite seu nome',
                  controller: _textController),
              SizedBox(height: spacing.md),
              const SearchInput(),
              SizedBox(height: spacing.md),
              const MoneyInput(),
              SizedBox(height: spacing.md),
              ChatInput(
                  controller: _chatController, hasText: false, onMicTap: () {}),
              SizedBox(height: spacing.md),
              Dropdown<String>(
                label: 'Categoria',
                value: _dropdownValue,
                items: const ['Alimentação', 'Transporte', 'Lazer'],
                itemLabel: (v) => v,
                onChanged: (v) => setState(() => _dropdownValue = v),
              ),
              SizedBox(height: spacing.md),
              Row(
                children: [
                  NortSwitch(
                      value: _switchValue,
                      onChanged: (v) => setState(() => _switchValue = v)),
                  NortCheckbox(
                      value: _checkboxValue,
                      onChanged: (v) =>
                          setState(() => _checkboxValue = v ?? false)),
                  NortRadio<String>(
                      value: 'a',
                      groupValue: _radioValue,
                      onChanged: (v) => setState(() => _radioValue = v)),
                  NortRadio<String>(
                      value: 'b',
                      groupValue: _radioValue,
                      onChanged: (v) => setState(() => _radioValue = v)),
                ],
              ),
            ],
          ),
          _CatalogSection(
            title: 'Navegação',
            children: [
              NavigationTile(
                  icon: Icons.person_outline,
                  title: 'Perfil',
                  subtitle: 'Editar informações',
                  onTap: () {}),
              const NortDivider(),
              SectionHeader(
                  title: 'Resumo do dia',
                  actionLabel: 'Ver tudo',
                  onAction: () {}),
              SizedBox(height: spacing.md),
              NortTabBar(
                tabs: const ['Ativas', 'Concluídas', 'Sonhos'],
                selectedIndex: _tabIndex,
                onChanged: (i) => setState(() => _tabIndex = i),
              ),
              SizedBox(height: spacing.md),
              NortBottomNavBar(
                items: const [
                  NortNavItem(icon: Icons.home_outlined, label: 'Início'),
                  NortNavItem(icon: Icons.swap_horiz, label: 'Transações'),
                  NortNavItem(icon: Icons.check_circle_outline, label: 'Metas'),
                  NortNavItem(icon: Icons.grid_view_outlined, label: 'Life OS'),
                ],
                currentIndex: _navIndex,
                onTap: (i) => setState(() => _navIndex = i),
                onFabTap: () {},
              ),
            ],
          ),
          _CatalogSection(
            title: 'Estados',
            children: [
              const SizedBox(height: 120, child: LoadingState()),
              SizedBox(height: spacing.md),
              const SizedBox(
                height: 160,
                child: EmptyState(
                    icon: Icons.flag_outlined,
                    title: 'Nova meta',
                    description: 'Comece a construir seu próximo sonho.'),
              ),
              SizedBox(height: spacing.md),
              Column(
                children: [
                  NortSkeleton(width: double.infinity, height: 16),
                  SizedBox(height: spacing.xs),
                  const NortSkeleton(width: 180, height: 16),
                ],
              ),
            ],
          ),
          _CatalogSection(
            title: 'Progress',
            children: [
              const NortProgressBar(progress: 0.56),
              SizedBox(height: spacing.md),
              Row(
                children: const [
                  NortCircularProgress(progress: 0.62, centerLabel: '62%'),
                  SizedBox(width: 16),
                  PercentageBadge(value: 0.44, positive: false),
                ],
              ),
              SizedBox(height: spacing.md),
              const GoalProgress(
                currentAmountLabel: 'R\$8.450',
                targetAmountLabel: 'R\$15.000',
                progress: 0.56,
              ),
            ],
          ),
          _CatalogSection(
            title: 'Badges',
            children: [
              Wrap(
                spacing: spacing.sm,
                children: const [
                  SuccessBadge(label: 'Meta concluída'),
                  WarningBadge(label: 'Perto do limite'),
                  InfoBadge(label: 'Novo'),
                  NeutralBadge(label: 'Categoria'),
                ],
              ),
            ],
          ),
          _CatalogSection(
            title: 'Widgets reutilizáveis',
            children: [
              const Tag(label: 'Alimentação'),
              SizedBox(height: spacing.sm),
              const Pill(label: 'Concluída'),
              SizedBox(height: spacing.sm),
              NortChip(label: 'Últimos 7 dias', selected: true, onTap: () {}),
              SizedBox(height: spacing.md),
              AvatarStack(avatars: const [
                UserAvatar(initials: 'EM'),
                UserAvatar(initials: 'JS'),
                UserAvatar(initials: 'AB'),
              ]),
              SizedBox(height: spacing.md),
              const StatisticRow(label: 'Categoria', value: 'Alimentação'),
              const TimelineItem(
                  dateLabel: 'Mar 2026',
                  title: 'Mudança de cidade',
                  isLast: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _CatalogSection extends StatelessWidget {
  const _CatalogSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Section(
      header: Text(title, style: context.textStyles.headlineSmall),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}
