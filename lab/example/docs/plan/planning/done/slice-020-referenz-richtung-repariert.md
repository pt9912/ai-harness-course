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
- [x] Beobachtungs-Register (`../observations.md`) fortgeschrieben — `BEO-004` neu (1×), `BEO-006` neu (1×, aus dem Risiko-Ausgang §6).
- [x] Jedes Risiko aus §6 trägt einen Ausgang.
- [x] Ohne laufende Welle: die drei Paarungen geprüft — **nach** dem `git mv` nach `done/` (siehe §7).

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
  `BEO-006` im **Beobachtungs-Register** (`../observations.md`)
  (Sub-Area *Spec-Schreibung*). Auch ein wellenloser Slice trägt selbst
  ein — der Zähler hängt an der Slice-Closure, nicht an der Welle.

## 7. Closure-Notiz

**Ausgeführt am:** 2026-06-03.

**Beobachtung:** Der Zeiger war beim Schreiben von `slice-008`
entstanden — die Spec wurde „zur Nachvollziehbarkeit" um den Slice-Bezug
ergänzt. Genau diese Bewegung kehrt die Referenz-Richtung um.

**Steering-Loop-Eintrag:** noch keiner — also **kein** Feld `liegt in`. Die
Beobachtung *„Spec-Text wird zur Nachvollziehbarkeit um Slice-Bezüge
ergänzt"* ist als `BEO-004` im Register eingetragen und steht bei 1×. Bei 3×
wird daraus eine Regel; bis dahin ist der Eintrag *gezählt, nicht verkörpert*
und kein Gegenstand der Anker-Paarung.

**Beobachtungs-Register (`../observations.md`):** `BEO-004` neu angelegt
(Sub-Area *Spec-Schreibung*, 1×, Beleg `slice-020`); `BEO-006` neu angelegt
(1×, Beleg `slice-020`, aus dem Risiko-Ausgang §6).

**Folge-Slice:** keiner.

**Drei Paarungen** (ohne laufende Welle; geprüft nach dem `git mv` nach
`done/`): (a) Anker — kein `liegt in`-Feld in dieser Sektion, also
gegenstandslos; (b) Folge-Slice — keiner genannt; (c) Register — `BEO-004`
und `BEO-006` haben je eine Zeile mit Beleg. Alle grün.

## 8. Sub-Area-Modus-Begründung

**Status:** alle berührten Sub-Areas GF (siehe
`harness/conventions.md` §Modus-Deklaration pro Sub-Area: `*` = GF
für das DocSearch-Lab als Ganzes). Reine Spec-Korrektur ohne
Konventions-Adaption — keine BF/Hybrid-Begründung nötig.

Voraussetzung-Wissen für den Block-Aufbau: Kurs
[Modul 5 §Worked Mini-Example](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#worked-mini-example-bootstrap-modus-pro-sub-area-für-einen-slice-begründen).
