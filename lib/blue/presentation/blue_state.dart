/// Estados visuais da Blue (ADR seção 9).
///
/// Puramente de apresentação — não tem relação com `blue/domain/brain`
/// ainda (que decide *quando* mudar de estado; isso é trabalho de
/// etapas futuras). Aqui só definimos os estados que `BlueAvatar`
/// sabe desenhar.
enum BlueState {
  idle,
  listening,
  thinking,
  speaking,
  celebrating,
  concerned,
}
