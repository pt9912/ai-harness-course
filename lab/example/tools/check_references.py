#!/usr/bin/env python3
# Kurs §Referenz-Richtung (SDP) — die mechanisch entscheidbaren Kanten.
# Prueft die zwei grep-entscheidbaren Regeln der Referenz-Matrix:
#   1. KEIN Spec-Stratum (lastenheft.md, spezifikation.md, architecture.md)
#      nennt eine ADR oder einen Slice — in keinem Abschnitt, auch nicht
#      unter ## Historie. Geprueft wird das ganze Dokument; es gibt hier
#      keine ausgenommene Sektion (Kurs §Referenz-Richtung, Regel 5).
#   2. Kein Slice referenziert eine superseded/deprecated ADR
#      (Regel 2: nur aktive ADRs sind autoritativ).
# Die semantische ADR->Slice-Unterscheidung (Verifikations-Zeiger vs.
# Entscheidungsgrundlage) ist NICHT grep-bar und gehoert zum Review-Agenten.

from __future__ import annotations

import pathlib
import re
import sys

# Alle Spec-Straten teilen dieselbe Decken-Regel: keine ADR-/slice-
# Abwaertszeiger im bindenden Text. (Vertrag, Technik, Sicht — vgl.
# Kurs §Spec-Straten. Projektspezifisch erweiterbar.)
SPEC_STRATA = [
    pathlib.Path("spec/lastenheft.md"),
    pathlib.Path("spec/spezifikation.md"),
    pathlib.Path("spec/architecture.md"),
]
PLANNING = pathlib.Path("docs/plan/planning")
ADR_DIR = pathlib.Path("docs/plan/adr")

DOWNWARD_REF_RE = re.compile(r"\b(?:ADR-\d+|slice-\d+)\b")
ADR_REF_RE = re.compile(r"\bADR-0*(\d+)\b")
STATUS_RE = re.compile(r"^\*\*Status:\*\*\s*(.+?)\s*$", re.MULTILINE)
NON_ACTIVE_RE = re.compile(r"superseded|deprecated", re.IGNORECASE)


def check_spec_strata() -> list[str]:
    errs = []
    for doc in SPEC_STRATA:
        if not doc.is_file():
            errs.append(f"{doc}: Datei nicht gefunden")
            continue
        body = doc.read_text(encoding="utf-8")
        for m in DOWNWARD_REF_RE.finditer(body):
            line_start = body.rfind("\n", 0, m.start()) + 1
            line_end = body.find("\n", m.start())
            snippet = body[line_start: line_end if line_end != -1 else len(body)].strip()
            errs.append(
                f"{doc}: Abwaerts-Zeiger '{m.group(0)}' — Spec-Straten nennen "
                f"ADR/Slice in keinem Abschnitt, auch nicht unter ## Historie "
                f"(eine Historie-Zeile wird nicht rueckwirkend korrigiert, der "
                f"Verweis rottet unreparierbar). Die Kopplung deklariert die ADR "
                f"aufwaerts im Schaerft:-Feld. Zeile: \"{snippet}\""
            )
    return errs


def adr_status(num: int) -> str | None:
    matches = sorted(ADR_DIR.glob(f"{num:04d}-*.md"))
    if not matches:
        return None
    m = STATUS_RE.search(matches[0].read_text(encoding="utf-8"))
    return m.group(1).strip() if m else None


def check_slice_adr_refs() -> list[str]:
    if not PLANNING.is_dir():
        return []
    errs = []
    for path in sorted(PLANNING.rglob("*.md")):
        text = path.read_text(encoding="utf-8")
        for num in sorted({int(m.group(1)) for m in ADR_REF_RE.finditer(text)}):
            status = adr_status(num)
            if status is None:
                continue  # noch nicht existierende/zukuenftige ADR -> Planungskontext, kein Fehler
            if NON_ACTIVE_RE.search(status):
                errs.append(
                    f"{path}: referenziert ADR-{num:04d} mit Status '{status}' — "
                    f"Slices referenzieren nur aktive ADRs (Regel 2: Autoritaet schlaegt Stabilitaet)"
                )
    return errs


def main() -> int:
    errs = check_spec_strata() + check_slice_adr_refs()
    for e in errs:
        print(e)
    if errs:
        print(f"check_references: {len(errs)} Befund(e).", file=sys.stderr)
        return 1
    print("check_references: ok (Spec-Straten sauber, keine superseded-ADR-Referenzen).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
