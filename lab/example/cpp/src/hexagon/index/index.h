// Vektor-Storage, Cosinus-Suche, Tie-Break.
// ADR-0001 Layer: darf nur model importieren (NICHT service, ui, ports).
#pragma once

#include <vector>

#include "hexagon/model/types.h"

namespace docsearch {

// Index — In-Memory-Index. Die Custom-Binary-Persistenz (ADR-0003) ist im
// Lab-Skelett ausgespart; das wäre ein eigener Slice.
class Index {
  public:
    void add(const IndexEntry& entry);
    [[nodiscard]] std::size_t size() const;

    // top_k — sortierte Top-K-Treffer für ein Anfrage-Embedding.
    // Tie-Break (AGENTS.md §2.7, slice-009): std::stable_sort +
    // lexikographisch nach (doc_path, section_index).
    [[nodiscard]] std::vector<SearchResult> top_k(const Embedding& query, int k) const;

  private:
    std::vector<IndexEntry> entries_;
};

}  // namespace docsearch
