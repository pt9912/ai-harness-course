// UI-Adapter (HTTP-Fassade). ADR-0001 Layer: darf service + model
// importieren; KEIN index, KEIN embedding-Adapter direkt.
#pragma once

#include <string>

#include "hexagon/model/types.h"
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

    // handle — POST /search.
    [[nodiscard]] HttpResult handle(const SearchRequest& req) const;

  private:
    const Searcher& searcher_;
};

}  // namespace docsearch
