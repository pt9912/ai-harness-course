// Service-Layer (LH-FA-02). ADR-0001: importiert types, index, embedding; KEIN ui.
package com.example.docsearch.service

import com.example.docsearch.embedding.Embedder
import com.example.docsearch.index.Index
import com.example.docsearch.types.MAX_TOPK
import com.example.docsearch.types.SearchRequest
import com.example.docsearch.types.SearchResult

class EmptyQueryException(msg: String = "E002: empty query") : IllegalArgumentException(msg)
class EmbeddingUnavailableException(msg: String = "E003: embedding unavailable") : RuntimeException(msg)

data class SearchResponse(
    val results: List<SearchResult>,
    val kClamped: Boolean,
)

class Searcher(
    private val index: Index,
    private val embedder: Embedder,
) {
    fun search(req: SearchRequest): SearchResponse {
        if (req.q.isEmpty()) throw EmptyQueryException()
        var k = req.k
        var clamped = false
        if (k > MAX_TOPK) {
            k = MAX_TOPK
            clamped = true
        }
        val vec = runCatching { embedder.embed(req.q) }
            .getOrElse { throw EmbeddingUnavailableException() }
        return SearchResponse(results = index.topK(vec, k), kClamped = clamped)
    }
}
