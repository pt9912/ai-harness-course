# Changelog

Kanonisches Register der Überarbeitungs-Wellen dieses Kurses. Die
Stand-Zeile von [`lab/regelwerk/README.md`](lab/regelwerk/README.md)
referenziert diese Nummern; adoptierende Repos vergleichen ihren
Baseline-`Stand:`-Eintrag gegen dieses Register.

> **Zählung.** Fortlaufend über alle Wellen (Inhalt, Didaktik,
> Tooling). Vor Einführung dieses Registers liefen zwei parallele
> Zählungen in Commit-Messages (generisch „Welle 1–16" und
> „Didaktik-Review Welle N") — Commit-Labels können daher von der
> kanonischen Nummer abweichen; maßgeblich ist dieses Register.

## Welle 37 — 2026-07-26 · Templates verweisen auf die vendorte Baseline statt in den Kurs

### Geändert

- **Alle 42 Kurs-Verweise in `lab/templates` aufgelöst — das Bundle ist jetzt
  vollständig netzlos.** Nach Welle 35 (Regelwerk) blieb die zweite Hälfte:
  Templates zeigten durchgängig in den Kurs, obwohl der Adopter das Regelwerk
  **lokal** unter `.harness/baseline/<tag>/regelwerk/` vendored liegen hat. Das
  widersprach der eigenen `MR-003`-Begründung (Modul-0-Prinzip:
  *Per-Lauf-Relevantes gehört verkörpert, nicht extern nachgeladen*) — ein
  Kurs-Verweis heißt Netz, und zwar auch dort, wo der Inhalt zwei Verzeichnisse
  weiter liegt. Drei Klassen, drei Behandlungen:
  - **Löschbare Blöcke (10)** — Kopf-Hinweise („lösche diesen Block") und
    HTML-Kommentare. Sie werden nie mitkopiert, also greift die
    Kopier-Einschränkung gar nicht: relativer Link auf `../regelwerk/…`, der im
    Kurs-Repo (`lab/regelwerk`) *und* im Bundle (`regelwerk/` neben
    `templates/`) auflöst — dieselbe Doppel-Auflösung wie die
    `../templates/`-Ziel-Form-Verweise in der Gegenrichtung.
  - **Bleibender Inhalt (13)** — landet dauerhaft im Adopter-Repo, wo weder
    Pfadtiefe noch `<tag>` bekannt sind. Deshalb **Abschnitts-Zitat statt Link**:
    „Baseline-Regelwerk `grundlagen-konventionen.md` §Source Precedence". Ohne
    Pfad, ohne Tag; wo die Baseline liegt, steht beim Adopter genau einmal in
    `MR-003`. Ein Baseline-Upgrade berührt damit **eine** Datei statt dreizehn.
  - **`templates/README.md` (17)** — Index der Sammlung, wird nicht kopiert;
    relative Links, Spaltenkopf „Kurs-Verweis" → „Regelwerk-Abschnitt".
  Dazu eine **zweite Schicht von 13 Klartext-Nennungen ohne Link**
  („siehe Kurs Modul 4", „Kurs §Referenz-Richtung", „Kurs-Glossar"), die keine
  `kurs/de`-Suche findet — ebenfalls auf Regelwerk-Abschnitte umgestellt.
  **Stehen bleibt „Kurs"** nur noch als Name der Baseline-Quelle (11 Stellen:
  Baseline-Aufzählungen, „Kurs-Welle 24" als Stand-Beispiel, CHANGELOG im
  Kurs-Repo, `lab/example` als Vorbild-Zeiger).
  Empirisch gegengeprüft am simulierten Release-Bundle: **19 `regelwerk/`-Links
  lösen auf, 0 kaputt, 0 verbliebene Kurs-URLs**; die übrigen offenen Ziele sind
  die bekannte symbolische Klasse (`spec/lastenheft.md`, `CO-<NNN>-<titel>.md` …),
  die erst beim Ausfüllen entsteht.
- **`tools/rewrite-template-links.sh` und `.d-check.yml`: Kommentare ehrlich
  gemacht.** Beide beschrieben den alten Zustand („Quelle behält relative
  `../../kurs/`-Links", „Verweise in den Kurs … werden beim Release gepinnt").
  Die kurs-`sed` ist jetzt im Normalfall ein No-op und bleibt als **Sicherheitsnetz**
  deklariert; `ignore-refs` prüft ab jetzt `../regelwerk/`-Anker scharf — eine
  umbenannte Regelwerk-Überschrift verschickt sonst unbemerkt einen toten Anker
  ins Adopter-Repo.

## Welle 36 — 2026-07-26 · Artefaktklasse pro Rolle: sechs Rollen sind nicht sechs Skills

### Hinzugefügt

- **Modul 8 §Welche Rolle braucht welche Artefaktklasse.** `lab/templates/.harness/skills`
  enthält zwei Skill-Templates, der Kurs nennt sechs Rollen — die Asymmetrie war
  **deklariert, aber unbegründet**, und las sich dadurch als Rückstand. Modul 8
  §Lab-Bezug sagte *„Das Lab enthält **keine** Skill-Dateien pro Rolle"*, und der
  Reflexions-Trigger schlug ausgerechnet *„Skill-Datei pro Rolle?"* vor — ein
  Adopter baut daraufhin vier Attrappen. Jetzt steht das Kriterium explizit, und
  es ist aus Modul 10 abgeleitet, nicht neu erfunden: **eine Rolle braucht genau
  dann eine Skill-Datei, wenn ihr Urteil *inferential* ist UND auf
  repo-spezifischem Wissen beruht, das aus keinem Artefakt ableitbar ist.**
  Zuordnung: Planner/Architect → **Template** (Slice, Roadmap, ADR);
  Implementation → **Briefing** (`AGENTS.md` + 8-Schritt-Workflow); Reviewer →
  **Skill-Datei** (HIGH-Liste steht in keiner Spec, `inferential feedback` driftet);
  Verifier/Validator → **keins** (Prüfgrundlage reist im Slice mit bzw. liegt
  außerhalb des Repos). Zusatz: **Skills wachsen pro Urteilstyp, nicht pro Rolle**
  — `closure-note-reviewer.md` (Modul 11) ist dieselbe Rolle mit anderem
  Urteilstyp, keine siebte Rolle. **Kein neues Template**: vier weitere
  Skill-Dateien trügen keinen nicht-ableitbaren Inhalt.

### Geändert

- **Drei Stellen, die „eine Skill-Datei pro Rolle" nahelegten, geschärft.**
  Modul 8 §Lab-Grenze von *„enthält keine"* auf *„braucht keine, weil…"*
  umformuliert (die *echte* Grenze — kein Replay eines kompletten
  Rollendurchlaufs — bleibt separat stehen); Reflexions-Trigger von
  *„Skill-Datei pro Rolle?"* auf *„ist ein neuer Urteilstyp entstanden, der
  driftet?"*; Fehlvorstellung „Eine Person spielt alle Rollen" von
  *„unterschiedlichen Skill-Dateien"* auf *„der je passenden Artefaktklasse"*
  (auch in `loesungen/modul-08` und im Regelwerk-Split). Regelwerk-Split
  `modul-08` trägt die operative Fassung mit stabilem Anker
  `#artefaktklasse-pro-rolle` und Ziel-Form-Verweis auf
  `../templates/.harness/skills/reviewer.template.md`.

## Welle 35 — 2026-07-26 · Guard-Härtung als Worked Example; Regelwerk-Deixis umgehängt

### Hinzugefügt

- **Modul 13 §Worked Example B — „Guard-Härtung als Steering-Loop am Wächter".**
  Schließt den seit Einführung der Durchsetzungsschicht offenen „(folgt)"-Verweis
  (`grundlagen/durchsetzungsschicht.md` §Die Schicht wird selbst gesteuert). Zwei
  Wellen an einem Befehls-Guard: Welle 1 (`MR-004`, Befehlspositions-Denylist nach
  3× direktem `pytest`-Aufruf), Welle 2 (`MR-005`, rekursives Auspacken der
  `-c`-Payloads inkl. `-lc`/`-ec`, fail-closed über Tiefenlimit) — je mit
  Beobachtungs-Beleg aus Lerneinträgen, *verworfener* Alternative (`bash` auf die
  Denylist: ein abgeschalteter Wächter ist schlechter als ein löchriger) und
  Landung als **neuer** `MR`, nie als Edit am akzeptierten Eintrag. Wellen-Tabelle
  mit bewusst leerer Zeile 3 („die nächste Welle wird beobachtet, nicht geplant"),
  drei Entgleisungen, und die Abgrenzung Gate (prüft ein *Ergebnis*, computational
  feedback) vs. Wächter (verhindert eine *Handlung*, computational feedforward) —
  deshalb steht der Guard bewusst **nicht** in §Gate-Typ ↔ Fehlerbild. Das
  bestehende Worked Example heißt jetzt **A** (Anker `worked-example-a-…`,
  3 Verweise in Modul 4 nachgezogen). Neue Analysieren-Übung (Welle 3 schreiben:
  Beleg → Abwägung → neue Grenz-Zeile) + Lösungshinweis, Reflexions-Trigger
  ergänzt. Die `Grenze:`-Zeile im `MR`-Block ist explizit als **repo-lokales
  Zusatzfeld** ausgewiesen — die Pflichtfelder des Adaptions-Blocks bleiben
  unangetastet, kein Template-Eingriff. Regelwerk-Split `modul-13` trägt die
  operative Fassung (`§Guard-Härtung`, stabiler Anker `#guard-haertung`), beide
  „(folgt)"-Enden geschlossen.

### Geändert

- **`lab/regelwerk`: Selbstverweise auf „Kurs" auf das Regelwerk umgehängt.** Sieben
  Stellen sagten im vendorten Betriebsregelwerk „in diesem Kurs" / „Bedeutung im
  Kurs" / „Kurs-Glossar" / „pro Kurs-Phase" — ein Referent, der im Adopter-Repo
  ins Leere zeigt (`grundlagen-konventionen` ×3, `grundlagen-klassifikation`,
  `modul-04`, `modul-14`, `modul-16`). Das ist **keine** Verletzung der
  Quelltreue-Regel, sondern dieselbe Operation, die beim Split ohnehin passiert:
  relative Links werden umgehängt, Deixis genauso — der Satz behält seine Aussage,
  nur sein Referent wandert mit dem Text. **Stehen bleibt „Kurs", wo es die
  Baseline-*Quelle* benennt** (Baseline-Aufzählungen in `modul-01`/`konventionen`,
  „neues Kurs-Release" als Drift-Trigger in `modul-02`, Baseline-Auswahl
  `modul-02` §Schritt 1, sowie das gesamte README: Framing, Stand-Zeile,
  Normativitäts-Klausel, Lizenz). Zusätzlich ein Didaktik-Rest entfernt
  (`grundlagen-klassifikation`: „…warum Replay und Golden Sets im Kurs ein eigenes
  Modul bekommen" — eine Aussage über den *Kursaufbau*, die nach der Weglass-Regel
  nicht ins Regelwerk gehört). Die Transformationsregel steht als eine Klausel im
  README-Extrakt-Satz, nicht als eigener Absatz: sie ist eine Maintainer-Regel für
  die *Herstellung* des Splits, und das README reist im Bundle zum Adopter mit.
  **Keine `kurs/`-Änderung** — die Quelle ist ein Kurs und sagt zu Recht „in diesem
  Kurs". `make check` grün (d-check 0 Befunde, docs 0/0, alignment 0 WARN).
- **`lab/regelwerk` verweist nicht mehr auf Kurs-Material — 14 Auswärts-Links
  aufgelöst.** Zweite Leck-Klasse an derselben Wurzel: Verweise aus dem netzlos
  ausgelieferten Bundle auf Dateien, die *nicht* mitreisen (`fallstudien.md`,
  `quellen.md`, `reflexion-vorlage.md`, `lernervorstellungen.md` liegen nicht in
  `lab/templates/`). Die betroffenen Ziele tragen **keine Regel**: Fallstudien
  sind vier konkrete Repos mit Stand-Momentaufnahme („Stand 2026-06") und einer
  Spalte *„Was der Kurs daraus zieht"*, `quellen.md` ist ein Literaturverzeichnis
  mit eigenem Abschnitt *„Didaktische Quellen"*, `reflexion-vorlage.md` eine
  Vorlage für Kurs-*Übungen*. Alle 14 Verweise standen in Beleg-Klammern; die
  tragenden Sätze bleiben wortgleich stehen (Beispiel: „Ein reifes Repo (Beispiel
  `pt9912/grid-gym`, siehe fallstudien.md) hat…" → „Ein reifes Repo (Beispiel
  `pt9912/grid-gym`) hat…"). Betroffen: 8× `fallstudien.md`, 2× `quellen.md`,
  1× `reflexion-vorlage.md`, 1× `lernervorstellungen.md`; dazu `modul-08`, dessen
  Steering-Loop-Verweis auf die **in-Bundle** stehende 1×/2×/3×-Regel in
  `grundlagen-klassifikation.md` §Steering Loop umgehängt wurde. Dazu die README
  selbst: ihr Absatz „Vendored gelesen?" — die Anrede an den Adopter, der das
  Bundle netzlos liest — schickte für *„Vorgehen beim Bootstrap"* nach draußen in
  den Kurs, obwohl `modul-02-harness-bootstrap.md` im Bundle liegt; auf den Split
  umgehängt. **Genau ein** Auswärts-Link bleibt: die Normativitäts-Klausel
  („maßgeblich für den Inhalt bleibt der Kurs unter `/kurs/de/`") — dort *ist* der
  Sprung nach draußen der Zweck. Alles andere im Regelwerk ist netzlos.
- **`konventionen.md`: neue `### Einführungs-Reihenfolge über mehrere Repos`.**
  Beim Entfernen der Fallstudien-Verweise fiel auf, dass `fallstudien.md`
  **gemischt** ist: neben Fallbeispielen trug sie eine echte Betriebsregel
  („Beginne immer beim Referenz-Repo, portiere erst nach erfolgreicher
  Steering-Loop-Iteration auf die Flagships; alle Repos parallel mit demselben
  Master-Prompt zu treiben skaliert nicht"), die **nirgends sonst stand** —
  verifiziert gegen Regelwerk *und* `konventionen.md`. Eine allgemeine Regel auf
  einer Fallbeispiel-Seite ist eine Quell-Fehlablage, deshalb Fix-Richtung
  **Quelle**: die Regel wandert wortgleich (plus Begründung aus §Konsequenzen pro
  Klasse) nach `konventionen.md` §Harness-Bootstrap; `fallstudien.md` behält den
  Absatz als Kontext-Hinweis mit Pointer, normativ ist ab jetzt der
  Konventions-Text. Damit trägt der Split `grundlagen-konventionen` die Regel
  quell-verankert — sie verschwindet nicht mit den Fallstudien-Verweisen. Die
  §Repo-Klassen-Hälfte brauchte keinen Umzug: sie steht als Kernbegriff und in
  den Source-Precedence-Konsequenzen bereits im Regelwerk.

## Welle 34 — 2026-07-24 · Change-Request-Landing-Disziplin: Fußabdruck statt Konstrukt

### Geändert

- **`konventionen.md` §Spec-Stratifizierung: „Change Request" als externer
  Prozess eingeordnet, nicht als Konstrukt.** Der Kurs benannte CR bisher nur
  als Änderungs-Prozess-Label des Vertrags-Stratums, ohne zu sagen, was er
  *ist* und was er im Repo hinterlässt — jedes adoptierende Repo hätte das
  anders gelöst (eigenes CR-Template? `spec/change-requests/`? Version-Bump
  ja/nein?). Ein Absatz nach der Hard Rule stellt klar: CR ist **bewusst kein
  Harness-Konstrukt** (kein `CR-*`-ID-Schema, keine Datei, kein Gate), sondern
  der externe Vorgang der Vertragsänderung mit dem Auftraggeber. In-Repo-
  Fußabdruck eines *angenommenen* CR = Version-Bump des Lastenhefts +
  Historie-Zeile mit CR-Verweis + geänderte `LH-*`/`HSM-*`;
  abgelehnte/schwebende CRs leben außerhalb. Die Hard Rule „ADR darf `LH-*` nie
  schärfen" wird explizit auf Slice ausgedehnt (über den SDP-Stabilitäts-Rang
  Vertrag › ADR › Slice bereits implizit). Verworfen: ein eigenes CR-Konstrukt
  (wäre ein viertes Änderungsmuster neben MR/ADR/supersede und bräche mit „ADR
  schärft das Lastenheft nicht") — die gewählte Option „Landing-Disziplin
  schärfen" ehrt Quelle-ist-Anker. Regelwerk-Split `grundlagen-konventionen`
  wortgleich mitgezogen; `lab/templates/spec/lastenheft.template.md` Historie-
  Kommentar schärft den Fußabdruck. `make check` grün (docs 0/0, alignment
  0 WARN). Auslöser: Adopter-Frage „brauchen wir ein CR-Template, sonst macht
  es jedes Zielprojekt anders?".

## Welle 33 — 2026-07-23 · README-Template: `done/` als Heimat abgeschlossener Nicht-Slice-Records ehrlich benennen

### Geändert

- **`planning/README.template.md`: „slice-reserviert"-Überbehauptung korrigiert.**
  Der Block „Slices vs. Wellen" behauptete pauschal „die Lifecycle-Verzeichnisse
  sind **slice-reserviert**" und legte zugleich `welle-<id>-results.md` (ein
  Nicht-Slice-Record) in `done/` — ein Widerspruch im selben Absatz. Jetzt
  getrennt: der aktive Durchlauf `open/` → `next/` → `in-progress/` nimmt
  ausschließlich Slices auf; `done/` archiviert zusätzlich abgeschlossene
  **Nicht-Slice-Records** (Welle-Closure `done/<welle-id>-results.md`; aufgelöste
  Carveouts, Modul 7). **Template-Drift-Korrektur:** „slice-reserviert" stand nur
  im Template, die Quelle (Modul 6 §Welle-Closure: aktive Welle flach, geschlossene
  → `done/` per `git mv`) war korrekt — Fix-Richtung Template→Quelle, **kein**
  `kurs/`-Eingriff, keine Lehre berührt. Auslöser: m-trace-Planning-Layout-Audit,
  bei dem Nicht-Slice-Register mangels sanktioniertem flachem Ort in ein
  Lifecycle-Verzeichnis gezwängt wurden. Die weitergehende Frage (eigener Kanal
  für Discovery-/Kandidaten-Register) ist bewusst **vertagt**, bis ein zweites
  Konsument-Repo denselben Druck unabhängig zeigt.

## Welle 32 — 2026-07-19 · regelwerk-drift-Sensor retired; d-check sources im Freshness-Audit eingeordnet

### Entfernt

- **`check_regelwerk_drift.py` + `make regelwerk-drift`** aus `lab/example`. Der
  Sensor war ein Asset-/Content-Hash-Vergleich — genau die Methode, die Modul 2
  §Freshness-Audit als unzureichend markiert („der Hash des gepinnten Assets fängt
  nur ein nachträglich verändertes Release, nicht einen neuen Tag") — und seit dem
  Split-Verzeichnis (Welle 24) ohnehin ein No-op. `conventions.md` §Baseline von
  „ausstehend/übersprungen" auf einen ehrlichen Verweis umgeschrieben: das
  In-Repo-Beispiel ist selbst am Kurs-Stand; die Upstream-Freshness-Frage
  (Release-Listen-Prüfung) stellt sich erst im adoptierenden Fremd-Repo.

### Geändert

- **Modul 2 §Freshness-Audit: d-check `sources` (v0.51.0) eingeordnet.** Ein
  präziser Satz: `sources` automatisiert die *Asset-/Integritäts*-Hälfte
  (`source-pin`/`source-drift`), ersetzt aber die Release-Listen-Prüfung nicht —
  klärt die Verwechslung „sources = Freshness-Audit". Regelwerk-Split `modul-02`
  quelltreu mitgezogen.
- **d-check-Pin v0.51.0 → v0.51.1** (Fragment regeneriert). PATCH: dpin-Befund
  führt jetzt den vollen `sha256` (pins-Ergonomie); verhaltensneutral, `make check`
  unverändert grün. Kurs-intern.

## Welle 31 — 2026-07-19 · lab/templates im Referenz-Gate (scoped ignore-refs) + d-check v0.51.0

### Geändert

- **`lab/templates` steht jetzt im Referenz-Gate.** Das Verzeichnis mischt
  symbolische Ziel-Repo-Pfade (lösen erst nach dem Ausfüllen auf) mit prüfbaren
  Verweisen — 39 Kurs-Links (inkl. Anker) und template-interne Navigation. Bisher
  opferte `scan.ignore` die zweite Klasse komplett: die beim Release auf
  `blob/<tag>/` eingefrorenen Kurs-Verweise waren ungeprüft (eine umbenannte
  Kurs-Überschrift verschickte unbemerkt einen toten Anker). Ersetzt durch scoped
  `ignore-refs` (top-level `in`/`refs`/`keep`, d-check v0.49.0+): die 42
  symbolischen Refs (37 links, 5 codepaths) bleiben ignoriert, der Rest wird scharf
  geprüft (`ignoriert ⇔ refs ∧ ¬keep`, `keep` reihenfolge-unabhängig). Damit ist
  `lab/templates` dauerhaft Teil von `make check`.
- **d-check-Pin v0.47.0 → v0.51.0** (Fragment via `--print-mk` regeneriert). Liefert
  das `ignore-refs`-`in`/`keep`-Feature (v0.49.0, Grundlage der Adoption) sowie die
  neuen opt-in-Module `citations`/`codepaths.check-lines` (v0.50.0) und `sources`
  (v0.51.0, Content-Pin externer Quellen gegen Upstream-Drift) — verfügbar, aber
  nicht aktiviert (`make check` verhaltensneutral grün). Kurs-intern: Fragment + Pin
  reisen auf `main` mit, sind nicht im Bundle.
- **Regelwerk-Anzeigetext auf `templates/`-Präfix vereinheitlicht.** Der sichtbare
  Linktext der Ziel-Form-Verweise zeigte bare Spiegel-Pfade
  (`docs/plan/planning/roadmap.template.md`) — das las sich wie eine Vorlage an
  einem `docs/`-Pfad, wo weder Kurs noch Adopter eine hält. Anzeigetext auf
  `templates/…` präfixiert (href unverändert), 10 Stellen; bundle-korrekt.

## Welle 30 — 2026-07-18 · Wellen zweistufig (flach → `done/`), Status-Feld retired

### Geändert

- **Welle-Zustand = Verzeichnis-Position, kein `Status`-Feld** — analog zum Slice
  (Welle 26). Die aktive Welle liegt flach unter `docs/plan/planning/`; bei
  Closure `git mv` der Plan-Datei nach `done/` (neben ihre `-results.md`). Zwei
  Zustände (flach = aktiv → `done/` = geschlossen) statt eines driftbaren Felds;
  die Roadmap (`Aktuelle`/`Nächste`/`Abgeschlossene Wellen`) bleibt die
  Sequenzierungs-Autorität — **kein** Vier-Zustands-Verzeichnis, das die
  Roadmap-Reihenfolge dupliziert. Löst zwei Probleme: abgeschlossene Wellen
  müllten den flachen `planning/`-Ordner zu, und das `Status`-Feld war dieselbe
  zweite, driftbare Wahrheit, die beim Slice retired wurde.
- `welle.template`: `**Status:**`-Feld → `**Lifecycle:**`-Hinweis; zusätzlich die
  **Slice-Status-Spalte** aus der §4-Tabelle entfernt (gleiche Drift-Klasse — der
  Slice-Zustand ist sein Lifecycle-Verzeichnis, nicht eine Tabellen-Zelle).
- `modul-06` (Kurs-Anker + Regelwerk-Split): Closure-Schritt 3 → „**Welle nach
  `done/` schließen**" (Ergebnis-Notiz **und** `git mv` der Plan-Datei); die Prosa
  verankert das Zwei-Zustands-Modell und die Roadmap als Reihenfolge-Autorität.
  Fünf-Schritte-Prozedur unverändert (git mv in Schritt 3 integriert).

## Welle 29 — 2026-07-18 · d-check-Gate-Fragment tool-generiert (include-Modell) + `--network none`

### Geändert

- **Doku-Gate-Fragment tool-generiert statt handgeschrieben.** Die Template-`Makefile`
  empfahl bereits `d-check --print-mk`, lieferte aber die handgepflegte Recipe, die
  das Tool längst überholt hatte (`--network none`, `DCHECK_DIGEST`-Override, neues
  Target-Set) — aufgedeckt durch einen Adopter (`ai-harness-init` `MR-010`). Umgestellt
  auf das **include-Modell**: das Fragment `d-check.mk` wird via `d-check --print-mk`
  erzeugt und per `include`/`-include` eingebunden; die Recipe-Form lebt in d-check,
  nichts driftet von Hand. Effekte: `--network none` auf jedem Run (LH-QA-01-Hermetik
  auf Container-Ebene, die der Kurs lehrte, aber am eigenen Gate nicht erzwang),
  `DCHECK_DIGEST`-Re-Pin (statt Digest-Chirurgie), volles Target-Set present-but-unclaimed.
- **d-check-Pin v0.43.1 → v0.47.0** (via `DCHECK_DIGEST`). Trockenlauf vorab: 139
  Dateien, 0 Befunde, verhaltensidentisch — der Kurs enthält keine der Muster, die
  v0.47.0 neu sichtbar macht (keine `| - |`-Trennzellen, keine Fence-Infozeilen mit
  Backtick).
- **Modul 13 — „Vorhanden ≠ behauptet".** Schärft „keine halluzinierten Gates": ein
  vorhandenes, nicht als Gate *behauptetes* Target (die advisory `doc-*`-Targets des
  Fragments, wie `regelwerk-check`) ist keine Lüge; nur ein behauptetes, nicht
  laufendes Gate ist eine.

### Geändert — Auslieferung (Bootstrap)

- **Das Gate-Fragment und der Pin sind tool-/versionsspezifisch → NICHT im Bundle.**
  Der Adopter erzeugt `d-check.mk` beim Bootstrap aus *seiner* gepinnten d-check
  (`d-check --print-mk`) und füllt den `DCHECK_DIGEST`-**Platzhalter** der Template-
  `Makefile` (Modul 2, Kurs + Regelwerk-Split lehren das). Das Bundle trägt nur
  versions-agnostischen Inhalt; keine Release-Ableitung, kein committetes Duplikat.

### Behoben

- Review-Pass (high effort) vor dem Commit: `d-check.mk`-Staging (harter `include`),
  Prosa-Zeilenlänge (Regelwerk-Modul-2), `include`→`-include`-Präzisierung (Modul 13).

**Hinweis für Konsumenten (kein Bruch nach Asset/Layout-Policy):** Die ausgelieferte
Template-`Makefile` ist jetzt ein Skelett mit `DCHECK_DIGEST`-Platzhalter und
`-include d-check.mk`; sie läuft nicht mehr out-of-box, sondern nach der
Bootstrap-Erzeugung von `d-check.mk`. Bundle-Layout und Asset-Name unverändert;
existierende Adopter-Repos bleiben unberührt.

## Welle 28 — 2026-07-18 · Instanziierungs-Zeitpunkt der Templates explizit (Modul 2)

### Hinzugefügt

- **Anmerkung zum Instanziierungs-Zeitpunkt an Modul-2-Schritt 2** (Kurs +
  Regelwerk-Split). Der Kurs sagte den Zeitpunkt der Skelett-Instanziierung
  bisher nur *strukturell* (Bootstrap-Tabelle listet Gründungs-Dokumente;
  „Bootstrap-Ende = bereit für ersten Slice"), nicht *explizit am
  Instruktions-Punkt*. Diese Lücke verleitete einen Adopter (`ai-harness-init`)
  dazu, alle Templates beim Bootstrap als `docs/…/*.template.md`-Blanks zu
  bevorraten — reine Wartungskosten, später per dessen `MR-008` wieder entfernt.
  Neue Anmerkung trennt jetzt explizit: **Gründungs-Dokumente** (je ein
  Singleton, beim Bootstrap instanziiert und gefüllt: Spec-Straten,
  `conventions`, `harness/README`, `AGENTS`, `roadmap`, Gründungs-ADR `0001`)
  gegen **wiederkehrende Artefakte** (`slice`, `welle`, weitere ADRs, `carveout`,
  `review-report` — pro Instanz aus der vendored Baseline kopiert, wenn der
  Workflow sie erreicht; keine Blank-Kopie vorhalten). Die ADR-Doppelnatur
  (`0001` beim Bootstrap, weitere wiederkehrend) ist explizit gemacht.
- **Review-verifiziert (high effort).** Vor dem Commit fing ein Diff-Review
  einen Faktenfehler (Repo-`README` fälschlich als Bootstrap-Gründung gelistet,
  obwohl in keinem Bootstrap-Schritt) plus drei Präzisierungen (ADR-Bereich
  `Modul 4–10` statt `5–10`; Skelette in Schritt 2 kopiert, in 3–8 gefüllt;
  Regelwerk-Split operativ an den Kurs angeglichen).

## Welle 27 — 2026-07-18 · Baseline-Freshness-Audit prozeduralisiert (Modul 2)

### Hinzugefügt

- **Freshness-Audit als Erweiterung der Modul-2-Baseline-Anmerkung.** Vendoring
  friert per Konstruktion eine Kopie ein, die still von Upstream driftet, sobald
  ein neues Kurs-Release erscheint. Der Kurs benannte die Gegenmaßnahme bisher
  nur als Listen-Phrase („Drift-Audit gegen die Baseline", `AGENTS.template.md`)
  und prozeduralisierte sie nirgends — Modul 16 leer dazu, Modul 2 nur das Warum
  des Vendorings. Neuer Absatz in `modul-02-harness-bootstrap.md` (Regelwerk-Split
  operativ mitgezogen) mit drei Eigenschaften: **beobachtbarer Auslöser** (keine
  Kalenderpflicht), **Netz-Operation außerhalb der Gates** (offline-grün bleibt
  unverletzt) und der nicht-offensichtliche Kern — die Release-**Liste** auf einen
  neueren Tag prüfen, **nicht** nur den Hash des gepinnten Assets (der fängt nur
  ein nachträglich verändertes Release, keinen neuen Tag). Ein neuer Tag löst
  einen Review mit eigenem Diff aus, keinen stillen Auto-Bump. An die kurs-eigene
  „pinnen **und** überwachen"-Doktrin (Modul 12 `image_hash`, Modul 14
  „unsichtbarste Drift") und an LZ 5 (aktives Überwachen) gekoppelt.
- **Anlass:** Adopter-Beobachtung, gegen `v3.1.0` auditiert. Ein Adopter
  (`ai-harness-init`, `MR-007`) dokumentiert die Lücke selbst als „offene Lücke,
  kein gelöstes Problem" — sein Sensor meldete „kein Drift" auf einem alten Pin,
  während zwei Major-Releases erschienen. Kurs-seitig verifiziert: Modul 16 ohne
  Baseline-Wartung, Modul 2 ohne Release-Erkennung. Der Kurs schreibt das
  Ergebnis (Prozedur) vor, keine Repo-Mechanik (kein Tool-/Target-Name).

## Welle 26 — 2026-07-17 · Slice-Zustand einwertig (Lifecycle-Verzeichnis), Baseline-Bundle von innen self-beschreibend

### Geändert

- **Slice-Status-Feld retired — das Lifecycle-Verzeichnis ist die Quelle.**
  Modul 5 definiert den Slice-Zustand ausschließlich als Verzeichnis (eines von
  `open/`, `next/`, `in-progress/`, `done/`); das `Status:`-Feld im
  `slice.template.md` hatte keine Quell-Verankerung und war eine zweite Wahrheit,
  die beim `git mv` driftet — ein Slice in `done/` mit `Status: open` ist genau
  der Zombie, den Modul 5 beklagt. Feld → **`Lifecycle:`**-Hinweis (Zustand =
  Verzeichnis, Wechsel nur per `git mv`); §4 Trigger benennt jetzt auch die zwei
  Rückführungen (`in-progress`→`next` zu groß, `in-progress`→`open` blockiert),
  verankert an §Lifecycle als State Machine. `welle.template.md`: Slice-Status-
  Zelle als `<einer von: …>` statt Slash-Liste (die Pfeilkette las sich als
  Ablauf statt als Auswahl); das *Welle*-Status-Feld bleibt — Wellen liegen flach
  ohne Lifecycle-Verzeichnis, dort trägt das Feld die Wahrheit. `lab/example/slice-014`
  nachgezogen. Fix-Richtung Quelle → Template → Beispiel; Modul 5 unberührt.
- **Modul 07 §Übungen — Pflichtfeld-Liste an Schritt 2 und Template angeglichen.**
  Die Übung nannte sechs Pflichtfelder inklusive `Auflösungs-Trigger` und ohne
  `Letzte Prüfung`; kanonisch sind sechs Pflicht-*Header*-Felder (Status, Datum
  angelegt, Letzte Prüfung, betroffenes Gate, Geltungsbereich, Folge-Slice) plus
  der Auflösungs-Trigger als eigener beobachtbarer Bestandteil.
- **`lab/regelwerk/README.md` beschreibt seinen Vendoring-Kontext selbst.** Wer
  das Regelwerk aus dem entpackten Bundle liest statt über das Kurs-README, fand
  keinen Hinweis darauf, worin die Datei liegt: neuer Absatz „Vendored gelesen?"
  — `regelwerk/` + `templates/` parallel unter `.harness/baseline/<tag>/`, daher
  netzlos auflösende `../templates/…`-Ziel-Form-Verweise; Einstieg ist `AGENTS.md`
  des Adopter-Repos, hierher wird pro Entscheidung nur der benötigte Abschnitt
  geladen. Damit ist der Bootstrap-Pfad auch von innen navigierbar, nicht nur vom
  Kurs-README aus. Zugleich der „Links."-Absatz korrigiert: er nannte Templates
  und Beispiel als beim Release gepinnt — seit Welle 25 hält
  `--keep-within=lab/templates` die Templates-Verweise relativ, und `lab/example`
  verlinkt das Regelwerk gar nicht (36× `../../kurs/`, 16× `../templates/`).

## Welle 25 — 2026-07-16 · Regelwerk agenten-tauglich (Ziel-Form statt Worked Examples) + self-contained Baseline-Bundle

### Geändert

- **Didaktik-Compliance der Regelwerk-Splits.** Das Regelwerk ist für Code-
  Agenten: **Regel + Ziel-Form** statt erzählter Worked-Example-Narrative. Über
  17 Dateien die Schritt-für-Schritt-Beispiele entfernt (netto −1045 Zeilen).
  Skelett, das ein `lab/templates`-Artefakt dupliziert → „Ziel-Form: X" = Verweis
  auf `../templates/…` + operative Kurzregeln (modul-03/04/05/06/07/10); kein
  Template (Code/Config/Prozess) → operative Regeln + Tabellen behalten
  (modul-08/11/12/14/16). modul-02: Worked Example 1/2 → operative Bootstrap-
  Schritt-Sequenzen (Mermaids + T1/T2-Markdown-Beispiele gestrippt; Detail-
  Tabellen, vendored-Baseline-Doktrin, Phasen×Modus-Matrix behalten).
- **Stabile HTML-Anker** (`<a id>`, von d-check erkannt) für viel-referenzierte
  Stellen: modul-07 `#werkzeug-wahl` (5 Verweise), modul-13
  `#adr-zur-fitness-function`, modul-01 `#source-precedence-block`; ~11
  eingehende Verweise umgebogen. modul-07 review-verifiziert.
- **Baseline vendored jetzt Regelwerk *und* Templates.** modul-02-Bootstrap
  (Quelle + Split): `.harness/baseline/<tag>/{regelwerk,templates}/` — Templates
  mit Doppelrolle (vendored Referenz-Form für die `../templates/`-Ziel-Form-
  Verweise + kopiert-und-ausgefüllt als eigene Artefakte). Adopter-Story
  (conventions.template `MR-003`, AGENTS.template, README.template, lab/example)
  durchgängig nachgezogen.
- **`lab-regelwerk.zip` ist ein self-contained Baseline-Bundle** (`regelwerk/` +
  `templates/` parallel). `templates-release.yml` packt beide; die Splits lösen
  `../templates/` netzlos gegen `templates/` auf.

### Hinzugefügt

- **`rewrite-doc-links.py --keep-within=<dir>`** — zusätzliche within-Bundle-
  Wurzel neben `--keep-within-src`, damit `../templates/`-Verweise in
  self-contained Bundles mit mehreren parallelen Verzeichnissen relativ mitreisen
  (netzlos auflösbar) statt auf eine blob-URL gepinnt zu werden; nur echte
  Außen-Verweise (Kurs, LICENSE) werden auf den Tag gepinnt.

### Entfernt

- **Release-Asset `lab-templates.zip`.** Die Templates liegen jetzt im
  self-contained `lab-regelwerk.zip` unter `templates/`; ein separates
  Template-ZIP wäre ein Duplikat. Wer nur die Skelette will, entpackt das Bundle
  und nimmt `templates/`. `README`, `lab/templates/README`,
  `rewrite-template-links.sh` und `templates-release.yml` entsprechend bereinigt.
  (Das `templates-zip`-Vorschau-Artifact auf `main` bleibt für Template-Autoren.)

**Bruch für Konsumenten:** (1) Das `lab-regelwerk.zip` wechselt vom flachen
Layout (`*.md` im Root, v2.0.0) auf `regelwerk/` + `templates/` parallel — nach
`.harness/baseline/<tag>/` entpacken (nicht mehr nach `…/regelwerk/`), dann lösen
die `../templates/`-Ziel-Form-Verweise netzlos auf. (2) Das Release-Asset
`lab-templates.zip` entfällt; Ersatz ist `templates/` im Baseline-Bundle. Der
Kurs-*Inhalt* bleibt maßgeblich unter `/kurs/de/`.

## Welle 24 — 2026-07-16 · Regelwerk konsumenten-sauber (A⁺), agents-regelwerk.md retired, d-check v0.43.1

### Geändert

- **Regelwerk-Splits von der Demo-App befreit (A⁺).** Das ausgelieferte
  `lab-regelwerk.zip` enthält nur `lab/regelwerk/*.md`, kein `lab/example` —
  DocSearch-/Lab-Referenzen im Split waren toter Ballast. modul-06 Worked
  Example → generisches Roadmap-Skelett; acht weitere Splits genericisiert
  (modul-02/07/10/12/14/16, grundlagen-konventionen/-klassifikation).
- **Modul 6 (Roadmap):** die Template-Abschnitte *Nächste Wellen* und
  *Abgeschlossene Wellen* in Quelle + Split verankert; normative
  **Wellen-Closure-Prozedur** (5 Schritte) ergänzt, kurs-intern verankert
  (kein externes Referenz-Repo als Autorität).
- **17 Modul-Splits auditiert** und Defekte behoben (verpatzter
  Fehlannahmen-Block modul-10, toter Selbstverweis modul-12, didaktische
  Reste modul-02/03/16; modul-03 Spec-Stratifizierung auf Kurzform + Verweis
  eingedampft).
- **Split-Selbst-Enthaltung:** 72 Kurs-Cross-Links → Geschwister-Links, damit
  sie im `lab-regelwerk.zip` mitreisen (`rewrite-doc-links.py --keep-within-src`).
- **Provenance-Zeilen (20×)** in `lab/regelwerk/` → HTML-Kommentar-Metadaten
  (nicht gerendert, aber weiter d-check-validiert).
- **d-check-Pin `v0.23.0` → `v0.43.1`** (Image-Digest) im `Makefile`;
  verhaltensgleich verifiziert.
- **`lab/regelwerk` ist jetzt das kanonische Betriebsregelwerk-Artefakt.** Die
  Adopter-Story (README, kurs/de/README, lab/README, Templates, lab/example)
  verweist durchgängig auf das `lab-regelwerk.zip` / den Split; die Stand-Zeile
  lebt jetzt in [`lab/regelwerk/README.md`](lab/regelwerk/README.md)
  (**Kurs-Welle 24**).

### Entfernt

- **`kurs/de/agents-regelwerk.md`** (Zwischen-Digest). Ersatz ist das per-Modul-
  Split `lab/regelwerk` bzw. das `lab-regelwerk.zip`. CI (`templates-release.yml`,
  `templates-zip.yml`) baut/releast die Einzeldatei nicht mehr; das
  `lab/example`-Drift-Tool zeigt aufs Split-Verzeichnis (inhaltsbasierte
  Verzeichnis-Hash-Migration deferred).
- **`lab/templates/harness.mk`** — der `docs-check`-Gate steht jetzt direkt im
  Template-`Makefile` (Adopter erzeugen ihn alternativ per `d-check --print-mk`).
- **`grundlagen-checkpoints.md` + `grundlagen-konzeptkarte.md`** aus dem
  Regelwerk (rein didaktische Lern-Navigation, kein operativer Inhalt).

**Bruch für Konsumenten:** Das Release-Asset `agents-regelwerk.md` und die
mitgelieferte `harness.mk` entfallen; wer die Einzeldatei per URL zog, wechselt
auf `lab-regelwerk.zip` (self-navigierbares Bundle). Der Kurs-*Inhalt* bleibt
maßgeblich unter `/kurs/de/`.

## Welle 23 — 2026-06-23 · Template-Feinschliff (ADR-Tabelle, Gate-Baseline) + d-check v0.23.0

### Geändert

- **ADR-Vorlage „Verglichene Alternativen" als Pro/Contra-Tabelle** — im
  [ADR-Datei-Template](lab/templates/docs/plan/adr/NNNN-titel.template.md) die
  drei `### Option A/B/C`-Blöcke (je eigene `- Pro:`/`- Contra:`-Liste) auf eine
  Markdown-Tabelle (`| Option | Pro | Contra |`) umgestellt, gewählte Option
  fett. Rein kosmetisch — kein Schema- oder Inhaltswechsel; die „mindestens drei
  Optionen mit Pro/Contra"-Regel bleibt.
- **d-check-Pin `v0.9.0` → `v0.23.0`** (Image-Digest neu gepinnt) im
  [`Makefile`](Makefile) (Single Source of Truth) und im
  `harness.mk` (`lab/templates/`); der Versions-Kommentar
  in `harness.mk` trug noch `v0.8.0` und wurde mitgezogen. Laut d-check-CHANGELOG
  keine Breaking-Config-Änderung v0.9.0→v0.23.0 — bestehende `.d-check.yml` bleibt
  gültig, `make check` grün (docs-check 0 Befunde, alignment-check 0 WARN).
- **Gate-Baseline um den Repo-Generator ergänzt** — der Regenerier-Hinweis in der
  [`lab/templates/README.md`](lab/templates/README.md) nannte nur das leere
  `d-check --print-config`-Gerüst; jetzt zusätzlich
  `d-check --suggest-config ai-harness-init --id-prefix <PRÄFIX>` (neu seit
  d-check v0.18.0/v0.22.0), das `ids`/`matrix`/`codepaths` mit den Kurs-Kennungen
  (`ADR-…`, `MR-…`, `slice-…`, `<PRÄFIX>-FA-…`/`-QA-…`) vorbelegt. `--id-prefix`
  als Begleitschalter dokumentiert: ohne ihn bleiben `<PREFIX>`-Platzhalter und
  `# TODO` stehen.

Alle drei Änderungen betreffen Templates bzw. Tooling — die Quelle
[`agents-regelwerk.md`](kurs/de/agents-regelwerk.md) bleibt unberührt
(**kein Stand-Bump**, vgl. Welle 20/21). Die Templates fließen mit dem
nächsten Release-Tag ins `lab-templates.zip`-Asset.

## Welle 22 — 2026-06-18 · ADR-ID-Schreibweise vereinheitlicht (vierstellig)

### Geändert

- **ADR-ID-Platzhalter durchgängig vierstellig (`ADR-<NNNN>`)** — die
  ADR-Kennung wurde zugleich zwei-, drei- und vierstellig geführt, während
  die realen ADRs unter
  [`lab/example/docs/plan/adr/`](lab/example/docs/plan/adr/), der ADR-Dateiname
  (`<NNNN>-titel`) und das ADR-README-Template bereits vierstellig waren.
  Vereinheitlicht auf vier Stellen: ADR-Bindung-Klasse der Konventionen-Seite
  ([`grundlagen/konventionen.md`](kurs/de/grundlagen/konventionen.md), Quelle)
  und ihre Derivate ([`agents-regelwerk.md`](kurs/de/agents-regelwerk.md) §463,
  [`lab/regelwerk/grundlagen-konventionen.md`](lab/regelwerk/grundlagen-konventionen.md)),
  die Observability-ID-Kette (Modul 15), das ADR-Datei-Template
  (`Status:`/`Bezug:`), das ADR-README-, AGENTS-, `harness/README`-,
  `harness/conventions`-, slice-, roadmap- und welle-Template sowie die
  `lab/example`-Spiegel (`AGENTS.md`, `harness/conventions.md`, `adr/README.md`).
  Reine Schreibweisen-Vereinheitlichung — **kein** Schema-Wechsel der
  Nummernvergabe; reale/fiktive vierstellige Nummern und die einstellige
  Prosa-Variable `ADR-N` (Fließtext „supersedes ADR-N") bleiben unverändert.
  Schließt die Quell-Wurzel der nachgelagerten Adaption **d-check `MR-008`**
  („Korrektur in der Kurs-Quelle steht aus"). `Stand:` von `agents-regelwerk.md`
  auf Welle 22 gezogen.

## Welle 21 — 2026-06-16 · Grundlagen-Rahmen im Regelwerk-Split + d-check v0.9.0

### Neu

- **Grundlagen-Rahmen im Split** — [`lab/regelwerk/`](lab/regelwerk/)
  trägt jetzt neben den 17 Modulen auch die drei Grundlagen-Abschnitte der Quelle als
  einzelne Dateien:
  [`grundlagen-konventionen.md`](lab/regelwerk/grundlagen-konventionen.md) (inkl.
  §Referenz-Richtung/SDP — wer darf wen referenzieren, also die ADR→Slice/Welle-
  Regel), [`grundlagen-klassifikation.md`](lab/regelwerk/grundlagen-klassifikation.md)
  und [`grundlagen-durchsetzungsschicht.md`](lab/regelwerk/grundlagen-durchsetzungsschicht.md).
  Wortgleicher Abschnittstext, kein Zusatz-Kopf; ein Agent kann so einen einzelnen
  Grundlagen-Abschnitt laden, ohne das ganze Regelwerk im Kontext zu halten. Die
  Quelle bleibt unberührt (kein Stand-Bump). Cross-Section-Anker (z. B.
  `#kernbegriffe`) zeigen auf die Geschwister-Datei, damit das
  `lab-regelwerk.zip`-Bundle self-navigierbar bleibt; Pfad-Verweise gehen auf den
  Kurs und werden beim Release auf den Tag gepinnt.

### Geändert

- **[`lab/regelwerk/README.md`](lab/regelwerk/README.md)** — Scope von „nur
  Modul-Sektionen" auf „Module + Grundlagen-Rahmen" erweitert (neue
  `### Grundlagen`-Liste); nur Quellen-Rang, Wartung und Stand bleiben der
  Quelldatei vorbehalten. Provenienz-Aufzählung in der Blockquote um
  Durchsetzungsschicht ergänzt (Doku-Drift behoben).
- **d-check-Pin `v0.8.0` → `v0.9.0`** im [`Makefile`](Makefile) (Image-Digest neu
  gepinnt); `make check` grün (140 Dateien, 0 Befunde, 0 ERROR/WARN).

### Korrektur · v1.2.1 — 2026-06-18

- **„Digeste" → „Grundlagen-Abschnitte"** in
  [`lab/regelwerk/README.md`](lab/regelwerk/README.md) (3×) und in der
  Welle-21-Notiz oben. Das Wort suggerierte eine Verdichtung und widersprach
  damit dem »wortgleichen« Charakter der Auszüge. Reine Terminologie — kein
  Inhalts-, kein Stand-Bump; ausgeliefert als Patch-Release `v1.2.1`
  (Assets tag-gepinnt neu gebaut).

## Welle 20 — 2026-06-15 · Regelwerk per Modul + SemVer-Release-Tags

### Neu

- **Regelwerk per Modul** in [`lab/regelwerk/`](lab/regelwerk/) — die 17
  Module (0–16) aus [`agents-regelwerk.md`](kurs/de/agents-regelwerk.md) als
  einzelne Dateien (Kurs-Slugs, wortgleicher Modultext, kein Zusatz-Kopf), plus
  [`README.md`](lab/regelwerk/README.md) als nach Phasen gruppierter Index. Die
  Quelle bleibt unberührt (kein Stand-Bump); ein Agent kann so ein einzelnes
  Modul laden, ohne das ganze Regelwerk im Kontext zu halten. Verweise bleiben
  in-repo relativ (gate-validiert, lokal navigierbar); beim Release pinnt
  `tools/rewrite-doc-links.py --keep-within-src` fürs `lab-regelwerk.zip`-Asset
  nur die Außen-Verweise (Kurs/Templates/Beispiel) auf den Tag — die
  Modul-Querverweise bleiben relativ, das Bundle ist self-navigierbar.

### Geändert

- **Release-Tags auf SemVer** — Schema von `templates-v*` auf `vX.Y.Z` (erstes
  `v1.0.0`). Der `templates-release.yml`-Trigger akzeptiert beide
  (`v[0-9]*` und `templates-v*`, abwärtskompatibel); die Release-Bedingung in
  `rewrite-template-links.sh` ist jetzt prefix-agnostisch (`ref != main`) und
  überlebt künftige Tag-Umbenennungen. Kopf-Kommentar in
  `rewrite-doc-links.py` aufs neue Schema nachgezogen. Adopter-Doku
  (Root-`README.md`, `lab/templates` §Download) auf das Schema und die drei
  Release-Assets (inkl. `lab-regelwerk.zip`) aktualisiert.
- **[`lab/README.md`](lab/README.md)** — `regelwerk/` in Intro-Liste und
  Aufbau-Baum ergänzt (Doku-Drift behoben).
- **`templates-release.yml`** liefert zusätzlich `lab-regelwerk.zip` (17 Module
  + README) als Release-Asset, parallel zu `lab-templates.zip`.

## Welle 19 — 2026-06-14 · C++/CMake-Skelett + Regelwerk-Drift-Sensor

### Neu

- **C++/CMake-Skelett** in [`lab/example/cpp/`](lab/example/cpp/) —
  sechstes Sprach-Skelett (C++20, hexagonal: `src/hexagon` + `src/adapters`),
  doctest via FetchContent (`GIT_TAG`-Pin), clang-tidy mit
  `WarningsAsErrors`, textbasierter `arch-check.sh` (ADR-0001) als
  CTest-Test, gcovr-Coverage. `make gates` grün im Docker (Coverage 94 %);
  Runtime-Image Distroless `cc` mit statisch gelinktem libstdc++ und
  glibc-Match (`debian:12` ↔ `distroless-debian12`, Base-Images per
  `@sha256` gepinnt).
- **Regelwerk-Drift-Sensor** — `make regelwerk-drift`
  ([`lab/example/tools/check_regelwerk_drift.py`](lab/example/tools/check_regelwerk_drift.py)):
  inhaltsbasierter sha256-Pin der adoptierten `agents-regelwerk.md` in
  `conventions.md` §Baseline; erkennt Upstream-Drift unabhängig vom
  `Stand:`-Marker (vgl. §„Nachweis über Inhalt, nicht Diff"). Kein
  `gates`-Glied — CI/periodisch, braucht die externe Quelle.
- **Regelwerk self-contained ausgeliefert** — `tools/rewrite-doc-links.py`
  schreibt die repo-internen Links der adoptierten `agents-regelwerk.md`
  beim Release auf absolute `blob/<tag>`-URLs um (fence- und
  existenz-gegated: illustrative Adopter-Pfade bleiben relativ). Das
  Regelwerk geht als eigenes Release-Asset neben `lab-templates.zip` raus
  (`releases/latest/download/agents-regelwerk.md`); `AGENTS.template`,
  Root-README-Adoption und `lab/templates` §Download zeigen dorthin statt
  auf Raw-`main`. Quelle bleibt relativ (kein
  Stand-Bump). Behebt tote Verweise beim Kopieren/Cachen in fremde Repos.

### Geändert

- Sprach-Skelett-Zählung durchgängig fünf → sechs: Lab-Satelliten
  ([`lab/README.md`](lab/README.md), `lab/example/` README/Makefile/AGENTS,
  ADR-0001-Fitness-Table) und Kurs-Prosa (grundlagen, modul-08, modul-14,
  `agents-regelwerk.md`, konventionen) sowie CO-001 / slice-013 /
  slice-014 / roadmap.

## Welle 18 — 2026-06-11 · Konsistenz-Welle + Agents-Regelwerk

*(Commits dieser Welle tragen das historische Label „Welle 8
(Konsistenz)" — die Kollision mit der älteren Welle 8 war der Anlass
für dieses Register.)*

### Behoben

- Fachdidaktisches Review (konstruktives Alignment, Anderson/Krathwohl,
  CLT, didaktische Rekonstruktion): ~45 Befunde — ungeprobte
  Spitzen-Verben mit `LZ <N>`-Items geschlossen, Tag-Fehler korrigiert,
  Engage-/Glossar-/Stimulus-Fixes.
- Lösungsschicht vollständig nachgezogen: jede Übung und jedes
  Selbstcheck-Item der Module 0–16 hat ein Musterantwort-Pendant.
- Off-by-one-Modulnummern der Modul-2-Einfügung repariert
  (`klassifikation.md`, `lernervorstellungen.md`, `kickoff-vorlauf.md`,
  Modul 9 „8a/8b", Root-README-Phasentabelle).
- Lab-Drift: alle fünf Dockerfiles per Registry-Digest gepinnt
  (inkl. Ersatz des toten C#-Tags `cbl-mariner` → `azurelinux`),
  `make plan-status` ergänzt, Modul-8-Lab-Bezug ehrlich gemacht.
- Richtungsfehler in der Lifecycle-Faustregel (`klassifikation.md`:
  „nach rechts" → „nach links").
- Phase-05-Assessment-Vakuum: Pflicht-Feature „Produktionsfreigabe"
  im Abschlussprojekt, Checkpoint A probt Modul 2, Checkpoint D die
  Sensor-Literacy; Kalibrierungsbeispiel B belegt alle Indikatoren.

### Neu

- **`kurs/de/agents-regelwerk.md`** — der Kurs als Betriebsregelwerk für
  Code-Agenten (derivatives Sicht-Artefakt mit Stand-Zeile), in den
  Session-Lesepfaden verdrahtet (AGENTS-/harness-README-Templates,
  Worked Example, `conventions`-Adoptionsquelle mit Raw-URL).
  Im Lauf der Welle umbenannt (vormals `agents-digest.md`) und
  methodisch neu aufgebaut: statt Hand-Verdichtung ein
  **didaktik-freier Extrakt in Quellformulierung** (~4.000 Zeilen —
  Grundlagen-Dossiers komplett, Module 0–16 als operative Extrakte
  mit Quell-Verweis pro Abschnitt; weggelassen ist die
  Didaktik-Schicht, nicht verdichtet der Inhalt).
- Modul 13: Sektion „Gate-Typ ↔ Fehlerbild" (Zuordnungstabelle).
- Templates: ID-Schema-Deklarations-Slot in
  `conventions.template.md`; AGENTS-Template §5 erklärt die
  ID-Vergabe.
- `docs-check`: nicht-kollabierender Slugger (erstmals 0 ERROR),
  `docs-check:ignore`-Marker, Modul-Nummern-Sensor gegen
  Off-by-one-Drift (Linktext = ERROR, Prosa-Titel = WARN).
- Root-`Makefile`: `make docs-check` · `make alignment-check` ·
  `make check` (Docker-basiert, `ARGS`-Durchreichung).
- GitHub-Actions-Workflow `.github/workflows/checks.yml`: beide
  Validatoren als CI-Gate bei Push/PR, über dieselben Make-Targets
  wie lokal (`alignment-check --strict`).
- Review-Report formalisiert: Vorlage
  `lab/templates/docs/reviews/review-report.template.md`, Ablageort
  `docs/reviews/` in der Verzeichniskonvention, Modul-10-Sektion
  „Reviewer berichtet auch, was er nicht gefunden hat" (schließt die
  bis dahin hängende §-Referenz im Reviewer-Skill).
- Dieses CHANGELOG als kanonisches Wellen-Register.

## Welle 17 — 2026-06-08 · Didaktik-Review

*(Commit-Label: „Didaktik-Review Welle 8" — achte Welle der
didaktischen Teilserie.)* Alignment-, Konsistenz- und CLT-Fixes über
32 Dateien: systemisches und-Verb-Audit, M13-Gate-Familien,
Kickoff-YAML-Zielmodule, M8-Übergabe-Zählung, Vier-Repos-Angaben.

## Wellen 1–16 — 2026-06-02 bis 2026-06-04

| Welle | Datum | Inhalt |
|---|---|---|
| 16 | 2026-06-04 | Fallstudien-Drift gegen Ist-Zustand der vier Beispiel-Repos behoben |
| 15 | 2026-06-04 | Englische Autorzitate ins DE übertragen, Given/When/Then-Notation verankert |
| 14 | 2026-06-03 | 12 Didaktik-Review-Findings (vier Linsen) behoben |
| 13 | 2026-06-03 | 16 Didaktik-Review-Findings behoben |
| 12 | 2026-06-02 | Modul 06: Übungen an beide Erschaffen-LZ gebunden |
| 11 | 2026-06-02 | Reflexionsvorlage: drei → vier Fragen angeglichen |
| 10 | 2026-06-02 | Lab um Module-10/11/14-Artefakte erweitert |
| 9 | 2026-06-02 | Worked Examples für fünf Erschaffen-Lernziele ergänzt |
| 8 | 2026-06-02 | Didaktik-Review-Findings (16 Befunde) behoben |
| 7 | 2026-06-02 | Didaktik-Review-Restposten behoben |
| 6 | 2026-06-02 | Didaktik-Review-Findings (4 Linsen) behoben |
| 5 | 2026-06-02 | Didaktik-Review-Findings (Alignment, Bloom, CLT) behoben |
| 4 | 2026-06-02 | Didaktik-Gutachten-Findings behoben |
| 3 | 2026-06-02 | docs-check-Validator-Findings behoben |
| 2 | 2026-06-02 | Sprach-Skelette-Review-Findings behoben |
| 1 | 2026-06-02 | Kurs-Inhalt-Review-Findings behoben |

Hinweis: Die Verweise „Welle 8" und „Welle 13" in
[`kurs/de/grundlagen/lernervorstellungen.md`](kurs/de/grundlagen/lernervorstellungen.md)
beziehen sich auf diese Zählung.
