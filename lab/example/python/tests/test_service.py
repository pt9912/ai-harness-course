"""Tests gegen LH-FA-02 mit ID-Bezug im Namen."""

from __future__ import annotations

import hashlib
import json

import pytest

from docsearch.embedding.embedder import MockEmbedder
from docsearch.index.index import Index
from docsearch.service.search import (
    EmptyQueryError,
    Searcher,
    SearchResponse,
)
from docsearch.types import MAX_TOPK, IndexEntry, SearchRequest


def _setup(n: int) -> Searcher:
    idx = Index()
    emb = MockEmbedder()
    for i in range(n):
        vec = emb.embed(f"seed-{chr(ord('a') + i % 26)}")
        idx.add(
            IndexEntry(
                doc_path=f"doc-{chr(ord('a') + i % 26)}.md",
                section_title="Section",
                section_index=i,
                section_text="…",
                embedding=vec,
            )
        )
    return Searcher(idx, emb)


def test_search_lhfa02_happy_path() -> None:
    s = _setup(5)
    resp = s.search(SearchRequest(q="frage", k=3))
    assert isinstance(resp, SearchResponse)
    assert len(resp.results) == 3
    assert not resp.k_clamped


def test_search_lhfa02_boundary_k_clamped() -> None:
    s = _setup(200)
    resp = s.search(SearchRequest(q="frage", k=500))
    assert resp.k_clamped
    assert len(resp.results) == MAX_TOPK


def test_search_lhfa02_negative_empty_query() -> None:
    s = _setup(5)
    with pytest.raises(EmptyQueryError):
        s.search(SearchRequest(q="", k=5))


def test_determinism() -> None:
    """LH-QA-02: identische Eingabe → identische Ausgabe."""
    s = _setup(20)
    req = SearchRequest(q="deterministisch?", k=10)
    resp1 = s.search(req)
    resp2 = s.search(req)
    h1 = hashlib.sha256(json.dumps([r.__dict__ for r in resp1.results]).encode()).hexdigest()
    h2 = hashlib.sha256(json.dumps([r.__dict__ for r in resp2.results]).encode()).hexdigest()
    assert h1 == h2


def test_search_tie_break() -> None:
    """slice-009: bei gleichem Score lexikographisch nach (doc_path, section_index)."""
    idx = Index()
    emb = MockEmbedder()
    vec = emb.embed("seed")
    idx.add(IndexEntry("b.md", "B", 0, "…", vec))
    idx.add(IndexEntry("a.md", "A1", 1, "…", vec))
    idx.add(IndexEntry("a.md", "A0", 0, "…", vec))

    s = Searcher(idx, emb)
    resp = s.search(SearchRequest(q="seed", k=3))

    assert resp.results[0].doc == "a.md" and resp.results[0].section == "A0"
    assert resp.results[1].doc == "a.md" and resp.results[1].section == "A1"
    assert resp.results[2].doc == "b.md"
