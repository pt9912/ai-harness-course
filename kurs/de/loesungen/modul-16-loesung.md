# Lösung — Modul 16: Produktiver Betrieb

Zugehöriges Modul: [Modul 16 — Produktiver Betrieb](../05-betrieb/modul-16-produktiver-betrieb.md).

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

### (Erschaffens-Prozess) Welcher Schritt der Freigabe-Checkliste war der unsicherste?

Maßstab: ein *konkreter* Schritt mit Begründung — "Schritt 3 war
ungewohnt" ohne das *Warum* bleibt rudimentär. Die zwei
erfahrungsgemäß häufigsten Kandidaten:

- **Schritt 3 (Anti-Items):** Die Unsicherheit liegt darin, zu
  entscheiden, was *bewusst nicht* gefragt sein soll — das verlangt,
  die Grenze der eigenen Freigabe zu kennen (was ist an Validator,
  Produktmanagement, ADR delegiert?). Genau diese Liste verhindert
  die schleichende Pflichten-Ausweitung: was nicht als Anti-Item
  dokumentiert ist, wandert irgendwann unbemerkt in die Pflicht.
- **Schritt 5 (Item-für-Item belegen):** Die Unsicherheit zeigt sich,
  wenn ein Item inhaltlich erfüllt ist, aber der Beleg fehlt — die
  Versuchung, "trotzdem abzuhaken", ist der Moment, in dem aus der
  Freigabe Bürokratie wird. Wer die Beleg-Pflicht einmal aufgibt,
  bekommt eine Checkbox-Liste.

Pointe: Beides sind keine Formfragen, sondern die einzigen zwei
Stellen, an denen die Freigabe gegen Verschleiß geschützt ist —
Anti-Items gegen Aufblähung, Beleg-Pflicht gegen Aushöhlung.

## Übungshinweise

### Produktionsfreigabe eines Projekts (Checkliste)

Mindest-Punkte einer Freigabe-Checkliste:

- `make gates` grün im aktuellen Image-Hash.
- `make ci` grün im selben Image-Hash.
- Mindestens ein Replay-Lauf gegen Golden Set, dokumentiert.
- ADR oder Carveout für jeden bewusst offenen Punkt.
- Runbook für *mindestens* den wahrscheinlichsten Incident-Typ (das ist die Checklisten-Untergrenze im Worked Example); solide sind die drei häufigsten Klassen (z. B. Out-of-Memory, Tool-Allowlist-Reject, Cache-Drift).
- Verifizierter Rollback-Pfad (oder dokumentierte Begründung, warum Fix-Forward die Strategie ist).
- Telemetrie-Smoke: ein Test-Trace ist im Trace-Viewer sichtbar.

