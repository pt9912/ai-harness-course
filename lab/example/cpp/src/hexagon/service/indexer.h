// Geschäftslogik (Reindex). ADR-0001 Layer (Service): darf model, index,
// ports importieren; KEIN ui, KEIN konkreter Adapter.
#pragma once

#include <string>

#include "hexagon/index/index.h"
#include "hexagon/ports/embedder_port.h"
#include "hexagon/service/searcher.h"

namespace docsearch {

// Indexer — Service-Fassade für die Indexierung (LH-FA-01). Fehler tragen
// denselben SearchError-Code-Träger wie die Suche (spec §4): E001 fehlendes
// Verzeichnis, E003 Embedding nicht verfügbar.
class Indexer {
  public:
    Indexer(Index& idx, const EmbedderPort& emb);

    // reindex — LH-FA-01: alle .md-Dateien aus dir indexieren, Zahl der
    // indexierten Dokumente zurückgeben. Leeres Verzeichnis ist kein Fehler.
    int reindex(const std::string& dir) const;

  private:
    Index& idx_;
    const EmbedderPort& emb_;
};

}  // namespace docsearch
