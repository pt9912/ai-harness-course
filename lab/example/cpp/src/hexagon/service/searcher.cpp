#include "hexagon/service/searcher.h"

namespace docsearch {

Searcher::Searcher(const Index& idx, const EmbedderPort& emb) : idx_(idx), emb_(emb) {}

SearchResponse Searcher::search(const SearchRequest& req) const {
    if (req.q.empty()) {
        throw SearchError("E002", "empty query");  // LH-FA-02 Negative
    }

    SearchRequest effective = req;
    bool clamped = false;
    if (effective.k > kMaxTopK) {  // LH-FA-02 Boundary
        effective.k = kMaxTopK;
        clamped = true;
    }

    Embedding vec{};
    try {
        vec = emb_.embed(effective.q);
    } catch (const std::exception&) {
        throw SearchError("E003", "embedding unavailable");
    }

    return SearchResponse{idx_.top_k(vec, effective.k), clamped};
}

}  // namespace docsearch
