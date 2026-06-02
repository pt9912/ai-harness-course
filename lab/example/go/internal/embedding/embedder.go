// Package embedding — Adapter zum Embedding-Modell (ADR-0002).
// ADR-0001 Layer: darf nur types importieren.
package embedding

import (
	"hash/fnv"

	"github.com/example/docsearch/internal/types"
)

// Embedder — port aus ADR-0002. Konkrete LLM-Clients sind Adapter.
type Embedder interface {
	Embed(text string) ([types.EmbeddingDim]float32, error)
}

// MockEmbedder — deterministisches Pseudo-Embedding für Tests und Lab.
// Echte LLM-Clients (lokales Modell, OpenAI etc.) sind eigene Adapter.
type MockEmbedder struct{}

// Embed erzeugt einen deterministischen Vektor aus einem Hash des Texts.
// Eigenschaft: gleicher Text → gleicher Vektor (LH-QA-02).
func (m MockEmbedder) Embed(text string) ([types.EmbeddingDim]float32, error) {
	var out [types.EmbeddingDim]float32
	h := fnv.New64a()
	_, _ = h.Write([]byte(text))
	seed := h.Sum64()
	for i := range out {
		seed = seed*1103515245 + 12345
		out[i] = float32((seed>>16)&0x7FFF) / 32768.0
	}
	return out, nil
}
