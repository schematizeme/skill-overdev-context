---
description: Gera o handoff de contexto (context.md + checklist.md) no archive, SEM compactar
---

Gere o handoff da montagem de contexto **sem** compactar — pra fim de sessão ou troca de tarefa:

1. `<projeto>_archive/context/<YYYY-MM-DD-HH-MM-SS>-context.md` — estado da Fase 0: etapas
   fechadas (decisões / grafo / plano / checklist / briefing), decisões `D1..Dn` colhidas, nós do
   grafo ancorados, on-holds abertos (+ perguntas de `PERGUNTAS-OVERDEV.txt`), decisões, onde parou.
2. `<projeto>_archive/context/<YYYY-MM-DD-HH-MM-SS>-checklist.md` — **FEITO vs EM ABERTO** das
   etapas da fundação (o que falta antes de o gate da Fase 0 fechar e soltar o `/eng-overdev`).

Não rode `/compact` — só arquiva.
