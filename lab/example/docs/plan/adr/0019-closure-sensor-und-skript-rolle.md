# ADR-0019: Das Closure-Gate trägt der Doku-Prüfer, das Skript trägt die Lehre

**Status:** Accepted

**Datum:** 2026-08-10

**Autor:** Kurs-Lab

**Bezug:** [ADR-0011](0011-closure-note-pflicht.md) (Closure-Note-Pflicht für
`done/`), Modul 11

**Schärft:** — (Prozess-ADR ohne Spec-Stratum: welcher Sensor eine
Harness-Regel durchsetzt, ist kein Vertragspunkt gegenüber einem Abnehmer)

---

## Kontext

[ADR-0011](0011-closure-note-pflicht.md) verlangt für jede Datei in `done/`
eine ausgefüllte Closure-Notiz und nennt in ihrer Fitness Function
[`tools/check_closure_notes.py`](../../../tools/check_closure_notes.py). Das Skript entstand, weil **kein Standard-Tool
diese Aussage prüfte** — genau der Fall, den Modul 11 als Worked Example lehrt.

Das gilt nicht mehr. Der Doku-Prüfer des Repos trägt die Prüfung inzwischen als
Fähigkeit `planning.closure`, und zwar vollständig: gleiche Kandidaten-Menge,
gleiche vier Bedingungen, gleiche Schwelle.

Damit stellt sich die Frage, die Modul 11 als Schritt 8 stellt: retiren oder
behalten? Die Kongruenz allein beantwortet sie nicht, denn das Skript hat einen
**zweiten Konsumenten** — es ist der per Pfad verlinkte Vergleichsgegenstand des
Worked Example von Modul 11.

## Entscheidung

1. **Die Deckung trägt `planning.closure`.** Alle vier Bedingungen aus
   ADR-0011 laufen dort: Abschnitt vorhanden, Substanz, keine Floskel, kein
   unausgefüllter Platzhalter.
2. **Die Schwelle kommt aus der ADR, nicht aus dem Werkzeug.**
   `min-sentences: 2` — ADR-0011 §Entscheidung 1 sagt „mindestens zwei Sätze".
   Die Vorbelegung des Werkzeugs ist 4; sie zu übernehmen hieße, eine
   Entscheidung durchzusetzen, die niemand getroffen hat.
3. **Die Kandidaten-Menge ist `done/*.md`, nicht `done/slice-*.md`.** ADR-0011
   zählt in ihrer Geschichte `welle-1-mvp.md` ausdrücklich zu den betroffenen
   Dateien. Ein Filter auf Slices wäre unter-gefasst.
4. **[`tools/check_closure_notes.py`](../../../tools/check_closure_notes.py) bleibt — als Artefakt der Lehre, nicht als
   Deckung.** Es ist der Gegenstand, an dem Modul 11 „Fitness Function ohne
   Standard-Tool" vorführt, und wird von dort per Pfad referenziert. Seine
   Existenz ist damit begründet; seine Rolle ist es, vorgeführt zu werden.
5. **Beide laufen weiter in `make verify`.** Ein Skript, das die Lehre trägt,
   muss lauffähig bleiben — ein Worked Example, dessen Gegenstand nicht mehr
   läuft, ist ein totes Beispiel. Der Doppellauf ist der Preis und ist billig.
6. **Bei Widerspruch gilt ADR-0011**, nicht der strengere Lauf. Beide sind
   Sensoren, keine Quelle — dieselbe Regel wie bei den zwei Layering-Sensoren
   ([ADR-0018](0018-grenzen-gehoeren-in-die-konfiguration.md)).

## Verglichene Alternativen

### Option A — Skript retiren, wie beim Referenz-Richtungs-Prüfer

- Pro: Ein Sensor weniger, eine Sache weniger zu pflegen; die Kongruenz ist
  belegt, technisch spricht nichts dagegen.
- Contra: Modul 11 verlöre seinen verlinkten Gegenstand, und die
  Skill-Vorlage `closure-note-reviewer` ihre Bezugsgröße. Der Kurs ist die
  Norm-Schicht; ein Beispiel zu löschen, auf das er zeigt, macht **den Kurs**
  falsch, nicht das Beispiel richtig.

### Option B — Skript aus dem Gate nehmen, Datei als Fixture behalten (gewählt: nein)

- Pro: Kein Doppellauf.
- Contra: Eine Datei, die aussieht wie ein Gate und keines ist, ist genau die
  Bauform, gegen die AGENTS.md §3 antritt. Und ein nie ausgeführtes Skript
  verrottet still — das Worked Example zeigte dann auf etwas, das nicht mehr
  funktioniert.

### Option C — beides behalten, Rollen ausschreiben (gewählt)

- Pro: Die Deckung liegt beim Werkzeug, die Lehre beim Skript, und beide
  Aussagen stehen dort, wo jemand sie liest.
- Contra: Zwei Sensoren an derselben Aussage können divergieren. Punkt 6 sagt,
  was dann gilt; ein Sensor auf ihre Gleichheit existiert nicht.
- Contra: Der Doppellauf kostet Laufzeit in `make verify`.

## Konsequenzen

- Positiv: Die Schwelle steht jetzt an genau einer Stelle als Entscheidung
  (ADR-0011) und an zwei als Konfiguration — vorher war die zweite eine
  Werkzeug-Vorbelegung, die zufällig strenger war.
- Positiv: Belegt statt angenommen — je Verstoßklasse ein Break-Test mit beiden
  Sensoren nebeneinander, über alle drei Dateiarten des Ruheorts (Slice,
  Welle-Ergebnisnotiz, Welle-Plan), plus unveränderter Bestand beidseitig still.
- Negativ: Divergenz-Risiko ohne Sensor (siehe Contra oben).
- Folgepflicht: Wo das Skript als *Gate* dokumentiert ist, steht jetzt seine
  Rolle — `AGENTS.md` §3, `harness/README.md` §Sensors und
  `docs/plan/planning/README.md`.

## Fitness Function

| Tooling | Regel | Make-Target |
|---|---|---|
| Doku-Prüfer, Modul `planning.closure` (Container, digest-gepinnt) | ADR-0011 §Entscheidung 1–4 über `done/*.md`, Schwelle 2 | `make doc-check` (läuft in `make verify` mit) |
| [`tools/check_closure_notes.py`](../../../tools/check_closure_notes.py) | dieselbe Aussage; **Rolle: Vorführ-Gegenstand für Modul 11**, nicht Deckung | `make verify-closure-notes` |

## Re-Evaluierungs-Trigger

- **Modul 11 verweist nicht mehr auf das Skript**: Dann hat es keinen
  Konsumenten mehr, und Option A ist die richtige Antwort.
- **Die beiden Sensoren widersprechen sich**: kein stilles Abschalten eines
  Laufs, sondern Befund gegen ADR-0011 prüfen und die Ursache benennen.
- **Die Konfiguration weicht von ADR-0011 ab** — Schwelle, Kandidaten-Menge
  oder eine der vier Bedingungen: Dann ist nicht die ADR nachzuziehen, sondern
  die Konfiguration, oder es braucht eine Nachfolge-ADR zu ADR-0011.

## Geschichte

| Datum | Ereignis | Verweis |
|---|---|---|
| 2026-08-10 | Proposed | Der Doku-Prüfer erreicht Kongruenz; Frage nach Retiren gestellt |
| 2026-08-10 | Accepted | Kongruenz über alle drei Dateiarten belegt; Rollen ausgeschrieben |
