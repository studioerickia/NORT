# Calm UI — Diretrizes de Componente (NORT)

Regra adicionada antes da Etapa 3 (Component Library). Vale para **todo**
componente em `shared/components/`, sem exceção. Em caso de dúvida entre
"mais expressivo" e "mais calmo", vence o mais calmo.

## O que "Calm UI" significa em código, não em sentimento

| Princípio | Regra concreta |
|---|---|
| **Sombra é exceção, não padrão** | Todo componente nasce com `context.shadows.none` ou `.low`. `.medium`/`.high` só em elementos genuinamente flutuantes (FAB, sheet abrindo) — nunca em card de conteúdo em repouso. |
| **Borda é exceção, não padrão** | Separação entre elementos vem de espaço em branco (`context.spacing`) e diferença sutil de `surface`, não de `Border`. Uma borda só aparece quando não há outra forma de indicar limite (ex.: input em foco). |
| **Radius sempre generoso** | Cards nunca usam `context.radii.sm` — mínimo `md` (16), preferencialmente `lg`/`xl` (20–24). `sm` é reservado só para botão/input/chip. |
| **Um ponto focal por componente** | Cada componente comunica **uma coisa** com clareza (um valor, uma ação, um estado) — não empilha 3 informações de mesmo peso visual competindo entre si. |
| **Espaço em branco é o elemento visual principal** | Padding interno mínimo de `context.spacing.lg` (16) em componentes de conteúdo, `context.spacing.xl` (24) em cards de destaque. Nunca comprimir para caber mais informação — cortar informação é preferível a comprimir espaço. |
| **Hierarquia por peso tipográfico e cor, não por decoração** | Diferenciar "principal" de "secundário" via `textPrimary`/`textSecondary` e `titleMedium`/`bodyMedium` — nunca via caixa de cor de fundo, ícone extra ou borda colorida "para chamar atenção". |
| **Cor com função, nunca decoração** | Se uma cor não estiver comunicando estado (positivo/atenção/marca), ela é neutra. Nada de cor "para dar vida" ao componente. |
| **Motion sutil e opcional, nunca chamativo** | Quando um componente anima, usa `context.motion.micro`/`standard` com `enter`/`exit` — nunca desenha atenção para si mesmo com o movimento. |

## Reutilização e independência

- Todo componente de `shared/components/` é **dumb**: recebe dados via
  construtor, emite eventos via `callback`, nunca lê Riverpod/provider
  diretamente e nunca importa nada de `features/`.
- Nenhum componente assume largura fixa — sempre responsivo ao pai
  (ver `core/extensions` de breakpoint, já preparado na Etapa 1).
- Todo componente já nasce com estado de `loading` e `empty` previstos
  na API (mesmo que hoje só o estado "preenchido" seja usado de fato),
  para não exigir refatoração de assinatura na Sprint de dados reais.

## Referência de atmosfera

A imagem de referência enviada por você (fundo quase-branco, um card
por vez, muito ar entre elementos, sombra imperceptível, um único
elemento de cor por tela) é o padrão de comparação para qualquer
componente novo: **se um componente do NORT, colocado ao lado dela,
parecer "mais carregado", ele está errado.**
