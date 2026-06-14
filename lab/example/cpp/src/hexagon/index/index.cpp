#include "hexagon/index/index.h"

#include <algorithm>
#include <cmath>
#include <cstddef>

namespace docsearch {

namespace {

// Cosinus-Ähnlichkeit mit double-Akkumulation. NaN wird auf 0 gemappt —
// sonst ist der slice-009-Tie-Break undefiniert.
float cosine(const Embedding& a, const Embedding& b) {
    double dot = 0.0;
    double na = 0.0;
    double nb = 0.0;
    for (std::size_t i = 0; i < kEmbeddingDim; ++i) {
        dot += static_cast<double>(a[i]) * static_cast<double>(b[i]);
        na += static_cast<double>(a[i]) * static_cast<double>(a[i]);
        nb += static_cast<double>(b[i]) * static_cast<double>(b[i]);
    }
    if (na == 0.0 || nb == 0.0) {
        return 0.0F;
    }
    const auto res = static_cast<float>(dot / (std::sqrt(na) * std::sqrt(nb)));
    if (std::isnan(res)) {
        return 0.0F;
    }
    return res;
}

}  // namespace

void Index::add(const IndexEntry& entry) {
    entries_.push_back(entry);
}

std::size_t Index::size() const {
    return entries_.size();
}

std::vector<SearchResult> Index::top_k(const Embedding& query, int k) const {
    if (k <= 0 || entries_.empty()) {
        return {};
    }
    if (k > kMaxTopK) {
        k = kMaxTopK;
    }

    struct Scored {
        const IndexEntry* entry;
        float score;
    };
    std::vector<Scored> scoreds;
    scoreds.reserve(entries_.size());
    for (const auto& entry : entries_) {
        scoreds.push_back(Scored{&entry, cosine(query, entry.embedding)});
    }

    // Pflicht: stable + expliziter Tie-Break (AGENTS.md §2.7).
    std::stable_sort(scoreds.begin(), scoreds.end(), [](const Scored& lhs, const Scored& rhs) {
        if (lhs.score != rhs.score) {
            return lhs.score > rhs.score;
        }
        if (lhs.entry->doc_path != rhs.entry->doc_path) {
            return lhs.entry->doc_path < rhs.entry->doc_path;
        }
        return lhs.entry->section_index < rhs.entry->section_index;
    });

    const auto limit = std::min(static_cast<std::size_t>(k), scoreds.size());
    std::vector<SearchResult> out;
    out.reserve(limit);
    for (std::size_t j = 0; j < limit; ++j) {
        out.push_back(SearchResult{scoreds[j].entry->doc_path, scoreds[j].entry->section_title,
                                   scoreds[j].score});
    }
    return out;
}

}  // namespace docsearch
