// Geschäftslogik (Search). ADR-0001 Layer (Service): darf model, index,
// ports importieren; KEIN ui, KEIN konkreter Adapter.
#pragma once

#include <stdexcept>
#include <string>
#include <utility>

#include "hexagon/index/index.h"
#include "hexagon/model/types.h"
#include "hexagon/ports/embedder_port.h"

namespace docsearch {

// SearchError trägt den Fehler-Code aus spec/spezifikation.md §4
// (E002 leere Anfrage, E003 Embedding nicht verfügbar). Der UI-Adapter
// mappt den Code auf den HTTP-Status.
class SearchError : public std::runtime_error {
  public:
    SearchError(std::string code, const std::string& message)
        : std::runtime_error(message), code_(std::move(code)) {}

    [[nodiscard]] const std::string& code() const { return code_; }

  private:
    std::string code_;
};

// Searcher — Service-Fassade. Adapter werden über Ports injiziert (ADR-0001).
class Searcher {
  public:
    Searcher(const Index& idx, const EmbedderPort& emb);

    // search — LH-FA-02: Validierung → Embed → TopK → Antwort.
    [[nodiscard]] SearchResponse search(const SearchRequest& req) const;

  private:
    const Index& idx_;
    const EmbedderPort& emb_;
};

}  // namespace docsearch
