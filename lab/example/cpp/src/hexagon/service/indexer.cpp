#include "hexagon/service/indexer.h"

#include <algorithm>
#include <filesystem>
#include <fstream>
#include <sstream>
#include <vector>

namespace docsearch {

namespace {

// first_heading — erste Markdown-Überschrift oder der Dateiname.
std::string first_heading(const std::string& text, const std::string& fallback) {
    std::istringstream in(text);
    std::string line;
    while (std::getline(in, line)) {
        if (!line.empty() && line.front() == '#') {
            const auto start = line.find_first_not_of("# ");
            if (start != std::string::npos) {
                return line.substr(start);
            }
        }
    }
    return fallback;
}

std::string read_file(const std::filesystem::path& path) {
    std::ifstream in(path);
    std::ostringstream buf;
    buf << in.rdbuf();
    return buf.str();
}

}  // namespace

Indexer::Indexer(Index& idx, const EmbedderPort& emb) : idx_(idx), emb_(emb) {}

int Indexer::reindex(const std::string& dir) const {
    std::error_code ec;
    if (!std::filesystem::is_directory(dir, ec) || ec) {
        throw SearchError("E001", "directory not found");  // LH-FA-01 Negative
    }

    std::vector<std::filesystem::path> files;
    for (const auto& entry : std::filesystem::directory_iterator(dir, ec)) {
        if (entry.is_regular_file() && entry.path().extension() == ".md") {
            files.push_back(entry.path());
        }
    }
    // Deterministische Reihenfolge: LH-QA-02 verlangt bit-identische
    // Ergebnisse, directory_iterator garantiert keine Sortierung.
    std::sort(files.begin(), files.end());

    std::uint32_t position = 0;
    for (const auto& path : files) {
        const std::string text = read_file(path);
        const std::string name = path.filename().string();
        Embedding vec{};
        try {
            vec = emb_.embed(text);
        } catch (const std::exception&) {
            throw SearchError("E003", "embedding unavailable");
        }
        idx_.add(IndexEntry{name, first_heading(text, name), position, text, vec});
        ++position;
    }
    return static_cast<int>(files.size());
}

}  // namespace docsearch