Für die geforderten *zwei eigenen Items*: beide brauchen eine
Beleg-Anforderung (Datei, Make-Target, Trace-ID), und sie sollen aus
dem *eigenen* Projekt kommen, nicht aus der Vorlage — z. B. ein
Domänen-Gate-Beleg (`make test-determinism`-Run-Link) oder ein
Kosten-Item ("Token-Budget der Welle nicht überschritten, Beleg:
Metrik-Dashboard-Snapshot mit `slice.id`-Filter").

### (Erschaffen — voll aktiviert LZ 1) Freigabe-Checkliste aus dem leeren Skelett

Beispiel-Konstruktion für ein eigenes Projekt (hier: das
Fallstudien-Repo-Muster eines Doc-Search-Services) — fünf
Phasen-Abschnitte, je zwei Items mit Beleg, plus Incident-Klausel:

```markdown
# release-checklist.md — Welle 1

## Vorbereitung
- [ ] Alle Slices der Welle in done/ mit Closure-Note.
      **Beleg:** make verify-closure-notes (grün, Run-Link).
- [ ] Offene Carveouts haben Trigger + Folge-Slice.
      **Beleg:** make carveout-audit (Output angehängt).

## Reproduzierbarkeits-Anker
- [ ] Image-Hash des Release-Builds festgehalten.
      **Beleg:** harness/image-hash.txt (Commit-Stand).
- [ ] make gates grün auf frischem Klon UND im CI mit
      identischem Image-Hash.
      **Beleg:** zwei Run-Links (Klon + CI).

## Replay-Beleg
- [ ] Golden-Set-Replay ≥ 3 Fälle, alle grün, Manifest aktuell.
      **Beleg:** evals/golden/welle-1-baseline/manifest.yaml + Run-Output.
- [ ] Drift-Rate gegen Vorwelle dokumentiert (Zahl, nicht "ok").
      **Beleg:** CHANGELOG-Eintrag im Golden-Set-Verzeichnis.

## Runtime-Validation
- [ ] Schema-/Budget-Validierung am laufenden Service geprüft.
      **Beleg:** Test-Trace-ID im Trace-Viewer.
- [ ] Tool-Allowlist des Produktiv-Agenten = Stand der AGENTS.md.
      **Beleg:** Doku-Konsistenz-Agent-Lauf (Modul 15).

## Anti-Items (bewusst NICHT in dieser Freigabe)
- Manuelle Smoke-Tests in Produktion (delegiert an Validator).
- 100 %-Gesamt-Coverage (Critical Coverage per ADR geregelt).

## Incident-Klausel
Die Freigabe entfällt automatisch — ohne Diskussion —, wenn vor dem
Release-Zeitpunkt (a) ein HIGH-Finding offen ist, (b) der
Doku-Konsistenz-Agent einen Geister-Befehl meldet oder (c) ein
Incident der Klasse "Agent schreibt produktive Daten" offen ist.
Wiederaufnahme nur durch erneuten vollen Checklisten-Durchlauf.
```

Begründung der Konstruktion: Jedes Item trägt einen Beleg-Slot
(Schritt 1 des Worked Example — die Beleg-Pflicht ist der einzige
Schutz gegen Bürokratie); die Incident-Klausel ist eine
*automatische* Entfall-Regel (Brandschutzklappe), kein
Eskalations-Meeting. Der verlangte Abschluss-Vergleich: gegen das
Worked Example und die Lab-Vorlage `runbooks/release-checklist.md`
prüfen, (a) welche Items dir fehlten — typisch: Anti-Items und der
zweifache `make gates`-Beleg (Klon + CI) — und (b) welche du hast,
die dort nicht stehen (hier z. B. die dokumentierte Drift-Rate):
Letztere sind Kandidaten für deinen Steering Loop, nicht automatisch
überflüssig.

### Spiele ein Incident-Szenario durch

Beispiel: "Agent löscht versehentlich produktive Daten."

Erste 15 Minuten:

1. **Stop**: weiteren Schaden verhindern. Agent abschalten, Tool-Allowlist verschärfen, ggf. Read-Only-Mode.
2. **Forensik einfrieren**: Traces, Logs, Eingabe-Cache der letzten Stunde sichern (nicht überschreiben).
3. **Schaden eingrenzen**: was wurde gelöscht? Aus Telemetrie ableitbar (Tool-Call-Audit-Log) oder aus DB-WAL?
4. **Kommunikation**: betroffene Stakeholder informieren mit *minimaler* aber wahrheitsgetreuer Faktenlage. Nicht "kein Problem" sagen, wenn Forensik noch läuft.

Erst danach: Wiederherstellung, Root-Cause, ADR-Folge-Slice. Die ersten
15 Minuten sind über *Schadensbegrenzung*, nicht über Reparatur.

### (Analysieren — aktiviert LZ 2) Injection-Symptome im Trace-Ausschnitt erkennen

Zur Übung mit dem Trace-Ausschnitt (spans 04–08). Der Slice-Auftrag
war neutral: *"Fasse `docs/spec.md` und die hochgeladenen
Nutzer-Notizen zusammen"* — kein Akzeptanzkriterium verlangt mehr.
Drei Symptome, je einer Telemetrie-Spur zugeordnet:

1. **Ungewöhnliche Tool-Sequenz** (span 06: `read_file` auf `../../.env`) <!-- d-check:ignore (Angriffs-Beispiel, kein Repo-Pfad) -->
   — sichtbar im **Tool-Call-Audit-Log**. Der Pfad liegt außerhalb des
   Slice-Scopes (der Auftrag braucht nur `docs/spec.md` und
   `user_upload/notes.md`); ein Lese-Zugriff auf Secrets ist nie Teil
   eines Zusammenfassungs-Auftrags.
2. **Externer `http_post`** (span 07: an `paste.example.com`) —
   sichtbar im **Tool-Call-Audit-Log** *plus* einem
   **Tool-Allowlist-Reject-Counter**, der hier *hätte* greifen müssen.
   Das ist der eigentliche Exfiltrations-Schritt: Secret lesen, dann nach
   außen schicken.
3. **Output-vs-Eingabe-Drift** (span 08: "Zusätzlich habe ich die
   Konfiguration gesichert") — sichtbar im
   **Output-Konsistenz-Marker**. Das Modell behauptet eine Handlung, die
   in keinem Akzeptanzkriterium des Slice steht — klassisches Zeichen,
   dass es Anweisungen aus den *Daten* (`user_upload/notes.md`, span 05)
   befolgt hat.

Die entscheidende Pointe: Das *Erkennen* aus dem Trace ist
nachgelagert (inferential feedback). Die *eine* präventive Kontrolle, die
den Lauf gar nicht erst so weit hätte kommen lassen, ist die
**Tool-Allowlist** (computational feedforward): `http_post` auf eine
nicht freigegebene Domain — und `read_file` außerhalb des Slice-Pfads —
wären erst gar nicht ausgeführt worden. So weit links und oben wie
möglich (Modul 0 / `klassifikation.md`).

### (Bewerten — aktiviert LZ 4) Rollback-oder-Fix-Forward-Abwägung — drei Fälle

| Fall | Ausgangslage | Wahl + entscheidender Trigger |
|---|---|---|
| **A** | Deploy enthält eine **nicht-rückwärtskompatible** DB-Migration; der Bug ist kosmetisch | **Fix-Forward.** Trigger: *Rückwärtskompatibilität* verletzt — ein Code-Rollback gegen das neue Schema macht das System inkonsistent, und der kosmetische Bug rechtfertigt das Risiko erst recht nicht. Kleiner Folge-Slice statt Rückwärtsgang. |
| **B** | Bug ist kritisch, aber der Fix ist klein und durch einen bestehenden Test gedeckt; keine Migration | **Fix-Forward** — knapp vor Rollback, beides legitim. Trigger: *Test-Coverage des Fix* — der Fix ist belegt geprüft, also ist Vorwärts hier schneller *und* sicherer als ein Rollback, dessen Pfad womöglich nie geprobt wurde. (Wäre der Rollback-Pfad nachweislich getestet und der Fix ungedeckt, kippte die Wahl.) |
| **C** | Agent hat bereits **fehlerhafte Daten an Kunden ausgeliefert**; das Original liegt im Backup | **Datenkorrektur** (parallel dazu Fix der Ursache). Trigger: *Existenz des Originaldatensatzes* — Code-Rollback stellt ausgelieferte Buggy-Daten nicht wieder her; das Backup macht die Korrektur überhaupt erst möglich. |

Als bedingte Runbook-Regeln umgeschrieben — *vor* dem Incident
festgelegt, nicht im Stress entschieden:

| Wenn … | Dann … |
|---|---|
| Migration nicht rückwärtskompatibel | kein Rollback — Fix-Forward (ggf. mit separatem, getestetem DB-Rollback) |
| Fix klein und durch bestehenden Test gedeckt, keine Migration | Fix-Forward; Rollback nur, wenn der Rollback-Pfad selbst getestet ist |
| Buggy-Daten bereits ausgeliefert und Original vorhanden | Datenkorrektur Pflicht — zusätzlich zu (nicht statt) der Ursachen-Behebung |

Die drei **Anti-Rollback-Szenarien** (LZ 4 verlangt sie explizit):

1. **Nicht-rückwärtskompatible DB-Migration** — Rollback erzeugt
   Schema-Code-Inkonsistenz (Fall A).
2. **Bereits erzeugte/ausgelieferte Buggy-Daten** — Rollback der
   Code-Version repariert keine Daten (Fall C).
3. **Ungetesteter Rollback-Pfad** — niemand hat geprüft, ob die alte
   Version mit aktueller DB/Config noch läuft; der "sichere"
   Rückwärtsgang ist dann das größte Experiment des Abends.

Pointe: Wer die Regeln vor dem Incident festlegt, entscheidet nachts
nach Tabelle statt nach Adrenalin — wer im Incident wählt, wählt
typischerweise die teuerste Option (siehe Selbstcheck "Wann ist
Rollback der falsche Reflex?").

## Häufige Fehler

- **Runbook beschreibt den Happy Path.** "Im Incident: Agent abschalten, Service neu starten." → Das ist Anwendung, kein Runbook. Runbook beschreibt *Entscheidungen* unter Unsicherheit, mit Triggern.
- **Freigabe als formale Checkbox.** → Wenn niemand die Checklist-Items inhaltlich prüft, ist Freigabe nicht Freigabe. Mindest-Praxis: Checklist hat *Belege* pro Item (Link auf Replay-Lauf, ADR-ID, Trace-Hash).
- **Rollback wird als universelle Antwort gelernt.** → Siehe Selbstcheck oben. Rollback ist Kontext-abhängig.

## Verweise

- Spec/Plan/ADR als Kontext für Runbooks: [`../grundlagen/konventionen.md`](../grundlagen/konventionen.md)
- Replay als Forensik-Werkzeug: [Modul 12](../04-qualitaet/modul-12-replay-evaluierung.md)
- Vorherige Lösung: [Modul 15](modul-15-loesung.md)
- Zurück zur Übersicht: [README](README.md)
