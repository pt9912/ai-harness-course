// LH-QA-02 Determinismus — 100 Wiederholungen identischer Eingabe.
package com.example.docsearch

import com.example.docsearch.embedding.MockEmbedder
import com.example.docsearch.index.Index
import com.example.docsearch.service.SearchResponse
import com.example.docsearch.service.Searcher
import com.example.docsearch.types.IndexEntry
import com.example.docsearch.types.SearchRequest
import java.security.MessageDigest
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.RepeatedTest

class DeterminismTest {

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

    @RepeatedTest(100)
    fun `determinism_LHQA02 — gleiche Eingabe, gleicher Hash`() {
        val s = setup(20)
        val req = SearchRequest(q = "deterministisch?", k = 10)
        val r1 = s.search(req)
        val r2 = s.search(req)
        assertEquals(hash(r1), hash(r2), "non-deterministic between two calls")
    }

    private fun hash(r: SearchResponse): String {
        val md = MessageDigest.getInstance("SHA-256")
        for (sr in r.results) {
            md.update(sr.doc.toByteArray())
            md.update(sr.section.toByteArray())
            md.update(sr.score.toString().toByteArray())
        }
        return md.digest().joinToString("") { "%02x".format(it) }
    }
}
