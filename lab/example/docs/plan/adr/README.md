# ADR-Index — DocSearch

| ID | Titel | Status | Bezug |
|---|---|---|---|
| [0001](0001-hexagonale-architektur.md) | Hexagonale Architektur mit Layering | Accepted (2026-05-15) | LH-FA-* |
| [0002](0002-modellwahl-embedding.md) | Modellwahl für Embedding | Accepted (2026-05-22) | LH-FA-01, LH-QA-01 |
| [0003](0003-index-storage-format.md) | Index-Storage-Format Custom Binary v1 | Accepted (2026-05-25) | LH-QA-01, LH-QA-02 |
| [0011](0011-closure-note-pflicht.md) | Closure-Note-Pflicht für `done/`-Slices | Accepted (2026-06-02) | LH-QA-02, Modul 1 §Closure, Modul 11 |
| [0012](0012-index-write-strategy.md) | Index-Write-Strategie (Temp-File + Atomic Rename) | Accepted (2026-06-02) | LH-FA-IDX-003, ADR-0003, Modul 15 |
| [0013](0013-coverage-schwellen.md) | Coverage-Schwellen — bootstrap-aware 70 %, kritisch 90 % | Accepted (2026-06-02) | CO-001, LH-QA-02, Modul 13 |
| [0014](0014-a-check-zweites-layering-gate.md) | a-check als zweites Layering-Gate im C++-Skelett | Superseded by 0015 (2026-08-09) | ADR-0001, Modul 4 |
| [0015](0015-a-check-rollout-sprachskelette.md) | a-check als zweites Layering-Gate — Rollout über die Sprach-Skelette | Superseded by 0016 (2026-08-09) | ADR-0001, Supersedes 0014 |
| [0016](0016-a-check-in-allen-skeletten.md) | a-check ist das zweite Layering-Gate in allen Sprach-Skeletten | Superseded by 0017 (2026-08-09) | ADR-0001, Supersedes 0015 |
| [0017](0017-kotlin-luecke-am-bestandssensor-geschlossen.md) | Die Kotlin-Lücke gehört in den Bestandssensor, nicht in eine Zusatzregel | Accepted (2026-08-09) | ADR-0001, Supersedes 0016 |

## Konventionen

- ADRs sind nach `Accepted` **immutable** (siehe [Kurs Modul 4](../../../../../kurs/de/01-spec-und-architektur/modul-04-adrs.md)).
- Schärfungen entstehen als neue ADR mit `Supersedes ADR-NNNN`.
- Neue ADR im Status `Proposed` darf während des Slice-Reviews iteriert werden.
- Bei `Accepted`: dieser Index aktualisieren (Status, Datum).
- Jede ADR deklariert im `**Schärft:**`-Feld *aufwärts*, welche Spec-Stelle sie verbindlich macht — die Änderungskopplung (Kurs [§Referenz-Richtung](../../../../../kurs/de/grundlagen/referenz-richtung.md#referenz-richtung-sdp-wer-darf-wen-referenzieren)). Prozess-ADRs ohne Spec-Stratum tragen `—`.
- Das `**Schärft:**`-Feld wurde am 2026-06-03 als Konventions-Backfill in die zu diesem Zeitpunkt bestehenden Accepted-ADRs ergänzt; jede spätere ADR trägt das Feld von Anfang an: Traceability-Metadata, keine Entscheidungs-Änderung — Immutability schützt die *Entscheidung*, nicht die Nachpflege (wie die Geschichte-/Index-Tabellen).
- Am 2026-08-08 wurde dieselbe Nachpflege eine Stufe genauer: Wo das Zielelement eine Kennung trägt (`SPEC-*`, `ARC-*`, `LH-FA-*.a`), nennt das Feld die Kennung statt des Abschnitts. Wo die Sektion selbst keine vergibt — die Constraint- und Fehlermodell-Sektionen der Sicht, deren Aussage ohnehin über alle Komponenten läuft —, bleibt der `§`-Anker. Das ist der vorgesehene Rückfallweg, kein Rückstand.
