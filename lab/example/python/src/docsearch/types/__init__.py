"""Domain-Modell, Pure. ADR-0001 Layer 1."""

from __future__ import annotations

from dataclasses import dataclass

EMBEDDING_DIM: int = 1024
MAX_TOPK: int = 100


@dataclass(frozen=True, slots=True)
class IndexEntry:
    doc_path: str
    section_title: str
    section_index: int
    section_text: str
    embedding: tuple[float, ...]  # Länge = EMBEDDING_DIM


@dataclass(frozen=True, slots=True)
class SearchResult:
    doc: str
    section: str
    score: float


@dataclass(frozen=True, slots=True)
class SearchRequest:
    q: str
    k: int
