# Modul 15 — Produktiver Betrieb

> **Aufwand:** ca. 75 Min Lesen · 90 Min Übung. Mit diesem Modul ist der inhaltliche Teil des Kurses abgeschlossen — danach folgt das [Abschlussprojekt](../abschluss/abschlussprojekt.md).

## Engage

Drei Uhr morgens. Ein Agent hat einen produktiven Datensatz fehlerhaft
verändert. Du bist Bereitschaft, du kennst den Autor nicht. *Was tust du
in den ersten 15 Minuten?* Wenn du diese Frage nicht im Schlaf
beantworten kannst, hat dein Projekt keinen produktiven Betrieb. Es hat
einen "läuft halt"-Modus.

## Lernziele

Nach diesem Modul kannst du:

* eine Produktionsfreigabe mit belegten Checklist-Items *entwerfen* (Erschaffen),
* Prompt-Injection-Symptome aus Telemetrie *erkennen* (Analysieren),
* einen Incident innerhalb der ersten 15 Minuten *strukturiert* angehen (Anwenden),
* Rollback und Fix-Forward gegeneinander *abwägen* und drei Anti-Rollback-Szenarien *benennen* (Bewerten).

## Lab-Bezug

* [`../../../lab/example/runbooks/`](../../../lab/example/runbooks/)
* [`../../../lab/example/Makefile`](../../../lab/example/Makefile), Target `make release`

## Themen

* Releases
* Runtime Validation (Schema, Spec, Budget)
* Sicherheitsprüfungen (Prompt Injection, Tool-Abuse, Data Exfiltration)
* Incident Response (Replay, Rollback, Forensik)

## Kernidee

Produktiv heißt: Du musst eine Frage in der Nacht beantworten können,
ohne den Autor zu kennen. Runbooks und Replay sind dafür da.

## Typische Fehlvorstellungen

- **"Rollback ist die Standardantwort."** — Drei Fälle, in denen Rollback schadet: nicht-rückwärtskompatible DB-Migration, bereits erzeugte Buggy-Daten, ungetesteter Rollback-Pfad. Runbook entscheidet *vor* dem Incident, wann Fix-Forward gilt.
- **"Runbook beschreibt den Happy Path."** — Nein. Runbook beschreibt *Entscheidungen unter Unsicherheit*, mit Triggern. Wenn das Runbook nur sagt "Service neu starten", ist es kein Runbook.
- **"Produktionsfreigabe ist eine formale Checkbox."** — Eine Checkliste ohne *Belege* pro Item (Replay-Lauf-Link, ADR-ID, Trace-Hash) ist Bürokratie. Mit Belegen ist sie das einzige nicht-fragmentierte Audit-Artefakt.
- **"Prompt-Injection ist eine Modell-Frage."** — Nein. Erkennung von Injection ist eine *Telemetrie-Frage*: Eingabe-Logging + Tool-Call-Audit + Output-Drift-Marker. Wer das nicht hat, erkennt Injection nur durch Glück.

## Worked Example: eine Produktionsfreigabe-Checkliste schreiben

