"""Embedder-Adapter — Port aus ADR-0002."""

from __future__ import annotations

import hashlib
from typing import Protocol

from docsearch.types import EMBEDDING_DIM


class Embedder(Protocol):
    def embed(self, text: str) -> tuple[float, ...]:
        ...


class MockEmbedder:
    """Deterministisches Pseudo-Embedding: gleicher Text → gleicher Vektor (LH-QA-02)."""

    def embed(self, text: str) -> tuple[float, ...]:
        digest = hashlib.sha256(text.encode("utf-8")).digest()
        # Deterministische LCG-Sequenz auf Basis des Hashes.
        seed = int.from_bytes(digest[:8], "big")
        out: list[float] = []
        for _ in range(EMBEDDING_DIM):
            seed = (seed * 1103515245 + 12345) & 0xFFFFFFFFFFFFFFFF
            out.append(((seed >> 16) & 0x7FFF) / 32768.0)
        return tuple(out)
