package com.example.docsearch

import com.example.docsearch.embedding.MockEmbedder
import com.example.docsearch.index.Index
import com.example.docsearch.service.EmptyQueryException
import com.example.docsearch.service.Searcher
import com.example.docsearch.types.IndexEntry
import com.example.docsearch.types.MAX_TOPK
import com.example.docsearch.types.SearchRequest
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertFalse
import org.junit.jupiter.api.Assertions.assertThrows
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test

class SearchTest {
    private fun setup(n: Int): Searcher {
        val idx = Index()
        val emb = MockEmbedder()
        for (i in 0 until n) {
            val vec = emb.embed("seed-${'a' + i % 26}")
            idx.add(
                IndexEntry(
                    docPath = "doc-${'a' + i % 26}.md",
                    sectionTitle = "Section",
                    sectionIndex = i,
                    sectionText = "…",
                    embedding = vec,
                ),
            )
        }
        return Searcher(idx, emb)
    }

    @Test
    fun searchHappyPath_LHFA02() {
        val s = setup(5)
        val resp = s.search(SearchRequest(q = "frage", k = 3))
        assertEquals(3, resp.results.size)
        assertFalse(resp.kClamped)
    }

    @Test
    fun searchBoundary_KClamped_LHFA02() {
        val s = setup(200)
        val resp = s.search(SearchRequest(q = "frage", k = 500))
        assertTrue(resp.kClamped)
        assertEquals(MAX_TOPK, resp.results.size)
    }

    @Test
    fun searchNegative_EmptyQuery_LHFA02() {
        val s = setup(5)
        assertThrows(EmptyQueryException::class.java) {
            s.search(SearchRequest(q = "", k = 5))
        }
    }

    @Test
    fun tieBreak_DocPathThenSectionIndex_slice009() {
        val idx = Index()
        val emb = MockEmbedder()
        val vec = emb.embed("seed")
        idx.add(IndexEntry("b.md", "B", 0, "…", vec))
        idx.add(IndexEntry("a.md", "A1", 1, "…", vec))
        idx.add(IndexEntry("a.md", "A0", 0, "…", vec))

        val s = Searcher(idx, emb)
        val resp = s.search(SearchRequest(q = "seed", k = 3))

        assertEquals("a.md", resp.results[0].doc)
        assertEquals("A0", resp.results[0].section)
        assertEquals("a.md", resp.results[1].doc)
        assertEquals("A1", resp.results[1].section)
        assertEquals("b.md", resp.results[2].doc)
    }
}
