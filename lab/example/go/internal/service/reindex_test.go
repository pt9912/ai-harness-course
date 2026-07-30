package service

import (
	"errors"
	"os"
	"path/filepath"
	"testing"

	"github.com/example/docsearch/internal/embedding"
	"github.com/example/docsearch/internal/index"
)

func newIndexer(t *testing.T) *Indexer {
	t.Helper()
	return NewIndexer(index.New(), embedding.MockEmbedder{})
}

// TestReindex_LHFA01_HappyPath — LH-FA-01 Happy Path: n Dateien → indexed_docs = n.
func TestReindex_LHFA01_HappyPath(t *testing.T) {
	dir := t.TempDir()
	for _, name := range []string{"a.md", "b.md", "c.md"} {
		if err := os.WriteFile(filepath.Join(dir, name), []byte("# "+name+"\ntext"), 0o600); err != nil {
			t.Fatalf("setup: %v", err)
		}
	}
	// Nicht-Markdown wird nicht indexiert.
	if err := os.WriteFile(filepath.Join(dir, "ignore.txt"), []byte("x"), 0o600); err != nil {
		t.Fatalf("setup: %v", err)
	}
	ix := newIndexer(t)
	n, err := ix.Reindex(dir)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if n != 3 {
		t.Errorf("expected indexed_docs=3, got %d", n)
	}
}

// TestReindex_LHFA01_Boundary_EmptyDir — LH-FA-01 Boundary: 0 Dateien, kein Fehler.
func TestReindex_LHFA01_Boundary_EmptyDir(t *testing.T) {
	ix := newIndexer(t)
	n, err := ix.Reindex(t.TempDir())
	if err != nil {
		t.Fatalf("empty dir must not error, got %v", err)
	}
	if n != 0 {
		t.Errorf("expected indexed_docs=0, got %d", n)
	}
}

// TestReindex_LHFA01_Negative_MissingDir — LH-FA-01 Negative: E001.
func TestReindex_LHFA01_Negative_MissingDir(t *testing.T) {
	ix := newIndexer(t)
	_, err := ix.Reindex(filepath.Join(t.TempDir(), "gibt-es-nicht"))
	if !errors.Is(err, ErrDirNotFound) {
		t.Fatalf("expected ErrDirNotFound (E001), got %v", err)
	}
}

// TestReindex_LHQA02_Deterministisch — LH-QA-02: gleiche Eingabe, gleiche Reihenfolge.
func TestReindex_LHQA02_Deterministisch(t *testing.T) {
	dir := t.TempDir()
	for _, name := range []string{"z.md", "a.md", "m.md"} {
		if err := os.WriteFile(filepath.Join(dir, name), []byte("# "+name), 0o600); err != nil {
			t.Fatalf("setup: %v", err)
		}
	}
	first := newIndexer(t)
	if _, err := first.Reindex(dir); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	second := newIndexer(t)
	if _, err := second.Reindex(dir); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if first.idx.Size() != second.idx.Size() {
		t.Errorf("size differs: %d vs %d", first.idx.Size(), second.idx.Size())
	}
}

// TestReindex_LHFA01_Negative_EmbeddingDown — Embedding-Ausfall während der
// Indexierung liefert E003, nicht E001.
func TestReindex_LHFA01_Negative_EmbeddingDown(t *testing.T) {
	dir := t.TempDir()
	if err := os.WriteFile(filepath.Join(dir, "a.md"), []byte("# a"), 0o600); err != nil {
		t.Fatalf("setup: %v", err)
	}
	ix := NewIndexer(index.New(), downEmbedder{})
	if _, err := ix.Reindex(dir); !errors.Is(err, ErrEmbeddingDown) {
		t.Fatalf("expected ErrEmbeddingDown (E003), got %v", err)
	}
}
