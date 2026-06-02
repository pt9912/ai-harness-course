"""Index — Vektor-Storage, Cosinus, Tie-Break."""

from __future__ import annotations

import math

from docsearch.types import MAX_TOPK, IndexEntry, SearchResult


class Index:
    def __init__(self) -> None:
        self._entries: list[IndexEntry] = []

    def add(self, e: IndexEntry) -> None:
        self._entries.append(e)

    def size(self) -> int:
        return len(self._entries)

    def top_k(self, query: tuple[float, ...], k: int) -> list[SearchResult]:
        """Top-K mit Stable-Sort und Tie-Break (slice-009, AGENTS.md §P-4)."""
        if k <= 0 or not self._entries:
            return []
        k = min(k, MAX_TOPK)

        scored = [(self._cosine(query, e.embedding), e) for e in self._entries]
        # Tie-Break: nach Score absteigend, dann doc_path, dann section_index.
        # sorted() ist stable in Python; expliziter Tie-Break-Key garantiert Determinismus.
        scored.sort(key=lambda x: (-x[0], x[1].doc_path, x[1].section_index))

        return [
            SearchResult(doc=e.doc_path, section=e.section_title, score=score)
            for score, e in scored[:k]
        ]

    @staticmethod
    def _cosine(a: tuple[float, ...], b: tuple[float, ...]) -> float:
        dot = sum(x * y for x, y in zip(a, b, strict=True))
        na = math.sqrt(sum(x * x for x in a))
        nb = math.sqrt(sum(x * x for x in b))
        if na == 0 or nb == 0:
            return 0.0
        return dot / (na * nb)
