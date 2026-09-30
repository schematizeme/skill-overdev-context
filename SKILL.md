---
name: schematize-overdev-context
metadata:
  version: 0.3.0
description: O montador de CONTEXTO GERAL de um overdev — a Fase 0, extraída da schematize-engineering para rodar solta e agnóstica de linguagem. Monta o briefing que o `/eng-overdev` (e o motor `schematize overdev start`) CONSOME antes do laço, em cinco passos: (1) varre a sessão/o repo e extrai as DECISÕES acordadas (decisão · motivo · alternativa descartada · origem) → `DECISOES.md`; (2) ANCORA no grafo do índice (MAPA + adjacência `A -> B`) — sem índice, gerá-lo é o 1º item; (3) produz um PLAN PESADO (escopo entra/NÃO-entra, itens verificáveis com nó do grafo, prova, dependências, risco, ordem topológica, paralelismo, DoD) → `PLAN.md`; (4) DERIVA o CHECKLIST exaustivo por contagem, nas 3 classes `- [ ]` máquina · `- [H ]` humano · `- [~]` on-hold → `CHECKLIST.md`; (5) entrega o documento de contexto. NÃO tickeia item nem entra no laço — só FUNDA. Use SEMPRE que for iniciar/retomar um overdev, preparar a Fase 0 ou colher as decisões acordadas antes de codar.
---

# O montador de contexto do overdev (schematize-overdev-context)

Disciplina normativa, **agnóstica de linguagem**, que responde a uma pergunta só: **como um
overdev NASCE bem fundado?** A resposta não é "abre o checklist e sai tickando" — é **com a Fase
0 inteira montada antes do primeiro item**: as decisões já acordadas colhidas, o grafo do índice
ancorado, o plano pesado escrito e o checklist exaustivo derivado dele. Esta skill é o
**montador desse contexto**: ela produz o **briefing** que o laço de trabalho consome.

É a contraparte de **fundação** do overdev. O `/eng-overdev` (motor `schematize overdev start`)
roda o **laço** — tickeia item a item e não deixa parar até fechar. Esta skill **monta o
contexto** que aquele laço CONSOME. Onde a `schematize-engineering` descreve a Fase 0 dentro do
overdev (reference `overdev.md` §0), aqui ela vira **skill própria**, com comando dedicado, pra
rodar solta: montar o contexto uma vez, revisar, e só então soltar o laço.

Pular a fundação é a causa nº 1 de **plano raso, retrabalho e "reabrir o que já foi combinado"**.
Esta skill existe pra matar isso: **planejamento pesado antes de começar**, ancorado no código
de verdade (o grafo), rastreável (cada decisão vira item, cada item aponta a decisão).

**Versão:** skill `schematize-overdev-context` v0.3.0. Changelog em `CHANGELOG.md`.

## Comandos (Claude Code)

Digite `/overdev-context-help` pra ver todos. Em resumo:

| Comando | O que faz |
|---|---|
| `/overdev-context-help` | lista todos os comandos do schematize-overdev-context |
| `/overdev-context-build` | **monta a Fase 0**: varre a sessão/repo e colhe as DECISÕES acordadas (`.schematize/overdev/DECISOES.md`), ancora no GRAFO do índice, escreve o PLAN pesado (`.schematize/overdev/PLAN.md`), deriva o CHECKLIST exaustivo (`.schematize/overdev/CHECKLIST.md`) e entrega o DOCUMENTO DE CONTEXTO GERAL (briefing) — pronto pro `/eng-overdev` consumir |
| `/overdev-context-load` | carrega à força TODO o corpo normativo (contexto, decisões, plano/checklist, briefing) e passa a aplicá-lo |
| `/overdev-context-claude` | cria ou mescla o `CLAUDE.md` sempre-on de montagem de contexto na raiz do repo |
| `/overdev-context-cc` | context compact: gera handoff no archive e roda `/compact` |
| `/overdev-context-handoff` | gera o handoff (context.md + checklist.md) sem compactar |

Os comandos ficam em `assets/commands/` e são instalados em `.claude/commands/`.

## Como usar esta skill

