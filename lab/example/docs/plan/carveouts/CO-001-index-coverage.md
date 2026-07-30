# CO-001: Bootstrap-Coverage Index-Layer

**Status:** Aktiv.

**Datum angelegt:** 2026-05-25. **Letzte Prüfung:** 2026-06-03.

**Betroffenes Gate:** `coverage-gate-critical` (Schwelle aus [ADR-0013](../adr/0013-coverage-schwellen.md)).

**Geltungsbereich:** der Index-Layer in allen sechs Sprach-Skeletten —
`go/internal/index/`, `python/src/docsearch/index/`,
`java/.../docsearch/index/`, `kotlin/.../docsearch/index/`,
`csharp/src/DocSearch/Index/`, `cpp/src/hexagon/index/`.

**Folge-Slice:** [`slice-013-property-tests.md`](../planning/in-progress/slice-013-property-tests.md)

---

## Begründung

`coverage-gate-critical` verlangt 90 % Zeilen-Coverage für kritische Layer —
schärfer als die Gesamt-Coverage (70 %, ab M2 80 %). Begründet in
[ADR-0013](../adr/0013-coverage-schwellen.md); dieser Carveout setzt die
Schwelle nicht, er nimmt einen Layer davon aus. Der Index-Layer enthält Binär-Format-Parser, deren
Fehlerpfade (`E099` bei korrupter Datei) durch Unit-Tests nur partiell
abgedeckt werden — eine Property-Test-Suite (slice-013) wird die
verbleibenden Pfade abdecken.

Aktueller Stand: 76 % statt 90 %. Ohne Property-Tests bliebe
`coverage-gate-critical` rot — dieser Carveout nimmt den Layer bis dahin
aus, indem die Messung auf `service` verengt wird (siehe
§Geltungs-Konfiguration).

## Auflösungs-Trigger

Welle 2 (welle-2-qualitaet) done — Property-Test-Suite läuft 100
Generationen und deckt die Fehlerpfade.

Konkret: die Index-Layer-Coverage erreicht ≥ 90 % — dieselbe Schwelle, die
das Gate für kritische Layer setzt —, geprüft in
`make coverage-gate-critical` ohne Ausnahmen.

## Geltungs-Konfiguration

Die Ausnahme ist nicht als Ausschluss-Liste konfiguriert, sondern als
**Verengung der Messung** auf den nicht ausgenommenen kritischen Layer
(`service`). Jedes Skelett trägt sie dort, wo seine Coverage-Schwelle steht:

| Datei | Zeile/Section | Wert |
|---|---|---|
| `go/Makefile` | `coverage-gate-critical` | Paket-Auswahl auf das `service`-Paket, Schwelle 90 |
| `python/Makefile` | `coverage-gate-critical` | `--cov=src/docsearch/service --cov-fail-under=90` |
| `java/pom.xml` | Profil `critical-coverage` | JaCoCo-`includes` auf `com/example/docsearch/service/**`, `minimum` 0.90 |
| `kotlin/build.gradle.kts` | `kover`, Schalter `-Pcritical` | `filters.includes` auf `com.example.docsearch.service.*`, `minValue` 90 |
| `csharp/Makefile` | `coverage-gate-critical` | `/p:Include="[DocSearch]DocSearch.Service.*"`, Schwelle 90 — **derzeit rot, siehe unten** |
| `cpp/Makefile` | `coverage-gate-critical` | `gcovr` mit Filter auf `src/hexagon/service/`, Schwelle 90 |

Der ID-Kommentar `CO-001` steht in jedem Skelett im `@echo` des Targets
(`<sprache>/Makefile`, Ziel `coverage-gate-critical`) — auch dort, wo die
Verengung selbst in `pom.xml` bzw. `build.gradle.kts` konfiguriert ist. Damit
ist der Carveout im Lauf sichtbar; ausgeführt wird das Target über `make ci`,
nicht über `make gates`.

**Stand für C# (gemessen 2026-07-30):** Beide Gates sind real. `coverage-gate`
wertet die Schwelle jetzt aus — `coverlet.msbuild` ist referenziert, und die
COLLECTOR-Integration (`--settings coverlet.runsettings`) ist aus dem Aufruf
raus: Beides zugleich hieß, dass gemessen wurde und die Schwelle unbeachtet
blieb. Gegenprobe: Schwelle 80 bei 74 % Line-Coverage → `error: The total line
coverage is below the specified 80`, Exit 1; vorher lief derselbe Aufruf grün
durch.

`coverage-gate-critical` verengt die Messung jetzt auf `DocSearch.Service.*`
statt Tests nach Namen zu wählen. Es war damit zunächst **rot** (82,6 %) — und
die Ursache lag nicht im Layer-Umfang: Der ungetestete `E003`-Pfad
(Embedding-Ausfall) fehlte in **fünf von sechs** Skeletten; nur C++ hatte ihn.
Go (90,9 %) und Python (93,1 %) bestanden die Schwelle **mit derselben Lücke**,
weil ihr Service-Layer genug andere Zeilen hat. Java und Kotlin (84,2 %) waren
ebenfalls rot. Mit dem nachgezogenen `LH-FA-02`-Negative-Test sind alle sechs
grün; C# steht bei 100 %.

## Verifikation (nach Auflösung)

- [ ] Index-Layer-Coverage in allen sechs Sprach-Skeletten ≥ 90 %.
- [ ] Die Mess-Verengung in allen Skeletten von `service` auf `service` **und**
      Index erweitert (Orte siehe §Geltungs-Konfiguration) — nicht ganz
      entfernt, sonst misst `coverage-gate-critical` dasselbe wie
      `coverage-gate`.
- [x] C#: wirksames Coverage-Gate vorhanden (`coverlet.msbuild`, gemessen 2026-07-30).
- [x] C#: Service-Layer erreicht die 90 % aus ADR-0013 (gemessen 2026-07-30) — die Lücke war der ungetestete E003-Pfad, nicht der Layer-Umfang.
- [ ] `make coverage-gate-critical` grün ohne Ausnahmen.
- [ ] Diese Datei nach `done/CO-001-index-coverage.md` bewegt (reiner `git mv`).
- [ ] slice-013 Closure-Notiz schließt diese Auflösung mit ein.

## Geschichte

| Datum | Ereignis | Verweis |
|---|---|---|
| 2026-05-25 | Angelegt | slice-006 (Index-Storage) |
| 2026-06-02 | Schwelle an ADR-0013 gebunden statt selbst behauptet (Nachtrag, keine Entscheidungs-Änderung) | ADR-0013 |
| 2026-06-03 | Geprüft, weiterhin gültig — Welle 2 läuft | slice-013 |
