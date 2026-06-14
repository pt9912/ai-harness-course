#include "adapters/embedding/mock_embedder.h"

#include <cstddef>
#include <cstdint>

namespace docsearch {

namespace {

// FNV-1a-64 über die Bytes des Texts — gleiche Konstruktion wie das
// Go-/Python-Skelett, damit die Determinismus-Eigenschaft sprachübergreifend
// dieselbe Idee zeigt (nicht bitgleich über Sprachen hinweg).
std::uint64_t fnv1a64(const std::string& text) {
    std::uint64_t hash = 1469598103934665603ULL;  // offset basis
    for (const char ch : text) {
        hash ^= static_cast<std::uint64_t>(static_cast<unsigned char>(ch));
        hash *= 1099511628211ULL;  // FNV prime
    }
    return hash;
}

}  // namespace

Embedding MockEmbedder::embed(const std::string& text) const {
    Embedding out{};
    std::uint64_t seed = fnv1a64(text);
    for (std::size_t i = 0; i < kEmbeddingDim; ++i) {
        seed = (seed * 1103515245ULL) + 12345ULL;  // LCG
        out[i] = static_cast<float>((seed >> 16U) & 0x7FFFU) / 32768.0F;
    }
    return out;
}

}  // namespace docsearch
