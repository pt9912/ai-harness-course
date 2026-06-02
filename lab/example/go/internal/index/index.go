// Package index — Vektor-Storage, Cosinus-Suche, Tie-Break.
// ADR-0001 Layer: darf nur types importieren. ADR-0003 Format.
package index

import (
	"math"
	"sort"

	"github.com/example/docsearch/internal/types"
)

// Index — In-Memory-Index. Custom-Binary-Persistenz (ADR-0003) ist
// im Lab-Skelett ausgespart; das wäre ein eigener Slice.
type Index struct {
	entries []types.IndexEntry
}

// New erzeugt einen leeren Index.
func New() *Index {
	return &Index{entries: nil}
}

// Add fügt einen Eintrag hinzu.
func (i *Index) Add(e types.IndexEntry) {
	i.entries = append(i.entries, e)
}

// Size — aktuelle Größe.
func (i *Index) Size() int {
	return len(i.entries)
}

// TopK — sortierte Top-K-Treffer für eine Anfrage-Embedding.
// Tie-Break (AGENTS.md §G-3, slice-009): sort.SliceStable + lexikographisch
// (DocPath, SectionIndex).
func (i *Index) TopK(query [types.EmbeddingDim]float32, k int) []types.SearchResult {
	if k <= 0 || i.Size() == 0 {
		return nil
	}
	if k > types.MaxTopK {
		k = types.MaxTopK
	}

	type scored struct {
		entry types.IndexEntry
		score float32
	}
	scoreds := make([]scored, len(i.entries))
	for idx, e := range i.entries {
		scoreds[idx] = scored{entry: e, score: cosine(query, e.Embedding)}
	}

	// Pflicht: stable + expliziter Tie-Break.
	sort.SliceStable(scoreds, func(a, b int) bool {
		if scoreds[a].score != scoreds[b].score {
			return scoreds[a].score > scoreds[b].score
		}
		if scoreds[a].entry.DocPath != scoreds[b].entry.DocPath {
			return scoreds[a].entry.DocPath < scoreds[b].entry.DocPath
		}
		return scoreds[a].entry.SectionIndex < scoreds[b].entry.SectionIndex
	})

	limit := k
	if limit > len(scoreds) {
		limit = len(scoreds)
	}
	out := make([]types.SearchResult, limit)
	for j := 0; j < limit; j++ {
		out[j] = types.SearchResult{
			Doc:     scoreds[j].entry.DocPath,
			Section: scoreds[j].entry.SectionTitle,
			Score:   scoreds[j].score,
		}
	}
	return out
}

func cosine(a, b [types.EmbeddingDim]float32) float32 {
	var dot, na, nb float64
	for i := 0; i < types.EmbeddingDim; i++ {
		dot += float64(a[i]) * float64(b[i])
		na += float64(a[i]) * float64(a[i])
		nb += float64(b[i]) * float64(b[i])
	}
	if na == 0 || nb == 0 {
		return 0
	}
	return float32(dot / (math.Sqrt(na) * math.Sqrt(nb)))
}
