# Changelog — schematize-overdev-context

Todas as mudanças relevantes deste pacote, no formato [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
com versionamento [SemVer](https://semver.org/lang/pt-BR/).


## [0.3.0] — 2026-09-30

Pedido do dono, por **custo**: o agent principal (o que fala com o humano) não desenvolve —
planeja e despacha; a execução vai para micro-tasks baratas (`sonnet` por padrão), e `opus` só
entra depois que o Sonnet falhar. Regra canônica em `schematize-engineering` →
`references/orquestracao.md` §9.

### Adicionado
- **PLAN/CHECKLIST no tamanho de uma micro-task de Sonnet** (`references/plano-checklist.md`):
  cada item com entrada/saída/arquivo-alvo/prova; "decidir arquitetura" não é item — o desenho é
  do orquestrador na Fase 0.
- **Tag de executor por item do CHECKLIST:** `[sonnet]` (default) ou `[opus: <motivo>]` (só após
  escalada registrada), com exemplo de linha.
- **Briefing declara a execução** (`references/briefing.md`, `references/contexto.md`): o principal
  só despacha/revisa; escada sonnet → correção pelo mesmo subagent (≤2 rodadas) → re-decompor → opus.
- Piso "Orquestrador não desenvolve; subagent barato executa" em `SKILL.md`, `assets/CLAUDE.md` e
  `assets/commands/overdev-context-build.md`.

### Mantido (piso inalterado)
- Fundação antes do laço, decisão só se acordada, plano ancorado no grafo, checklist exaustivo por
  contagem, 2 níveis, rastreabilidade, saída em `.schematize/overdev/` + archive, MONTA-não-CONSOME;
  parar para perguntar segue VETADO.

## [0.2.1] — 2026-08-21
Saneamento do catálogo conforme a vistoria de 2026-08-21.

### Mudado
- `install.sh` regenerado do template único do catálogo: **exclui `*.zip`** do que é copiado para dentro da skill instalada, **poda o comando removido** (sem a poda, comando morto sobrevive para sempre na máquina de quem já instalou) e instala os hooks de `assets/hooks`/`scripts/hooks` em `.claude/hooks/`.

## [0.2.0] — 2026-08-18

Migração do layout operacional do projeto de `.overdev/` para `.schematize/overdev/`,
acompanhando a mudança do motor (que passou a ler `.schematize/overdev` com **fallback** ao
`.overdev` legado e **auto-migrar** no `schematize overdev start`).

### Alterado
- **Path dos artefatos da Fase 0.** `DECISOES.md`, `PLAN.md` e `CHECKLIST.md` agora são gravados
  em **`.schematize/overdev/`** (control-plane) — antes `.overdev/`. Todo texto normativo
  (SKILL.md, `assets/CLAUDE.md`, `assets/commands/*`, `references/*`) aponta pro novo path.
- **Marcador/dir operacional do projeto** passa a ser `.schematize/`; o grafo operacional vive em
  `.schematize/grafos/` (`GRAFO_GLOBAL.md` + por-serviço), com espelho em
  `<projeto>_archive/index/`.

### Compat
- `.overdev/` fica documentado como **layout LEGADO** aceito por compatibilidade: o motor lê o
  novo `.schematize/overdev` com fallback ao antigo e auto-migra no start. Nenhuma instrução ativa
  manda mais gravar em `.overdev/`.
- O **espelho durável** no archive continua `<projeto>_archive/overdev/` (não muda).

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
