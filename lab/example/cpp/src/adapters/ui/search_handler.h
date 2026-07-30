// UI-Adapter (HTTP-Fassade). ADR-0001 Layer: darf service + model
// importieren; KEIN index, KEIN embedding-Adapter direkt.
#pragma once

#include <string>

#include "hexagon/model/types.h"
#include "hexagon/service/indexer.h"
#include "hexagon/service/searcher.h"

namespace docsearch {

// SearchHandler — übersetzt zwischen Transport (HTTP) und Service.
// Im Lab-Skelett ohne echten HTTP-Server: handle() nimmt eine bereits
// geparste Anfrage und liefert ein transport-nahes Ergebnis.
class SearchHandler {
  public:
    struct HttpResult {
        int status = 200;
        std::string body;          // JSON-Antwortkörper
        bool topk_clamped = false;  // setzt Header X-Topk-Clamped (LH-FA-02)
    };

    explicit SearchHandler(const Searcher& searcher);
    SearchHandler(const Searcher& searcher, const Indexer& indexer);

    // handle — POST /search.
    [[nodiscard]] HttpResult handle(const SearchRequest& req) const;

    // handle_reindex — POST /reindex (LH-FA-01).
    [[nodiscard]] HttpResult handle_reindex(const std::string& dir) const;

    // status_for — Fehler-Code aus spec/spezifikation.md §4 auf HTTP-Status.
    // Unbekannte Codes sind E099 (500).
    [[nodiscard]] static int status_for(const std::string& code);

  private:
    const Searcher& searcher_;
    const Indexer* indexer_ = nullptr;
};

}  // namespace docsearch
