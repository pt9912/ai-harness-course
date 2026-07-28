# CO-001: Bootstrap-Coverage Index-Layer

**Status:** Aktiv.

**Datum angelegt:** 2026-05-20. **Letzte Prüfung:** 2026-06-01.

**Betroffenes Gate:** `coverage-gate-critical`.

**Geltungsbereich:** der Index-Layer in allen sechs Sprach-Skeletten —
`go/internal/index/`, `python/src/docsearch/index/`,
`java/.../docsearch/index/`, `kotlin/.../docsearch/index/`,
`csharp/src/DocSearch/Index/`, `cpp/src/hexagon/index/`.

**Folge-Slice:** [`slice-013-property-tests.md`](../planning/in-progress/slice-013-property-tests.md)

---

## Begründung

`coverage-gate-critical` verlangt 80 % Zeilen-Coverage für
kritische Layer. Der Index-Layer enthält Binär-Format-Parser, deren
Fehlerpfade (`E099` bei korrupter Datei) durch Unit-Tests nur partiell
abgedeckt werden — eine Property-Test-Suite (slice-013) wird die
verbleibenden Pfade abdecken.

Aktueller Stand: 76 % statt 80 %. Ohne Property-Tests bliebe
`coverage-gate-critical` rot — dieser Carveout nimmt den Layer bis dahin
aus, indem die Messung auf `service` verengt wird (siehe
§Geltungs-Konfiguration).

## Auflösungs-Trigger

Welle 2 (welle-2-qualitaet) done — Property-Test-Suite läuft 100
Generationen und deckt die Fehlerpfade.

Konkret: die Index-Layer-Coverage erreicht ≥ 80 % — dieselbe Schwelle, die
das Gate für kritische Layer setzt —, geprüft in
`make coverage-gate-critical` ohne Ausnahmen.

## Geltungs-Konfiguration

Die Ausnahme ist nicht als Ausschluss-Liste konfiguriert, sondern als
**Verengung der Messung** auf den nicht ausgenommenen kritischen Layer
(`service`). Jedes Skelett trägt sie dort, wo seine Coverage-Schwelle steht:

| Datei | Zeile/Section | Wert |
|---|---|---|
| `go/Makefile` | `coverage-gate-critical` | Paket-Auswahl auf das `service`-Paket, Schwelle 80 |
| `python/Makefile` | `coverage-gate-critical` | `--cov=src/docsearch/service --cov-fail-under=80` |
| `java/pom.xml` | Profil `critical-coverage` | JaCoCo-`includes` auf `com/example/docsearch/service/**`, `minimum` 0.80 |
| `kotlin/build.gradle.kts` | `kover`, Schalter `-Pcritical` | `filters.includes` auf `com.example.docsearch.service.*`, `minValue` 80 |
| `csharp/Makefile` | `coverage-gate-critical` | Test-Auswahl `FullyQualifiedName~Service` — **wirkungslos, siehe unten** |
| `cpp/Makefile` | `coverage-gate-critical` | `gcovr` mit Filter auf `src/hexagon/service/`, Schwelle 80 |

Der ID-Kommentar `CO-001` steht in jedem Skelett im `@echo` des Targets
(`<sprache>/Makefile`, Ziel `coverage-gate-critical`) — auch dort, wo die
Verengung selbst in `pom.xml` bzw. `build.gradle.kts` konfiguriert ist. Damit
ist der Carveout im Lauf sichtbar; ausgeführt wird das Target über `make ci`,
nicht über `make gates`.

**Offen für C#:** Das Skelett hat kein wirksames Coverage-Gate. `coverage-gate`
setzt `/p:Threshold=70`, was `coverlet.msbuild` voraussetzt — referenziert ist
nur `coverlet.collector`, der misst, aber keine Schwelle auswertet.
`coverage-gate-critical` misst gar nicht: Es wählt nur Tests nach Namen aus.
Der Carveout greift dort also ins Leere, bis das Gate real ist; die
Verifikations-Checkliste führt das als eigenen Punkt.

## Verifikation (nach Auflösung)

- [ ] Index-Layer-Coverage in allen sechs Sprach-Skeletten ≥ 80 %.
- [ ] Die Mess-Verengung in allen Skeletten von `service` auf `service` **und**
      Index erweitert (Orte siehe §Geltungs-Konfiguration) — nicht ganz
      entfernt, sonst misst `coverage-gate-critical` dasselbe wie
      `coverage-gate`.
- [ ] C#: wirksames Coverage-Gate vorhanden (`coverlet.msbuild`).
- [ ] `make coverage-gate-critical` grün ohne Ausnahmen.
- [ ] Diese Datei nach `done/CO-001-index-coverage.md` bewegt (reiner `git mv`).
- [ ] slice-013 Closure-Notiz schließt diese Auflösung mit ein.

## Geschichte

| Datum | Ereignis | Verweis |
|---|---|---|
| 2026-05-20 | Angelegt | slice-005 (Index-Format) |
| 2026-06-01 | Geprüft, weiterhin gültig — Welle 2 läuft | slice-013 |
