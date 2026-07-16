#!/usr/bin/env python3
# rewrite-doc-links — macht ein einzelnes Markdown-Dokument self-contained,
# wenn es AUSSERHALB seines Repos ausgeliefert/kopiert wird: schreibt seine
# repo-internen relativen Links auf absolute GitHub-blob-URLs (auf <ref>
# gepinnt) um. Gegenstueck zu rewrite-template-links.sh, aber fuer eine
# einzelne, woanders ausgelieferte Datei (z. B. agents-regelwerk.md als
# Release-Asset neben lab-templates.zip).
#
# Robust gegen illustrative Pfade: umgeschrieben wird NUR, was
#   (a) ausserhalb eines ```-/~~~-Codeblocks steht UND
#   (b) als reale Datei/Verzeichnis im Repo aufloest.
# Damit bleiben Adopter-Repo-Beispielpfade (spec/..., docs/plan/..., die es
# unter der Quell-Ebene nicht gibt) unangetastet. Anker (#...), http(s)://
# und mailto: bleiben ebenfalls unveraendert.
#
# Aufruf: rewrite-doc-links.py <datei> <quell-verzeichnis> <ref> [repo-root] [--keep-within-src]
#   <datei>             die (Staging-)Kopie, die in-place umgeschrieben wird
#   <quell-verzeichnis> repo-relative Heimat der Datei (z. B. kurs/de) —
#                       Basis fuer die Aufloesung relativer Links
#   <ref>               Release-Tag (vX.Y.Z), sonst "main" (Vorschau)
#   [repo-root]         Wurzel fuer die Existenzpruefung (Default: .)
#   --keep-within-src   Links, die INNERHALB von <quell-verzeichnis> aufloesen,
#                       relativ lassen — fuer Verzeichnis-Bundles (z. B.
#                       lab/regelwerk), deren Modul-Querverweise mit dem ZIP
#                       mitreisen; nur Verweise NACH AUSSEN werden gepinnt.
#                       (Fuer Einzeldatei-Auslieferung wie agents-regelwerk.md
#                       weglassen — dort muss alles absolut werden.)
#   --keep-within=<dir> Zusaetzliche repo-relative Wurzel (wiederholbar), deren
#                       Verweise ebenfalls relativ bleiben. Fuer self-contained
#                       Baseline-Bundles, die MEHRERE Verzeichnisse parallel
#                       tragen — z. B. `lab/regelwerk` (Quelle) + `lab/templates`
#                       (als `regelwerk/` + `templates/` im ZIP), damit die
#                       `../templates/…`-Ziel-Form-Verweise netzlos mitreisen
#                       statt auf eine blob-URL gepinnt zu werden.
from __future__ import annotations

import os
import posixpath
import re
import sys

BASE = "https://github.com/pt9912/ai-harness-course/blob"
LINK_RE = re.compile(r"(\]\()([^)]+)(\))")
FENCE_RE = re.compile(r"^\s*(```|~~~)")
SKIP_PREFIXES = ("#", "http://", "https://", "mailto:")


def main() -> int:
    keep_within = "--keep-within-src" in sys.argv[1:]
    extra_within = [a.split("=", 1)[1].strip("/")
                    for a in sys.argv[1:] if a.startswith("--keep-within=")]
    argv = [a for a in sys.argv[1:]
            if a != "--keep-within-src" and not a.startswith("--keep-within=")]
    if len(argv) < 3:
        print("usage: rewrite-doc-links.py <datei> <quell-verzeichnis> <ref> [repo-root] "
              "[--keep-within-src] [--keep-within=<dir> …]", file=sys.stderr)
        return 2
    path, src_dir, ref = argv[0], argv[1].strip("/"), argv[2]
    repo_root = argv[3] if len(argv) > 3 else "."
    within_roots = ([src_dir] if keep_within else []) + extra_within

    rewritten = 0

    def repl(match: "re.Match[str]") -> str:
        nonlocal rewritten
        target = match.group(2)
        if target.startswith(SKIP_PREFIXES):
            return match.group(0)
        link, frag = (target.split("#", 1) + [""])[:2]
        frag = "#" + frag if "#" in target else ""
        trailing = "/" if link.endswith("/") else ""
        resolved = posixpath.normpath(posixpath.join(src_dir, link))
        # Nur umschreiben, was real im Repo existiert (sonst illustrativ).
        if not os.path.exists(os.path.join(repo_root, resolved)):
            return match.group(0)
        # Verweise, die innerhalb einer mitgelieferten Bundle-Wurzel bleiben,
        # relativ lassen (sie reisen mit dem Bundle — Modul-Querverweise via
        # --keep-within-src, ../templates/-Ziel-Form-Verweise via --keep-within).
        if any(resolved == r or resolved.startswith(r + "/") for r in within_roots):
            return match.group(0)
        rewritten += 1
        return f"{match.group(1)}{BASE}/{ref}/{resolved}{trailing}{frag}{match.group(3)}"

    in_fence = False
    out = []
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            if FENCE_RE.match(line):
                in_fence = not in_fence
                out.append(line)
                continue
            out.append(line if in_fence else LINK_RE.sub(repl, line))

    with open(path, "w", encoding="utf-8") as fh:
        fh.writelines(out)

    print(f"rewrite-doc-links: {rewritten} Link(s) auf blob/{ref} gepinnt in {path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
