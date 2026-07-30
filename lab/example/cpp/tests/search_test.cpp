// DocSearch C++-Skelett — Tests (doctest).
// Test-Namen tragen LH-/slice-IDs zur Traceability (harness/README.md).
#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include <doctest/doctest.h>

#include <filesystem>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>

#include "adapters/embedding/mock_embedder.h"
#include "adapters/ui/search_handler.h"
#include "hexagon/index/index.h"
#include "hexagon/model/types.h"
#include "hexagon/ports/embedder_port.h"
#include "hexagon/service/indexer.h"
#include "hexagon/service/searcher.h"

namespace {

using docsearch::Index;
using docsearch::Indexer;
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

// TempDir — legt ein eindeutiges Verzeichnis an und räumt es wieder ab.
// Ohne Zufall: der Testname liefert den eindeutigen Namen (LH-QA-02).
class TempDir {
  public:
    explicit TempDir(const std::string& name)
        : path_(std::filesystem::temp_directory_path() / ("docsearch-" + name)) {
        std::filesystem::remove_all(path_);
        std::filesystem::create_directories(path_);
    }
    TempDir(const TempDir&) = delete;
    TempDir& operator=(const TempDir&) = delete;
    TempDir(TempDir&&) = delete;
    TempDir& operator=(TempDir&&) = delete;
    ~TempDir() {
        std::error_code ec;
        std::filesystem::remove_all(path_, ec);
    }

    [[nodiscard]] std::string str() const { return path_.string(); }

    void write(const std::string& name) const {
        std::ofstream out(path_ / name);
        out << "# " << name << "\n";
    }

  private:
    std::filesystem::path path_;
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

TEST_CASE("LH-FA-01 Happy Path — Reindex zählt indexierte Dokumente") {
    const TempDir dir("reindex-happy");
    dir.write("a.md");
    dir.write("b.md");
    const MockEmbedder emb;
    Index idx;
    const Indexer indexer(idx, emb);
    const Searcher searcher(idx, emb);
    const SearchHandler handler(searcher, indexer);

    const SearchHandler::HttpResult res = handler.handle_reindex(dir.str());

    CHECK(res.status == 200);
    CHECK(res.body == R"({"indexed_docs":2})");
    CHECK(idx.size() == 2);
}

TEST_CASE("LH-FA-01 Boundary — leeres Verzeichnis ist kein Fehler") {
    const TempDir dir("reindex-empty");
    const MockEmbedder emb;
    Index idx;
    const Indexer indexer(idx, emb);
    const Searcher searcher(idx, emb);
    const SearchHandler handler(searcher, indexer);

    const SearchHandler::HttpResult res = handler.handle_reindex(dir.str());

    CHECK(res.status == 200);
    CHECK(res.body == R"({"indexed_docs":0})");
}

TEST_CASE("LH-FA-01 Negative — fehlendes Verzeichnis liefert E001") {
    const TempDir dir("reindex-missing");
    const MockEmbedder emb;
    Index idx;
    const Indexer indexer(idx, emb);
    const Searcher searcher(idx, emb);
    const SearchHandler handler(searcher, indexer);

    const SearchHandler::HttpResult res = handler.handle_reindex(dir.str() + "/weg");

    CHECK(res.status == 400);
    CHECK(res.body == R"({"error":"E001"})");
}

TEST_CASE("LH-QA-02 Determinism — Reindex liefert dieselbe Trefferfolge") {
    const TempDir dir("reindex-determinism");
    dir.write("b.md");
    dir.write("a.md");
    const MockEmbedder emb;
    Index first;
    Index second;
    CHECK(Indexer(first, emb).reindex(dir.str()) == 2);
    CHECK(Indexer(second, emb).reindex(dir.str()) == 2);

    const SearchResponse a = Searcher(first, emb).search(SearchRequest{"frage", 2});
    const SearchResponse b = Searcher(second, emb).search(SearchRequest{"frage", 2});
    REQUIRE(a.results.size() == b.results.size());
    for (std::size_t i = 0; i < a.results.size(); ++i) {
        CHECK(a.results[i].doc == b.results[i].doc);
        CHECK(a.results[i].section == b.results[i].section);
    }
}

TEST_CASE("Reindex — Embedding-Ausfall liefert E003") {
    const TempDir dir("reindex-e003");
    dir.write("a.md");
    const ThrowingEmbedder emb;
    Index idx;
    const Indexer indexer(idx, emb);
    const Searcher searcher(idx, emb);
    const SearchHandler handler(searcher, indexer);

    const SearchHandler::HttpResult res = handler.handle_reindex(dir.str());

    CHECK(res.status == 503);
    CHECK(res.body == R"({"error":"E003"})");
}

TEST_CASE("UI-Handler — unklassifizierter Code ist E099 (Status 500)") {
    CHECK(SearchHandler::status_for("E099") == 500);
    CHECK(SearchHandler::status_for("was-auch-immer") == 500);
}

TEST_CASE("UI-Handler — status_for deckt alle Codes aus spec §4 ab") {
    CHECK(SearchHandler::status_for("E001") == 400);
    CHECK(SearchHandler::status_for("E002") == 400);
    CHECK(SearchHandler::status_for("E003") == 503);
    CHECK(SearchHandler::status_for("E099") == 500);
}

TEST_CASE("UI-Handler ohne Indexer liefert E099") {
    const MockEmbedder emb;
    const Index idx = make_index(emb, 1);
    const Searcher searcher(idx, emb);
    const SearchHandler handler(searcher);  // kein Indexer verdrahtet

    const SearchHandler::HttpResult res = handler.handle_reindex("/beliebig");

    CHECK(res.status == 500);
    CHECK(res.body == R"({"error":"E099"})");
}
