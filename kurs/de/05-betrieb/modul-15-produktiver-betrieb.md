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

## Übungen

* Produktionsfreigabe eines Projekts (Checkliste aus dem Begleit-Repo)
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

Nach den Übungen: [Reflexionsvorlage](../grundlagen/reflexion-vorlage.md).

## Selbstcheck

* Welche Telemetrie brauchst du, um einen Prompt-Injection-Versuch nachträglich zu erkennen?
* Wann ist Rollback der falsche Reflex?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Telemetrie für nachträgliche Injection-Erkennung? | "Logs." | Drei Spuren: Eingabe-Roh-Logging (mit Redaction), Tool-Call-Audit-Log, Output-vs-Eingabe-Konsistenz-Marker. | + Ergänzende Indikatoren: Cache-Miss-Spike, Tool-Allowlist-Reject-Counter — ohne mindestens *eines* der drei Pflicht-Felder bleibt Erkennung Glücksache. |
| Wann ist Rollback der falsche Reflex? | "Wenn es nicht hilft." | Drei Szenarien: nicht-rückwärtskompatible DB-Migration, bereits erzeugte Buggy-Daten, ungetesteter Rollback-Pfad. | + Folge: Rollback gehört *vor* den Incident im Runbook entschieden — als bedingte Regel mit Trigger, nicht als Universal-Reflex. Wer im Incident entscheidet, entscheidet schlecht. |

## Weiterlesen

* Übergang zum Abschluss: [Abschlussprojekt](../abschluss/abschlussprojekt.md)
