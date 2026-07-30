"""Reindex-Service (LH-FA-01). ADR-0001 Layer: nutzt index + embedding, kein ui."""

from __future__ import annotations

from pathlib import Path

from docsearch.embedding.embedder import Embedder
from docsearch.index.index import Index
from docsearch.service.search import EmbeddingUnavailableError
from docsearch.types import IndexEntry


class DirectoryNotFoundError(ValueError):
    """E001 — Verzeichnis existiert nicht."""


def _first_heading(text: str, fallback: str) -> str:
    for line in text.splitlines():
        if line.startswith("#"):
            return line.lstrip("# ").strip()
    return fallback


class Indexer:
    """Indexiert ein Verzeichnis mit `.md`-Dateien."""

    def __init__(self, idx: Index, emb: Embedder) -> None:
        self._idx = idx
        self._emb = emb

    def reindex(self, directory: str) -> int:
        """Indexiert alle `.md`-Dateien und liefert `indexed_docs`.

        Fehlt das Verzeichnis, wird `DirectoryNotFoundError` (E001) geworfen.
        Ein leeres Verzeichnis ist kein Fehler (LH-FA-01 Boundary).
        """
        base = Path(directory)
        if not base.is_dir():
            raise DirectoryNotFoundError("E001: directory not found")
        # Deterministische Reihenfolge: LH-QA-02 verlangt bit-identische
        # Ergebnisse bei identischer Eingabe.
        names = sorted(p.name for p in base.iterdir() if p.is_file() and p.suffix == ".md")
        for i, name in enumerate(names):
            text = (base / name).read_text(encoding="utf-8")
            try:
                vec = self._emb.embed(text)
            except Exception as exc:  # auf E003 abgebildet
                raise EmbeddingUnavailableError("E003: embedding unavailable") from exc
            self._idx.add(
                IndexEntry(
                    doc_path=name,
                    section_title=_first_heading(text, name),
                    section_index=i,
                    section_text=text,
                    embedding=vec,
                )
            )
        return len(names)
