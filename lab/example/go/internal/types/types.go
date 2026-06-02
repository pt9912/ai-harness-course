// Package types — Domain-Modell, Pure. ADR-0001 Layer 1.
package types

const (
	// EmbeddingDim aus spec/spezifikation.md §3.
	EmbeddingDim = 1024
	// MaxTopK aus spec/spezifikation.md §3, ADR-0001.
	MaxTopK = 100
)

// IndexEntry — Vektor + Metadaten eines Markdown-Abschnitts.
type IndexEntry struct {
	DocPath      string
	SectionTitle string
	SectionIndex uint32
	SectionText  string
	Embedding    [EmbeddingDim]float32
}

// SearchResult — Treffer-Eintrag.
type SearchResult struct {
	Doc     string  `json:"doc"`
	Section string  `json:"section"`
	Score   float32 `json:"score"`
}

// SearchRequest — Anfrage-Schema.
type SearchRequest struct {
	Q string `json:"q"`
	K int    `json:"k"`
}
