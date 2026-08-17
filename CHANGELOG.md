# Changelog — schematize-overdev-context

Formato: [Keep a Changelog](https://keepachangelog.com/pt-BR/). Versionamento semântico.

## [0.1.0] — 2026-08-16

Primeira versão da skill de **montagem do contexto geral do overdev** da casa — a Fase 0 /
fundação, extraída da `schematize-engineering` (reference `overdev.md` §0) pra rodar solta e
agnóstica de linguagem. É a skill que **monta** o briefing que o `/eng-overdev` + o motor
`schematize overdev start` **consomem** antes do laço.

### Adicionado
- **SKILL.md** com 8 pisos inegociáveis (fundação antes do laço; decisão só entra se acordada e
  com origem; plano ancorado no grafo real; checklist exaustivo por contagem; convenção de 2
  níveis `- [ ]`/`- [H ]`/`- [~]`; rastreabilidade decisão→item→nó; saída durável no
  archive + control-plane `.overdev/`; esta skill MONTA, não CONSOME) + mapa de references +
  relação com engineering/audit.
- **references/**:
  - `contexto.md` — o **método completo**: as 5 etapas (decisões → grafo → plano → checklist →
    briefing), o gate da Fase 0, o que a skill NÃO faz (não tickeia), quando rodar.
  - `decisoes.md` — etapa 1 a fundo: varredura da sessão/repo, o que conta como decisão
    **acordada** (vs abandonada/ambígua), o formato **ADR-lite**, o mapa decisão→item, onde gravar.
  - `plano-checklist.md` — etapas 3+4: anatomia do **PLAN pesado** (escopo entra/NÃO-entra,
    decomposição verificável ancorada no grafo, ordem topológica, paralelismo, riscos, DoD) e a
    **derivação do CHECKLIST** exaustivo por contagem, com a **convenção de 2 níveis** detalhada.
  - `briefing.md` — etapa 5: anatomia do **DOCUMENTO DE CONTEXTO GERAL** (objetivo, decisões,
    grafo, plano, checklist, riscos, DoD), onde grava e como o `/eng-overdev` + o painel consomem.
- **assets/commands/**: `/overdev-context-help`, `/overdev-context-build` (a montagem em si),
  `/overdev-context-load`, `/overdev-context-claude`, `/overdev-context-cc`,
  `/overdev-context-handoff`.
- **assets/CLAUDE.md** — regra sempre-on: fundação antes do laço; decisão só se acordada;
  checklist exaustivo na convenção de 2 níveis; a skill monta, o `/eng-overdev` consome.
