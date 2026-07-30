// LH-FA-01: Indexierung eines Verzeichnisses.
// ADR-0001 Layer: darf types, index, embedding importieren; KEIN ui.

package service

import (
	"errors"
	"io/fs"
	"math"
	"os"
	"sort"
	"strings"

	"github.com/example/docsearch/internal/embedding"
	"github.com/example/docsearch/internal/index"
	"github.com/example/docsearch/internal/types"
)

// ErrDirNotFound — spec/spezifikation.md §4: Verzeichnis existiert nicht.
var ErrDirNotFound = errors.New("E001: directory not found")

// Indexer — Service-Fassade für die Indexierung (LH-FA-01).
type Indexer struct {
	idx *index.Index
	emb embedding.Embedder
}

// NewIndexer konstruiert den Service mit injizierten Adaptern.
func NewIndexer(idx *index.Index, emb embedding.Embedder) *Indexer {
	return &Indexer{idx: idx, emb: emb}
}

// Reindex liest alle .md-Dateien aus dir und gibt die Zahl der indexierten
// Dokumente zurück. Fehlt das Verzeichnis, liefert es ErrDirNotFound (E001).
// Ein leeres Verzeichnis ist kein Fehler (LH-FA-01 Boundary).
func (ix *Indexer) Reindex(dir string) (int, error) {
	info, err := os.Stat(dir)
	if err != nil || !info.IsDir() {
		return 0, ErrDirNotFound
	}
	// os.DirFS begrenzt jeden Lesezugriff auf dir — damit ist der Pfad nicht
	// mehr frei wählbar (gosec G304) und braucht keine Suppression
	// (AGENTS.md §G-1).
	fsys := os.DirFS(dir)
	entries, err := fs.ReadDir(fsys, ".")
	if err != nil {
		return 0, ErrDirNotFound
	}
	names := make([]string, 0, len(entries))
	for _, e := range entries {
		if !e.IsDir() && strings.HasSuffix(e.Name(), ".md") {
			names = append(names, e.Name())
		}
	}
	// Deterministische Reihenfolge: LH-QA-02 verlangt bit-identische Ergebnisse
	// bei identischer Eingabe, und os.ReadDir garantiert keine Sortierung.
	sort.Strings(names)

	count := 0
	for i, name := range names {
		raw, readErr := fs.ReadFile(fsys, name)
		if readErr != nil {
			return 0, ErrDirNotFound
		}
		text := string(raw)
		vec, embErr := ix.emb.Embed(text)
		if embErr != nil {
			return 0, ErrEmbeddingDown
		}
		// Bounds-Check statt Suppression (AGENTS.md §G-1).
		if i < 0 || i > math.MaxUint32 {
			return 0, ErrDirNotFound
		}
		ix.idx.Add(types.IndexEntry{
			DocPath:      name,
			SectionTitle: firstHeading(text, name),
			SectionIndex: uint32(i),
			SectionText:  text,
			Embedding:    vec,
		})
		count++
	}
	return count, nil
}

// firstHeading liefert die erste Markdown-Überschrift oder den Dateinamen.
func firstHeading(text, fallback string) string {
	for _, line := range strings.Split(text, "\n") {
		if strings.HasPrefix(line, "#") {
			return strings.TrimSpace(strings.TrimLeft(line, "# "))
		}
	}
	return fallback
}
