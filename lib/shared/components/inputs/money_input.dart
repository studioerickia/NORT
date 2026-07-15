import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Campo de valor monetário — usa `NortNumericStyles` (tabular) para
/// o próprio texto digitado, já que é, por definição, um número
/// financeiro.
///
/// **Sem lógica de formatação/máscara de moeda nesta etapa** — isso é
/// regra de negócio (cálculo financeiro), fora do escopo da Sprint 0.
/// O componente só define a *aparência* do campo; a feature que o
/// usa é responsável por formatar/validar quando essa lógica existir.
///
/// Exemplo:
/// ```dart
/// MoneyInput(currencyPrefix: 'R\$', controller: controller)
/// ```
class MoneyInput extends StatefulWidget {
  const MoneyInput({
    super.key,
    this.currencyPrefix = 'R\$',
    this.controller,
    this.enabled = true,
    this.onChanged,
  });

  final String currencyPrefix;
  final TextEditingController? controller;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  State<MoneyInput> createState() => _MoneyInputState();
}

class _MoneyInputState extends State<MoneyInput> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode
        .addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return AnimatedContainer(
      duration: context.motion.micro,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: radii.smRadius,
        border: Border.all(
          color: _focused ? colors.brand.defaultColor : Colors.transparent,
          width: 1.5,
        ),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm),
      child: Row(
        children: [
          Text(widget.currencyPrefix, style: context.numericStyles.medium),
          SizedBox(width: spacing.xs),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: widget.onChanged,
              style: context.numericStyles.medium,
              cursorColor: colors.brand.defaultColor,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
