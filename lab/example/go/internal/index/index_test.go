package index

import (
	"testing"

	"github.com/example/docsearch/internal/types"
)

// uniformVec liefert ein konstantes Embedding (identischer Score → Tie-Break greift).
func uniformVec(val float32) [types.EmbeddingDim]float32 {
	var v [types.EmbeddingDim]float32
	for i := range v {
		v[i] = val
	}
	return v
}

func TestNewAndAddSize(t *testing.T) {
	idx := New()
	if idx.Size() != 0 {
		t.Fatalf("neuer Index muss leer sein, got %d", idx.Size())
	}
	idx.Add(types.IndexEntry{DocPath: "a.md", Embedding: uniformVec(1)})
	if idx.Size() != 1 {
		t.Errorf("Size nach Add = %d, want 1", idx.Size())
	}
}

func TestTopK_EmptyAndNonPositiveK(t *testing.T) {
	idx := New()
	if got := idx.TopK(uniformVec(1), 3); got != nil {
		t.Errorf("leerer Index muss nil liefern, got %v", got)
	}
	idx.Add(types.IndexEntry{DocPath: "a.md", Embedding: uniformVec(1)})
	if got := idx.TopK(uniformVec(1), 0); got != nil {
		t.Errorf("k=0 muss nil liefern, got %v", got)
	}
}

// slice-009: bei gleichem Score lexikographisch nach (DocPath, SectionIndex).
func TestTopK_TieBreakAndLimit(t *testing.T) {
	idx := New()
	q := uniformVec(1)
	idx.Add(types.IndexEntry{DocPath: "b.md", SectionIndex: 0, SectionTitle: "B", Embedding: q})
	idx.Add(types.IndexEntry{DocPath: "a.md", SectionIndex: 1, SectionTitle: "A1", Embedding: q})
	idx.Add(types.IndexEntry{DocPath: "a.md", SectionIndex: 0, SectionTitle: "A0", Embedding: q})

	res := idx.TopK(q, 2)
	if len(res) != 2 {
		t.Fatalf("want 2 Treffer (limit), got %d", len(res))
	}
	if res[0].Section != "A0" || res[1].Section != "A1" {
		t.Errorf("Tie-Break-Reihenfolge falsch: %+v", res)
	}
}

func TestTopK_KClampedToMax(t *testing.T) {
	idx := New()
	q := uniformVec(1)
	for n := 0; n < 3; n++ {
		idx.Add(types.IndexEntry{DocPath: "d.md", Embedding: q})
	}
	res := idx.TopK(q, types.MaxTopK+50)
	if len(res) != 3 {
		t.Errorf("want 3 Treffer, got %d", len(res))
	}
}

// cosine: Null-Vektor → Score 0 (na==0-Zweig).
func TestTopK_ZeroVectorScoresZero(t *testing.T) {
	idx := New()
	idx.Add(types.IndexEntry{DocPath: "z.md", Embedding: uniformVec(0)})
	res := idx.TopK(uniformVec(0), 1)
	if len(res) != 1 || res[0].Score != 0 {
		t.Errorf("Null-Vektor muss Score 0 liefern, got %+v", res)
	}
}
