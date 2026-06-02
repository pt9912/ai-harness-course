# Lastenheft — DocSearch

**Version:** 0.3.0
**Status:** Accepted
**Autor:** Kurs-Lab, **Datum:** 2026-06-02

## 1. Zweck und Geltungsbereich

DocSearch ist ein interner Service, der eine Sammlung von
Markdown-Dokumenten (Onboarding-Material, technische Doku,
Wiki-Exporte) **semantisch durchsuchbar** macht. Eine Anfrage liefert
eine sortierte Liste der `k` relevantesten Dokument-Abschnitte mit
Quellen-Referenz.

Zielgröße: bis 10.000 Dokumente, durchschnittlich 5.000 Tokens pro
Dokument. Antwortzeit unter 1 s p95.

## 2. Stakeholder

| Stakeholder | Rolle | Erwartung |
|---|---|---|
| Engineering-Onboarding | Auftraggeber | Neue Engineers finden Antworten ohne Slack-Frage |
| Plattform-Team | Betreiber | Reproduzierbares Image, OTel-Traces, fail-closed |
| InfoSec | Reviewer | Keine Exfiltration sensibler Inhalte, Audit-Log |

## 3. Funktionale Anforderungen

### LH-FA-01 — Dokument-Indexierung

**Beschreibung:** Der Service indexiert alle Markdown-Dateien in einem
konfigurierten Verzeichnis und erzeugt pro Datei Embedding-Vektoren je
Abschnitt (`##`-Heading-Granularität).

**Akzeptanzkriterien:**

- **Happy Path:** Given 100 `.md`-Dateien, when `POST /reindex`, then Statuscode 200 und `indexed_docs=100` in der Antwort.
- **Boundary:** Given 0 Dateien im Verzeichnis, when `POST /reindex`, then Statuscode 200, `indexed_docs=0`, kein Fehler.
- **Negative:** Given ein nicht existierendes Verzeichnis, when `POST /reindex`, then Statuscode 400, Fehler-Code `E001`.

**Out-of-Scope:** Nicht-Markdown-Formate (PDF, DOCX) in dieser Version.

---

### LH-FA-02 — Semantische Suche

**Beschreibung:** Der Service nimmt eine Suchanfrage entgegen und
liefert die `k` ähnlichsten Dokument-Abschnitte mit Cosinus-Ähnlichkeit
und Quellen-Referenz.

**Akzeptanzkriterien:**

- **Happy Path:** Given indexierte Doku, when `POST /search` mit `{"q": "<Frage>", "k": 5}`, then Antwort `{"results": [{"doc":"...", "section":"...", "score": 0.0–1.0}, …]}` mit genau 5 Einträgen, absteigend sortiert.
- **Boundary:** Given Index leer, when `POST /search`, then `{"results": []}`, Statuscode 200.
- **Boundary:** Given `k > 100`, when `POST /search`, then `k` wird auf 100 begrenzt (siehe `spec/spezifikation.md` `MAX_TOPK`), Antwort enthält Hinweis-Header `X-Topk-Clamped: 100`.
- **Negative:** Given leere Anfrage `q=""`, when `POST /search`, then Statuscode 400, Fehler-Code `E002`.

**Out-of-Scope:** Filterung nach Metadaten (Autor, Datum).

---

### LH-FA-03 — Audit-Logging

**Beschreibung:** Jeder Suchaufruf wird strukturiert geloggt: Anfrage,
Anzahl Ergebnisse, Latenz, anonymisierte User-ID.

**Akzeptanzkriterien:**

- **Happy Path:** Given eine Suchanfrage, when `POST /search`, then ein Log-Eintrag in stdout mit Feldern `event=search`, `user_id_hash`, `q_hash`, `result_count`, `latency_ms`.
- **Negative:** User-ID wird *nicht* unverschlüsselt geloggt — SHA-256-Hash mit Salt aus Config.

**Out-of-Scope:** Persistente Audit-DB (nur stdout / OTel-Stream).

---

## 4. Nichtfunktionale Anforderungen

### LH-QA-01 — Performance

- **Anforderung:** Suchanfrage liefert Antwort in p95 < 1.000 ms bei 10 RPS auf einem Standard-Worker (2 vCPU, 4 GB RAM, 10.000 indexierte Abschnitte).
- **Messmethode:** Lasttest gemäß `spec/spezifikation.md` §5.

### LH-QA-02 — Reproduzierbarkeit

- **Anforderung:** Identische Eingabe (Dokumente + Anfrage + Modellversion) liefert identische Ausgabe (deterministische Sortierung bei gleichem Score, fester Tie-Break).
- **Messmethode:** `make test-determinism` läuft 100× identische Eingabe, vergleicht Hashes der Antworten.

### LH-QA-03 — Container-Reproduzierbarkeit

- **Anforderung:** Das Runtime-Image wird aus pinned Base + gepinnten Dependencies gebaut. Build-Hash ist stabil bei identischem Source-Tree.
- **Messmethode:** `make build` zweimal in Folge, Image-Hashes vergleichen.

### LH-QA-04 — Audit-Datenschutz

- **Anforderung:** Keine personenbezogenen Klartext-Daten in Logs (siehe LH-FA-03).
- **Messmethode:** Linter-Regel `no-userid-in-log`, geprüft in `make lint`.

## 5. Globale Out-of-Scope-Punkte

- Multi-Tenancy (gemeinsamer Index für alle Nutzer).
- Schreibender Inhalts-Editor (DocSearch liest nur).
- Echtzeit-Indexierung (Re-Index läuft on demand).
- LLM-Antwort-Generierung (kein RAG-Generator, nur Retrieval).

## 6. Glossar

| Begriff | Bedeutung |
|---|---|
| Embedding | Vektor-Repräsentation eines Text-Abschnitts (Dimension `EMBEDDING_DIM`, siehe Spezifikation). |
| Abschnitt | Block zwischen zwei `##`-Headings einer Markdown-Datei. |
| Cosinus-Ähnlichkeit | Standardmaß zwischen zwei Vektoren, Wertebereich [-1, 1]. |
| Top-K | Anzahl der zurückgegebenen Ergebnisse pro Suche. |

## 7. Historie

| Version | Datum | Änderung | Verweis |
|---|---|---|---|
| 0.1.0 | 2026-05-15 | Initiale Fassung | slice-001 |
| 0.2.0 | 2026-05-22 | Boundary-Kriterium für `k > 100` ergänzt | slice-007 |
| 0.3.0 | 2026-06-01 | LH-QA-04 Audit-Datenschutz ergänzt | slice-012 |
