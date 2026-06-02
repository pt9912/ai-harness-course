package service

import (
	"crypto/sha256"
	"encoding/json"
	"errors"
	"testing"

	"github.com/example/docsearch/internal/embedding"
	"github.com/example/docsearch/internal/index"
	"github.com/example/docsearch/internal/types"
)

// TestSearch_LHFA02_HappyPath — LH-FA-02 Happy Path.
func TestSearch_LHFA02_HappyPath(t *testing.T) {
	s := setup(t, 5)
	resp, err := s.Search(types.SearchRequest{Q: "frage", K: 3})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(resp.Results) != 3 {
		t.Errorf("expected 3 results, got %d", len(resp.Results))
	}
	if resp.KClamped {
		t.Errorf("k=3 should not clamp")
	}
}

// TestSearch_LHFA02_Boundary_KClamped — LH-FA-02 Boundary.
func TestSearch_LHFA02_Boundary_KClamped(t *testing.T) {
	s := setup(t, 200)
	resp, err := s.Search(types.SearchRequest{Q: "frage", K: 500})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !resp.KClamped {
		t.Errorf("k=500 must clamp to MaxTopK=100")
	}
	if len(resp.Results) != types.MaxTopK {
		t.Errorf("expected %d results, got %d", types.MaxTopK, len(resp.Results))
	}
}

// TestSearch_LHFA02_Negative_EmptyQuery — LH-FA-02 Negative.
func TestSearch_LHFA02_Negative_EmptyQuery(t *testing.T) {
	s := setup(t, 5)
	_, err := s.Search(types.SearchRequest{Q: "", K: 5})
	if err == nil {
		t.Fatal("expected ErrEmptyQuery, got nil")
	}
	if !errors.Is(err, ErrEmptyQuery) {
		t.Errorf("expected ErrEmptyQuery, got %v", err)
	}
}

// TestDeterminism — LH-QA-02: identische Eingabe → identische Ausgabe.
// Wird von `make test-determinism` 100x gefahren.
func TestDeterminism(t *testing.T) {
	s := setup(t, 20)
	req := types.SearchRequest{Q: "deterministisch?", K: 10}
	resp1, err := s.Search(req)
	if err != nil {
		t.Fatalf("err: %v", err)
	}
	resp2, err := s.Search(req)
	if err != nil {
		t.Fatalf("err: %v", err)
	}
	if hash(t, resp1) != hash(t, resp2) {
		t.Errorf("non-deterministic: hashes differ")
	}
}

// TestSearch_TieBreak — slice-009: bei gleichem Score lexikographisch
// nach (DocPath, SectionIndex).
func TestSearch_TieBreak(t *testing.T) {
	idx := index.New()
	// Zwei Einträge mit identischem Embedding → identischer Score.
	emb := embedding.MockEmbedder{}
	vec, _ := emb.Embed("seed")
	idx.Add(types.IndexEntry{DocPath: "b.md", SectionIndex: 0, SectionTitle: "B", Embedding: vec})
	idx.Add(types.IndexEntry{DocPath: "a.md", SectionIndex: 1, SectionTitle: "A1", Embedding: vec})
	idx.Add(types.IndexEntry{DocPath: "a.md", SectionIndex: 0, SectionTitle: "A0", Embedding: vec})

	s := NewSearcher(idx, emb)
	resp, err := s.Search(types.SearchRequest{Q: "seed", K: 3})
	if err != nil {
		t.Fatalf("err: %v", err)
	}
	// Erwartet: a.md#0, a.md#1, b.md#0 (lexikographisch).
	if resp.Results[0].Doc != "a.md" || resp.Results[0].Section != "A0" {
		t.Errorf("tie-break broken at [0]: got %+v", resp.Results[0])
	}
	if resp.Results[1].Doc != "a.md" || resp.Results[1].Section != "A1" {
		t.Errorf("tie-break broken at [1]: got %+v", resp.Results[1])
	}
	if resp.Results[2].Doc != "b.md" {
		t.Errorf("tie-break broken at [2]: got %+v", resp.Results[2])
	}
}

func setup(t *testing.T, n int) *Searcher {
	t.Helper()
	idx := index.New()
	emb := embedding.MockEmbedder{}
	for i := 0; i < n; i++ {
		vec, _ := emb.Embed("seed-" + string(rune('a'+i%26)))
		idx.Add(types.IndexEntry{
			DocPath:      "doc-" + string(rune('a'+i%26)) + ".md",
			SectionTitle: "Section",
			SectionIndex: uint32(i),
			Embedding:    vec,
		})
	}
	return NewSearcher(idx, emb)
}

func hash(t *testing.T, v interface{}) string {
	t.Helper()
	b, err := json.Marshal(v)
	if err != nil {
		t.Fatalf("marshal: %v", err)
	}
	h := sha256.Sum256(b)
	return string(h[:])
}
