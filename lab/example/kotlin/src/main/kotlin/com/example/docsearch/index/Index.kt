// Index — Vektor-Storage, Cosinus, Tie-Break.
package com.example.docsearch.index

import com.example.docsearch.types.IndexEntry
import com.example.docsearch.types.MAX_TOPK
import com.example.docsearch.types.SearchResult
import kotlin.math.sqrt

class Index {
    private val entries = mutableListOf<IndexEntry>()

    fun add(e: IndexEntry) {
        entries += e
    }

    fun size(): Int = entries.size

    fun topK(query: FloatArray, k: Int): List<SearchResult> {
        if (k <= 0 || entries.isEmpty()) return emptyList()
        val effectiveK = minOf(k, MAX_TOPK)

        // Tie-Break (slice-009, AGENTS.md §K-3): Comparator absteigend Score,
        // dann lexikographisch (docPath, sectionIndex). sortedWith ist stable.
        val scored = entries
            .map { it to cosine(query, it.embedding) }
            .sortedWith(
                compareByDescending<Pair<IndexEntry, Float>> { it.second }
                    .thenBy { it.first.docPath }
                    .thenBy { it.first.sectionIndex },
            )

        return scored.take(effectiveK).map { (e, score) ->
            SearchResult(doc = e.docPath, section = e.sectionTitle, score = score)
        }
    }

    private fun cosine(a: FloatArray, b: FloatArray): Float {
        var dot = 0.0
        var na = 0.0
        var nb = 0.0
        for (i in a.indices) {
            dot += a[i] * b[i]
            na += a[i] * a[i]
            nb += b[i] * b[i]
        }
        if (na == 0.0 || nb == 0.0) return 0.0f
        return (dot / (sqrt(na) * sqrt(nb))).toFloat()
    }
}
