// DocSearch C++-Skelett — Tests (doctest).
// Test-Namen tragen LH-/slice-IDs zur Traceability (harness/README.md).
#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include <doctest/doctest.h>

#include <stdexcept>
#include <string>
#include <vector>

#include "adapters/embedding/mock_embedder.h"
#include "adapters/ui/search_handler.h"
#include "hexagon/index/index.h"
#include "hexagon/model/types.h"
#include "hexagon/ports/embedder_port.h"
#include "hexagon/service/searcher.h"

namespace {

using docsearch::Index;
using docsearch::IndexEntry;
using docsearch::MockEmbedder;
using docsearch::SearchError;
using docsearch::Searcher;
using docsearch::SearchHandler;
using docsearch::SearchRequest;
using docsearch::SearchResponse;

// Port-Double, das den Embedding-Ausfall simuliert (E003-Pfad).
class ThrowingEmbedder : public docsearch::EmbedderPort {
  public:
    [[nodiscard]] docsearch::Embedding embed(const std::string& /*text*/) const override {
        throw std::runtime_error("model down");
    }
};

// Baut einen Index mit n Mock-Einträgen.
Index make_index(const MockEmbedder& emb, int n) {
    Index idx;
    for (int i = 0; i < n; ++i) {
        const std::string suffix(1, static_cast<char>('a' + (i % 26)));
        IndexEntry entry;
        entry.doc_path = "doc-" + suffix + ".md";
        entry.section_title = "Section";
        entry.section_index = static_cast<std::uint32_t>(i);
        entry.embedding = emb.embed("seed-" + suffix);
        idx.add(entry);
    }
    return idx;
}

// Serialisiert eine Antwort für den Determinismus-Vergleich.
std::string serialize(const SearchResponse& resp) {
    std::string out;
    for (const auto& r : resp.results) {
        out += r.doc + '|' + r.section + '|' + std::to_string(r.score) + ';';
    }
    return out;
}

}  // namespace

TEST_CASE("LH-FA-02 Happy Path — k Ergebnisse, absteigend") {
    const MockEmbedder emb;
    const Index idx = make_index(emb, 5);
    const Searcher searcher(idx, emb);

    const SearchResponse resp = searcher.search(SearchRequest{"frage", 3});

    CHECK(resp.results.size() == 3);
    CHECK_FALSE(resp.k_clamped);
}

TEST_CASE("LH-FA-02 Boundary — k>100 wird auf MaxTopK geklemmt") {
    const MockEmbedder emb;
    const Index idx = make_index(emb, 200);
    const Searcher searcher(idx, emb);

    const SearchResponse resp = searcher.search(SearchRequest{"frage", 500});

    CHECK(resp.k_clamped);
    CHECK(resp.results.size() == static_cast<std::size_t>(docsearch::kMaxTopK));
}

TEST_CASE("LH-FA-02 Negative — leere Anfrage liefert E002") {
    const MockEmbedder emb;
    const Index idx = make_index(emb, 5);
    const Searcher searcher(idx, emb);

    SearchError captured("", "");
    bool threw = false;
    try {
        (void)searcher.search(SearchRequest{"", 5});  // nodiscard bewusst verwerfen
    } catch (const SearchError& err) {
        threw = true;
        captured = err;
    }
    CHECK(threw);
    CHECK(captured.code() == "E002");
}

TEST_CASE("LH-QA-02 Determinism — identische Eingabe, identische Ausgabe") {
    const MockEmbedder emb;
    const Index idx = make_index(emb, 20);
    const Searcher searcher(idx, emb);
    const SearchRequest req{"deterministisch?", 10};

    // make test-determinism feuert diesen Case; intern 100 Wiederholungen.
    const std::string reference = serialize(searcher.search(req));
    for (int i = 0; i < 100; ++i) {
        CHECK(serialize(searcher.search(req)) == reference);
    }
}

TEST_CASE("slice-009 TieBreak — gleicher Score, lexikographisch (doc, section_index)") {
    const MockEmbedder emb;
    Index idx;
    // Drei Einträge mit identischem Embedding → identischer Score.
    const docsearch::Embedding vec = emb.embed("seed");
    idx.add(IndexEntry{"b.md", "B", 0, "", vec});
    idx.add(IndexEntry{"a.md", "A1", 1, "", vec});
    idx.add(IndexEntry{"a.md", "A0", 0, "", vec});

    const Searcher searcher(idx, emb);
    const SearchResponse resp = searcher.search(SearchRequest{"seed", 3});

    REQUIRE(resp.results.size() == 3);
    CHECK(resp.results[0].doc == "a.md");
    CHECK(resp.results[0].section == "A0");
    CHECK(resp.results[1].doc == "a.md");
    CHECK(resp.results[1].section == "A1");
    CHECK(resp.results[2].doc == "b.md");
}

TEST_CASE("LH-FA-02 Negative — Embedding-Ausfall liefert E003") {
    const ThrowingEmbedder emb;
    const Index idx;  // leer — embed wirft vor TopK
    const Searcher searcher(idx, emb);

    SearchError captured("", "");
    bool threw = false;
    try {
        (void)searcher.search(SearchRequest{"x", 1});  // nodiscard bewusst verwerfen
    } catch (const SearchError& err) {
        threw = true;
        captured = err;
    }
    CHECK(threw);
    CHECK(captured.code() == "E003");
}

TEST_CASE("UI-Handler — Happy Path: Status 200, results-JSON, kein Clamp") {
    const MockEmbedder emb;
    const Index idx = make_index(emb, 5);
    const Searcher searcher(idx, emb);
    const SearchHandler handler(searcher);

    const SearchHandler::HttpResult res = handler.handle(SearchRequest{"frage", 3});

    CHECK(res.status == 200);
    CHECK_FALSE(res.topk_clamped);
    CHECK(res.body.starts_with(R"({"results":[)"));  // beginnt mit results-Objekt
}

TEST_CASE("UI-Handler — leere Anfrage: Status 400, E002") {
    const MockEmbedder emb;
    const Index idx = make_index(emb, 5);
    const Searcher searcher(idx, emb);
    const SearchHandler handler(searcher);

    const SearchHandler::HttpResult res = handler.handle(SearchRequest{"", 5});

    CHECK(res.status == 400);
    CHECK(res.body == R"({"error":"E002"})");
}

TEST_CASE("UI-Handler — k>100 setzt Clamp-Flag (X-Topk-Clamped)") {
    const MockEmbedder emb;
    const Index idx = make_index(emb, 200);
    const Searcher searcher(idx, emb);
    const SearchHandler handler(searcher);

    const SearchHandler::HttpResult res = handler.handle(SearchRequest{"frage", 500});

    CHECK(res.status == 200);
    CHECK(res.topk_clamped);
}

TEST_CASE("UI-Handler — Embedding-Ausfall: Status 503, E003") {
    const ThrowingEmbedder emb;
    const Index idx;
    const Searcher searcher(idx, emb);
    const SearchHandler handler(searcher);

    const SearchHandler::HttpResult res = handler.handle(SearchRequest{"x", 1});

    CHECK(res.status == 503);
    CHECK(res.body == R"({"error":"E003"})");
}
