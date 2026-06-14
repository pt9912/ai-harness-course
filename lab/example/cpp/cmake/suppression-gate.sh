#!/usr/bin/env bash
# suppression-gate — Inline-Suppression-Verbot (AGENTS.md §2.2).
# Echte Ausnahmen leben zentral in .clang-tidy mit ADR-/Slice-Begründung,
# nicht als Inline-Marker im Code. Rot/grün, kein Vorschlag (Modul 13).
set -euo pipefail
cd "$(dirname "$0")/.."

# clang-tidy- und Compiler-Suppression-Marker.
pattern='NOLINT|NOLINTNEXTLINE|NOLINTBEGIN|#pragma[[:space:]]+GCC[[:space:]]+diagnostic|#pragma[[:space:]]+clang[[:space:]]+diagnostic'

hits="$(grep -rnE "$pattern" src tests 2>/dev/null || true)"
if [ -n "$hits" ]; then
    echo "SUPPRESSION-GATE FAIL: Inline-Suppression gefunden (AGENTS.md §2.2)."
    echo "Ausnahmen gehören zentral in .clang-tidy mit ADR-/Slice-Begründung:"
    echo "$hits"
    exit 1
fi

echo "suppression-gate ok: keine Inline-Suppression."
exit 0
