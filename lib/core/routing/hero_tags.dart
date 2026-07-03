/// Tags de `Hero` compartilhadas entre telas — centralizadas para que
/// duas telas usando a mesma tag nunca "dessincronizem" por erro de
/// digitação de string solta.
abstract final class NortHeroTags {
  /// Usada pelo `BlueAvatar` na Home e no header do Chat — é o que
  /// produz a transição "a Blue atravessando telas" (ADR seção 8).
  static const blueAvatar = 'blue-avatar';
}
