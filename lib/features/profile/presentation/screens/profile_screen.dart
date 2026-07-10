import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../shared/components/avatars/user_avatar.dart';
import '../../../../shared/components/buttons/primary_button.dart';
import '../../../../shared/components/common/pressable_scale.dart';
import '../../../../shared/components/inputs/text_input.dart';
import '../../../../shared/components/layout/section_and_divider.dart';
import '../../../../shared/components/loading/loading_state.dart';
import '../../../../shared/components/navigation/navigation_tile.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/profile_providers.dart';

const int _maxAvatarBytes = 5 * 1024 * 1024;
const List<String> _allowedAvatarExtensions = ['jpg', 'jpeg', 'png', 'webp'];

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _editName(BuildContext context, WidgetRef ref, String currentName) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _EditNameDialog(initialName: currentName),
    );
  }

  Future<void> _pickAndUploadAvatar(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final picker = ImagePicker();

    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null) return;

    final extension = file.name.split('.').last.toLowerCase();
    if (!_allowedAvatarExtensions.contains(extension)) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Formato não suportado — use JPG, PNG ou WEBP.')),
      );
      return;
    }

    final bytes = await file.readAsBytes();
    if (bytes.lengthInBytes > _maxAvatarBytes) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Imagem muito grande — o limite é 5MB.')),
      );
      return;
    }

    messenger.showSnackBar(
      const SnackBar(content: Text('Enviando foto...'), duration: Duration(seconds: 2)),
    );

    try {
      await ref.read(profileRepositoryProvider).uploadAvatar(
            bytes: bytes,
            fileExtension: extension,
          );
      ref.invalidate(currentProfileProvider);
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Não foi possível enviar a imagem. Tente de novo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const NortTopAppBar(title: 'Perfil', showBackButton: true),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.lg,
            spacing.lg,
            spacing.xxxl,
          ),
          children: [
            profileAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: LoadingState(),
              ),
              error: (error, _) => Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.xxl),
                child: Column(
                  children: [
                    Text(
                      'Não foi possível carregar seu perfil.',
                      textAlign: TextAlign.center,
                      style: context.textStyles.bodyMedium,
                    ),
                    SizedBox(height: spacing.md),
                    PrimaryButton(
                      label: 'Tentar de novo',
                      fullWidth: false,
                      onPressed: () => ref.invalidate(currentProfileProvider),
                    ),
                  ],
                ),
              ),
              data: (profile) => _ProfileHeader(
                profile: profile,
                onTapAvatar: () => _pickAndUploadAvatar(context, ref),
                onTapEditName: () => _editName(
                  context,
                  ref,
                  profile?.displayNameOrFallback ?? '',
                ),
              ),
            ),
            SizedBox(height: spacing.xxl),
            NavigationTile(
              icon: Icons.settings_outlined,
              title: 'Configurações',
              onTap: () => context.push(AppRoutes.settings),
            ),
            const NortDivider(),
            NavigationTile(
              icon: Icons.help_outline,
              title: 'Ajuda',
              onTap: () {},
            ),
            const NortDivider(),
            NavigationTile(
              icon: Icons.logout,
              title: 'Sair',
              onTap: () async {
                await ref.read(authServiceProvider).signOut();
                if (context.mounted) context.go(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.profile,
    required this.onTapAvatar,
    required this.onTapEditName,
  });

  final UserProfile? profile;
  final VoidCallback onTapAvatar;
  final VoidCallback onTapEditName;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final name = profile?.displayNameOrFallback ?? 'Você';
    final email = profile?.email ?? '';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final avatarUrl = profile?.avatarUrl;

    return Center(
      child: Column(
        children: [
          PressableScale(
            onTap: onTapAvatar,
            child: Stack(
              children: [
                avatarUrl != null
                    ? UserAvatar(
                        size: 72,
                        imageBuilder: (context) => Image.network(avatarUrl, fit: BoxFit.cover),
                      )
                    : UserAvatar(initials: initials, size: 72),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: colors.brand.defaultColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.background, width: 2),
                    ),
                    child: Icon(Icons.camera_alt, size: 12, color: colors.textOnBrand),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: spacing.md),
          PressableScale(
            onTap: onTapEditName,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name, style: context.textStyles.titleLarge),
                SizedBox(width: spacing.xs),
                Icon(Icons.edit_outlined, size: 16, color: colors.textTertiary),
              ],
            ),
          ),
          SizedBox(height: spacing.xs / 2),
          Text(email, style: context.textStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _EditNameDialog extends ConsumerStatefulWidget {
  const _EditNameDialog({required this.initialName});

  final String initialName;

  @override
  ConsumerState<_EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends ConsumerState<_EditNameDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialName);
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final newName = _controller.text.trim();
    if (newName.isEmpty) {
      setState(() => _error = 'O nome não pode ficar vazio.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await ref.read(profileRepositoryProvider).updateDisplayName(newName);
      ref.invalidate(currentProfileProvider);
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

    return Dialog(
      backgroundColor: colors.surfaceElevated,
      shape: RoundedRectangleBorder(borderRadius: radii.xlRadius),
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Editar nome', style: context.textStyles.headlineSmall),
            SizedBox(height: spacing.lg),
            NortTextInput(
              label: 'Nome',
              controller: _controller,
              errorText: _error,
              enabled: !_saving,
            ),
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
}