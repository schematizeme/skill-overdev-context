#!/usr/bin/env bash
# check-contexto.sh — gate VERIFICÁVEL da Fase 0 (schematize-overdev-context, contexto.md §6).
#
# O quê: prova por execução que a fundação do overdev está fechada, em vez de "parece pronta".
# Checa: (1) os artefatos existem e não estão vazios — control-plane `DECISOES.md`, `PLAN.md`,
# `CHECKLIST.md`, e no archive `overdev/OBJETIVO.md` (espelho) + `overdev/<AAAA-MM-DD>-CONTEXTO.md`
# (briefing); (2) a contagem por classe do checklist (`- [ ]` máquina, `- [H ]` humano, `- [~]`
# on-hold, mais os fechados) e que há ao menos 1 item; (3) toda decisão `### D<n>` do DECISOES.md
# é citada por >=1 item do checklist (decisão sem item = decisão esquecida); (4) todo item de
# máquina aberto leva a tag de executor `[sonnet]`/`[opus: motivo]`; (5) o grafo está ancorado:
# existe `<archive>/index/` OU o checklist tem um item de gerar o índice.
# Uso:   check-contexto.sh [dir-control-plane] [dir-archive]
#        defaults: .schematize/overdev (ou .overdev legado) e o único `*_archive` do diretório atual.
# Saída: 0 = Fase 0 fechada; 1 = ao menos uma falha (cada uma impressa); 2 = uso/ambiente.
set -euo pipefail

SD="${1:-}"
if [ -z "$SD" ]; then
  if [ -d .schematize/overdev ]; then SD=.schematize/overdev
  elif [ -d .overdev ]; then SD=.overdev
  else echo "check-contexto: sem control-plane (.schematize/overdev)" >&2; exit 2; fi
fi
AR="${2:-}"
if [ -z "$AR" ]; then
  mapfile -t cands < <(find . -maxdepth 2 -type d -name '*_archive' -not -path '*/.git/*' | sort)
  [ "${#cands[@]}" -eq 1 ] || { echo "check-contexto: informe o archive (achei ${#cands[@]} candidatos)" >&2; exit 2; }
  AR="${cands[0]}"
fi
[ -d "$SD" ] || { echo "check-contexto: '$SD' não existe" >&2; exit 2; }
[ -d "$AR" ] || { echo "check-contexto: '$AR' não existe" >&2; exit 2; }

falhas=0
falha() { echo "  FALHA: $1"; falhas=$((falhas+1)); }
tem() { [ -s "$1" ] || { falha "artefato ausente ou vazio: $1"; return 1; }; }
conta() { local n; n="$(grep -cE "$1" "$2" 2>/dev/null || true)"; echo "${n:-0}"; }

echo "== 1. artefatos =="
tem "$SD/DECISOES.md" || true
tem "$SD/PLAN.md" || true
tem "$SD/CHECKLIST.md" || true
tem "$AR/overdev/OBJETIVO.md" || true
briefings=("$AR"/overdev/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-CONTEXTO.md)
if [ ! -s "${briefings[0]}" ]; then falha "briefing ausente: $AR/overdev/<AAAA-MM-DD>-CONTEXTO.md"; fi

CL="$SD/CHECKLIST.md"
if [ -s "$CL" ]; then
  echo "== 2. contagem por classe =="
  maq_a="$(conta '^[[:space:]]*- \[ \]' "$CL")"; maq_f="$(conta '^[[:space:]]*- \[x\]' "$CL")"
  hum_a="$(conta '^[[:space:]]*- \[H \]' "$CL")"; hum_f="$(conta '^[[:space:]]*- \[H x\]' "$CL")"
  hold="$(conta '^[[:space:]]*- \[~\]' "$CL")"
  total=$((maq_a+maq_f+hum_a+hum_f+hold))
  echo "  maquina: $maq_a abertos / $maq_f feitos · humano: $hum_a abertos / $hum_f feitos · on-hold: $hold · total: $total"
  [ "$total" -ge 1 ] || falha "checklist sem nenhum item"

  echo "== 3. decisao -> item =="
  if [ -s "$SD/DECISOES.md" ]; then
    mapfile -t decs < <(grep -oE '^#{2,4}[[:space:]]+D[0-9]+\b' "$SD/DECISOES.md" | grep -oE 'D[0-9]+' || true)
    [ "${#decs[@]}" -ge 1 ] || falha "DECISOES.md sem nenhuma decisao '### D<n>.'"
    for d in "${decs[@]}"; do
      grep -E '^[[:space:]]*- \[' "$CL" | grep -qE "\\b$d\\b" || falha "decisao $d sem nenhum item no checklist"
    done
    echo "  decisoes: ${#decs[@]}"
  fi

  echo "== 4. tag de executor nos itens de maquina abertos =="
  sem_tag="$(grep -E '^[[:space:]]*- \[ \]' "$CL" | grep -vE '\[(sonnet|opus:[^]]+)\]' | wc -l || true)"
  [ "${sem_tag:-0}" -eq 0 ] || falha "$sem_tag item(ns) de maquina abertos sem [sonnet]/[opus: motivo]"

  echo "== 5. grafo ancorado =="
  if [ ! -d "$AR/index" ] && ! grep -qiE '^[[:space:]]*- \[.{0,2}\].*(índice|indice|/eng-index|MAPA)' "$CL"; then
    falha "sem $AR/index/ e sem item de gerar o indice no checklist"
  fi
fi

if [ "$falhas" -gt 0 ]; then echo "FASE 0 ABERTA: $falhas falha(s)"; exit 1; fi
echo "FASE 0 FECHADA"
