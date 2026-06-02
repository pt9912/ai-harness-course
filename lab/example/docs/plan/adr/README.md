# ADR-Index — DocSearch

| ID | Titel | Status | Bezug |
|---|---|---|---|
| [0001](0001-hexagonale-architektur.md) | Hexagonale Architektur mit Layering | Accepted (2026-05-15) | LH-FA-* |
| [0002](0002-modellwahl-embedding.md) | Modellwahl für Embedding | Accepted (2026-05-22) | LH-FA-01, LH-QA-01 |
| [0003](0003-index-storage-format.md) | Index-Storage-Format Custom Binary v1 | Accepted (2026-05-29) | LH-QA-01, LH-QA-02 |
| [0011](0011-closure-note-pflicht.md) | Closure-Note-Pflicht für `done/`-Slices | Accepted (2026-06-02) | LH-QA-02, Modul 1 §Closure, Modul 10 |
| [0012](0012-index-write-strategy.md) | Index-Write-Strategie (Temp-File + Atomic Rename) | Accepted (2026-06-02) | LH-FA-IDX-003, ADR-0003, Modul 14 |

## Konventionen

- ADRs sind nach `Accepted` **immutable** (siehe [Kurs Modul 3](../../../../../kurs/de/01-spec-und-architektur/modul-03-architektur-adrs.md)).
- Schärfungen entstehen als neue ADR mit `Supersedes ADR-NN`.
- Neue ADR im Status `Proposed` darf während des Slice-Reviews iteriert werden.
- Bei `Accepted`: dieser Index aktualisieren (Status, Datum).
