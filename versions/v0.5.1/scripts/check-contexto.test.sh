#!/usr/bin/env bash
# Vermelho primeiro do gate da Fase 0. Cada caso planta UMA lacuna que o gate tem de pegar.
# EXCEÇÃO DECLARADA de strict mode (`schematize-shell` -> `references/piso.md` secao 1):
# harness de teste roda sem `-e` de propósito — ele precisa continuar depois de um caso
# vermelho para reportar TODOS, em vez de parar no primeiro.
set -u
AQUI="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
G="$AQUI/check-contexto.sh"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
ok=0; fail=0
checa() { local nome="$1" esp="$2" agulha="$3" dir="$4"
  local saida; saida="$(cd "$dir" && bash "$G" .schematize/overdev p_archive 2>&1)"; local rc=$?
  if [ "$rc" != "$esp" ]; then echo "  ✖ $nome: exit $rc, esperado $esp"; sed 's/^/      /' <<<"$saida"; fail=$((fail+1)); return; fi
  if [ -n "$agulha" ] && ! grep -qF -- "$agulha" <<<"$saida"; then echo "  ✖ $nome: exit certo, saida sem \"$agulha\""; sed 's/^/      /' <<<"$saida"; fail=$((fail+1)); return; fi
  echo "  ✔ $nome"; ok=$((ok+1)); }

novo() { local d="$TMP/$1"; rm -rf "$d"; mkdir -p "$d/.schematize/overdev" "$d/p_archive/overdev" "$d/p_archive/index"
  printf '### D1. Usar X\n- **Decisao:** X\n### D2. Usar Y\n- **Decisao:** Y\n' > "$d/.schematize/overdev/DECISOES.md"
  printf '# PLAN\nescopo\n' > "$d/.schematize/overdev/PLAN.md"
  printf -- '- [ ] [sonnet] implementar X (prova: make t) [D1]\n- [ ] [sonnet] implementar Y (prova: make t) [D2]\n- [H ] aceite visual [D2]\n- [~] pergunta aberta\n- [x] [sonnet] feito antigo [D1]\n' > "$d/.schematize/overdev/CHECKLIST.md"
  printf '# objetivo\n' > "$d/p_archive/overdev/OBJETIVO.md"
  printf '# briefing\n' > "$d/p_archive/overdev/2026-10-14-CONTEXTO.md"
  echo "$d"; }

echo "== verde de partida =="
d="$(novo ok)"; checa verde 0 "FASE 0 FECHADA" "$d"
checa contagem-por-classe 0 "maquina: 2 abertos / 1 feitos · humano: 1 abertos / 0 feitos · on-hold: 1 · total: 5" "$d"

echo "== vermelhos plantados =="
d="$(novo sem-decisoes)"; rm "$d/.schematize/overdev/DECISOES.md"; checa sem-DECISOES 1 "DECISOES.md" "$d"
d="$(novo sem-plan)"; rm "$d/.schematize/overdev/PLAN.md"; checa sem-PLAN 1 "PLAN.md" "$d"
d="$(novo sem-checklist)"; rm "$d/.schematize/overdev/CHECKLIST.md"; checa sem-CHECKLIST 1 "CHECKLIST.md" "$d"
d="$(novo sem-objetivo)"; rm "$d/p_archive/overdev/OBJETIVO.md"; checa sem-espelho-OBJETIVO 1 "OBJETIVO.md" "$d"
d="$(novo sem-briefing)"; rm "$d/p_archive/overdev/2026-10-14-CONTEXTO.md"; checa sem-briefing 1 "briefing ausente" "$d"
d="$(novo checklist-vazio)"; : > "$d/.schematize/overdev/CHECKLIST.md"; checa checklist-vazio 1 "CHECKLIST.md" "$d"
d="$(novo checklist-sem-item)"; printf 'so texto, nenhum item\n' > "$d/.schematize/overdev/CHECKLIST.md"; checa checklist-sem-item 1 "sem nenhum item" "$d"
d="$(novo decisao-orfa)"; printf '### D3. Z\n' >> "$d/.schematize/overdev/DECISOES.md"; checa decisao-sem-item 1 "decisao D3 sem nenhum item" "$d"
d="$(novo decisoes-sem-D)"; printf 'texto livre sem decisoes numeradas\n' > "$d/.schematize/overdev/DECISOES.md"; checa DECISOES-sem-Dn 1 "sem nenhuma decisao" "$d"
d="$(novo sem-tag)"; printf -- '- [ ] implementar sem tag [D1]\n- [ ] [sonnet] y [D2]\n' > "$d/.schematize/overdev/CHECKLIST.md"; checa item-sem-tag 1 "sem [sonnet]" "$d"
d="$(novo sem-grafo)"; rmdir "$d/p_archive/index"; checa sem-grafo-e-sem-item 1 "indice" "$d"
d="$(novo grafo-via-item)"; rmdir "$d/p_archive/index"; printf -- '- [ ] [sonnet] gerar o indice /eng-index (prova: MAPA.md existe) [D1]\n- [ ] [sonnet] y [D2]\n' > "$d/.schematize/overdev/CHECKLIST.md"; checa grafo-ausente-mas-com-item-de-gerar 0 "FASE 0 FECHADA" "$d"

echo; echo "$ok ok, $fail falha(s)"; [ "$fail" -eq 0 ]
