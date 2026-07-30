"""Tests gegen LH-FA-01 und die Fehler-Codes aus spec/spezifikation.md §4."""

from __future__ import annotations

from pathlib import Path

import pytest

from docsearch.embedding.embedder import MockEmbedder
from docsearch.index.index import Index
from docsearch.service.reindex import DirectoryNotFoundError, Indexer
from docsearch.service.search import EmbeddingUnavailableError, EmptyQueryError, Searcher
from docsearch.types import SearchRequest
from docsearch.ui import Handler, status_for


def _indexer() -> Indexer:
    return Indexer(Index(), MockEmbedder())


def _write(base: Path, *names: str) -> None:
    for name in names:
        (base / name).write_text(f"# {name}\ntext", encoding="utf-8")


def test_lh_fa_01_happy_path(tmp_path: Path) -> None:
    """LH-FA-01 Happy Path: n Dateien -> indexed_docs = n."""
    _write(tmp_path, "a.md", "b.md", "c.md")
    (tmp_path / "ignore.txt").write_text("x", encoding="utf-8")
    assert _indexer().reindex(str(tmp_path)) == 3


def test_lh_fa_01_boundary_empty_dir(tmp_path: Path) -> None:
    """LH-FA-01 Boundary: 0 Dateien, kein Fehler."""
    assert _indexer().reindex(str(tmp_path)) == 0


def test_lh_fa_01_negative_missing_dir(tmp_path: Path) -> None:
    """LH-FA-01 Negative: fehlendes Verzeichnis liefert E001."""
    with pytest.raises(DirectoryNotFoundError) as exc:
        _indexer().reindex(str(tmp_path / "gibt-es-nicht"))
    assert "E001" in str(exc.value)


def test_lh_qa_02_reindex_deterministisch(tmp_path: Path) -> None:
    """LH-QA-02: gleiche Eingabe, gleiche Zahl indexierter Dokumente."""
    _write(tmp_path, "z.md", "a.md", "m.md")
    assert _indexer().reindex(str(tmp_path)) == _indexer().reindex(str(tmp_path))


class _DownEmbedder:
    def embed(self, text: str) -> tuple[float, ...]:
        raise RuntimeError("model down")


def test_lh_fa_01_negative_embedding_down(tmp_path: Path) -> None:
    """Embedding-Ausfall waehrend der Indexierung liefert E003, nicht E001."""
    _write(tmp_path, "a.md")
    with pytest.raises(EmbeddingUnavailableError):
        Indexer(Index(), _DownEmbedder()).reindex(str(tmp_path))


def _handler(tmp: Path | None = None) -> Handler:
    idx, emb = Index(), MockEmbedder()
    return Handler(Searcher(idx, emb), Indexer(idx, emb))


def test_handler_reindex_status_codes(tmp_path: Path) -> None:
    """LH-FA-01 ueber den UI-Layer: 200/n und 400/E001."""
    _write(tmp_path, "a.md", "b.md")
    ok = _handler().handle_reindex(str(tmp_path))
    assert ok.status == 200
    assert ok.body["indexed_docs"] == 2

    missing = _handler().handle_reindex(str(tmp_path / "weg"))
    assert missing.status == 400
    assert missing.body["error"] == "E001"


def test_status_for_alle_codes() -> None:
    """Die vier Codes aus spec/spezifikation.md §4."""
    assert status_for(DirectoryNotFoundError("x")) == (400, "E001")
    assert status_for(EmptyQueryError("x")) == (400, "E002")
    assert status_for(EmbeddingUnavailableError("x")) == (503, "E003")
    assert status_for(RuntimeError("etwas Unerwartetes")) == (500, "E099")


def test_handler_search_maps_empty_query() -> None:
    """Leere Anfrage ueber den UI-Layer: 400/E002."""
    res = _handler().handle_search(SearchRequest(q="", k=1))
    assert res.status == 400
    assert res.body["error"] == "E002"