1. **Monte o contexto** (`/overdev-context-build`, `references/contexto.md`): rode as **cinco
   etapas em ordem** — decisões → grafo → plano → checklist → briefing. É a Fase 0 inteira, num
   passo. Não entre no laço aqui: esta skill **funda**, não tickeia.
2. **Colha as decisões primeiro** (`references/decisoes.md`): varra a sessão/o repo e extraia o
   que **já foi acordado** (as fechadas, não as abandonadas) em formato ADR-lite. Isso **trava o
   que já foi combinado** e vira input do plano. Ambíguo/em aberto **não se inventa** — vira
   candidato a `- [~]` on-hold.
3. **Ancore no grafo** (`references/contexto.md` §2): o plano se prende ao **MAPA + adjacência**
   do índice (§39). Sem índice ainda? **gerá-lo é o 1º item** do checklist.
4. **Planeje pesado, derive o checklist** (`references/plano-checklist.md`): escopo entra/NÃO
   entra, decomposição em itens verificáveis **do tamanho de uma micro-task de Sonnet, com tag
   `[sonnet]`/`[opus: motivo]`**, ordem topológica, paralelismo, riscos, DoD. O
   checklist é a **projeção executável do plano**, exaustivo **por contagem**, na convenção de 2
   níveis (`- [ ]`/`- [H ]`/`- [~]`).
5. **Entregue o briefing** (`references/briefing.md`): um documento coeso que amarra objetivo +
   decisões + grafo + plano + checklist + riscos, gravado no archive. É o que o overdev abre pra
   trabalhar e o que o humano lê pra acompanhar.
6. **Não trabalhe de memória** — o método, o formato das decisões, a anatomia do plano/checklist
   e do briefing estão nos references. Aplique os pisos abaixo independentemente do reference
   carregado.

Mapa de references — leia o que casa com a tarefa:

| Tarefa | Reference |
|---|---|
| O método completo: as 5 etapas (decisões → grafo → plano → checklist → briefing), o gate da Fase 0, o que esta skill NÃO faz, quando rodar | `references/contexto.md` |
| Etapa 1 a fundo: varrer a sessão/repo, o que conta como decisão **acordada** (vs abandonada/ambígua), o formato ADR-lite, o mapa decisão→item, onde gravar | `references/decisoes.md` |
| Etapas 3+4: anatomia do PLAN pesado (escopo, decomposição verificável, ordem/paralelismo, riscos, DoD) e a derivação do CHECKLIST exaustivo por contagem na convenção de 2 níveis | `references/plano-checklist.md` |
| Etapa 5: anatomia do DOCUMENTO DE CONTEXTO GERAL (briefing), o que amarra, onde grava, como o `/eng-overdev` e o painel consomem | `references/briefing.md` |

## Pisos inegociáveis (vetam o atalho)

Independente do reference, estes limites nunca são cruzados:

1. **Fundação ANTES do laço — sempre, sem exceção.** Nenhum item é tickado antes de as cinco
   etapas fecharem. Começar a codar sem decisões colhidas, grafo ancorado, plano pesado e
   checklist derivado é exatamente a macaquice que esta skill existe pra matar. Esta skill
   **funda**; quem tickeia é o `/eng-overdev`.
2. **Decisão só entra se foi ACORDADA — e com origem rastreável.** Só vão pro `DECISOES.md` as
   decisões **fechadas** no contexto (decisão · motivo · alternativa descartada · **origem** onde
   no contexto/repo). O que ficou ambíguo/em aberto **não se inventa**: vira candidato a `- [~]`
   on-hold, não vira decisão de fachada.
3. **O plano se ancora no GRAFO real, não no ar.** Cada item aponta o(s) **nó(s)** que toca
   (função/serviço/`arquivo:linha`) e as **arestas** afetadas. Sem índice (§39) ainda? **gerá-lo
   é o 1º item** do checklist — não se planeja cego.
4. **Checklist exaustivo POR CONTAGEM, cada item com como provar.** Um item por linha, pequeno,
   com o jeito de provar (teste/comando/gate). Checklist magro = "terminei" precoce embutido na
   fundação. Se o usuário já tem um checklist, ele é **incorporado inteiro** — nunca resumido/aparado.
