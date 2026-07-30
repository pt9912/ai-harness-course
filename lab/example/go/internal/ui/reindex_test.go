package ui

import (
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/example/docsearch/internal/service"
	"github.com/example/docsearch/internal/testutil"
)

// handlerWithIndexer baut über testutil (depguard-konform: ui importiert
// NICHT direkt index/embedding).
func handlerWithIndexer() *Handler {
	return NewHandlerWithIndexer(testutil.SeededHandlerParts())
}

// TestReindexHTTP_LHFA01_HappyPath — LH-FA-01 Happy Path: 200 + indexed_docs.
func TestReindexHTTP_LHFA01_HappyPath(t *testing.T) {
	dir := t.TempDir()
	for _, name := range []string{"a.md", "b.md"} {
		if err := os.WriteFile(filepath.Join(dir, name), []byte("# "+name), 0o600); err != nil {
			t.Fatalf("setup: %v", err)
		}
	}
	rec := httptest.NewRecorder()
	body := `{"dir":` + strconvQuote(dir) + `}`
	handlerWithIndexer().ReindexHTTP(rec, httptest.NewRequest(http.MethodPost, "/reindex", strings.NewReader(body)))
	if rec.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d (%s)", rec.Code, rec.Body.String())
	}
	var got map[string]any
	if err := json.Unmarshal(rec.Body.Bytes(), &got); err != nil {
		t.Fatalf("bad json: %v", err)
	}
	if got["indexed_docs"] != float64(2) {
		t.Errorf("expected indexed_docs=2, got %v", got["indexed_docs"])
	}
}

// TestReindexHTTP_LHFA01_Boundary_EmptyDir — LH-FA-01 Boundary: 200, indexed_docs=0.
func TestReindexHTTP_LHFA01_Boundary_EmptyDir(t *testing.T) {
	rec := httptest.NewRecorder()
	body := `{"dir":` + strconvQuote(t.TempDir()) + `}`
	handlerWithIndexer().ReindexHTTP(rec, httptest.NewRequest(http.MethodPost, "/reindex", strings.NewReader(body)))
	if rec.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d", rec.Code)
	}
}

// TestReindexHTTP_LHFA01_Negative_E001 — LH-FA-01 Negative: 400 + E001.
func TestReindexHTTP_LHFA01_Negative_E001(t *testing.T) {
	rec := httptest.NewRecorder()
	body := `{"dir":` + strconvQuote(filepath.Join(t.TempDir(), "weg")) + `}`
	handlerWithIndexer().ReindexHTTP(rec, httptest.NewRequest(http.MethodPost, "/reindex", strings.NewReader(body)))
	if rec.Code != http.StatusBadRequest {
		t.Fatalf("expected 400, got %d", rec.Code)
	}
	if !strings.Contains(rec.Body.String(), "E001") {
		t.Errorf("expected E001, got %s", rec.Body.String())
	}
}

// TestStatusFor_E099 — unklassifizierter Fehler wird zu 500/E099
// (spec/spezifikation.md §4).
func TestStatusFor_E099(t *testing.T) {
	status, code := statusFor(errors.New("etwas Unerwartetes"))
	if status != http.StatusInternalServerError || code != "E099" {
		t.Errorf("expected 500/E099, got %d/%s", status, code)
	}
}

// TestStatusFor_AlleCodes — die vier Codes aus spec/spezifikation.md §4.
func TestStatusFor_AlleCodes(t *testing.T) {
	cases := []struct {
		err    error
		status int
		code   string
	}{
		{service.ErrDirNotFound, http.StatusBadRequest, "E001"},
		{service.ErrEmptyQuery, http.StatusBadRequest, "E002"},
		{service.ErrEmbeddingDown, http.StatusServiceUnavailable, "E003"},
	}
	for _, c := range cases {
		status, code := statusFor(c.err)
		if status != c.status || code != c.code {
			t.Errorf("%v: expected %d/%s, got %d/%s", c.err, c.status, c.code, status, code)
		}
	}
}

// strconvQuote — JSON-sicheres Quoten ohne strconv-Import im Testkopf.
func strconvQuote(s string) string {
	b, _ := json.Marshal(s)
	return string(b)
}

// TestDecodeFehler_E099_500 — kaputter Body ist unklassifiziert: E099 mit
// Status 500 (spec/spezifikation.md §4), nicht 400.
func TestDecodeFehler_E099_500(t *testing.T) {
	for name, call := range map[string]func(*Handler, http.ResponseWriter, *http.Request){
		"reindex": (*Handler).ReindexHTTP,
		"search":  (*Handler).SearchHTTP,
	} {
		rec := httptest.NewRecorder()
		req := httptest.NewRequest(http.MethodPost, "/"+name, strings.NewReader("{kaputt"))
		call(handlerWithIndexer(), rec, req)
		if rec.Code != http.StatusInternalServerError {
			t.Errorf("%s: expected 500, got %d", name, rec.Code)
		}
		if !strings.Contains(rec.Body.String(), "E099") {
			t.Errorf("%s: expected E099, got %s", name, rec.Body.String())
		}
	}
}
