#!/usr/bin/env bash
# Pinnt Kurs-Verweise in den ausgelieferten Templates auf absolute,
# getaggte URLs. Quelle (lab/templates) behält relative ../../kurs/-Links
# (klickbar beim Kurs-Browsen, vom Gate ohnehin via .d-check.yml ignoriert);
# beim ZIP-Bau werden sie hier zu .../blob/<ref>/kurs/… umgeschrieben, damit
# sie das Kopieren ins Ziel-Repo überstehen (Defekt 1 des lab-templates-Reports).
#
# Aufruf: rewrite-template-links.sh <ziel-verzeichnis> <git-ref>
#   <git-ref> = Tag (templates-v*) im Release-Workflow, sonst "main" (Vorschau).
set -euo pipefail

dir="${1:?Ziel-Verzeichnis fehlt}"
ref="${2:?Git-Ref (Tag oder Branch) fehlt}"
base="https://github.com/pt9912/ai-harness-course"

find "$dir" -name '*.md' -print0 | while IFS= read -r -d '' f; do
  # Kurs-relative Links beliebiger ../-Tiefe (../../kurs/ … ../../../../../kurs/)
  # → auf den ausgelieferten Stand gepinnte blob-URL.
  sed -E -i "s#(\\.\\./)+kurs/#${base}/blob/${ref}/kurs/#g" "$f"

  # Release-Asset-Referenzen (ZIP + Agents-Regelwerk; Bootstrap-Pointer im
  # AGENTS-Template) im Release-ZIP auf den Tag pinnen, damit der
  # ausgelieferte Stand reproduzierbar ist. Nur in *.template.md — die README
  # behält bewusst den stabilen latest-Link ("Stabiler Link" in §Download).
  # Im Vorschau-Build (ref=main) bleibt alles.
  if [[ "$ref" == templates-v* && "$f" == *.template.md ]]; then
    sed -E -i \
      "s#releases/latest/download/(lab-templates\\.zip|agents-regelwerk\\.md)#releases/download/${ref}/\\1#g" \
      "$f"
  fi
done

# d-check-Digest aus dem Kurs-Makefile (Single Source of Truth) in das
# ausgelieferte harness.mk injizieren. Sonst ist der Pin ein hartkodiertes
# Duplikat, das beim nächsten d-check-Bump driftet (wie früher templates-v1).
# Das Quell-harness.mk behält einen realen Wert (Repo-Direkt-Copy-Fallback);
# der ZIP-Stand wird hier auf den Kurs-Pin gesetzt.
pin=$(sed -nE 's/^D_CHECK_IMAGE[[:space:]]*\?=[[:space:]]*(.+)$/\1/p' Makefile 2>/dev/null | head -1)
if [[ -n "${pin:-}" && -f "$dir/harness.mk" ]]; then
  sed -E -i "s#^D_CHECK_IMAGE[[:space:]]*\\?=.*#D_CHECK_IMAGE ?= ${pin}#" "$dir/harness.mk"
  echo "rewrite-template-links: harness.mk D_CHECK_IMAGE auf Kurs-Pin gesetzt ($pin)."
fi

echo "rewrite-template-links: Kurs-Verweise in $dir auf '$ref' gepinnt."
