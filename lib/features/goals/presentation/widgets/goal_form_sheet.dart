import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../shared/components/buttons/primary_button.dart';
import '../../../../shared/components/common/pressable_scale.dart';
import '../../../../shared/components/dialogs/bottom_sheet.dart';
import '../../../../shared/components/inputs/dropdown.dart';
import '../../../../shared/components/inputs/money_input.dart';
import '../../../../shared/components/inputs/text_input.dart';
import '../../../../shared/tokens/colors/nort_colors.dart';
import '../../domain/entities/goal.dart';
import '../providers/goals_providers.dart';

const int _maxImageBytes = 5 * 1024 * 1024;
const List<String> _allowedImageExtensions = ['jpg', 'jpeg', 'png', 'webp'];

String _statusLabel(GoalStatus status) {
  switch (status) {
    case GoalStatus.active:
      return 'Ativa';
    case GoalStatus.completed:
      return 'Concluída';
    case GoalStatus.archived:
      return 'Sonho';
  }
}

class GoalFormSheet extends ConsumerStatefulWidget {
  const GoalFormSheet({
    super.key,
    this.existingGoal,
    this.initialStatus = GoalStatus.active,
  });

  final Goal? existingGoal;
  final GoalStatus initialStatus;

  bool get isEditing => existingGoal != null;

  @override
  ConsumerState<GoalFormSheet> createState() => _GoalFormSheetState();
}

class _GoalFormSheetState extends ConsumerState<GoalFormSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _targetController;
  late final TextEditingController _currentController;
  late GoalStatus _status;
  DateTime? _targetDate;
  Uint8List? _pickedImageBytes;
  String? _pickedImageExtension;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final g = widget.existingGoal;
    _titleController = TextEditingController(text: g?.title ?? '');
    _targetController = TextEditingController(
      text: g != null ? g.targetAmount.toStringAsFixed(2) : '',
    );
    _currentController = TextEditingController(
      text: g != null ? g.currentAmount.toStringAsFixed(2) : '0',
    );
    _status = g?.status ?? widget.initialStatus;
    _targetDate = g?.targetDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    _currentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file == null) return;

    final extension = file.name.split('.').last.toLowerCase();
    if (!_allowedImageExtensions.contains(extension)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Formato não suportado — use JPG, PNG ou WEBP.')),
        );
      }
      return;
    }

    final bytes = await file.readAsBytes();
    if (bytes.lengthInBytes > _maxImageBytes) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Imagem muito grande — o limite é 5MB.')),
        );
      }
      return;
    }

    setState(() {
      _pickedImageBytes = bytes;
      _pickedImageExtension = extension;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 20),
    );
    if (picked != null) setState(() => _targetDate = picked);
  }

  double? _parseAmount(String text) {
    final normalized = text.trim().replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(normalized) ?? double.tryParse(text.trim());
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final targetAmount = _parseAmount(_targetController.text);
    final currentAmount = _parseAmount(_currentController.text) ?? 0;

    if (title.isEmpty) {
      setState(() => _error = 'Dê um nome pra sua meta.');
      return;
    }
    if (targetAmount == null || targetAmount <= 0) {
      setState(() => _error = 'Informe um valor de meta válido.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    final repository = ref.read(goalsRepositoryProvider);

    try {
      String goalId;

      if (widget.isEditing) {
        goalId = widget.existingGoal!.id;
        await repository.updateGoal(
          id: goalId,
          title: title,
          targetAmount: targetAmount,
          currentAmount: currentAmount,
          targetDate: _targetDate,
          status: _status,
        );
      } else {
        final created = await repository.createGoal(
          title: title,
          targetAmount: targetAmount,
          currentAmount: currentAmount,
          targetDate: _targetDate,
          status: _status,
        );
        goalId = created.id;
      }

      if (_pickedImageBytes != null && _pickedImageExtension != null) {
        await repository.uploadGoalImage(
          goalId: goalId,
          bytes: _pickedImageBytes!,
          fileExtension: _pickedImageExtension!,
        );
      }

      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      setState(() {
        _saving = false;
        _error = 'Não foi possível salvar. Tente de novo.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return NortBottomSheet(
      title: widget.isEditing ? 'Editar meta' : 'Nova meta',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PressableScale(
              onTap: _saving ? null : _pickImage,
              child: ClipRRect(
                borderRadius: radii.mdRadius,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  color: colors.brand.disabled,
                  alignment: Alignment.center,
                  child: _buildImagePreview(colors),
                ),
              ),
            ),
            SizedBox(height: spacing.lg),
            NortTextInput(
              label: 'Nome da meta',
              placeholder: 'Ex.: Viagem para o Japão',
              controller: _titleController,
              enabled: !_saving,
            ),
            SizedBox(height: spacing.md),
            Text('Valor da meta', style: context.textStyles.labelLarge),
            SizedBox(height: spacing.xs),
            MoneyInput(controller: _targetController, enabled: !_saving),
            SizedBox(height: spacing.md),
            Text('Já tenho guardado', style: context.textStyles.labelLarge),
            SizedBox(height: spacing.xs),
            MoneyInput(controller: _currentController, enabled: !_saving),
            SizedBox(height: spacing.md),
            PressableScale(
              onTap: _saving ? null : _pickDate,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: spacing.md, vertical: spacing.md),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: radii.smRadius,
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 18, color: colors.textSecondary),
                    SizedBox(width: spacing.sm),
                    Text(
                      _targetDate != null
                          ? '${_targetDate!.day.toString().padLeft(2, '0')}/${_targetDate!.month.toString().padLeft(2, '0')}/${_targetDate!.year}'
                          : 'Data alvo (opcional)',
                      style: context.textStyles.bodyLarge?.copyWith(
                        color: _targetDate != null
                            ? colors.textPrimary
                            : colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: spacing.md),
            Dropdown<GoalStatus>(
              label: 'Status',
              value: _status,
              items: GoalStatus.values,
              itemLabel: _statusLabel,
              onChanged: _saving
                  ? null
                  : (value) => setState(() => _status = value ?? _status),
            ),
            if (_error != null) ...[
              SizedBox(height: spacing.sm),
              Text(
                _error!,
                style: context.textStyles.bodySmall
                    ?.copyWith(color: colors.danger),
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: spacing.xl),
            PrimaryButton(
              label: 'Salvar',
              loading: _saving,
              onPressed: _saving ? null : _save,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(NortColors colors) {
    if (_pickedImageBytes != null) {
      return Image.memory(_pickedImageBytes!,
          fit: BoxFit.cover, width: double.infinity, height: 120);
    }
    if (widget.existingGoal?.imageUrl != null) {
      return Image.network(
        widget.existingGoal!.imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 120,
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.add_a_photo_outlined, color: colors.brand.defaultColor),
        const SizedBox(height: 4),
        Text('Adicionar foto', style: context.textStyles.labelMedium),
      ],
    );
  }
}
