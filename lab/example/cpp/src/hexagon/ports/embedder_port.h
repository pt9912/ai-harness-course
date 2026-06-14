// Driven Port zum Embedding-Modell (ADR-0002).
// ADR-0001 Layer: darf nur model importieren, niemals adapters.
#pragma once

#include <string>

#include "hexagon/model/types.h"

namespace docsearch {

// EmbedderPort — Port aus ADR-0002. Konkrete LLM-Clients sind Adapter
// (siehe adapters/embedding/). Der Kern kennt nur diese Schnittstelle.
class EmbedderPort {
  public:
    EmbedderPort() = default;
    EmbedderPort(const EmbedderPort&) = default;
    EmbedderPort(EmbedderPort&&) = default;
    EmbedderPort& operator=(const EmbedderPort&) = default;
    EmbedderPort& operator=(EmbedderPort&&) = default;
    virtual ~EmbedderPort() = default;

    // Eigenschaft: gleicher Text → gleicher Vektor (LH-QA-02).
    [[nodiscard]] virtual Embedding embed(const std::string& text) const = 0;
};

}  // namespace docsearch
