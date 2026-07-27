#!/usr/bin/env bash
# Baut das self-contained Baseline-Bundle (regelwerk/ + templates/ parallel) in
# ein Zielverzeichnis — OHNE zu zippen und OHNE den Arbeitsbaum zu verändern.
#
# Warum als eigenes Skript: Der Release-Workflow und `make bundle-check` müssen
# BYTEGLEICH dasselbe Artefakt erzeugen. Solange die Assemblierung im Workflow
# inline stand, war der lokale Check bestenfalls eine Nachbildung — und eine
# Nachbildung prüft nicht das, was ausgeliefert wird.
#
# Aufruf: build-bundle.sh <ziel-verzeichnis> <git-ref>
#   <git-ref> = Release-Tag (vX.Y.Z) im Release-Workflow, sonst "main".
set -euo pipefail

out="${1:?Ziel-Verzeichnis fehlt}"
ref="${2:?Git-Ref (Tag oder Branch) fehlt}"
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$out/regelwerk"
cp "$root"/lab/regelwerk/*.md "$out/regelwerk/"

# Templates parallel ins Bundle, damit die `../templates/`-Ziel-Form-Verweise
# der Splits NETZLOS auflösen: regelwerk/ ↔ templates/ liegen im Bundle wie
# lab/regelwerk ↔ lab/templates im Kurs-Repo.
cp -r "$root/lab/templates" "$out/templates"

# Kurs-Verweise in den Templates auf den Tag pinnen. Anders als früher im
# Workflow läuft das auf der KOPIE, nicht auf `lab/templates` im Arbeitsbaum —
# sonst hinterlässt ein lokaler Lauf gepinnte Links im Repo.
bash "$root/tools/rewrite-template-links.sh" "$out/templates" "$ref"

# Splits: Modul-Querverweise (--keep-within-src) UND `../templates/`-Verweise
# (--keep-within=lab/templates) bleiben relativ; nur echte Außen-Verweise
# (Kurs, LICENSE) werden auf den Tag gepinnt.
for f in "$out/regelwerk"/*.md; do
  python3 "$root/tools/rewrite-doc-links.py" \
    "$f" lab/regelwerk "$ref" "$root" --keep-within-src --keep-within=lab/templates
done
