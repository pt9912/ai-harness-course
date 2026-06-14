#!/usr/bin/env python3
# regelwerk-drift — erkennt, ob sich die adoptierte agents-regelwerk.md
# (externe Form-Quelle, Source Precedence) seit der Adoption geaendert hat.
#
# INHALTSBASIERT, nicht Stand-Marker-basiert: vergleicht den sha256 der
# Quelle gegen den in harness/conventions.md (§Baseline, "Regelwerk-Pin:")
# gepinnten Hash. Faengt damit auch Aenderungen, bei denen der Maintainer
# die `**Stand:**`-Zeile NICHT gebumpt hat (siehe agents-regelwerk.md
# §"Nachweis ueber Inhalt, nicht Diff"). Der Stand-Marker ist die
# menschenlesbare Beschreibung; der Hash ist die Wahrheit.
#
# KEIN gates-Glied: braucht die externe Quelle (fuer echte Adopter Netz).
# Wie b-cad `schema-check` periodisch / in CI, nicht pro Slice.
#
# Quelle ueber $REGELWERK_SRC (Pfad ODER http-URL). Default fuer dieses
# In-Repo-Beispiel ist der lokale Kurspfad; externe Adopter setzen die
# Raw-URL aus conventions.md (§Adoptierte Konventions-Quellen):
#   REGELWERK_SRC=https://raw.githubusercontent.com/pt9912/ai-harness-course/main/kurs/de/agents-regelwerk.md
#
# Re-Sync bei Drift: agents-regelwerk.md neu lesen, conventions.md
# §Baseline (Stand + Pin) aktualisieren, betroffene Adaptionen pruefen.
from __future__ import annotations

import hashlib
import os
import pathlib
import re
import sys
import urllib.request

CONVENTIONS = pathlib.Path("harness/conventions.md")
DEFAULT_SRC = "../../kurs/de/agents-regelwerk.md"
PIN_RE = re.compile(r"Regelwerk-Pin:\*\*\s*sha256:([0-9a-f]{64})")
STAND_RE = re.compile(r"^\*\*Stand:\*\*\s*(.+)$", re.MULTILINE)


def fail(msg: str) -> None:
    # fail-closed: fehlt das Pruefmittel, blockiert der Sensor (nicht durchwinken).
    print(f"regelwerk-drift FAIL (fail-closed): {msg}", file=sys.stderr)
    sys.exit(2)


def load_source(src: str) -> bytes:
    try:
        if src.startswith(("http://", "https://")):
            with urllib.request.urlopen(src, timeout=15) as resp:
                return resp.read()
        return pathlib.Path(src).read_bytes()
    except Exception as exc:  # Quelle unerreichbar -> fail-closed
        fail(f"Quelle '{src}' nicht lesbar: {exc}")
        raise  # unreachable (fail() beendet), haelt aber den Typ-Checker ruhig


def main() -> int:
    if not CONVENTIONS.is_file():
        fail(f"{CONVENTIONS} fehlt (Pin-Quelle).")
    pin_match = PIN_RE.search(CONVENTIONS.read_text(encoding="utf-8"))
    if not pin_match:
        fail(f"Kein 'Regelwerk-Pin:' in {CONVENTIONS} §Baseline. "
             "Erst pinnen (sha256 der adoptierten agents-regelwerk.md).")
    pinned = pin_match.group(1)

    src = os.environ.get("REGELWERK_SRC", DEFAULT_SRC)
    data = load_source(src)
    actual = hashlib.sha256(data).hexdigest()

    if actual == pinned:
        print(f"regelwerk-drift OK: sha256 {actual[:12]}… == Pin (Quelle: {src})")
        return 0

    stand = STAND_RE.search(data.decode("utf-8", "replace"))
    print("regelwerk-drift: DRIFT — die adoptierte agents-regelwerk.md "
          "hat sich geaendert.", file=sys.stderr)
    print(f"  Pin:     sha256:{pinned}", file=sys.stderr)
    print(f"  Aktuell: sha256:{actual}", file=sys.stderr)
    if stand:
        print(f"  Upstream-Stand: {stand.group(1).strip()}", file=sys.stderr)
    print("  -> agents-regelwerk.md neu lesen, conventions.md §Baseline "
          "(Stand + Pin) aktualisieren, Adaptionen pruefen.", file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main())
