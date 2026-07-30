// Package ui — HTTP-Handler, Input-Validierung.
// ADR-0001 Layer: darf service + types importieren; KEIN index, embedding direkt.
package ui

import (
	"encoding/json"
	"errors"
	"net/http"
	"strconv"

	"github.com/example/docsearch/internal/service"
	"github.com/example/docsearch/internal/types"
)

// Handler — HTTP-Layer.
type Handler struct {
	s  *service.Searcher
	ix *service.Indexer
}

// NewHandler konstruiert mit injiziertem Service.
func NewHandler(s *service.Searcher) *Handler {
	return &Handler{s: s}
}

// NewHandlerWithIndexer konstruiert zusätzlich mit dem Indexierungs-Service
// (LH-FA-01).
func NewHandlerWithIndexer(s *service.Searcher, ix *service.Indexer) *Handler {
	return &Handler{s: s, ix: ix}
}

// statusFor bildet die Fehler-Codes aus spec/spezifikation.md §4 auf
// HTTP-Status ab. Unbekannte Fehler sind E099.
func statusFor(err error) (int, string) {
	switch {
	case errors.Is(err, service.ErrDirNotFound):
		return http.StatusBadRequest, "E001"
	case errors.Is(err, service.ErrEmptyQuery):
		return http.StatusBadRequest, "E002"
	case errors.Is(err, service.ErrEmbeddingDown):
		return http.StatusServiceUnavailable, "E003"
	default:
		return http.StatusInternalServerError, "E099"
	}
}

// ReindexHTTP — POST /reindex (LH-FA-01).
func (h *Handler) ReindexHTTP(w http.ResponseWriter, r *http.Request) {
	var req struct {
		Dir string `json:"dir"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		// Unklassifiziert -> E099/500, wie jeder andere unbekannte Fehler
		// (spec/spezifikation.md §4). Eine Zuordnungsstelle, nicht zwei.
		status, code := statusFor(err)
		http.Error(w, `{"error":"`+code+`"}`, status)
		return
	}
	n, err := h.ix.Reindex(req.Dir)
	if err != nil {
		status, code := statusFor(err)
		http.Error(w, `{"error":"`+code+`"}`, status)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]any{"indexed_docs": n})
}

// SearchHTTP — POST /search.
func (h *Handler) SearchHTTP(w http.ResponseWriter, r *http.Request) {
	var req types.SearchRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		status, code := statusFor(err)
		http.Error(w, `{"error":"`+code+`"}`, status)
		return
	}
	resp, err := h.s.Search(req)
	if err != nil {
		status, code := statusFor(err)
		http.Error(w, `{"error":"`+code+`"}`, status)
		return
	}
	if resp.KClamped {
		w.Header().Set("X-Topk-Clamped", strconv.Itoa(types.MaxTopK))
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]any{"results": resp.Results})
}
