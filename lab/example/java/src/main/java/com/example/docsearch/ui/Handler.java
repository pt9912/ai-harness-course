package com.example.docsearch.ui;

import com.example.docsearch.service.Indexer;
import com.example.docsearch.service.Searcher;
import com.example.docsearch.service.Searcher.SearchResponse;
import com.example.docsearch.types.Types.SearchRequest;
import java.util.Map;

/**
 * UI-Layer. ADR-0001: importiert service + types; KEIN index, embedding direkt.
 */
public final class Handler {

    /** Antwort des UI-Layers: Status und Körper, ohne echten HTTP-Server. */
    public record HttpResult(int status, Map<String, Object> body) { }

    /** Status und Fehler-Code eines abgebildeten Fehlers. */
    public record ErrorMapping(int status, String code) { }

    private final Searcher searcher;
    private final Indexer indexer;

    public Handler(Searcher searcher) {
        this(searcher, null);
    }

    public Handler(Searcher searcher, Indexer indexer) {
        this.searcher = searcher;
        this.indexer = indexer;
    }

    /**
     * Bildet die Fehler-Codes aus spec/spezifikation.md §4 auf HTTP-Status ab.
     * Unbekannte Fehler sind E099.
     */
    public static ErrorMapping statusFor(RuntimeException exc) {
        if (exc instanceof Indexer.DirectoryNotFoundException) {
            return new ErrorMapping(400, "E001");
        }
        if (exc instanceof Searcher.EmptyQueryException) {
            return new ErrorMapping(400, "E002");
        }
        if (exc instanceof Searcher.EmbeddingUnavailableException) {
            return new ErrorMapping(503, "E003");
        }
        return new ErrorMapping(500, "E099");
    }

    public SearchResponse handleSearch(SearchRequest req) {
        return searcher.search(req);
    }

    /** Suche mit Fehler-Abbildung nach spec/spezifikation.md §4. */
    public HttpResult handleSearchHttp(SearchRequest req) {
        try {
            final SearchResponse resp = searcher.search(req);
            return new HttpResult(200, Map.of("results", resp.results()));
        } catch (RuntimeException e) {
            final ErrorMapping m = statusFor(e);
            return new HttpResult(m.status(), Map.of("error", m.code()));
        }
    }

    /** Reindex (LH-FA-01) mit Fehler-Abbildung nach spec/spezifikation.md §4. */
    public HttpResult handleReindex(String directory) {
        if (indexer == null) {
            return new HttpResult(500, Map.of("error", "E099"));
        }
        try {
            final int n = indexer.reindex(directory);
            return new HttpResult(200, Map.of("indexed_docs", n));
        } catch (RuntimeException e) {
            final ErrorMapping m = statusFor(e);
            return new HttpResult(m.status(), Map.of("error", m.code()));
        }
    }
}
