/**
 * UI-Layer. ADR-0001: importiert service + types; KEIN index, embedding direkt.
 */
package com.example.docsearch.ui;

import com.example.docsearch.service.Searcher;
import com.example.docsearch.service.Searcher.SearchResponse;
import com.example.docsearch.types.Types.SearchRequest;

public final class Handler {
    private final Searcher searcher;

    public Handler(Searcher searcher) {
        this.searcher = searcher;
    }

    public SearchResponse handleSearch(SearchRequest req) {
        return searcher.search(req);
    }
}
