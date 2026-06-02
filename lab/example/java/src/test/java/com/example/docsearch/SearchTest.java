package com.example.docsearch;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.example.docsearch.embedding.MockEmbedder;
import com.example.docsearch.index.Index;
import com.example.docsearch.service.Searcher;
import com.example.docsearch.service.Searcher.EmptyQueryException;
import com.example.docsearch.service.Searcher.SearchResponse;
import com.example.docsearch.types.Types;
import com.example.docsearch.types.Types.IndexEntry;
import com.example.docsearch.types.Types.SearchRequest;
import org.junit.jupiter.api.Test;

class SearchTest {

    private Searcher setup(int n) {
        Index idx = new Index();
        MockEmbedder emb = new MockEmbedder();
        for (int i = 0; i < n; i++) {
            float[] vec = emb.embed("seed-" + (char) ('a' + i % 26));
            idx.add(new IndexEntry(
                "doc-" + (char) ('a' + i % 26) + ".md",
                "Section", i, "…", vec));
        }
        return new Searcher(idx, emb);
    }

    @Test
    void searchHappyPath_LHFA02() {
        Searcher s = setup(5);
        SearchResponse resp = s.search(new SearchRequest("frage", 3));
        assertEquals(3, resp.results().size());
        assertFalse(resp.kClamped());
    }

    @Test
    void searchBoundary_KClamped_LHFA02() {
        Searcher s = setup(200);
        SearchResponse resp = s.search(new SearchRequest("frage", 500));
        assertTrue(resp.kClamped());
        assertEquals(Types.MAX_TOPK, resp.results().size());
    }

    @Test
    void searchNegative_EmptyQuery_LHFA02() {
        Searcher s = setup(5);
        assertThrows(EmptyQueryException.class,
            () -> s.search(new SearchRequest("", 5)));
    }

    @Test
    void tieBreak_slice009() {
        Index idx = new Index();
        MockEmbedder emb = new MockEmbedder();
        float[] vec = emb.embed("seed");
        idx.add(new IndexEntry("b.md", "B", 0, "…", vec));
        idx.add(new IndexEntry("a.md", "A1", 1, "…", vec));
        idx.add(new IndexEntry("a.md", "A0", 0, "…", vec));

        Searcher s = new Searcher(idx, emb);
        SearchResponse resp = s.search(new SearchRequest("seed", 3));

        assertEquals("a.md", resp.results().get(0).doc());
        assertEquals("A0", resp.results().get(0).section());
        assertEquals("a.md", resp.results().get(1).doc());
        assertEquals("A1", resp.results().get(1).section());
        assertEquals("b.md", resp.results().get(2).doc());
    }
}
