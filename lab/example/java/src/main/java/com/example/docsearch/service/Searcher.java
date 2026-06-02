/**
 * Service-Layer (LH-FA-02). ADR-0001: importiert types, index, embedding; KEIN ui.
 */
package com.example.docsearch.service;

import com.example.docsearch.embedding.Embedder;
import com.example.docsearch.index.Index;
import com.example.docsearch.types.Types;
import com.example.docsearch.types.Types.SearchRequest;
import com.example.docsearch.types.Types.SearchResult;
import java.util.List;

public final class Searcher {
    private final Index idx;
    private final Embedder emb;

    public Searcher(Index idx, Embedder emb) {
        this.idx = idx;
        this.emb = emb;
    }

    public static final class EmptyQueryException extends RuntimeException {
        public EmptyQueryException() { super("E002: empty query"); }
    }

    public static final class EmbeddingUnavailableException extends RuntimeException {
        public EmbeddingUnavailableException(Throwable cause) {
            super("E003: embedding unavailable", cause);
        }
    }

    public record SearchResponse(List<SearchResult> results, boolean kClamped) { }

    public SearchResponse search(SearchRequest req) {
        if (req.q() == null || req.q().isEmpty()) {
            throw new EmptyQueryException();
        }
        int k = req.k();
        boolean clamped = false;
        if (k > Types.MAX_TOPK) {
            k = Types.MAX_TOPK;
            clamped = true;
        }
        final float[] vec;
        try {
            vec = emb.embed(req.q());
        } catch (RuntimeException e) {
            throw new EmbeddingUnavailableException(e);
        }
        return new SearchResponse(idx.topK(vec, k), clamped);
    }
}
