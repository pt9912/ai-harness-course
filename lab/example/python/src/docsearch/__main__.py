"""DocSearch Entry-Point. ADR-0001 Wiring."""

from __future__ import annotations

import sys

from docsearch import __version__
from docsearch.embedding.embedder import MockEmbedder
from docsearch.index.index import Index
from docsearch.service.search import Searcher


def main() -> int:
    if "--version" in sys.argv:
        print(__version__)
        return 0
    if "--help" in sys.argv or len(sys.argv) < 2:
        print(f"DocSearch {__version__}\n\nNutzung: python -m docsearch [--version]")
        return 0

    idx = Index()
    emb = MockEmbedder()
    _ = Searcher(idx, emb)
    print("DocSearch wired. HTTP-Start ist in Welle-4-Slice geplant.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
