package embedding

import "testing"

// LH-QA-02: gleicher Text → gleicher Vektor.
func TestMockEmbedder_Deterministic(t *testing.T) {
	m := MockEmbedder{}
	a, err := m.Embed("frage")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	b, _ := m.Embed("frage")
	if a != b {
		t.Errorf("Embed nicht deterministisch für identische Eingabe")
	}
}

func TestMockEmbedder_DistinctInputs(t *testing.T) {
	m := MockEmbedder{}
	a, _ := m.Embed("alpha")
	b, _ := m.Embed("beta")
	if a == b {
		t.Errorf("verschiedene Eingaben erzeugten identische Vektoren")
	}
}

func TestMockEmbedder_ComponentsInUnitRange(t *testing.T) {
	m := MockEmbedder{}
	v, _ := m.Embed("x")
	for i, f := range v {
		if f < 0 || f >= 1 {
			t.Fatalf("Komponente %d außerhalb [0,1): %v", i, f)
		}
	}
}
