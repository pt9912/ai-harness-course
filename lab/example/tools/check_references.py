#!/usr/bin/env python3
# Kurs §Referenz-Richtung (SDP) — die mechanisch entscheidbaren Kanten.
# Prueft die zwei grep-entscheidbaren Regeln der Referenz-Matrix:
#   1. KEIN Spec-Stratum (lastenheft.md, spezifikation.md, architecture.md)
#      traegt im *bindenden Text* einen ADR-/slice-Abwaertszeiger — auch
#      nicht als Quellen-Spalte. Die Aenderungskopplung deklariert die ADR
#      aufwaerts (Schaerft:-Feld); Provenance ist nur unter der Historie-/
#      Changelog-Sektion erlaubt (Regel 5) und wird ausgenommen.
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

HEADING_RE = re.compile(r"^(#{1,6})\s+(.+?)\s*$", re.MULTILINE)
DOWNWARD_REF_RE = re.compile(r"\b(?:ADR-\d+|slice-\d+)\b")
ADR_REF_RE = re.compile(r"\bADR-0*(\d+)\b")
STATUS_RE = re.compile(r"^\*\*Status:\*\*\s*(.+?)\s*$", re.MULTILINE)
PROVENANCE_HEADING_RE = re.compile(r"historie|geschichte|changelog|versionen", re.IGNORECASE)
NON_ACTIVE_RE = re.compile(r"superseded|deprecated", re.IGNORECASE)


def strip_provenance_section(text: str) -> str:
    """Schneidet die erste Provenance-Sektion (Historie/Changelog) inkl.
    Ueberschrift heraus, bis zur naechsten Ueberschrift gleicher oder
    hoeherer Ebene. Dort ist ein ADR-/slice-Verweis als Regel-5-Provenance
    erlaubt und soll nicht als Abwaertszeiger gewertet werden."""
    headings = [(m.start(), m.end(), len(m.group(1)), m.group(2)) for m in HEADING_RE.finditer(text)]
    for i, (start, _, level, title) in enumerate(headings):
        if not PROVENANCE_HEADING_RE.search(title):
            continue
        body_end = len(text)
        for n_start, _, n_level, _ in headings[i + 1:]:
            if n_level <= level:
                body_end = n_start
                break
        return text[:start] + text[body_end:]
    return text


def check_spec_strata() -> list[str]:
    errs = []
    for doc in SPEC_STRATA:
        if not doc.is_file():
            errs.append(f"{doc}: Datei nicht gefunden")
            continue
        body = strip_provenance_section(doc.read_text(encoding="utf-8"))
        for m in DOWNWARD_REF_RE.finditer(body):
            line_start = body.rfind("\n", 0, m.start()) + 1
            line_end = body.find("\n", m.start())
            snippet = body[line_start: line_end if line_end != -1 else len(body)].strip()
            errs.append(
                f"{doc}: Abwaerts-Zeiger '{m.group(0)}' im bindenden Text — "
                f"Spec-Straten referenzieren ADR/Slice nie abwaerts; die Kopplung "
                f"deklariert die ADR aufwaerts (Schaerft:-Feld), Provenance nur "
                f"unter ## Historie. Zeile: \"{snippet}\""
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
