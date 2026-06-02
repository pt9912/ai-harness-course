// Package ui — HTTP-Handler, Input-Validierung.
// ADR-0001 Layer: darf service + types importieren; KEIN index, embedding direkt.
package ui

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/example/docsearch/internal/service"
	"github.com/example/docsearch/internal/types"
)

// Handler — HTTP-Layer.
type Handler struct {
	s *service.Searcher
}

// NewHandler konstruiert mit injiziertem Service.
func NewHandler(s *service.Searcher) *Handler {
	return &Handler{s: s}
}

// SearchHTTP — POST /search.
func (h *Handler) SearchHTTP(w http.ResponseWriter, r *http.Request) {
	var req types.SearchRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error":"E099"}`, http.StatusBadRequest)
		return
	}
	resp, err := h.s.Search(req)
	switch err {
	case nil:
		// ok
	case service.ErrEmptyQuery:
		http.Error(w, `{"error":"E002"}`, http.StatusBadRequest)
		return
	case service.ErrEmbeddingDown:
		http.Error(w, `{"error":"E003"}`, http.StatusServiceUnavailable)
		return
	default:
		http.Error(w, `{"error":"E099"}`, http.StatusInternalServerError)
		return
	}
	if resp.KClamped {
		w.Header().Set("X-Topk-Clamped", strconv.Itoa(types.MaxTopK))
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]any{"results": resp.Results})
}
