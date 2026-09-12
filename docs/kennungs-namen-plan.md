# Kennungs-Namen-Plan — Bereinigung der Welle-/Slice-Restbestände

**Stand:** 2026-09-11 — **alle sieben Pakete (P1–P7) umgesetzt, Gates grün**
(`make check`, `make bundle-check`, `lab/example`s eigenes `make verify`,
`bash lab/team-sim/run.sh` — 72/72). Diese Datei ist damit Historie: Sie
dokumentiert, was gesucht und in welcher Reihenfolge behoben wurde.
Committet und gepusht als Wellen 130–131 (`80b0968`).

Ursprünglich: Welle 130 hat die Regel gesetzt (`kurs/de/grundlagen/source-precedence.md`
§Vergabe) und den Herkunfts-Anker (`grundlagen/traceability.md`) auf sie umgestellt.
Dieser Plan trug den **Rest**: alle Stellen, an denen der alte Zählraum
(`welle-<NN>`, `slice-<NNN>` und ihre konkreten Instanzen) noch auftauchte.

**Abgrenzung.** Die Regel selbst (**warum** Name statt Nummer) steht in
[`source-precedence.md` §Vergabe](../kurs/de/grundlagen/source-precedence.md#vergabe-woher-die-nächste-kennung-kommt)
und wird hier **nicht** wiederholt. Dieser Plan sagt nur, **wo** noch die alte
Form steht und **in welcher Reihenfolge** sie fällt.

## Regeln für jede Umsetzung

1. **Fix-Richtung Quelle zuerst:** `kurs/de` → `lab/regelwerk` (Spiegel,
   wortgleich — Operation 6/Verdichten wird hier **nicht** angewandt; das ist
   eine bewusst konservative Wahl dieser Wellen, keine Vorgabe aus
   `regelwerk-extrakt.md` selbst, das Operation 6 allgemein und nur an
   Kontext-Kosten gebunden fasst) → `lab/templates` → `lab/example`, wo
   berührt → `kurs/de/loesungen`.
2. **Zeitdokumente bleiben, wie sie sind.** Was einen realen, bereits
   vergangenen Zustand protokolliert, ist ein
   [einfrierendes Artefakt](../kurs/de/grundlagen/harness-dateien.md#harnessreadmemd-als-einstiegspunkt)
   und wird **nicht** umgeschrieben — dieselbe Regel, die
   `referenz-richtung.md` so fasst: *„Eine Historie-Zeile ist ein Protokoll;
   sie wird nicht rückwirkend geändert."* Das gilt für:
   - `docs/reviews/review-runde-*.md` (abgeschlossene Reviews),
   - datierte Einträge in `docs/roadmap.md` und `docs/team-plan.md`
     (*„umgesetzt als Welle NN"*),
   - die Messreihe in `docs/team.md` (*„Gemessen an `ai-harness-init` über
     764 Commits"* — 83/19/24/10/2 sind Ist-Zahlen einer historischen Zählung,
     keine Norm),
   - CR-Zitate in `docs/regelwerk-extrakt.md` (`slice-019`, `CO-009` — real
     angenommene Change Requests),
   - `docs/steering-loop-team.md`s Herkunfts-Anker-Zitate (`seit
     welle-105`/`welle-106`/`welle-116`) — das sind reale, im CHANGELOG
     kanonisch gezählte Wellen **dieses Repos selbst** (Projekt-Wellenzählung),
     eine andere Kennungs-Klasse als die gelehrte Slice-/Welle-Datei-Form aus
     §Vergabe. Sie numerisch zu belassen ist keine Altlast, sondern korrekt.

   Diese Dateien bleiben unangetastet. Ausnahme: Ein Verweis darin zeigt auf
   eine Datei, die selbst umbenannt wird (siehe P4) — dann zieht **nur der
   Pfad** nach, nicht der historische Sachverhalt drumherum.

   **Keine Ausnahme für `lab/example`.** Obwohl seine Slices/Wellen reale,
   abgeschlossene Arbeit dokumentieren und einzelne seiner Artefakte
   (Review-Report, Closure-Notiz, Accepted-ADR, geschlossener Slice) nach
   `harness-dateien.md` §Jedes Artefakt hat einen Konsumenten selbst
   **einfrierende Artefakte** sind, gilt die Zeitdokument-Regel oben nur für
   Zeitdokumente **dieses** Repos. `lab/example` steht laut
   [`AGENTS.md` §1 Rangfolge](../AGENTS.md#1-rangfolge) am **Ende** der
   Kette (`kurs/de` → `lab/regelwerk` → `lab/templates` → `lab/example`) —
   nichts Nachgelagertes zitiert seine Kennungen als Autorität, anders als
   ein reales Projekt, dessen geschlossener Slice der Endpunkt seiner
   eigenen Kette ist. Die Kennungs-**Form** darf deshalb umgestellt werden;
   das ändert nichts an der Einfrier-Regel für den **Inhalt** einzelner
   Artefakte selbst (siehe P3, ADR-Immutability-Ausnahme). Entschieden:
   volle Umbenennung, siehe P3.
3. **Gates grün pro Paket:** `make check`, `make bundle-check`,
   `bash lab/team-sim/run.sh` — vor jedem Commit.
4. **Nicht committen ohne Wort** — Standard-Konvention dieses Repos.

## Fundklassen

Ein Sweep (`grep -rlE 'welle-<NN>|slice-<NNN>|welle-3\b|welle-2-qualitaet|
welle-4-betrieb|slice-0[0-9][0-9]\b|welle-NN\b|slice-NNN\b'`, Chronik nach
Regel 2 abgezogen) trifft **~45 Dateien** in vier ungleich großen Klassen:

| Klasse | Beispiel | Risiko, wenn liegen gelassen | Paket |
|---|---|---|---|
| **A — Definitions-Echo** | „trägt den Herkunfts-Anker `(seit welle-<NN>)`" | genau die Vorlage, die ein Code-Agent kopiert | P2 |
| **B — Operative Platzhalter** | `slice.template.md`: `docs/plan/planning/open/slice-<NNN>-<kurzer-titel>.md` | ein Agent füllt das Template **wörtlich** aus | P1 |
| **C — Realer Bestand in `lab/example`** | `slice-014-ann-suche.md`, `welle-2-qualitaet.md` (12 physische Slice-Dateien, 1 Welle, alle Querverweise) | Lehrmaterial, das dem Kurs widerspricht, wenn es numeriert bleibt — **entschieden: volle Umbenennung**, siehe P3 | P3 |
| **D — Einzelne Fallbeispiel-Zahlen** | `slice-024` in Modul-11/12/15, `slice-031` in der Lösung zu Modul 5 | kleiner, verstreuter Rest ohne Definitions-Anspruch | P5 |

## Pakete

| Paket | Inhalt | hängt an | Größe |
|---|---|---|---|
| **P1** | Templates: operative `<NN>`/`<NNN>`-Platzhalter auf `<Kennung>`/Namensform | nichts | M |
| **P2** | Definitions-Echo in Modulen + Grundlagen: Restatement → Pointer auf `traceability.md#herkunfts-anker` bzw. `source-precedence.md#vergabe-…` | nichts | L |
| **P3** | **Entschieden — volle Umbenennung:** `lab/example`s realer Bestand (12 physische Slice-Dateien, `welle-1`, `welle-2-qualitaet` offen) plus alle Querverweise auf Namensform migrieren | P1, P2 (Form muss stehen, bevor P3 sie anwendet) | **L** |
| **P4** | Modul-6-Fallbeispiel-Tabelle (*„Nächste Wellen"*: `welle-3-skalierung`, `welle-4-betrieb`, `slice-014`–`017`) — bereits jetzt teilweise von `lab/example` gedriftet (siehe Befund unten), zusätzlich auf P3s neue Namen umzustellen | P3 | M |
| **P5** | Verstreute Einzel-Beispiele ohne Definitions- oder Bestands-Bezug (Modul 4/9/11/12/15, Lösungen, `checkpoints.md`, `kalibrierungsbeispiele.md`) | nichts | S–M |
| **P6** | `docs/zeitdokument-archiv.md` — explizit „Diskussionsstand, nicht normativ"; niedrige Priorität, eigener kleiner Durchgang | nichts | S |
| **P7** | `.d-check.yml` + `lab/example/.d-check.yml`: `matrix`-Sensor hat `token: 'slice-\d{3}'` hart kodiert — erkennt einen namensbasierten Slice nicht. Muss vor P3 stehen, sonst wird die ADR→Slice-Prüfung für jede umbenannte Datei still blind (kein Fehler, kein Treffer mehr) | nichts (strukturell) — empfohlen vor P3 | S |

P1, P2, P5, P6 sind unabhängig voneinander und von P3/P4/P7 — sie können in
beliebiger Reihenfolge laufen und jede Welle aus [`docs/team-plan.md`](team-plan.md)-artigem
Zuschnitt auffüllen. P7 ist strukturell frei, aber vor P3 empfohlen.

### P1 — Templates

**Kette:**
`lab/templates/docs/plan/planning/{welle.template.md, welle-results.template.md,
slice.template.md, observation.template.md, roadmap.template.md,
archiv-stub-slice.template.md, archiv-stub-welle.template.md, README.template.md,
reconciliation.template.md}` (in `reconciliation.template.md` :19 mischt die
Beispielzeile `CO-004 -> slice-021` in einer Zelle — nur `slice-021` fällt,
`CO-004` ist eine andere Kennungs-Klasse und bleibt) ·
`lab/templates/docs/plan/carveouts/README.template.md`
(nur die `slice-<NNN>`-Spalte — `CO-<NNN>` ist eine andere Kennungs-Klasse,
bleibt) ·
`lab/templates/docs/reviews/review-report.template.md` ·
`lab/templates/harness/conventions.template.md` (nur die
`slice-<NNN>`-Nennung, nicht `ADR-<NNNN>`/`MR-<NNN>`/`BEO-<NNN>`/`CO-<NNN>`) ·
`lab/templates/AGENTS.template.md`.

**DoD:** Sweep-Pattern liefert für `lab/templates/` 0 Treffer außerhalb der
anderen Kennungs-Klassen (`ADR-`, `MR-`, `BEO-`, `CO-`, `RC-` bleiben
unverändert); `make bundle-check` grün.

### P2 — Definitions-Echo

**Kette:** überall, wo der Herkunfts-Anker oder die Slice-Datei-Form **erneut
behauptet** statt **verwiesen** wird:
`kurs/de/{02-planung/modul-05-planning-harness.md, 02-planung/modul-06-roadmap.md
(nur die definitorischen Stellen — die Fallbeispiel-Tabelle ist P4),
02-planung/modul-07-carveouts.md, 03-agenten/modul-08-agentenrollen.md
(nur die definitorischen Zeilen `welle-<NN>-results.md`/`seit slice-<NNN>` —
der Sequenzdiagramm-Dialog mit `slice-024` ist P4),
03-agenten/modul-09-implementierung.md, 04-qualitaet/modul-10-review-harness.md,
04-qualitaet/modul-13-quality-gates.md, 05-betrieb/modul-16-produktiver-betrieb.md,
grundlagen/harness-dateien.md (Rest-Beleg), grundlagen/referenz-richtung.md
(Rest-Beleg)}` →
`lab/regelwerk/{modul-05-planning-harness.md, modul-06-roadmap.md,
modul-07-carveouts.md, modul-08-agentenrollen.md, modul-09-implementierung.md,
modul-10-review-harness.md, modul-13-quality-gates.md,
modul-16-produktiver-betrieb.md, grundlagen-harness-dateien.md,
grundlagen-referenz-richtung.md}`.

**Muster:** `` `(seit welle-<NN>)` — ohne Welle `(seit slice-<NNN>)` `` wird zu
einem Verweis auf [§Herkunfts-Anker](../kurs/de/grundlagen/traceability.md#herkunfts-anker-für-steering-loop-regeln) —
dieselbe Bauart, die `grundlagen-harness-dateien.md` §Verzeichniskonvention
in Welle 130 schon bekommen hat (Pointer statt Wiederholung).

**DoD:** Sweep-Pattern liefert für die genannten Dateien 0 Treffer; die
Spiegel-Sätze bleiben wortgleiche Teilfolgen der Kurs-Sätze (Operation 1–5,
kein Verdichten); `make check` grün.

### P3 — `lab/example`s realer Bestand auf Namensform migrieren (entschieden)

**Befund.** `lab/example` trägt **12 physische Slice-Dateien**
(`slice-009`, `013`–`015`, `020`–`026`; `slice-001`–`008`/`010`–`012`/
`016`–`019` sind nie als eigene Datei geführt worden oder in
`welle-1-mvp.md` aufgegangen — die „26" in älteren Zählungen sind
Beobachtungs-Register-Belege, keine Dateien) sowie
`welle-1-mvp`/`welle-1-results` (`done/`) und `welle-2-qualitaet` (offen) —
mit Geflecht aus Beobachtungs-Register-Belegen (`evidence/slice-NNN.md`),
ADR-Rückbezügen, Review-Reports und der Roadmap.

**Entschieden: volle Umbenennung** — Begründung siehe Regel 2 oben
(„Keine Ausnahme für `lab/example`"). Ein „kein Nachrüsten" wurde erwogen
und **ausdrücklich verworfen**.

**Umfang.** Alle 12 Slice-Dateien, `welle-1-mvp`/`welle-1-results`,
`welle-2-qualitaet` werden per `git mv` umbenannt; Pfad-Querverweise ziehen
nach, in eigenem Commit nach dem Move (dieselbe Trennung wie beim
Herkunfts-Anker-Ruheort). Ein breiterer Sweep (`rg 'slice-0|welle-' -i
lab/example`, 167 Dateien/874 Zeilen repoweit, davon ~100 Treffer allein in
`lab/example`) ist zu **weit** gefasst — er trifft überwiegend normales
Vokabular (`Welle-Closure`, `Welle-Datei`, `Slice-Plan`), keine Kennungen —,
deckt aber Querverweis-Gruppen auf, die in einer ersten Fassung dieses
Plans fehlten:

- **Der eigene Herkunfts-Anker.** `lab/example/AGENTS.md` §2.7 trägt
  `(seit welle-1)` und zeigt auf `done/welle-1-results.md` — dieselbe
  Ruheort-Pfadkorrektur wie überall sonst, kein Sonderfall (AGENTS.md ist
  kein einfrierendes Artefakt).
- **Das Golden-Set-Verzeichnis** `evals/golden/welle-1-baseline/` — eine
  **Verzeichnis-Umbenennung**, nicht nur Dateien; zieht `evals/golden/README.md`,
  `harness/sensors/replay.md`, `runbooks/release-checklist.md` sowie das
  `CHANGELOG.md`/`manifest.yaml` **innerhalb** des Verzeichnisses nach.
- **Carveout-Dateien** `docs/plan/carveouts/CO-001-index-coverage.md` und
  `CO-002-replay-verifikation.md` zitieren `welle-1`/`welle-2`.
- **`docs/plan/planning/README.md`** verlinkt die umbenannten Dateien
  namentlich (`welle-2-qualitaet.md`, `welle-1-mvp.md`, `welle-1-results.md`).
- **Coverage-Gate-Kommentar, identisch in sechs Sprachvarianten** —
  „Hochschalt-Trigger M2 (welle-2 geschlossen)" in `cpp/Makefile`,
  `csharp/Makefile` + `coverlet.runsettings`, `go/Makefile`,
  `java/Makefile` + `pom.xml`, `kotlin/Makefile` + `build.gradle.kts`,
  `python/Makefile`.
- **Geklärt bei Ausführung:** `docs/reviews/2026-09-05-slice-026.md` trägt
  keine d-check-durchgesetzte Immutability (anders als Accepted-ADRs —
  `reviews`-Modul prüft Deckung, nicht Inhalt) — mitmigriert.
  `spec/lastenheft.md`s „Welle-1-Schema" meint das **LH-\*-Nummernschema**
  aus der Zeit von Welle 1, nicht die Slice-/Welle-Kennung selbst — eine
  andere Kennungsklasse, unverändert gelassen.
- **Außerhalb von `lab/example` selbst, aber von P3 abhängig:**
  `kurs/de/grundlagen/referenz-richtung.md` und ihr Spiegel zitieren
  `slice-009` als reales Beispiel für einen Sensor-Ausnahmefall (*„`make
  test-determinism` (slice-009) verifiziert auch LH-FA-NNN"*) — zieht mit,
  sobald P3 diese Datei umbenennt.

**Ausdrücklich nicht Teil von P3: `lab/team-sim/`.** Der
Simulations-Harness (`run.sh`, `seed/`) nutzt numerische
Welle-/Slice-Fixtures **absichtlich**, um beide Formen — die kollisions-
anfällige Nummer und die kollisionsfreie Name-Form (Szenariogruppe s24) —
gegeneinander zu testen. Umbenennen würde genau den Kontrast zerstören,
den die Szenarien belegen sollen.

**Ausnahme: Accepted-ADR-Rumpftext.** Sechs Accepted ADRs (`0001`, `0002`,
`0003`, `0011`, `0012`, `0013`) zitieren `slice-009`/`slice-013` in
laufender Prosa (nicht nur in `Geschichte`), z. B.
`0012-index-write-strategy.md` :45/:73/:86. Nach `lab/example/AGENTS.md`
§2.5 sind Accepted-ADRs **immutable** — Korrekturen laufen nur über
`Supersedes ADR-NNNN`, ein Rumpftext-Edit träfe `core-drift-vcs` (d-check
`vcs`-Modul). Diese Zitate bleiben deshalb in Zahlenform stehen; migriert
wird nur die **Datei**, nicht die historische Prosa, die sie beim Namen
nennt — dieselbe Unterscheidung, die die Zeitdokument-Regel oben für
Inhalt vs. Form trifft.

**Aufwand:** **L** — Dateiumfang (12 reale Dateien, nicht 26 wie zunächst
angenommen) plus Querverweis-Nacharbeit. Keine MAJOR-Politik dieses Repos
einschlägig: `lab-regelwerk.zip` enthält laut `tools/build-bundle.sh` nur
`lab/regelwerk/` und `lab/templates/` — `lab/example` ist kein Bundle-Asset,
also greift `AGENTS.md` §6s Datei-Ebene-Kriterium hier nicht. Läuft als
normale(r) MINOR-Welle(n) dieses Repos, dokumentiert im CHANGELOG wie jede
andere Welle — kein eigenes ADR in `lab/example` nötig (der Rename ist eine
Pflege-Entscheidung dieses Repos, keine fiktive Architektur-Entscheidung
des Beispiel-Projekts).

**Reihenfolge innerhalb P3:** **P7 zuerst, vor jedem Rename** — der
`matrix`-Sensor scannt jede `slice-*.md` unabhängig von offen/geschlossen;
ein Rename vor dem Token-Fix macht die ADR→Slice-Prüfung für die
betroffene Datei **still blind** (sie feuert nicht mehr, meldet aber auch
keinen Fehler), nicht nur bei offenen Slices. Danach beliebige Reihenfolge;
geschlossene Slices (`done/`) sind unkritischer, weil keine laufende Arbeit
an ihnen hängt.

**DoD:** `rg 'slice-<NNN>|welle-<NN>' -i lab/example` 0 Treffer; zusätzlich
`rg 'slice-0|welle-' -i lab/example` gegengelesen — jeder verbleibende
Treffer ist entweder normales Vokabular oder eine der beiden benannten
Ausnahmen (Accepted-ADR-Rumpftext, ggf. Review-Reports); `make bundle-check`
und `bash lab/team-sim/run.sh` grün (Letzteres unverändert, weil P3
`lab/team-sim/` nicht berührt).

### P4 — Modul-6-Fallbeispiel-Tabelle

**Befund.** Die Tabelle ist bereits jetzt nicht mehr deckungsgleich mit
`lab/example`: `slice-015` heißt im Kurs „Multi-Sprach-Adapter-Cleanup", die
reale Datei ist ein Replay-Runner; `slice-016`/`017` und `welle-4-betrieb`
existieren in `lab/example` gar nicht. Die Tabelle ist damit schon vor
diesem Plan zu einer Illustration gedriftet, keine Bestandsspiegelung mehr.

**Umsetzung.** Zwei Korrekturen in einem Zug: die Drift beheben (Tabelle
wieder an reale `lab/example`-Inhalte binden, oder — wo kein realer
Gegenpart existiert wie bei `slice-016`/`017`/`welle-4-betrieb` — als
erkennbar hypothetisches Beispiel kennzeichnen) und die Namen aus P3
übernehmen, sobald P3 gelandet ist.

**Nicht nur die Tabelle.** Dasselbe Fallbeispiel taucht in
`modul-06-roadmap.md` an mehreren weiteren Stellen auf, die ein enger
Sweep auf die Tabellenzeile allein übersehen hätte: der Abhängigkeits-Satz
„Welle 3 (`welle-3-skalierung`) kann erst starten, wenn Welle 2
(`welle-2-qualitaet`) fertig ist", die Drift-Log-Beispielzeile „`slice-019`
in `welle-3` nachgenommen" und die zugehörige Selbstcheck-/Übungsfrage. Alle
zitieren dieselben Namen wie die Tabelle und fallen mit ihr.

Betroffen zusätzlich (weil sie **dieselbe Zeile** zitieren, nicht neu
behaupten): `lab/regelwerk/modul-06-roadmap.md` :73
(Kandidaten-Tabelle) · `kurs/de/loesungen/modul-06-loesung.md` ·
`kurs/de/03-agenten/modul-08-agentenrollen.md` (Sequenzdiagramm-Dialog mit
`slice-024`) und dessen Lösung.

**DoD:** `rg 'welle-3-skalierung|welle-4-betrieb|welle-2-qualitaet|slice-01[4-9]|slice-024' kurs/ lab/`
zeigt für jeden verbleibenden Treffer entweder P3s neue Namen oder eine
erkennbare Kennzeichnung als hypothetisch; `make check` grün.

### P5 — Verstreute Einzel-Beispiele

Kleinere Fundstellen ohne Definitions- oder Bestands-Anspruch — reine
Illustrationszahlen, austauschbar ohne Rename-Kaskade:
`kurs/de/01-spec-und-architektur/modul-04-adrs.md` (`slice-014` als
ADR/Spec/Plan-Beispiel) · `kurs/de/loesungen/modul-04-loesung.md` ·
`kurs/de/loesungen/modul-05-loesung.md` (`slice-031`) ·
`kurs/de/loesungen/modul-07-loesung.md` · `kurs/de/loesungen/modul-08-loesung.md` ·
`kurs/de/loesungen/modul-09-loesung.md` (`slice-014a`) ·
`kurs/de/loesungen/modul-11-loesung.md` (`slice-014b`) ·
`kurs/de/loesungen/modul-12-loesung.md` (`welle-1-baseline`) ·
`kurs/de/loesungen/modul-15-loesung.md` ·
`kurs/de/04-qualitaet/modul-11-verification.md` ·
`kurs/de/04-qualitaet/modul-12-replay-evaluierung.md` ·
`kurs/de/04-qualitaet/modul-13-quality-gates.md` :414 (Adaptions-Block-Beispiel
— dieselbe Vereinfachung, die `traceability.md` in Welle 130 schon bekommen
hat: *„drei Slice-Kennungen als Beleg"* statt `slice-041/044/047`) ·
`kurs/de/05-betrieb/modul-15-observability.md` ·
`kurs/de/05-betrieb/modul-16-produktiver-betrieb.md` ·
`kurs/de/grundlagen/checkpoints.md` · `kurs/de/abschluss/kalibrierungsbeispiele.md`.

**DoD:** jede Ersetzung durch einen Namens-Slug im selben Stil wie
`source-precedence.md` (`slice-audit-log-hardening`, `welle-cache-warmup`),
Sweep-Pattern 0 Treffer, `make check` grün.

### P6 — `docs/zeitdokument-archiv.md`

Explizit als „Diskussionsstand, nicht normativ" markiert und ausdrücklich
folgenlos für Kurs/Regelwerk/Templates. Eigener, kleiner Durchgang, niedrige
Priorität — ändert nichts an der Normkette.

## Wellen-Vorschlag

Reihenfolge, kein Terminplan — jede Welle schließt durch ihre Kette und
`make check`, nicht durch ein Datum. Nummern erst bei der Registrierung
(CHANGELOG-kanonisch).

| | Pakete | Bemerkung |
|---|---|---|
| 1. | P1 | Templates zuerst — größtes operatives Risiko, kleinster Umfang |
| 2. | P2 | Definitions-Echo — schließt die vom Nutzer benannte Dringlichkeit |
| 3. | P7 | `matrix`-Sensor-Fix, vor P3 — sonst bricht die ADR→Slice-Prüfung während der Migration |
| 4. | P3 | `lab/example` vollständig auf Namensform migrieren (MINOR-Welle(n), kein Bundle-Asset) |
| 5. | P4 | Fallbeispiel-Tabelle: Drift beheben + P3s neue Namen übernehmen |
| 6. | P5 | verstreute Einzelbeispiele, beliebig parallel zu 1–5 einschiebbar |
| 7. | P6 | Diskussionsdokument, jederzeit nachziehbar |
