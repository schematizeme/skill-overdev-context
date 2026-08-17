# Montagem do contexto do overdev — a Fase 0 / fundação em cinco etapas

> Antes de o overdev tickar **um** item, o trabalho precisa ser **fundado**. Este reference é o
> método de montagem desse contexto: as cinco etapas, em ordem, que transformam "um objetivo e
> uma sessão de conversa" no **briefing** que o laço de trabalho consome. Pular isto é a causa nº
> 1 de plano raso, retrabalho e "reabrir o que já foi combinado".

Esta skill **monta o contexto**; ela **não tickeia**. Fechada a Fase 0 (o gate, §6), quem assume
o laço é o `/eng-overdev` (motor `schematize overdev start`). A fronteira é dura: aqui se
**funda**, lá se **executa**. Misturar as duas coisas é como a fundação vira rasa.

O produto final é **cinco artefatos coerentes**:

| Etapa | Produz | Onde |
|---|---|---|
| 1. Decisões | `DECISOES.md` (ADR-lite) | `.overdev/` + `<projeto>_archive/overdev/` |
| 2. Grafo | ancoragem no índice (leitura/geração) | `<projeto>_archive/index/` (MAPA + adjacência) |
| 3. Plano | `PLAN.md` (pesado) | `.overdev/` + `<projeto>_archive/overdev/` |
| 4. Checklist | `CHECKLIST.md` (exaustivo, 2 níveis) | `.overdev/` (control-plane) + espelho `OBJETIVO.md` no archive |
| 5. Briefing | **Documento de Contexto Geral** | `<projeto>_archive/overdev/<data>-CONTEXTO.md` |

## 1. Colher as DECISÕES já acordadas (varre a sessão + o repo)

Varra a **conversa/sessão inteira** e o **repo** e extraia as **decisões acordadas** — as
**fechadas**, não as abandonadas nem as ainda-em-aberto. Para cada uma, registre em formato
**ADR-lite**: `Decisão · Motivo · Alternativa descartada · Origem (onde no contexto/repo)`.

Grava em **`.overdev/DECISOES.md`** (+ espelho no `<projeto>_archive/overdev/`). Isso **trava o
que já foi combinado** (não se re-debate) e vira **input do plano** (§3). O que ficou
**ambíguo/em aberto não se inventa**: vira candidato a `- [~]` on-hold no checklist (§4), não vira
decisão de fachada.

> Detalhe completo (o que conta como acordado vs abandonado, o formato, o mapa decisão→item):
> `references/decisoes.md`.

## 2. Ancorar no GRAFO do índice

Rode/leia `/eng-index` (§39): o **MAPA** e os grafos de serviço/chamadas em
`<projeto>_archive/index/` (`INDEX_GLOBAL.md`, `INDEX_FUNCTIONS.md`, `MAPA.md` — adjacência
`A -> B`). O plano (§3) se **ancora no grafo real**: cada item vai apontar o(s) **nó(s)** que toca
(função/serviço/`arquivo:linha`) e as **arestas** afetadas (quem chama / é chamado).

- **Sem índice ainda?** Não se planeja cego: **gerar o índice é o 1º item do checklist**. Se por
  algum motivo não dá pra gerar agora, **registre a ausência** e planeje pela enumeração de
  rotas/funções — mas isso é exceção, não o caminho.
- O grafo é o que **liga o plano ao código de verdade** — e é o que o painel/tela de grafos do
  `schematize` consome pra mostrar o progresso ancorado nos nós.

## 3. Planejar PESADO (plan-first de verdade)

Só depois de 1+2, produza o **PLANO** em **`.overdev/PLAN.md`** (+ archive). Pesado, não uma
lista rasa: **objetivo e escopo** (o que entra / o que **NÃO** entra, ancorado nas decisões),
**decomposição** em fases e itens **verificáveis** (cada item: nó do grafo + prova + dependências
+ risco/reversibilidade), **ordem topológica** pelas dependências, **paralelismo** (≥3 unidades
independentes → fan-out via `/eng-orchestrate`), **mapa decisão→item**, **cobertura do grafo**
(nós tocados vs nós que deveriam ser), **riscos** e **pontos de parada legítima**, e a
**Definition of Done** (§35) + **archive** (§28).

> Anatomia detalhada do PLAN: `references/plano-checklist.md`.

## 4. Derivar o CHECKLIST exaustivo (convenção de 2 níveis)

