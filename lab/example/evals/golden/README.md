# Golden Sets — DocSearch

Replay-Eingaben mit Erwartungen für [Modul 12](../../../../kurs/de/04-qualitaet/modul-12-replay-evaluierung.md).

## Sets

| Set | Beschreibung |
|---|---|
| [`welle-1-baseline/`](welle-1-baseline/) | Baseline nach Welle-1-Abschluss: Happy + Boundary + Negative für LH-FA-02 — `manifest.yaml` + `inputs/case-{001,002,003}.json` + `expectations/case-{001,002,003}.json` + `CHANGELOG.md` |

**Verzeichnisform.** Bis Welle 9 lag jedes Set als einzelne JSON-Datei.
Seit dem Welle-9-Lab-Ausbau folgen die Sets dem Schema aus
[Kurs Modul 12 §Worked Example](../../../../kurs/de/04-qualitaet/modul-12-replay-evaluierung.md#worked-example-ein-replay-manifest-aufbauen):
`manifest.yaml` (Top-Level-Konfiguration, Modell, Runtime, Determinismus-
Anker) + `inputs/` (eine JSON-Datei pro Case) + `expectations/`
(parallel benannt) + `CHANGELOG.md`. Vorteil: Modell-/Tool-Call-
Erwartungen liegen pro Case getrennt, ohne dass eine Sammeldatei mit
jedem Case-Edit anwächst. Migration siehe `welle-1-baseline/CHANGELOG.md`.

## Replay-Vertrag

Jeder Replay-Lauf muss:

1. **Modellversion** aus dem Set übernehmen (`model_version`), nicht dynamisch wählen.
2. **Tie-Break-Strategie** aus dem Set respektieren — `sort_stable_then_doc_path_then_section_index` (siehe AGENTS.md §2.7).
3. **Externe Antworten** mocken (Embedding-Antworten werden aus Recordings ausgespielt; bei diesem Set kommt der Mock aus der dokumentierten Modell-Version).
4. Pro Case ein **Ergebnis-Hash** erzeugen und in CI veröffentlichen — bei zwei aufeinanderfolgenden Läufen identischer Eingabe müssen die Hashes übereinstimmen.

## Erwartungs-Felder

Die Cases nutzen drei Erwartungs-Modi (kann gemischt sein):

- **Exact-Match-Felder** (`status`, `error_code`, `response_header`) — wörtlich.
- **Boundary-Felder** (`result_count_max`, `top_score_min`) — Schwellen statt Exact.
- **Semantische Felder** (`top_section_title_contains`) — Substring-Match. Toleriert Formulierungs-Drift, scheitert bei semantischer Verschiebung.

## Steering Loop

Wenn ein Case dreimal denselben False-Positive-Fail produziert (z.B.
`top_score_min` ist konsistent zu eng), wandert das in den Steering
Loop: entweder das Set anpassen (Schwelle korrigieren) oder neuen Case
hinzufügen (semantisch genauer prüfen). Das Set ist nicht heilig.
