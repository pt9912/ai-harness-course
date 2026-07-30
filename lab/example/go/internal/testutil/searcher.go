// Package testutil — gemeinsame Test-Fixtures für höhere Schichten.
// Liegt bewusst AUSSERHALB der ADR-0001-Layer-Hierarchie (reines
// Test-Support-Paket) und darf daher index + embedding verdrahten, ohne
// die depguard-Regel der ui-Schicht zu verletzen.
package testutil

import (
	"github.com/example/docsearch/internal/embedding"
	"github.com/example/docsearch/internal/index"
	"github.com/example/docsearch/internal/service"
	"github.com/example/docsearch/internal/types"
)

// SeededSearcher baut einen Searcher mit n identisch eingebetteten Einträgen.
func SeededSearcher(n int) *service.Searcher {
	idx := index.New()
	emb := embedding.MockEmbedder{}
	vec, _ := emb.Embed("seed")
	for i := 0; i < n; i++ {
		idx.Add(types.IndexEntry{DocPath: "d.md", Embedding: vec})
	}
	return service.NewSearcher(idx, emb)
}

// SeededHandlerParts baut Searcher und Indexer auf demselben Index — für
// UI-Tests, die beide Wege brauchen.
func SeededHandlerParts() (*service.Searcher, *service.Indexer) {
	idx := index.New()
	emb := embedding.MockEmbedder{}
	return service.NewSearcher(idx, emb), service.NewIndexer(idx, emb)
}
