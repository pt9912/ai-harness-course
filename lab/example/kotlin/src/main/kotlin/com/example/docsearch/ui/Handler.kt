// UI-Layer. ADR-0001: importiert service + types; KEIN index, embedding direkt.
package com.example.docsearch.ui

import com.example.docsearch.service.DirectoryNotFoundException
import com.example.docsearch.service.EmbeddingUnavailableException
import com.example.docsearch.service.EmptyQueryException
import com.example.docsearch.service.Indexer
import com.example.docsearch.service.SearchResponse
import com.example.docsearch.service.Searcher
import com.example.docsearch.types.SearchRequest

private const val STATUS_OK = 200
private const val STATUS_BAD_REQUEST = 400
private const val STATUS_SERVER_ERROR = 500
private const val STATUS_UNAVAILABLE = 503

/** Antwort des UI-Layers: Status und Körper, ohne echten HTTP-Server. */
data class HttpResult(val status: Int, val body: Map<String, Any>)

/**
 * Bildet die Fehler-Codes aus spec/spezifikation.md §4 auf HTTP-Status ab.
 * Unbekannte Fehler sind E099.
 */
fun statusFor(exc: Throwable): Pair<Int, String> = when (exc) {
    is DirectoryNotFoundException -> STATUS_BAD_REQUEST to "E001"
    is EmptyQueryException -> STATUS_BAD_REQUEST to "E002"
    is EmbeddingUnavailableException -> STATUS_UNAVAILABLE to "E003"
    else -> STATUS_SERVER_ERROR to "E099"
}

class Handler(
    private val searcher: Searcher,
    private val indexer: Indexer? = null,
) {
    fun handleSearch(req: SearchRequest): SearchResponse = searcher.search(req)

    /** Suche mit Fehler-Abbildung nach spec/spezifikation.md §4. */
    fun handleSearchHttp(req: SearchRequest): HttpResult =
        runCatching { searcher.search(req) }.fold(
            onSuccess = { HttpResult(STATUS_OK, mapOf("results" to it.results)) },
            onFailure = { failure(it) },
        )

    /** Reindex (LH-FA-01) mit Fehler-Abbildung nach spec/spezifikation.md §4. */
    fun handleReindex(directory: String): HttpResult {
        val ix = indexer ?: return HttpResult(STATUS_SERVER_ERROR, mapOf("error" to "E099"))
        return runCatching { ix.reindex(directory) }.fold(
            onSuccess = { HttpResult(STATUS_OK, mapOf("indexed_docs" to it)) },
            onFailure = { failure(it) },
        )
    }

    private fun failure(exc: Throwable): HttpResult {
        val (status, code) = statusFor(exc)
        return HttpResult(status, mapOf("error" to code))
    }
}
