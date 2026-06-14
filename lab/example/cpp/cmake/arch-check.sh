#!/usr/bin/env bash
# arch-check — hexagonale Schichtung durchsetzen (ADR-0001).
# Computational feedback (Modul 13): rot/grün, kein Vorschlag. Rein
# textbasiert (Include-Heuristik, kein C++-Parser), läuft ohne Toolchain
# und ist deshalb auch als CTest-Test registriert.
#
# Layer-Reihenfolge (ADR-0001): Types → Index → Embedding → Service → UI.
# Importe zeigen nur nach innen (Adapter → Kern, nie umgekehrt).
#
#   Regel A  Kern src/hexagon/ importiert NIE aus adapters/.
#   Regel B  Index (hexagon/index/) importiert nur model — nicht service/ports.
#   Regel C  UI-Adapter (adapters/ui/) importiert nicht index oder den
#            embedding-Adapter (nur hexagon/service + hexagon/model).
#   Regel D  Embedding-Adapter (adapters/embedding/) importiert nicht index,
#            service oder den ui-Adapter (nur ports + model).
set -euo pipefail
cd "$(dirname "$0")/.."

status=0

report() {
    echo "ARCH-CHECK FAIL ($1): $2"
    echo "$3"
    status=1
}

# --- Regel A: Kern-Reinheit ---
a_hits="$(grep -rnE '#include[[:space:]]*"adapters/' src/hexagon 2>/dev/null || true)"
[ -z "$a_hits" ] || report "ADR-0001 Regel A" \
    "Kern src/hexagon/ importiert aus adapters/" "$a_hits"

# --- Regel B: Index-Isolation ---
b_hits="$(grep -rnE '#include[[:space:]]*"hexagon/(service|ports)/' src/hexagon/index 2>/dev/null || true)"
[ -z "$b_hits" ] || report "ADR-0001 Regel B" \
    "Index importiert service/ports (erlaubt: nur hexagon/model)" "$b_hits"

# --- Regel C: UI-Adapter ---
c_hits="$(grep -rnE '#include[[:space:]]*"(hexagon/index|adapters/embedding)/' src/adapters/ui 2>/dev/null || true)"
[ -z "$c_hits" ] || report "ADR-0001 Regel C" \
    "UI-Adapter importiert index/embedding (erlaubt: hexagon/service, hexagon/model)" "$c_hits"

# --- Regel D: Embedding-Adapter ---
d_hits="$(grep -rnE '#include[[:space:]]*"(hexagon/index|hexagon/service|adapters/ui)/' src/adapters/embedding 2>/dev/null || true)"
[ -z "$d_hits" ] || report "ADR-0001 Regel D" \
    "Embedding-Adapter importiert index/service/ui (erlaubt: hexagon/ports, hexagon/model)" "$d_hits"

if [ "$status" -eq 0 ]; then
    echo "arch-check ok: hexagonale Schichtung gewahrt (ADR-0001)."
fi
exit "$status"
