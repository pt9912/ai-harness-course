// Domain-Modell, pure. ADR-0001 Layer 1 (Types).
// Reiner Kern: keine Adapter-, Framework- oder Bibliotheks-Includes.
#pragma once

#include <array>
#include <cstddef>
#include <cstdint>
#include <string>
#include <vector>

namespace docsearch {

// kEmbeddingDim aus spec/spezifikation.md §3.
inline constexpr std::size_t kEmbeddingDim = 1024;
// kMaxTopK aus spec/spezifikation.md §3, ADR-0001.
inline constexpr int kMaxTopK = 100;

using Embedding = std::array<float, kEmbeddingDim>;

// IndexEntry — Vektor + Metadaten eines Markdown-Abschnitts.
struct IndexEntry {
    std::string doc_path;
    std::string section_title;
    std::uint32_t section_index = 0;
    std::string section_text;
    Embedding embedding{};
};

// SearchResult — Treffer-Eintrag.
struct SearchResult {
    std::string doc;
    std::string section;
    float score = 0.0F;
};

// SearchRequest — Anfrage-Schema.
struct SearchRequest {
    std::string q;
    int k = 0;
};

// SearchResponse — Antwort an den UI-Adapter inkl. Clamping-Flag (LH-FA-02).
struct SearchResponse {
    std::vector<SearchResult> results;
    bool k_clamped = false;
};

}  // namespace docsearch
