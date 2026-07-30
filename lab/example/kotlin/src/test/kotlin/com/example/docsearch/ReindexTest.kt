package com.example.docsearch

import com.example.docsearch.embedding.Embedder
import com.example.docsearch.embedding.MockEmbedder
import com.example.docsearch.index.Index
import com.example.docsearch.service.DirectoryNotFoundException
import com.example.docsearch.service.EmbeddingUnavailableException
import com.example.docsearch.service.EmptyQueryException
import com.example.docsearch.service.Indexer
import com.example.docsearch.service.Searcher
import com.example.docsearch.types.SearchRequest
import com.example.docsearch.ui.Handler
import com.example.docsearch.ui.statusFor
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertThrows
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.io.TempDir
import java.io.File

/** Port-Double, das den Embedding-Ausfall simuliert (E003-Pfad). */
private class ReindexDownEmbedder : Embedder {
    override fun embed(text: String): FloatArray = error("model down")
}

/** LH-FA-01 Reindex + Fehler-Abbildung E001/E002/E003/E099 (spec §4). */
class ReindexTest {
    private fun handler(emb: Embedder): Handler {
        val idx = Index()
        return Handler(Searcher(idx, emb), Indexer(idx, emb))
    }

    private fun write(dir: File, name: String) = File(dir, name).writeText("# $name")

    @Test
    fun `LH-FA-01 Happy Path`(@TempDir dir: File) {
        write(dir, "a.md")
        write(dir, "b.md")
        val res = handler(MockEmbedder()).handleReindex(dir.path)
        assertEquals(200, res.status)
        assertEquals(2, res.body["indexed_docs"])
    }

    @Test
    fun `LH-FA-01 Boundary - leeres Verzeichnis ist kein Fehler`(@TempDir dir: File) {
        val res = handler(MockEmbedder()).handleReindex(dir.path)
        assertEquals(200, res.status)
        assertEquals(0, res.body["indexed_docs"])
    }

    @Test
    fun `LH-FA-01 Negative - fehlendes Verzeichnis liefert E001`(@TempDir dir: File) {
        val res = handler(MockEmbedder()).handleReindex(File(dir, "weg").path)
        assertEquals(400, res.status)
        assertEquals("E001", res.body["error"])
    }

    @Test
    fun `LH-QA-02 - Reindex ist deterministisch`(@TempDir dir: File) {
        write(dir, "b.md")
        write(dir, "a.md")
        val emb = MockEmbedder()
        val first = Index().also { Indexer(it, emb).reindex(dir.path) }
        val second = Index().also { Indexer(it, emb).reindex(dir.path) }
        assertEquals(first.size(), second.size())
        val a = Searcher(first, emb).search(SearchRequest("frage", 2)).results
        val b = Searcher(second, emb).search(SearchRequest("frage", 2)).results
        assertEquals(a, b)
    }

    @Test
    fun `Embedding-Ausfall im Reindex liefert E003`(@TempDir dir: File) {
        write(dir, "a.md")
        val res = handler(ReindexDownEmbedder()).handleReindex(dir.path)
        assertEquals(503, res.status)
        assertEquals("E003", res.body["error"])
    }

    @Test
    fun `Indexer wirft E001 direkt`(@TempDir dir: File) {
        val ix = Indexer(Index(), MockEmbedder())
        val ex = assertThrows(DirectoryNotFoundException::class.java) {
            ix.reindex(File(dir, "weg").path)
        }
        assertTrue(ex.message!!.contains("E001"))
    }

    @Test
    fun `unklassifizierter Fehler ist E099`() {
        assertEquals(500 to "E099", statusFor(IllegalStateException("unerwartet")))
    }

    @Test
    fun `statusFor deckt alle Codes aus spec §4 ab`() {
        assertEquals(400 to "E001", statusFor(DirectoryNotFoundException()))
        assertEquals(400 to "E002", statusFor(EmptyQueryException()))
        assertEquals(503 to "E003", statusFor(EmbeddingUnavailableException()))
    }

    @Test
    fun `Handler ohne Indexer liefert E099`() {
        val h = Handler(Searcher(Index(), MockEmbedder()))
        val res = h.handleReindex("/beliebig")
        assertEquals(500, res.status)
        assertEquals("E099", res.body["error"])
    }
}
