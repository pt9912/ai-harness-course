"""Search-Service (LH-FA-02)."""

from __future__ import annotations

from dataclasses import dataclass

from docsearch.embedding.embedder import Embedder
from docsearch.index.index import Index
from docsearch.types import MAX_TOPK, SearchRequest, SearchResult


class EmptyQueryError(ValueError):
    """E002 — leere Anfrage."""


class EmbeddingUnavailableError(RuntimeError):
    """E003 — Embedding-Adapter nicht erreichbar."""


@dataclass(frozen=True, slots=True)
class SearchResponse:
    results: list[SearchResult]
    k_clamped: bool


class Searcher:
    def __init__(self, idx: Index, emb: Embedder) -> None:
        self._idx = idx
        self._emb = emb

    def search(self, req: SearchRequest) -> SearchResponse:
        if not req.q:
            raise EmptyQueryError("E002: empty query")

        clamped = False
        k = req.k
        if k > MAX_TOPK:
            k = MAX_TOPK
            clamped = True

        try:
            vec = self._emb.embed(req.q)
        except Exception as exc:
            raise EmbeddingUnavailableError("E003: embedding unavailable") from exc

        return SearchResponse(results=self._idx.top_k(vec, k), k_clamped=clamped)
