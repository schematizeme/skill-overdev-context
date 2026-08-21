# Etapas 3+4 — o PLAN pesado e a derivação do CHECKLIST exaustivo

> Um plano raso é um "terminei" precoce embutido na fundação: o agente tickeia a listinha curta,
> declara vitória e deixa metade do trabalho invisível. Este reference é a anatomia do **plano
> pesado** e da **derivação do checklist exaustivo** que o torna a projeção executável do plano —
> não uma lista solta.

## Parte A — o PLAN pesado (`.schematize/overdev/PLAN.md`)

Só se escreve o plano **depois** de colhidas as decisões (`decisoes.md`) e ancorado o grafo
(`contexto.md` §2). O plano se prende às duas coisas: **ancorado nas decisões** (escopo) e **no
grafo** (nós/arestas). Seções:

### A.1 Objetivo e escopo
- **Objetivo:** uma frase acionável do que o overdev entrega.
- **Entra:** o que está no escopo (cada linha ancorada numa decisão `D<n>`).
- **NÃO entra:** o que fica **fora** — explícito. Escopo sem "NÃO entra" é escopo que incha no
  laço. É aqui que se corta gold-plating antes de ele nascer.

### A.2 Decomposição em itens verificáveis
A unidade do plano é o **item verificável**. Cada item carrega:
- **Nó(s) do grafo** que toca — função/serviço/`arquivo:linha` (da etapa 2). Item sem nó é item
  no ar.
- **Prova** — como se sabe que fechou: teste que roda, comando, gate, observação. Sem prova, o
  item não é verificável e não deveria existir como está.
- **Dependências** — o que vem antes (define a ordem, A.3).
- **Risco / reversibilidade** — o que quebra se der errado; é reversível?
- **Decisão que o justifica** — o `D<n>` de origem (rastreabilidade).

### A.3 Ordem topológica e paralelismo
- **Ordem:** ordene os itens pela dependência (topológica). O que não depende de nada vem
  primeiro; o que depende, depois.
- **Paralelismo:** identifique **unidades independentes**. ≥3 independentes → planeje **fan-out**
  (`/eng-orchestrate`): cada unidade é uma tarefa de subagent, sem colisão de arquivo/nó. O
  paralelismo acelera o laço; planejá-lo aqui é o que o torna possível.

### A.4 Cobertura do grafo
Liste os **nós que o objetivo deveria tocar** vs os **nós que os itens tocam**. Diferença =
buraco no plano (um nó que ninguém cobre) ou escopo a mais (um item que toca nó fora do
objetivo). Feche a diferença **agora**, não no meio do laço.

### A.5 Riscos, paradas legítimas e DoD
- **Riscos:** o que pode dar errado, probabilidade/impacto, mitigação.
- **Pontos de parada legítima:** o que é irreversível (exige aceite humano → item `- [H ]`); onde
  faz sentido o overdev encerrar por budget/thrashing.
- **Definition of Done** (§35) do objetivo + **archive** (§28) + índice/MAPA (§39) como itens.

## Parte B — a derivação do CHECKLIST (`.schematize/overdev/CHECKLIST.md`)

O plano **gera** o checklist: cada item verificável do plano vira ≥1 linha do checklist. O
checklist é o **control-plane** que o hook do overdev lê; espelha em
`<projeto>_archive/overdev/OBJETIVO.md` (registro humano durável).

### B.1 Exaustivo por CONTAGEM
- **Um item por linha**, pequeno, cada um com **como provar** anexado.
- Cubra o ciclo inteiro, não só o "caminho feliz": implementação, **testes**, **edge cases**,
  estados de **erro/loading/vazio**, **doc-comment + índice/MAPA** (§39), **DoD** (§35),
  **archive** (§28). O que não está no checklist não vai ser feito — checklist magro = trabalho
  perdido.
- Se o usuário **já tem um checklist**, **incorpore-o inteiro** — nunca resuma nem apare. Some os
  itens dele aos derivados do plano.

### B.2 A convenção de 2 níveis (o coração da skill)

Cada linha do checklist tem um **nível** que diz **quem fecha** e **como**:

| Marca | Nível | Fecha quando… |
|---|---|---|
| `- [ ]` | **máquina**, aberto | há prova automática pendente |
| `- [x]` | **máquina**, feito | o teste/gate/comando do item passa (verificado, não na fé) |
| `- [H ]` | **humano**, aberto | espera verificação humana (revisão de olho, decisão de produto, aceite UX/visual, aprovação) |
| `- [H x]` | **humano**, feito | um humano **verificou e aceitou** |
| `- [~]` | **on-hold / parkeado** | pergunta pendente; **não bloqueia** o fim do run |

Regras da convenção:
- **A máquina não auto-fecha item humano.** Um `- [H ]` só vira `- [H x]` por aceite humano
  explícito — o gate automático o ignora ao contar "terminou". Isso protege o que exige olho
  (UX, segurança sensível, decisão de negócio) de ser marcado por um teste que passou.
- **`- [~]` não bloqueia**, mas **fica visível**: cada on-hold tem uma pergunta em
  `./PERGUNTAS-OVERDEV.txt`. Ao ser respondido, vira `- [ ]`/`- [H ]` e entra no fluxo.
- **Todo item de máquina precisa de prova** anexada na própria linha (ou logo abaixo): o comando
  ou teste que o fecha. `- [ ]` sem prova é `- [ ]` que ninguém sabe fechar.

Exemplo de bloco derivado (ilustrativo):

```markdown
## Objetivo: <frase>  (deriva de D1, D3, D4)

### Fase 1 — <nome>  (nós: svc.auth, handler.login:42)
- [ ] Implementar validação de token no login  (prova: `go test ./auth -run TestLoginToken`)  [D3]
- [ ] Rejeitar token expirado com 401  (prova: teste de rejeição verde)  [D3]
- [H ] Revisar mensagem de erro de login (não vazar se user existe)  [D4]  (aceite: revisão de segurança)
- [~] Suportar login por passkey?  (pergunta parkeada em PERGUNTAS-OVERDEV.txt)  [ambígua, ex-D?]
- [ ] Atualizar índice/MAPA (§39) com os nós novos  (prova: `/eng-index` sem diff pendente)
- [ ] Archive do run (§28)  (prova: arquivo em <projeto>_archive/overdev/)
```

### B.3 Rastreabilidade decisão→item→nó
- Cada **decisão** `D<n>` (de `decisoes.md`) aponta ≥1 item (preencha o campo *Deriva itens* lá).
- Cada **item** referencia a decisão que o justifica (`[D3]`) e o(s) **nó(s)** do grafo (no
  cabeçalho da fase ou na linha).
- Item **sem** decisão nem nó é **suspeito**: ou é escopo-a-mais (corte), ou faltou registrar a
  decisão/nó (conserte). O briefing exibe o mapa fechado.

## Piso das etapas 3+4

1. Plano com **escopo entra/NÃO-entra**, itens **verificáveis** (nó + prova + deps + risco),
   ordem topológica, paralelismo planejado, cobertura do grafo, riscos e DoD.
2. Checklist **exaustivo por contagem**, cada item com **como provar**, cobrindo testes/edge/
   erro/doc/DoD/archive — checklist do usuário **incorporado inteiro**.
3. **Convenção de 2 níveis** aplicada (`- [ ]` máquina / `- [H ]` humano / `- [~]` on-hold); a
   máquina **não** auto-fecha item humano.
4. **Rastreabilidade** decisão→item→nó fechada.
