#include "adapters/ui/search_handler.h"

#include <sstream>

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

SearchHandler::HttpResult SearchHandler::handle(const SearchRequest& req) const {
    try {
        const SearchResponse resp = searcher_.search(req);
        return HttpResult{200, render_results(resp), resp.k_clamped};
    } catch (const SearchError& err) {
        int status = 500;
        if (err.code() == "E002") {
            status = 400;  // leere Anfrage
        } else if (err.code() == "E003") {
            status = 503;  // Embedding nicht verfügbar
        }
        return HttpResult{status, R"({"error":")" + err.code() + R"("})", false};
    }
}

}  // namespace docsearch
