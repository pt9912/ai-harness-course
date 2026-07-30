#include "adapters/ui/search_handler.h"

#include <sstream>

#include "hexagon/service/indexer.h"
#include "hexagon/service/searcher.h"

namespace docsearch {

namespace {

// Minimaler JSON-Renderer fürs Lab-Skelett (keine externe Bibliothek).
// Doc-Pfade und Section-Titel des Beispiels sind frei von Sonderzeichen;
// ein produktiver Adapter nutzte eine echte JSON-Bibliothek mit Escaping.
std::string render_results(const SearchResponse& resp) {
    std::ostringstream out;
    out << R"({"results":[)";
    for (std::size_t i = 0; i < resp.results.size(); ++i) {
        const auto& r = resp.results[i];
        if (i > 0) {
            out << ',';
        }
        out << R"({"doc":")" << r.doc << R"(","section":")" << r.section << R"(","score":)"
            << r.score << '}';
    }
    out << "]}";
    return out.str();
}

}  // namespace

SearchHandler::SearchHandler(const Searcher& searcher) : searcher_(searcher) {}

SearchHandler::SearchHandler(const Searcher& searcher, const Indexer& indexer)
    : searcher_(searcher), indexer_(&indexer) {}

// status_for — die Zuordnung aus spec/spezifikation.md §4 an EINER Stelle.
int SearchHandler::status_for(const std::string& code) {
    if (code == "E001") {
        return 400;  // Verzeichnis fehlt
    }
    if (code == "E002") {
        return 400;  // leere Anfrage
    }
    if (code == "E003") {
        return 503;  // Embedding nicht verfügbar
    }
    return 500;  // E099 unklassifiziert
}

SearchHandler::HttpResult SearchHandler::handle(const SearchRequest& req) const {
    try {
        const SearchResponse resp = searcher_.search(req);
        return HttpResult{200, render_results(resp), resp.k_clamped};
    } catch (const SearchError& err) {
        return HttpResult{status_for(err.code()), R"({"error":")" + err.code() + R"("})", false};
    } catch (const std::exception&) {
        return HttpResult{status_for("E099"), R"({"error":"E099"})", false};
    }
}

SearchHandler::HttpResult SearchHandler::handle_reindex(const std::string& dir) const {
    if (indexer_ == nullptr) {
        return HttpResult{status_for("E099"), R"({"error":"E099"})", false};
    }
    try {
        const int indexed = indexer_->reindex(dir);
        return HttpResult{200, R"({"indexed_docs":)" + std::to_string(indexed) + "}", false};
    } catch (const SearchError& err) {
        return HttpResult{status_for(err.code()), R"({"error":")" + err.code() + R"("})", false};
    } catch (const std::exception&) {
        return HttpResult{status_for("E099"), R"({"error":"E099"})", false};
    }
}

}  // namespace docsearch
