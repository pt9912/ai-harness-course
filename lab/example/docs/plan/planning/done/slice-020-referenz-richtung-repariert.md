# Slice 020: Abwärtszeiger im Spec-Stratum entfernen

**Status:** done

**Welle:** ohne Welle

**Bezug:** LH-QA-02 (Reproduzierbarkeit, primär — eine Spec, die auf Slices zeigt, ist nicht reproduzierbar lesbar), ADR-0011 (Closure-Note-Pflicht, sekundär)

**Autor:** Kurs-Lab. **Datum:** 2026-06-03.

## 1. Ziel

Den Abwärtszeiger aus `spec/spezifikation.md` entfernen, den
`make check-references` gemeldet hat — die Spec verwies auf einen
Slice-Plan statt umgekehrt.

> **Warum ohne Welle** (Kurs
> [Modul 6 §Wann Arbeit eine Welle braucht](../../../../../../kurs/de/02-planung/modul-06-roadmap.md#wann-arbeit-eine-welle-braucht--und-wann-nicht)):
> Ein Closure-Trigger um diesen Slice könnte nur „Zeiger entfernt,
> `make verify` grün" lauten — und genau das steht schon in der DoD
> unten. Es fehlt die Bedingung, die über die DoD hinausgeht, also liegt
> keine Welle vor. Der Slice erscheint deshalb **nicht** in der Roadmap;
> sein Zustand ist die Verzeichnis-Position.

## 2. Definition of Done

- [x] `spec/spezifikation.md`: Abwärtszeiger auf `slice-008` entfernt, Aussage ohne Slice-Bezug formuliert.
- [x] `make check-references` grün.
- [x] `make verify` grün.
- [x] Closure-Notiz (siehe §7).

## 3. Plan (vor Code)

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| `spec/spezifikation.md` | update | Abwärtszeiger raus |
| `docs/plan/planning/done/` | add | dieser Slice-Plan |

## 4. Trigger

- `make check-references` meldete den Abwärtszeiger (reaktiv — ein Sensor
  hat gefeuert, kein gewolltes Vorhaben).

## 5. Closure-Trigger

- DoD vollständig. Eine weitere Bedingung gibt es nicht — siehe §1.

## 6. Risiken und offene Punkte

Jedes Risiko trägt bei Closure genau einen Ausgang (Modul 5
§Offene Risiken werden bei Closure aufgelöst).

- Die Aussage in der Spec könnte ohne den Slice-Bezug unverständlich
  werden — **Ausgang:** entfallen. Der Bezug war redundant; die Spec
  trägt die Aussage selbst.
- `check-references` prüft nur `spec/`, nicht `docs/plan/adr/` — dort
  könnten dieselben Zeiger unbemerkt stehen — **Ausgang:** weiter offen →
  *Beobachtungen unter Schwelle* der **nächsten** Welle-Closure
  (Sub-Area *Spec-Schreibung*). Auch ein wellenloser Slice liefert
  dorthin ab: Die Welle-Closure verdichtet alle Slice-Closures seit der
  letzten Welle-Closure, nicht nur die der Welle.

## 7. Closure-Notiz

**Ausgeführt am:** 2026-06-03.

**Beobachtung:** Der Zeiger war beim Schreiben von `slice-008`
entstanden — die Spec wurde „zur Nachvollziehbarkeit" um den Slice-Bezug
ergänzt. Genau diese Bewegung kehrt die Referenz-Richtung um.

**Steering-Loop-Eintrag:** noch keiner. Die Beobachtung *„Spec-Text wird
zur Nachvollziehbarkeit um Slice-Bezüge ergänzt"* steht damit bei 2×
(`welle-1-results.md` führt sie als Finding-Klasse *ADR-Bezug im Commit
vergessen* separat) und geht als *Beobachtung unter Schwelle* in die
nächste Welle-Closure. Bei 3× wird daraus eine Regel.

**Folge-Slice:** keiner.

## 8. Sub-Area-Modus-Begründung

**Status:** alle berührten Sub-Areas GF (siehe
`harness/conventions.md` §Modus-Deklaration pro Sub-Area: `*` = GF
für das DocSearch-Lab als Ganzes). Reine Spec-Korrektur ohne
Konventions-Adaption — keine BF/Hybrid-Begründung nötig.

Voraussetzung-Wissen für den Block-Aufbau: Kurs
[Modul 5 §Worked Mini-Example](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#worked-mini-example-bootstrap-modus-pro-sub-area-für-einen-slice-begründen).
