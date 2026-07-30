# ADR-0011: Closure-Note-Pflicht für `done/`-Slices

**Status:** Accepted

**Datum:** 2026-06-02

**Autor:** Kurs-Lab

**Bezug:** [LH-QA-02](../../../spec/lastenheft.md#lh-qa-02--reproduzierbarkeit) (Reproduzierbarkeit/Auditierbarkeit), Modul 1 §Closure, Modul 11 Worked Example

**Schärft:** Planning-Closure-Konvention (`docs/plan/planning/`) + Gate
`verify-closure-notes` — *kein* Spec-Stratum (Prozess-ADR).

---

## Kontext

Wellen-Closures werden in der Praxis häufig "weggeschoben" statt
abgeschlossen: ein Slice landet in `done/`, der Tracker-Eintrag wird
geschlossen, ein Lerneintrag fehlt. Damit verliert der Harness sein
Hauptlernsignal — wer den nächsten Slice plant, sieht nicht, woran
der letzte gestolpert ist (siehe [Kurs Modul 1
§Closure](../../../../../kurs/de/01-spec-und-architektur/modul-01-entwicklungszyklus.md#kernidee)).

Reviewer prüft den Diff gegen Plan und ADR — *nicht* gegen die
DoD-Pflicht zum Lerneintrag. Genau diese Lücke fängt eine Verification
(siehe [Kurs Modul
10](../../../../../kurs/de/04-qualitaet/modul-11-verification.md)). Es
gibt für die Closure-Pflicht kein Standard-Tool; die Operationalisierung
gehört in dieses Lab.

## Entscheidung

Jede Datei unter `docs/plan/planning/done/*.md` (Slices wie
Welle-Closures) muss eine **Closure-Notiz** tragen. Eine Closure-Notiz
ist definiert als Markdown-Sektion, deren Überschrift das Wort
*Closure* enthält (Schreibvarianten erlaubt: `# Welle-N — Closure-Notiz`,
`## Closure`, `## 7. Closure-Notiz`).

Inhaltliche Mindestform — vier Pflichten:

1. **Substanz:** Mindestens zwei Sätze (gemessen an Satzendezeichen
   außerhalb von Code-Blöcken), die *was* gelernt wurde benennen.
2. **Ausgefülltheit:** **Kein** unausgefüllter Template-Platzhalter (`<…>`).
   Nicht als Zähl-Ausnahme zu Pflicht 1, sondern als eigenes Verbot — sonst
   wäre eine Notiz mit fünf echten Sätzen und einem Restplatzhalter regelkonform,
   und der Gate meldete sie trotzdem. Grund für das Verbot: Der blanke
   Template-Rumpf bringt die Satz-Schwelle allein mit (zehn Sätze), der Gate war
   auf ihm grün.
3. **Konkretheit:** Keine der bekannten Floskeln (`see PR`, `n/a`,
   `siehe Ticket`, `wird nachgereicht`, `fertig`, `ok`, `läuft jetzt`).
4. **Steering-Loop-Bezug:** Wo die Closure einen Steering-Loop-Eintrag
   nach sich zieht (neue Hard Rule, Skill-Schärfung, Sensor, Folge-Slice),
   wird dieser im Lerneintrag oder in einer eigenen Sektion benannt.

Die maschinelle Prüfung deckt Pflicht 1 bis 3 ab; Pflicht 4 bleibt
inferentiell und ist Gegenstand des Reviewer-Skills (siehe Modul 10), nicht
des Gates.

> **Grenze — ehrlich benannt:** „vollständig" wäre zu viel für Pflicht 1. Die
> Maschine zählt Satzendezeichen; ob die Sätze *benennen, was gelernt wurde*,
> ist ein Urteil. Pflicht 2 und 3 sind dagegen vollständig maschinell.

## Verglichene Alternativen

### Option A — Frontmatter-Feld `closure_note: …`

- Pro: Maschinell trivial parsbar (YAML).
- Contra: Closure-Notizen sind häufig mehrabsätzig (Beobachtung,
  Steering-Loop-Eintrag, Folge-Slice). Ein YAML-String quetscht das in
  eine Zeile mit `\n` oder verliert die Struktur.
- Contra: Bricht zwei bestehende done-Dateien retroaktiv.

### Option B — Eigene Datei `*.closure.md` neben dem Slice

- Pro: Saubere Trennung Slice-Plan vs. Closure-Erkenntnis.
- Contra: Verdoppelt die Dateienzahl in `done/`; eine vergessene
  Closure-Datei wäre stiller als eine fehlende Sektion.

### Option C — Sektion mit "Closure"-Überschrift im Slice-File (gewählt)

- Pro: Folgt bestehender Lab-Praxis (slice-009 §7, welle-1-results.md
  H1-Titel). Mehrabsätzige Closures haben Platz.
- Pro: Maschinelle Prüfung über Headings ist robust und sprach­arm
  (kein YAML-Parser nötig).
- Contra: Etwas weniger streng als Frontmatter — eine Closure-Sektion
  ohne Inhalt würde nur an Pflicht 1 scheitern, nicht an
  "Schlüssel-fehlt".

## Konsequenzen

- Positiv: `make verify-closure-notes` fängt die häufigste
  Closure-Drift (vergessener Lerneintrag, Floskel-Closure).
- Positiv: Welle-Closures sind miterfasst — die Welle-Closure-Notiz
  ist *eine* Closure auf höherer Ebene.
- Negativ: Reviewer-Skill bleibt für die Steering-Loop-Bezugs-Prüfung
  verantwortlich; das Gate ersetzt nicht das Lesen.
- Folgepflicht: Reviewer-Skill `closure-note-reviewer.md` (Modul 15
  Doku-Konsistenz-Agent) übernimmt die inferentielle Schicht.

## Fitness Function

| Tooling | Regel | Make-Target |
|---|---|---|
| [`tools/check_closure_notes.py`](../../../tools/check_closure_notes.py) | Heading mit "Closure" + ≥2 Sätze außerhalb Code-Blöcken + keine Floskel + keine unausgefüllten `<…>`-Platzhalter | `make verify-closure-notes` |

`verify-closure-notes` ist in das aggregierte `verify`-Target
eingehängt. Es läuft *nicht* in `make gates`, weil es eine DoD-/Closure-
Frage ist, keine Code-Architektur-Frage.

## Re-Evaluierungs-Trigger

- Wenn das Lab auf eine strukturierte Trace-Pipeline umstellt und
  Closure-Notizen als Telemetrie eingespeist werden sollen — dann
  Wechsel auf Frontmatter-Schema sinnvoll prüfen.
- Wenn die Floskel-Liste regelmäßig erweitert werden muss: Wechsel auf
  einen Doku-Konsistenz-Agenten (inferentielle Schicht) anstelle des
  syntaktischen Checks.

## Geschichte

| Datum | Ereignis | Verweis |
|---|---|---|
| 2026-06-02 | Proposed | Modul 11 Worked Example, Lab-Ausbau (Kurs-Welle 9) |
| 2026-06-02 | Accepted | bestehende done-Dateien geprüft, beide bestehen |
| 2026-06-03 | Vierte Pflicht ergänzt | *Ausgefülltheit*: kein unausgefüllter `<…>`-Platzhalter. Der Gate war grün auf dem blanken Template-Rumpf, weil dieser die Satz-Schwelle allein mitbringt. Zuerst als Zähl-Ausnahme zu Pflicht 1 formuliert — das war falsch: Der Code verbietet Platzhalter unabhängig von der Satzzahl, also ist es ein eigenes Verbot und eine echte Erweiterung der Entscheidung |
| 2026-06-03 | Korrektur | „zwei done-Dateien" (Option A · Geschichte *Accepted*) war falsch: drei, mit `welle-1-mvp.md`. Tatsachenangabe, Text oben unverändert ([Modul 4](../../../../../kurs/de/01-spec-und-architektur/modul-04-architektur-adrs.md)) |
