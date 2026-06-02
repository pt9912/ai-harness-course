// Package service — Geschäftslogik (Reindex, Search).
// ADR-0001 Layer: darf types, index, embedding importieren; KEIN ui.
package service

import (
	"errors"

	"github.com/example/docsearch/internal/embedding"
	"github.com/example/docsearch/internal/index"
	"github.com/example/docsearch/internal/types"
)

// Fehler aus spec/spezifikation.md §4.
var (
	ErrEmptyQuery     = errors.New("E002: empty query")
	ErrEmbeddingDown  = errors.New("E003: embedding unavailable")
)

// Searcher — Service-Fassade.
type Searcher struct {
	idx *index.Index
	emb embedding.Embedder
}

// NewSearcher konstruiert den Service mit injizierten Adaptern.
func NewSearcher(idx *index.Index, emb embedding.Embedder) *Searcher {
	return &Searcher{idx: idx, emb: emb}
}

// SearchResponse — Antwort an UI inkl. Clamping-Flag.
type SearchResponse struct {
	Results    []types.SearchResult
	KClamped   bool
}

// Search — LH-FA-02.a: Embed → TopK → Antwort.
func (s *Searcher) Search(req types.SearchRequest) (SearchResponse, error) {
	if req.Q == "" {
		return SearchResponse{}, ErrEmptyQuery
	}

	clamped := false
	if req.K > types.MaxTopK {
		req.K = types.MaxTopK
		clamped = true
	}

	vec, err := s.emb.Embed(req.Q)
	if err != nil {
		return SearchResponse{}, ErrEmbeddingDown
	}

	return SearchResponse{
		Results:  s.idx.TopK(vec, req.K),
		KClamped: clamped,
	}, nil
}