> **Wenn du Produktionsfreigaben mit Belegen pro Item bereits routiniert durchführst, springe zu [§Übungen](#übungen).** Worked Examples sind für den ersten oder zweiten Durchgang am wirksamsten — danach kostet das Mitlesen mehr Last als es trägt (Expertise-Reversal).

**Ausgangs-Situation:** Du sollst die Freigabe-Checkliste für Welle 1
deines Projekts schreiben. Das Repo hat: ein abgeschlossenes Slice in
`done/`, eine ADR, einen Carveout, ein Replay-Set, ein Trace-Fixture.

**Schritt 1 — Item-Form festlegen: keine Häkchen ohne Beleg.**
Schlechtes Format:
```markdown
- [ ] Tests grün.
- [ ] Replay gelaufen.
```
Gutes Format — jedes Item trägt einen **Beleg-Slot**:
```markdown
- [ ] Tests grün. **Beleg:** Link zum CI-Run + Image-Hash.
- [ ] Replay gelaufen. **Beleg:** Link zum Replay-Manifest (Modul 11).
```
Die Beleg-Pflicht ist der einzige Schutz gegen Bürokratie.

**Schritt 2 — Pflicht-Items aus Phasen ableiten.**
Eines pro Phase des Kurses:

```markdown
## Freigabe-Checkliste — Welle 1

### Spec / Architektur (Phase 01)
- [ ] Alle abgeschlossenen Slices haben `lastenheft_refs`.
      **Beleg:** Frontmatter-Grep über `done/`.
- [ ] Alle Accepted-ADRs sind referenziert oder superseded.
      **Beleg:** `make adr-graph`.

### Planung (Phase 02)
- [ ] Carveouts sind alle entweder permanent gekennzeichnet
      oder haben Folge-Slice + Trigger.
      **Beleg:** `make carveout-audit`.

### Agenten (Phase 03)
- [ ] AGENTS.md beschreibt nur existierende Konventionen.
      **Beleg:** Doku-Konsistenz-Agent-Lauf (Modul 14).

### Qualität (Phase 04)
- [ ] `make gates` grün auf frischem Klon + im CI mit
      identischem Image-Hash.
      **Beleg:** zwei Run-Links (Klon-Run + CI-Run).
- [ ] Replay-Manifest (Modul 11) mit ≥3 Fällen, alle grün.
      **Beleg:** Link zum manifest.yaml + Run-Output.

### Betrieb (Phase 05)
- [ ] Runbook für *mindestens* den wahrscheinlichsten
      Incident-Typ existiert mit Entscheidungs-Triggern
      (nicht "Service neu starten").
      **Beleg:** Pfad zur Runbook-Datei.
- [ ] Trace-Fixture pro Welle archiviert.
      **Beleg:** OTel-Endpoint oder Pfad zur JSONL-Datei.
```

**Schritt 3 — Anti-Items hinzufügen (was *nicht* gefragt wird).**
Eine Liste der bewusst weggelassenen Häkchen — sonst wandern sie
schleichend in die Pflicht:

```markdown
### Bewusst NICHT in dieser Freigabe
- Manuelle Smoke-Tests in Produktion (delegiert an Validator).
- Aktualität von Stakeholder-Slides (delegiert an Produktmanagement).
- 100 %-Coverage (siehe ADR-0019 zu Critical Coverage).
```

**Schritt 4 — Incident-Klausel verlinken.**
```markdown
### Incident-Bereitschaft
- [ ] Bereitschafts-Dokument zeigt, wer in den ersten 15 Min
      welche der drei Optionen wählt: Rollback · Fix-Forward
      · Datenkorrektur.
      **Beleg:** Link zum Bereitschafts-Dokument.
```
Die Drei-Optionen-Tabelle gehört *vor* den Incident geschrieben — nicht
im Stress entschieden (siehe Engage).

**Schritt 5 — Item-für-Item belegen.**
Jetzt durchgehen und *jeden* Beleg-Slot tatsächlich füllen. Wenn ein
Beleg fehlt, ist das Item *nicht* abgehakt — auch wenn das Item
inhaltlich erfüllt wäre. Eine Checkliste ohne Belege ist die
Bürokratie-Form, gegen die der Kurs sich wendet.

**Schritt 6 — Freigabe-Eintrag in `done/welle-1-closure.md`.**
```markdown
# Welle 1 — Closure-Eintrag
Status: released
Datum: 2026-06-30
Checkliste: docs/release/welle-1-checkliste.md (alle Items mit Beleg)
Restrisiken: zwei (siehe §"Bewusst NICHT", plus Folge-Slice SL-027 für
             Coverage-Erhöhung auf Critical-Pfad).
Steering-Loop-Eintrag (Modul 14 Doku-Konsistenz-Agent meldete vor
Freigabe einen Drift in AGENTS.md — wurde behoben, vor Freigabe geprüft).
```

Sechs Schritte, eine Freigabe mit Belegen pro Item. Vergleich:
[`../../../lab/example/runbooks/`](../../../lab/example/runbooks/) und
[`../../../lab/example/Makefile`](../../../lab/example/Makefile) Target
`make release`.

## Übungen

* Produktionsfreigabe eines Projekts (Checkliste aus dem Begleit-Repo) — **erweitere** die Repo-Checkliste um zwei eigene Items mit Beleg-Anforderung für ein Projekt deiner Wahl (aktiviert das *Erschaffen*-Lernziel).
* Spiele ein Incident-Szenario durch: Agent löscht versehentlich produktive Daten — was tust du in den ersten 15 Minuten?

### Minimaler Übungspfad

```bash
cd lab/example
make release
```

Erwartete Beobachtung: Das Target prüft nur, ob Release-Checkliste und
Incident-Runbook Belege enthalten. Danach spielst du den Incident aus
[`../../../lab/example/runbooks/incident-agent-data-loss.md`](../../../lab/example/runbooks/incident-agent-data-loss.md)
durch und entscheidest begründet zwischen Rollback, Fix-Forward und
Datenkorrektur.

## Reflexion

Nach der Freigabe-Checkliste und dem Incident-Szenario kurz **schriftlich**:

1. **Was ist beobachtbar passiert?** — Welche Items deiner Checkliste hatten *keinen* Beleg, als du sie abhaken wolltest? Welche der drei Incident-Optionen hättest du im Stress gewählt — und wäre sie richtig gewesen?
2. **Welcher 2×2-Quadrant war Ursache?** — siehe [`konzeptkarte.md §2x2-Schnellanker`](../grundlagen/konzeptkarte.md#2x2-schnellanker). Runbook-Trigger sind *inferential feedforward*; Telemetrie für Injection-Erkennung ist *computational feedback*.
3. **Welche konkrete Steering-Loop-Aktion folgt?** — Beleg-Pflicht im Checklisten-Template? Runbook um Trigger erweitern, statt "Service neu starten"? Injection-Marker als CI-Lauf-Auswertung?
4. **Welche eigene Vorstellung wurde unzufriedenstellend?** — Conceptual Change; Kandidaten in [`lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "Rollback ist die Standardantwort", "Produktionsfreigabe ist eine formale Checkbox", "Prompt-Injection ist eine Modell-Frage").

**(Synthese-Frage, Modul-Abschluss):** Für ein dir bekanntes Projekt — nenne die drei *schwächsten* Stellen der Produktionsfreigabe und ordne jede einer Phase des Kurses (01–05) zu, in der das Defizit entstanden ist. Vergleiche dann mit der Pass-Through-Tabelle in [`../grundlagen/checkpoints.md`](../grundlagen/checkpoints.md#pass-through-logik-zum-abschlussprojekt) — landest du auf denselben Phasen?

Eintragsformat, "Wann *nicht* reagieren" und Anti-Antworten: [`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md).

## Selbstcheck

* **(Erinnern)** Welche drei Antwortoptionen prüft das Runbook bei einem produktiven Incident?
* Welche Telemetrie brauchst du, um einen Prompt-Injection-Versuch nachträglich zu erkennen?
* Wann ist Rollback der falsche Reflex?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Runbook-Optionen bei Incident? | "Rollback oder weitermachen." | Rollback · Fix-Forward · Datenkorrektur. Drei *verschiedene* Antwortklassen, mit jeweils anderen Voraussetzungen (Rückwärtskompatibilität, Test-Coverage des Fix, Vorhandensein des Originaldatensatzes). | + Hinweis: Welche der drei greift, ist *vor* dem Incident im Runbook festzulegen — mit Triggern wie "DB-Migration rückwärtskompatibel?" und "Buggy-Daten bereits ausgeliefert?". Wer im Incident wählt, wählt typischerweise unter Stress die teuerste Option. |
| Telemetrie für nachträgliche Injection-Erkennung? | "Logs." | Drei Spuren: Eingabe-Roh-Logging (mit Redaction), Tool-Call-Audit-Log, Output-vs-Eingabe-Konsistenz-Marker. | + Ergänzende Indikatoren: Cache-Miss-Spike, Tool-Allowlist-Reject-Counter — ohne mindestens *eines* der drei Pflicht-Felder bleibt Erkennung Glücksache. |
| Wann ist Rollback der falsche Reflex? | "Wenn es nicht hilft." | Drei Szenarien: nicht-rückwärtskompatible DB-Migration, bereits erzeugte Buggy-Daten, ungetesteter Rollback-Pfad. | + Folge: Rollback gehört *vor* den Incident im Runbook entschieden — als bedingte Regel mit Trigger, nicht als Universal-Reflex. Wer im Incident entscheidet, entscheidet schlecht. |

## Weiterlesen

* Übergang zum Abschluss: [Abschlussprojekt](../abschluss/abschlussprojekt.md)
