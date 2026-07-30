package com.example.docsearch;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.example.docsearch.embedding.Embedder;
import com.example.docsearch.index.Index;
import com.example.docsearch.service.Searcher;
import com.example.docsearch.service.Searcher.EmbeddingUnavailableException;
import com.example.docsearch.types.Types.SearchRequest;
import org.junit.jupiter.api.Test;

class EmbeddingFailureTest {

    /** Port-Double, das den Embedding-Ausfall simuliert (E003-Pfad). */
    private static final class DownEmbedder implements Embedder {
        @Override
        public float[] embed(String text) {
            throw new IllegalStateException("model down");
        }
    }

    @Test
    void lhFa02NegativeEmbeddingDownYieldsE003() {
        Searcher searcher = new Searcher(new Index(), new DownEmbedder());
        EmbeddingUnavailableException ex = assertThrows(
            EmbeddingUnavailableException.class,
            () -> searcher.search(new SearchRequest("frage", 1)));
        assertTrue(ex.getMessage().contains("E003"));
    }
}
