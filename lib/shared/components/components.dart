/// Barrel da Component Library do NORT — importar só este arquivo em
/// vez de cada componente individualmente.
///
/// Não inclui os componentes da Blue (`BlueAvatar`, `BlueGlow` etc.)
/// — eles vivem em `lib/blue/presentation/`, uma camada separada por
/// decisão de arquitetura (ver ADR seção 13, regra 4). Importe-os
/// diretamente de lá quando precisar.
///
/// Todo componente aqui consome tokens exclusivamente via
/// `context.colors` / `context.spacing` / `context.radii` /
/// `context.shadows` / `context.motion` / `context.numericStyles`
/// (ver `core/extensions/nort_theme_context_x.dart`) e segue as
/// diretrizes de `CALM_UI_GUIDELINES.md`.
library;

// Animations
export 'animations/fade_scale_in.dart';

// Avatars
export 'avatars/avatar_stack.dart';
export 'avatars/user_avatar.dart';

// Badges & Tags
export 'badges_tags/badges.dart';
export 'badges_tags/tag_pill_chip.dart';

// Bottom bar
export 'bottom_bar/bottom_nav_bar.dart';

// Buttons
export 'buttons/fab.dart';
export 'buttons/nort_icon_button.dart';
export 'buttons/nort_text_button.dart';
export 'buttons/primary_button.dart';
export 'buttons/secondary_button.dart';

// Cards
export 'cards/base_card.dart';
export 'cards/goal_card.dart';
export 'cards/info_card.dart';
export 'cards/metric_card.dart';
export 'cards/notification_card.dart';
export 'cards/status_card.dart';
export 'cards/summary_card.dart';

// Chat
export 'chat_bubble/blue_message_bubble.dart';
export 'chat_bubble/suggestion_chip.dart';
export 'chat_bubble/timestamp_and_status.dart';
export 'chat_bubble/typing_indicator.dart';
export 'chat_bubble/user_message_bubble.dart';

// Dialogs
export 'dialogs/alert_dialog.dart';
export 'dialogs/bottom_sheet.dart';
export 'dialogs/confirmation_dialog.dart';
export 'dialogs/modal_card.dart';

// Empty / Error / Offline states
export 'empty_states/empty_error_offline_states.dart';

// Inputs
export 'inputs/chat_input.dart';
export 'inputs/dropdown.dart';
export 'inputs/money_input.dart';
export 'inputs/search_input.dart';
export 'inputs/selection_controls.dart';
export 'inputs/text_input.dart';

// Layout
export 'layout/list_tile.dart';
export 'layout/section_and_divider.dart';
export 'layout/statistic_row.dart';
export 'layout/timeline_item.dart';

// Loading
export 'loading/loading_state.dart';

// Navigation
export 'navigation/navigation_tile.dart';
export 'navigation/section_header.dart';
export 'navigation/tab_bar.dart';
export 'navigation/top_app_bar.dart';

// Progress
export 'progress/circular_progress.dart';
export 'progress/goal_progress_and_percentage.dart';
export 'progress/progress_bar.dart';

// Skeleton
export 'skeleton/skeleton.dart';
