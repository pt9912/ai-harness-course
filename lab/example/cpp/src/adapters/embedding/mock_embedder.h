// Embedding-Adapter (ADR-0002). Implementiert den EmbedderPort des Kerns.
// ADR-0001 Layer: darf ports + model importieren; KEIN index, service, ui.
#pragma once

#include <string>

#include "hexagon/model/types.h"
#include "hexagon/ports/embedder_port.h"

namespace docsearch {

// MockEmbedder — deterministisches Pseudo-Embedding für Tests und Lab.
// Echte LLM-Clients (lokales Modell, OpenAI etc.) sind eigene Adapter
// hinter demselben Port.
class MockEmbedder : public EmbedderPort {
  public:
    // Erzeugt einen deterministischen Vektor aus einem Hash des Texts:
    // gleicher Text → gleicher Vektor (LH-QA-02).
    [[nodiscard]] Embedding embed(const std::string& text) const override;
};

}  // namespace docsearch
