// DocSearch Entry-Point — Composition Root. Verdrahtet die Schichten
// gemäß ADR-0001 (Adapter → Kern, nie umgekehrt).
#include <iostream>
#include <string>

#include "adapters/embedding/mock_embedder.h"
#include "adapters/ui/search_handler.h"
#include "hexagon/index/index.h"
#include "hexagon/service/indexer.h"
#include "hexagon/service/searcher.h"

namespace {
constexpr const char* kVersion = "0.3.0";
}  // namespace

int main(int argc, char** argv) {
    for (int i = 1; i < argc; ++i) {
        const std::string arg = argv[i];
        if (arg == "--version") {
            std::cout << kVersion << '\n';
            return 0;
        }
        if (arg == "--help") {
            std::cerr << "DocSearch " << kVersion << "\n\nNutzung: docsearch [--version]\n";
            return 0;
        }
    }

    // Wiring: model ← index, embedding(Adapter) → service → ui(Adapter).
    docsearch::Index idx;
    docsearch::MockEmbedder emb;
    docsearch::Searcher searcher(idx, emb);
    const docsearch::Indexer indexer(idx, emb);
    docsearch::SearchHandler handler(searcher, indexer);
    (void)handler;  // HTTP-Layer-Start wäre hier; im Lab-Skelett zeigen wir nur das Wiring.

    std::cout << "DocSearch wired. HTTP-Start bleibt ausserhalb des Lab-Skeletts (Lab-Grenze).\n";
    return 0;
}