5. **Convenção de 2 níveis no checklist.** `- [ ]`/`- [x]` = item de **máquina** (fecha com
   prova automática: teste/gate). `- [H ]`/`- [H x]` = item que exige **verificação humana**
   (revisão de olho, decisão de produto, aceite). `- [~]` = **on-hold/parkeado** (pergunta
   pendente, não bloqueia). Cada nível fecha do seu jeito; máquina não auto-fecha item humano.
6. **Rastreabilidade decisão→item→nó.** Cada decisão de (1) vira **≥1 item** do checklist; cada
   item aponta a **decisão que o justifica** e o **nó do grafo** que toca. Decisão sem item é
   decisão esquecida; item sem decisão/nó é item solto. O briefing exibe esse mapa.
7. **Saída durável no archive + control-plane.** Os artefatos vivem em `.schematize/overdev/`
   (`DECISOES.md`, `PLAN.md`, `CHECKLIST.md` — control-plane que o hook lê, trate como `.git`,
   **gitignore**) **e** espelhados em `<projeto>_archive/overdev/` (registro humano durável §28).
   O briefing vai pro archive. Sem archive, a fundação não aconteceu. O layout `.overdev/` é o
   **legado** aceito por compat: o motor (`schematize overdev start`) lê `.schematize/overdev`
   com fallback ao `.overdev` antigo e **auto-migra** no start; escreva sempre em `.schematize/`.
8. **Esta skill MONTA, não CONSOME.** Ela não entra no laço, não abre pool de pergunta
   bloqueante, não declara "pronto". Fechada a Fase 0, o `/eng-overdev` (ou `schematize overdev
   start`) assume o laço com o contexto já montado.

9. **Orquestrador não desenvolve; subagent barato executa**
   (`schematize-engineering` → `references/orquestracao.md` §9). A Fase 0 decompõe PLAN/CHECKLIST
   em itens do tamanho de **uma micro-task de Sonnet**, cada um com tag de executor `[sonnet]`
   (default) ou `[opus: <motivo>]` (só após escalada registrada); "decidir arquitetura" não é
   item — o desenho é do orquestrador. O briefing declara que o principal só despacha/revisa e a
   escada: sonnet → correção pelo mesmo subagent (≤2 rodadas) → re-decompor → opus. **Sem frota ociosa** (`schematize-engineering` → `references/orquestracao.md` §9.6): agent idle com pendência executável volta ao trabalho; pendência que depende de outro agent → mata e enfileira com gatilho de dependência; terminou → mata.

## Relação com as outras skills

- **schematize-engineering** — a **BASE**. Esta skill extrai a **Fase 0 do overdev** (reference
  `overdev.md` §0) pra rodar solta. Ela produz o que o **`/eng-overdev`** e o motor **`schematize
  overdev start`** consomem: `DECISOES.md`, `PLAN.md`, `CHECKLIST.md` e o briefing. Consome, por
  sua vez, o **índice/MAPA (§39)** (`/eng-index`), a **DoD (§35)**, o **archive (§28)** e a
  **orquestração** (fan-out ≥3 unidades independentes via `/eng-orchestrate`). O fluxo completo:
  **`/overdev-context-build` (funda)** → **`/eng-overdev` (laço, tickeia com prova)** → fim
  legítimo (checklist fechado + gate).
- **schematize-audit** — a **contraparte de histórico**. A auditoria depois COBRA que o que foi
  fundado aqui **fechou**: cada decisão virou item feito?, o checklist derivado do plano foi
  sanado?, on-hold parkeado foi respondido? Órfão que a audit acha vira saneamento (candidato a
  novo `/eng-overdev`). Montar bem o contexto aqui é o que dá à auditoria um rastro auditável.
- **schematize-web / go / rust / elixir / c# / zig / ruby / node** — esta skill é agnóstica: ela
  monta o contexto de um overdev **de qualquer stack**; a **prova** de cada item roda no gate
  daquela linguagem (`/<slug>-review`, testes, lint), referenciada no plano e no `gate.sh`.
