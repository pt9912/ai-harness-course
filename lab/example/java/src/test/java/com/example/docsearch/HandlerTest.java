package com.example.docsearch;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.example.docsearch.embedding.MockEmbedder;
import com.example.docsearch.index.Index;
import com.example.docsearch.service.Searcher;
import com.example.docsearch.types.Types.IndexEntry;
import com.example.docsearch.types.Types.SearchRequest;
import com.example.docsearch.ui.Handler;
import org.junit.jupiter.api.Test;

/** UI-Layer-Tests (ADR-0001): Handler delegiert an den Service. */
class HandlerTest {

    private Handler handler(int n) {
        final Index idx = new Index();
        final MockEmbedder emb = new MockEmbedder();
        for (int i = 0; i < n; i++) {
            idx.add(new IndexEntry("d.md", "S", i, "txt", emb.embed("seed")));
        }
        return new Handler(new Searcher(idx, emb));
    }

    @Test
    void delegatesToService() {
        final var resp = handler(3).handleSearch(new SearchRequest("frage", 2));
        assertEquals(2, resp.results().size());
        assertFalse(resp.kClamped());
    }

    @Test
    void clampsLargeK() {
        final var resp = handler(3).handleSearch(new SearchRequest("frage", 500));
        assertTrue(resp.kClamped());
    }

    @Test
    void emptyQueryThrows() {
        final Handler h = handler(1);
        final SearchRequest req = new SearchRequest("", 1);
        assertThrows(Searcher.EmptyQueryException.class, () -> h.handleSearch(req));
    }
}
