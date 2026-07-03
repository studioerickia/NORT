import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Campo de texto padrão do NORT — sem borda em repouso, borda sutil
/// só em foco/erro (Calm UI: "borda é exceção").
///
/// Exemplo:
/// ```dart
/// NortTextInput(label: 'Nome', controller: controller)
/// ```
class NortTextInput extends StatefulWidget {
  const NortTextInput({
    super.key,
    this.label,
    this.placeholder,
    this.controller,
    this.errorText,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.onChanged,
  });

  final String? label;
  final String? placeholder;
  final TextEditingController? controller;
  final String? errorText;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;

  @override
  State<NortTextInput> createState() => _NortTextInputState();
}

class _NortTextInputState extends State<NortTextInput> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
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
    final hasError = widget.errorText != null;

    final borderColor = hasError
        ? colors.danger
        : (_focused ? colors.brand.defaultColor : Colors.transparent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: context.textStyles.labelLarge),
          SizedBox(height: spacing.xs),
        ],
        AnimatedContainer(
          duration: context.motion.micro,
          decoration: BoxDecoration(
            color: widget.enabled ? colors.surface : colors.surface.withOpacity(0.6),
            borderRadius: radii.smRadius,
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            style: context.textStyles.bodyLarge,
            cursorColor: colors.brand.defaultColor,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: context.textStyles.bodyLarge?.copyWith(color: colors.textTertiary),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, size: 20, color: colors.textSecondary)
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.md,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          SizedBox(height: spacing.xs),
          Text(
            widget.errorText!,
            style: context.textStyles.bodySmall?.copyWith(color: colors.danger),
          ),
        ],
      ],
    );
  }
}
