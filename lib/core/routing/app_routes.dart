/// Paths de rota do NORT (ADR seção 10).
///
/// Fonte única de verdade — nenhuma tela ou botão deve escrever uma
/// string de rota "na mão"; sempre referenciar `AppRoutes.x`. Isso é
/// o que permite trocar um path (ex.: `/goals` → `/metas` para uma
/// futura localização de URL) em um único lugar.
///
/// Paths já são compatíveis com deep link — o GoRouter resolve
/// `https://nort.app/goals` ou `nort://goals` para a mesma rota sem
/// configuração adicional aqui; o que falta é só o registro nativo do
/// esquema/domínio (`AndroidManifest.xml` / `Info.plist`), que é
/// configuração de plataforma, fora do escopo desta etapa.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';

  // Abas dentro do ShellRoute (bottom navigation)
  static const home = '/home';
  static const transactions = '/transactions';
  static const goals = '/goals';
  static const lifeOs = '/life-os';

  // Rotas de tela cheia, fora do Shell (empilhadas por cima)
  static const chat = '/chat';
  static const profile = '/profile';
  static const settings = '/settings';
}
