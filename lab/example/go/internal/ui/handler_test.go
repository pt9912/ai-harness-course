package ui

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/example/docsearch/internal/testutil"
)

// post baut einen Handler über testutil (depguard-konform: ui importiert
// NICHT direkt index/embedding) und feuert einen POST /search.
func post(t *testing.T, n int, body string) *httptest.ResponseRecorder {
	t.Helper()
	h := NewHandler(testutil.SeededSearcher(n))
	req := httptest.NewRequest(http.MethodPost, "/search", strings.NewReader(body))
	rec := httptest.NewRecorder()
	h.SearchHTTP(rec, req)
	return rec
}

func TestSearchHTTP_Happy(t *testing.T) {
	rec := post(t, 3, `{"q":"frage","k":2}`)
	if rec.Code != http.StatusOK {
		t.Fatalf("Status = %d, want 200; body=%s", rec.Code, rec.Body.String())
	}
}

func TestSearchHTTP_BadJSON(t *testing.T) {
	rec := post(t, 1, `not-json`)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("Status = %d, want 400 (E099)", rec.Code)
	}
}

func TestSearchHTTP_EmptyQuery(t *testing.T) {
	rec := post(t, 1, `{"q":"","k":1}`)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("leere Query Status = %d, want 400 (E002)", rec.Code)
	}
}

func TestSearchHTTP_ClampHeaderSet(t *testing.T) {
	rec := post(t, 3, `{"q":"frage","k":500}`)
	if rec.Header().Get("X-Topk-Clamped") == "" {
		t.Errorf("X-Topk-Clamped-Header für k=500 erwartet")
	}
}
