# ADR-0002: Modellwahl für Embedding

**Status:** Accepted

**Datum:** 2026-05-22

**Autor:** Kurs-Lab

**Bezug:** LH-FA-01, LH-QA-01

---

## Kontext

DocSearch braucht Embedding-Vektoren je Markdown-Abschnitt. Die
Modellwahl entscheidet über Dimensionalität, Antwortzeit, Kosten und
Sprach-Reichweite. Eingangswerte:

- Index-Größe Zielgröße 10.000 × ca. 8 Abschnitte = 80.000 Embeddings je
  Re-Index.
- p95 Suchantwort < 1.000 ms (LH-QA-01).
- Sprachen: vor allem Deutsch und Englisch.
- On-Prem-Option erwünscht (InfoSec-Anforderung).

## Entscheidung

Wir wählen **lokales Embedding-Modell mit Adapter-Pattern**, konkret in
der Initialfassung das *fiktive* Modell `local-embed-v3` (Platzhalter
im Beispiel-Lab) mit `EMBEDDING_DIM=1024`.

Der Adapter liegt in `internal/embedding/` (Go) bzw. äquivalenten
Pfaden in den anderen Sprachen. Modell-Wechsel ist eine ADR-Folge-
Schärfung, kein Service-Eingriff.

## Verglichene Alternativen

### Option A — OpenAI `text-embedding-3-large`

- Pro: Höchste Qualität, breite Sprach-Abdeckung.
- Contra: Externe API, Kosten skalieren, InfoSec-Constraint (siehe Kontext).

### Option B — Cohere `embed-multilingual-v3`

- Pro: Gute Qualität, multilingual.
- Contra: Externe API, gleiche InfoSec-Probleme wie A.

### Option C — Lokales Modell mit Adapter (gewählt)

- Pro: On-Prem, kein API-Limit, Kosten nur Compute. Adapter-Pattern macht späteren Wechsel billig.
- Contra: Initiale Qualität niedriger als A/B; Hardware-Anforderungen (GPU oder kleines Modell).

## Konsequenzen

- Positiv: Compliance-konform, deterministisch (LH-QA-02 erfüllbar mit fester Modell-Version).
- Negativ: Mögliche Qualitätsdefizite bei seltenen Sprachen — out-of-scope für jetzt (siehe Lastenheft §5).
- Folgepflicht: Adapter-Interface `Embedder.Embed(string) ([]float32, error)` als ports im Service-Layer. Cache-Schicht im Adapter (siehe Spec §5 `cache_hit`-Span).

## Fitness Function

| Tooling | Regel | Make-Target |
|---|---|---|
| Architekturtest | Nur `internal/embedding/` darf konkrete LLM-Client-Bibliotheken importieren. | `make arch-check` |
| Vertragstest | `Embedder.Embed("hallo welt")` liefert Vektor mit exakt `EMBEDDING_DIM=1024`. | `make test` |

## Re-Evaluierungs-Trigger

- Wenn Qualität in Replay-Golden-Set unter Schwelle `recall@5 < 0.7` fällt (siehe `evals/golden/`).
- Wenn ein neues lokales Modell verfügbar wird, das `EMBEDDING_DIM` signifikant senkt (Speicherbedarf).

## Geschichte

| Datum | Ereignis | Verweis |
|---|---|---|
| 2026-05-22 | Proposed | slice-007 |
| 2026-05-22 | Accepted | PR slice-007 |