O PLANO **gera o CHECKLIST** — o checklist é a **projeção executável do plano**, não uma lista
solta. Grava em **`.overdev/CHECKLIST.md`** (control-plane que o hook do overdev lê) + espelho em
**`<projeto>_archive/overdev/OBJETIVO.md`** (registro humano). Regras:

- **Exaustivo por CONTAGEM**: um item por linha, cada um pequeno e com **como provar**
  (comando/teste/observação). Cubra implementação, testes, edge cases, erro/loading/vazio,
  doc-comment + índice/MAPA (§39), DoD (§35), archive (§28).
- **Convenção de 2 níveis**:
  - `- [ ]` / `- [x]` → item de **máquina**: fecha com **prova automática** (teste/gate/comando).
  - `- [H ]` / `- [H x]` → item que exige **verificação humana**: revisão de olho, decisão de
    produto, aceite visual/UX, aprovação. A máquina **não auto-fecha** item humano.
  - `- [~]` → **on-hold/parkeado**: pergunta pendente (do §1 ou surgida no plano). **Não bloqueia**
    o fim do run; espera resposta do usuário.
- Se o usuário **já tem um checklist**, ele é **incorporado inteiro** — nunca resumido/aparado.
- **Rastreabilidade**: cada decisão de §1 vira **≥1 item**; cada item aponta a **decisão** que o
  justifica e o **nó do grafo** que toca.

> Regras completas da derivação e da convenção de 2 níveis: `references/plano-checklist.md`.

## 5. Entregar o DOCUMENTO DE CONTEXTO GERAL (o briefing)

Amarre tudo num documento coeso — o **briefing do overdev**: objetivo, decisões (resumo + link
pro `DECISOES.md`), grafo/cobertura, plano (resumo + link), checklist (estado inicial: quantos
`- [ ]`/`- [H ]`/`- [~]`), riscos, DoD e pontos de parada legítima. Grava em
`<projeto>_archive/overdev/<YYYY-MM-DD>-CONTEXTO.md`.

É o que o `/eng-overdev` **abre pra trabalhar** e o que o humano lê pra acompanhar (o painel
`schematize` renderiza a partir desses arquivos). O briefing **não substitui** os artefatos de
control-plane — é a **vista coesa** por cima deles.

> Anatomia do briefing e como é consumido: `references/briefing.md`.

## 6. Gate da Fase 0 (quando a fundação está fechada)

A montagem só está **pronta pra soltar o laço** quando **tudo** isto vale:

1. `DECISOES.md` colhido (acordadas travadas; ambíguas viraram `- [~]`, não decisões de fachada);
2. **grafo carregado** (ou ausência registrada + **item de gerá-lo** no checklist);
3. **`PLAN.md` pesado** escrito (escopo entra/NÃO-entra, itens verificáveis com nó+prova+deps,
   ordem, paralelismo, riscos, DoD);
4. `CHECKLIST.md` **derivado do plano** (exaustivo por contagem, convenção de 2 níveis,
   rastreável decisão→item→nó);
5. **briefing** gravado no archive.

Fechado o gate: entregue o contexto e **passe o bastão** — `schematize overdev start "<objetivo>"`
+ `/eng-overdev` assumem o laço. **Esta skill não entra no laço.**

## O que esta skill NÃO faz (fronteira dura)

- **Não tickeia item** nem implementa — isso é o laço do `/eng-overdev`.
- **Não declara "pronto"** — ela funda; quem julga "terminou" é o checklist + gate do overdev.
- **Não abre pool de pergunta bloqueante** — dúvida vira `- [~]` on-hold + linha em
  `./PERGUNTAS-OVERDEV.txt`, seguindo a regra do overdev de "parkeia e segue".
- **Não fecha o loop de histórico** — provar que o fundado aqui foi sanado é a `schematize-audit`.

## Quando rodar

- **Início de um overdev** — sempre, é a Fase 0 obrigatória antes do laço.
- **Retomada de projeto parado** — remonta o contexto (decisões podem ter mudado, grafo pode ter
  drift) antes de voltar ao laço.
- **Trabalho grande novo** (feature/marco) — mesmo fora de um overdev formal, montar o briefing
  antes de codar paga o retrabalho evitado.
- **Antes de um fan-out** (`/eng-orchestrate`) — o plano/checklist é o que se reparte entre os
  subagents; sem ele, o paralelismo vira colisão.
