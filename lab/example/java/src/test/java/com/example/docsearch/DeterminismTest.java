// LH-QA-02 Determinismus — 100 Wiederholungen identischer Eingabe.
package com.example.docsearch;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.example.docsearch.embedding.MockEmbedder;
import com.example.docsearch.index.Index;
import com.example.docsearch.service.Searcher;
import com.example.docsearch.service.Searcher.SearchResponse;
import com.example.docsearch.types.Types.IndexEntry;
import com.example.docsearch.types.Types.SearchRequest;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import org.junit.jupiter.api.RepeatedTest;

class DeterminismTest {

    private static Searcher setup(int n) {
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

    @RepeatedTest(100)
    void determinism_LHQA02() {
        Searcher s = setup(20);
        SearchRequest req = new SearchRequest("deterministisch?", 10);
        SearchResponse r1 = s.search(req);
        SearchResponse r2 = s.search(req);
        assertEquals(hash(r1), hash(r2), "non-deterministic between two calls");
    }

    private static String hash(SearchResponse r) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            for (var sr : r.results()) {
                md.update(sr.doc().getBytes());
                md.update(sr.section().getBytes());
                md.update(Float.toString(sr.score()).getBytes());
            }
            return java.util.HexFormat.of().formatHex(md.digest());
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException(e);
        }
    }
}
