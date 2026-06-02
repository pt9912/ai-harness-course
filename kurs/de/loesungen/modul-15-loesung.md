# Lösung — Modul 15: Produktiver Betrieb

Zugehöriges Modul: [Modul 15 — Produktiver Betrieb](../05-betrieb/modul-15-produktiver-betrieb.md).

## Selbstcheck-Antworten

### (Erinnern) Welche drei Antwortoptionen prüft das Runbook bei einem Incident?

1. **Rollback** — Code-Version zurückspielen.
2. **Fix-Forward** — Bugfix einspielen, vorhandenen Stand belassen.
3. **Datenkorrektur** — am bereits geschriebenen Datensatz arbeiten,
   meist parallel zu (1) oder (2).

Drei *verschiedene* Antwortklassen, mit jeweils unterschiedlichen
Voraussetzungen:

- Rollback verlangt Rückwärtskompatibilität von DB-Schema und Config sowie
  einen *getesteten* Rollback-Pfad.
- Fix-Forward verlangt eine getestete Fix-Variante und Vertrauen in die
  Test-Coverage des Fixes.
- Datenkorrektur verlangt einen Original-Datensatz oder
  rekonstruierbares Audit-Log.

Welche der drei greift, gehört *vor* den Incident ins Runbook — mit
Triggern wie "DB-Migration rückwärtskompatibel? → Rollback möglich" und
"Buggy-Daten bereits ausgeliefert? → Datenkorrektur Pflicht". Wer im
Incident unter Stress wählt, wählt typischerweise die teuerste oder
falsch-greifende Option (siehe Häufige Fehler).

### Welche Telemetrie brauchst du, um einen Prompt-Injection-Versuch nachträglich zu erkennen?

Mindestens drei Spuren:

1. **Eingabe-Roh-Logging** (mit Redaction-Strategie für PII, aber strukturell vollständig). Ohne die Eingabe ist Forensik nicht möglich.
2. **Tool-Call-Audit-Log**: welche Tools wurden in welcher Reihenfolge mit welchen Args aufgerufen. Injection zeigt sich oft in *ungewöhnlicher Tool-Sequenz* (z. B. plötzlich ein File-Read auf einen sensiblen Pfad).
3. **Output-vs-Eingabe-Konsistenz-Marker**: hat das Modell auf Anweisungen aus den *Daten* reagiert (klassisches Anzeichen von Injection)? Marker: Drift im Antwort-Stil, plötzliches Ignorieren der System-Anweisung.

Ergänzend wertvoll:

- **Cache-Miss-Spike** zur selben Zeit wie ein ungewöhnliches Eingabe-Pattern — Injection-Versuche umgehen oft Cache, weil sie variabel sind.
- **Tool-Allowlist-Reject-Counter**: jeder abgelehnte Tool-Call ist ein Verdacht.

Wenn du nur die Antworten loggst, aber nicht die Eingaben + Tool-Sequenz,
kannst du Injection nur durch Glück erkennen.

### Wann ist Rollback der falsche Reflex?

Drei Szenarien, in denen Rollback schadet:

1. **Daten-Schemaänderung**: Wenn das Release eine DB-Migration ausgeführt hat, die nicht rückwärtskompatibel ist, macht Rollback der App das System inkonsistent. Lösung: vorwärts korrigieren oder DB-Rollback dazu.
2. **Wenn der Bug schon Daten erzeugt hat**: Rollback der Code-Version stellt Buggy-Daten nicht her. Lösung: Bugfix + Daten-Reparatur-Slice.
3. **Wenn Rollback selbst nicht getestet ist**: in vielen Repos ist Rollback "wir spielen die alte Version ein" — aber niemand hat geprüft, ob die alte Version mit *aktueller* DB/Config noch läuft. Lösung: Fix-Forward.

Faustregel: Rollback ist *eine* Reaktion, nicht *die* Reaktion. Im
Runbook sollte stehen, *wann* Rollback gilt und *wann* Fix-Forward — und
das vor dem Incident, nicht im Incident.

## Übungshinweise

### Produktionsfreigabe eines Projekts (Checkliste)

Mindest-Punkte einer Freigabe-Checkliste:

- `make gates` grün im aktuellen Image-Hash.
- `make ci` grün im selben Image-Hash.
- Mindestens ein Replay-Lauf gegen Golden Set, dokumentiert.
- ADR oder Carveout für jeden bewusst offenen Punkt.
- Runbook für mindestens drei Standard-Incidents (Out-of-Memory, Tool-Allowlist-Reject, Cache-Drift).
- Verifizierter Rollback-Pfad (oder dokumentierte Begründung, warum Fix-Forward die Strategie ist).
- Telemetrie-Smoke: ein Test-Trace ist im Trace-Viewer sichtbar.

### Spiele ein Incident-Szenario durch

Beispiel: "Agent löscht versehentlich produktive Daten."

Erste 15 Minuten:

1. **Stop**: weiteren Schaden verhindern. Agent abschalten, Tool-Allowlist verschärfen, ggf. Read-Only-Mode.
2. **Forensik einfrieren**: Traces, Logs, Eingabe-Cache der letzten Stunde sichern (nicht überschreiben).
3. **Schaden eingrenzen**: was wurde gelöscht? Aus Telemetrie ableitbar (Tool-Call-Audit-Log) oder aus DB-WAL?
4. **Kommunikation**: betroffene Stakeholder informieren mit *minimaler* aber wahrheitsgetreuer Faktenlage. Nicht "kein Problem" sagen, wenn Forensik noch läuft.

Erst danach: Wiederherstellung, Root-Cause, ADR-Folge-Slice. Die ersten
15 Minuten sind über *Schadensbegrenzung*, nicht über Reparatur.

## Häufige Fehler

- **Runbook beschreibt den Happy Path.** "Im Incident: Agent abschalten, Service neu starten." → Das ist Anwendung, kein Runbook. Runbook beschreibt *Entscheidungen* unter Unsicherheit, mit Triggern.
- **Freigabe als formale Checkbox.** → Wenn niemand die Checklist-Items inhaltlich prüft, ist Freigabe nicht Freigabe. Mindest-Praxis: Checklist hat *Belege* pro Item (Link auf Replay-Lauf, ADR-ID, Trace-Hash).
- **Rollback wird als universelle Antwort gelernt.** → Siehe Selbstcheck oben. Rollback ist Kontext-abhängig.

## Verweise

- Spec/Plan/ADR als Kontext für Runbooks: [`../grundlagen/konventionen.md`](../grundlagen/konventionen.md)
- Replay als Forensik-Werkzeug: [Modul 11](../04-qualitaet/modul-11-replay-evaluierung.md)
- Vorherige Lösung: [Modul 14](modul-14-loesung.md)
- Zurück zur Übersicht: [README](README.md)
