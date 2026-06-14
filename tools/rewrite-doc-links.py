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
# Aufruf: rewrite-doc-links.py <datei> <quell-verzeichnis> <ref> [repo-root]
#   <datei>             die (Staging-)Kopie, die in-place umgeschrieben wird
#   <quell-verzeichnis> repo-relative Heimat der Datei (z. B. kurs/de) —
#                       Basis fuer die Aufloesung relativer Links
#   <ref>               Tag (templates-v*) im Release, sonst "main" (Vorschau)
#   [repo-root]         Wurzel fuer die Existenzpruefung (Default: .)
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
    if len(sys.argv) < 4:
        print("usage: rewrite-doc-links.py <datei> <quell-verzeichnis> <ref> [repo-root]",
              file=sys.stderr)
        return 2
    path, src_dir, ref = sys.argv[1], sys.argv[2].strip("/"), sys.argv[3]
    repo_root = sys.argv[4] if len(sys.argv) > 4 else "."

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
