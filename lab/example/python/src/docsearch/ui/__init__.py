"""UI-Layer. Importiert service + types; KEIN index, embedding direkt."""

from __future__ import annotations

from dataclasses import dataclass

from docsearch.service.reindex import DirectoryNotFoundError, Indexer
from docsearch.service.search import (
    EmbeddingUnavailableError,
    EmptyQueryError,
    Searcher,
)
from docsearch.types import SearchRequest


@dataclass(frozen=True, slots=True)
class HttpResult:
    """Antwort des UI-Layers: Status und Koerper, ohne echten HTTP-Server."""

    status: int
    body: dict[str, object]


def status_for(exc: Exception) -> tuple[int, str]:
    """Bildet die Fehler-Codes aus spec/spezifikation.md §4 auf HTTP-Status ab.

    Unbekannte Fehler sind E099.
    """
    if isinstance(exc, DirectoryNotFoundError):
        return 400, "E001"
    if isinstance(exc, EmptyQueryError):
        return 400, "E002"
    if isinstance(exc, EmbeddingUnavailableError):
        return 503, "E003"
    return 500, "E099"


class Handler:
    """UI-Fassade ueber Such- und Indexierungs-Service."""

    def __init__(self, searcher: Searcher, indexer: Indexer | None = None) -> None:
        self._searcher = searcher
        self._indexer = indexer

    def handle_search(self, req: SearchRequest) -> HttpResult:
        try:
            resp = self._searcher.search(req)
        except Exception as exc:  # auf Fehler-Codes abgebildet
            status, code = status_for(exc)
            return HttpResult(status=status, body={"error": code})
        results = [
            {"doc": r.doc, "section": r.section, "score": r.score} for r in resp.results
        ]
        return HttpResult(status=200, body={"results": results})

    def handle_reindex(self, directory: str) -> HttpResult:
        if self._indexer is None:
            return HttpResult(status=500, body={"error": "E099"})
        try:
            n = self._indexer.reindex(directory)
        except Exception as exc:  # auf Fehler-Codes abgebildet
            status, code = status_for(exc)
            return HttpResult(status=status, body={"error": code})
        return HttpResult(status=200, body={"indexed_docs": n})
