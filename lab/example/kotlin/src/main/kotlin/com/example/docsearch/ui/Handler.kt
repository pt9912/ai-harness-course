// UI-Layer. ADR-0001: importiert service + types; KEIN index, embedding direkt.
package com.example.docsearch.ui

import com.example.docsearch.service.SearchResponse
import com.example.docsearch.service.Searcher
import com.example.docsearch.types.SearchRequest

class Handler(private val searcher: Searcher) {
    fun handleSearch(req: SearchRequest): SearchResponse = searcher.search(req)
}
