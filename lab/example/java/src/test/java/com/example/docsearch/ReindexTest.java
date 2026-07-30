package com.example.docsearch;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.example.docsearch.embedding.Embedder;
import com.example.docsearch.embedding.MockEmbedder;
import com.example.docsearch.index.Index;
import com.example.docsearch.service.Indexer;
import com.example.docsearch.service.Searcher;
import com.example.docsearch.types.Types.SearchRequest;
import com.example.docsearch.ui.Handler;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

/** LH-FA-01 Reindex + Fehler-Abbildung E001/E002/E003/E099 (spec §4). */
class ReindexTest {

    /** Port-Double, das den Embedding-Ausfall simuliert (E003-Pfad). */
    private static final class DownEmbedder implements Embedder {
        @Override
        public float[] embed(String text) {
            throw new IllegalStateException("model down");
        }
    }

    private static Handler handler(Embedder emb) {
        final Index idx = new Index();
        return new Handler(new Searcher(idx, emb), new Indexer(idx, emb));
    }

    private static void write(Path dir, String name) throws IOException {
        Files.writeString(dir.resolve(name), "# " + name, StandardCharsets.UTF_8);
    }

    @Test
    void lhFa01HappyPath(@TempDir Path dir) throws IOException {
        write(dir, "a.md");
        write(dir, "b.md");
        final Handler.HttpResult res = handler(new MockEmbedder()).handleReindex(dir.toString());
        assertEquals(200, res.status());
        assertEquals(2, res.body().get("indexed_docs"));
    }

    @Test
    void lhFa01BoundaryEmptyDirIsNoError(@TempDir Path dir) {
        final Handler.HttpResult res = handler(new MockEmbedder()).handleReindex(dir.toString());
        assertEquals(200, res.status());
        assertEquals(0, res.body().get("indexed_docs"));
    }

    @Test
    void lhFa01NegativeMissingDirYieldsE001(@TempDir Path dir) {
        final Handler.HttpResult res =
            handler(new MockEmbedder()).handleReindex(dir.resolve("weg").toString());
        assertEquals(400, res.status());
        assertEquals("E001", res.body().get("error"));
    }

    @Test
    void lhQa02ReindexIsDeterministic(@TempDir Path dir) throws IOException {
        write(dir, "b.md");
        write(dir, "a.md");
        final MockEmbedder emb = new MockEmbedder();
        final Index first = new Index();
        new Indexer(first, emb).reindex(dir.toString());
        final Index second = new Index();
        new Indexer(second, emb).reindex(dir.toString());
        assertEquals(first.size(), second.size());
        // Bit-identische Trefferfolge über beide Läufe (LH-QA-02).
        final var a = new Searcher(first, emb).search(new SearchRequest("frage", 2)).results();
        final var b = new Searcher(second, emb).search(new SearchRequest("frage", 2)).results();
        assertEquals(a, b);
    }

    @Test
    void embeddingDownDuringReindexYieldsE003(@TempDir Path dir) throws IOException {
        write(dir, "a.md");
        final Handler.HttpResult res = handler(new DownEmbedder()).handleReindex(dir.toString());
        assertEquals(503, res.status());
        assertEquals("E003", res.body().get("error"));
    }

    @Test
    void indexerThrowsE001Directly(@TempDir Path dir) {
        final Indexer ix = new Indexer(new Index(), new MockEmbedder());
        final String missing = dir.resolve("weg").toString();
        final Indexer.DirectoryNotFoundException ex = assertThrows(
            Indexer.DirectoryNotFoundException.class, () -> ix.reindex(missing));
        assertTrue(ex.getMessage().contains("E001"));
    }

    @Test
    void statusForUnknownErrorIsE099() {
        final Handler.ErrorMapping m = Handler.statusFor(new IllegalStateException("unerwartet"));
        assertEquals(500, m.status());
        assertEquals("E099", m.code());
    }

    @Test
    void statusForAlleCodes() {
        assertEquals("E001", Handler.statusFor(new Indexer.DirectoryNotFoundException()).code());
        assertEquals("E002", Handler.statusFor(new Searcher.EmptyQueryException()).code());
        assertEquals(503, Handler.statusFor(
            new Searcher.EmbeddingUnavailableException(new IllegalStateException())).status());
    }

    @Test
    void handlerOhneIndexerLiefertE099() {
        final Handler h = new Handler(new Searcher(new Index(), new MockEmbedder()));
        final Handler.HttpResult res = h.handleReindex("/beliebig");
        assertEquals(500, res.status());
        assertEquals("E099", res.body().get("error"));
    }
}
