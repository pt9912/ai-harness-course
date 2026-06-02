// Domain-Modell, Pure. ADR-0001 Layer 1.
package com.example.docsearch.types

const val EMBEDDING_DIM: Int = 1024
const val MAX_TOPK: Int = 100

data class IndexEntry(
    val docPath: String,
    val sectionTitle: String,
    val sectionIndex: Int,
    val sectionText: String,
    val embedding: FloatArray,
) {
    init {
        require(embedding.size == EMBEDDING_DIM) {
            "embedding must have $EMBEDDING_DIM dimensions"
        }
    }

    override fun equals(other: Any?): Boolean =
        other is IndexEntry &&
            docPath == other.docPath &&
            sectionIndex == other.sectionIndex &&
            sectionTitle == other.sectionTitle &&
            embedding.contentEquals(other.embedding)

    override fun hashCode(): Int {
        var h = docPath.hashCode()
        h = 31 * h + sectionIndex
        h = 31 * h + sectionTitle.hashCode()
        h = 31 * h + embedding.contentHashCode()
        return h
    }
}

data class SearchResult(val doc: String, val section: String, val score: Float)

data class SearchRequest(val q: String, val k: Int)
