# `.d-check.yml` gehört zu keiner Sub-Area eindeutig

**Sub-Area:** Sensor-Werkzeuge

`harness/conventions.md` weist weder `Verifikation` (Pfad-Cluster
`verification/`) noch `Sensor-Werkzeuge` (Pfad-Cluster nennt die
Sprach-Gate-Konfigurationen, aber nicht `.d-check.yml` selbst) die Datei
`.d-check.yml` explizit zu. `slice-wellen-invariante-per-d-check` klassifizierte sie unbelegt als
`Verifikation`; `slice-review-report-deckung-per-d-check` übernahm das unverändert.
