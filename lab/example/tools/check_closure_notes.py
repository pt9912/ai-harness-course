#!/usr/bin/env python3
# ADR-0011 — Closure-Note-Pflicht für done/-Slices.
# Prueft jede Datei in docs/plan/planning/done/*.md auf eine Sektion,
# deren Ueberschrift "Closure" enthaelt, und auf >=2 Saetze Substanz
# ausserhalb von Code-Bloecken. Floskeln ohne Inhalt schlagen fehl.

from __future__ import annotations

import pathlib
import re
import sys

DONE = pathlib.Path("docs/plan/planning/done")
FLOSKELN = {
    "see pr", "n/a", "siehe ticket", "wird nachgereicht",
    "fertig", "ok", "läuft jetzt", "lauft jetzt",
    "war ganz okay", "passt schon",
}
HEADING_RE = re.compile(r"^(#{1,6})\s+(.+?)\s*$", re.MULTILINE)
CODEBLOCK_RE = re.compile(r"```.*?```", re.DOTALL)
INLINE_CODE_RE = re.compile(r"`[^`]+`")


def find_closure_section(text: str) -> str | None:
    """Return the body of the first heading whose title contains 'closure',
    up to the next heading of equal or higher level (or EOF)."""
    headings = [(m.start(), m.end(), len(m.group(1)), m.group(2)) for m in HEADING_RE.finditer(text)]
    for i, (start, end, level, title) in enumerate(headings):
        if "closure" not in title.lower():
            continue
        body_start = end
        body_end = len(text)
        for j in range(i + 1, len(headings)):
            next_start, _, next_level, _ = headings[j]
            if next_level <= level:
                body_end = next_start
                break
        return text[body_start:body_end]
    return None


def count_sentences(body: str) -> int:
    cleaned = CODEBLOCK_RE.sub("", body)
    cleaned = INLINE_CODE_RE.sub("", cleaned)
    parts = re.split(r"[.!?]+", cleaned)
    return sum(1 for p in parts if p.strip())


def floskel_hits(body: str) -> list[str]:
    cleaned = CODEBLOCK_RE.sub("", body).lower()
    return sorted({f for f in FLOSKELN if re.search(rf"(?<!\w){re.escape(f)}(?!\w)", cleaned)})


def errors_for(path: pathlib.Path) -> list[str]:
    text = path.read_text(encoding="utf-8")
    body = find_closure_section(text)
    if body is None:
        return [f"{path}: keine Closure-Sektion (Ueberschrift mit 'Closure' erwartet)"]
    sentences = count_sentences(body)
    if sentences < 2:
        return [f"{path}: Closure-Sektion hat nur {sentences} Satz (mindestens 2 erwartet)"]
    hits = floskel_hits(body)
    if hits:
        return [f"{path}: Closure-Sektion enthaelt Floskel(n): {', '.join(hits)}"]
    return []


def main() -> int:
    if not DONE.is_dir():
        print(f"Verzeichnis nicht gefunden: {DONE}", file=sys.stderr)
        return 2
    files = sorted(DONE.glob("*.md"))
    if not files:
        print(f"Keine done-Dateien in {DONE} — nichts zu pruefen.")
        return 0
    errs = [e for p in files for e in errors_for(p)]
    for e in errs:
        print(e)
    if errs:
        print(f"check_closure_notes: {len(errs)} Befund(e), {len(files)} Dateien geprueft.", file=sys.stderr)
        return 1
    print(f"check_closure_notes: ok ({len(files)} Dateien geprueft).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
