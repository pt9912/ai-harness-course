#!/usr/bin/env bash
# Pinnt Kurs-Verweise in den ausgelieferten Templates auf absolute,
# getaggte URLs. Quelle (lab/templates) behält relative ../../kurs/-Links
# (klickbar beim Kurs-Browsen, vom Gate ohnehin via .d-check.yml ignoriert);
# beim ZIP-Bau werden sie hier zu .../blob/<ref>/kurs/… umgeschrieben, damit
# sie das Kopieren ins Ziel-Repo überstehen (Defekt 1 des lab-templates-Reports).
#
# Aufruf: rewrite-template-links.sh <ziel-verzeichnis> <git-ref>
#   <git-ref> = Release-Tag (vX.Y.Z, hist. templates-v*) im Release-Workflow,
#               sonst "main" (Vorschau).
set -euo pipefail

dir="${1:?Ziel-Verzeichnis fehlt}"
ref="${2:?Git-Ref (Tag oder Branch) fehlt}"
base="https://github.com/pt9912/ai-harness-course"

find "$dir" -name '*.md' -print0 | while IFS= read -r -d '' f; do
  # Kurs-relative Links beliebiger ../-Tiefe (../../kurs/ … ../../../../../kurs/)
  # → auf den ausgelieferten Stand gepinnte blob-URL.
  sed -E -i "s#(\\.\\./)+kurs/#${base}/blob/${ref}/kurs/#g" "$f"

  # Baseline-Bundle-Referenz (lab-regelwerk.zip; Bootstrap-Pointer im
  # AGENTS-Template) im ausgelieferten Template auf den Tag pinnen, damit der
  # ausgelieferte Stand reproduzierbar ist. Nur in *.template.md — die README
  # behält bewusst den stabilen latest-Link ("Stabiler Link" in §Download).
  # Im Vorschau-Build (ref=main) bleibt alles.
  if [[ "$ref" != main && "$f" == *.template.md ]]; then
    sed -E -i \
      "s#releases/latest/download/lab-regelwerk\\.zip#releases/download/${ref}/lab-regelwerk.zip#g" \
      "$f"
  fi
done

# Das d-check-Gate wird NICHT ins Template gespritzt: weder das tool-generierte
# Fragment `d-check.mk` (Kopie eines Generats → Drift) noch der `DCHECK_DIGEST`-Pin.
# Beides ist tool-/versionsspezifisch und wird vom Adopter beim Bootstrap gesetzt
# (`d-check --print-mk` + eigenen Digest pinnen, Modul 2). Die Template-Makefile
# führt `DCHECK_DIGEST` als auszufüllenden Platzhalter; das Bundle trägt nur
# versions-agnostischen Inhalt.

echo "rewrite-template-links: Kurs-Verweise in $dir auf '$ref' gepinnt."
