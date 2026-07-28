# Slice 020: Abwärtszeiger im Spec-Stratum entfernen

**Lifecycle:** Der Zustand dieses Slice ist das Verzeichnis, in dem diese
Datei liegt — eines von `open/`, `next/`, `in-progress/`, `done/`. Er wechselt
nur durch `git mv` (Kurs
[Modul 5 §Lifecycle als State Machine](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#lifecycle-als-state-machine)).

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

**Drei Paarungen:** hier nicht — dieses Repo schneidet Wellen. Dass *dieser
Slice* zu keiner gehört, ändert daran nichts: Die nächste Welle-Closure
(`welle-2-qualitaet`) prüft alles, was seit `welle-1` in `done/` gelandet ist,
also auch `BEO-004` und `BEO-006` aus dieser Notiz.

## 8. Sub-Area-Modus-Begründung

**Status:** alle berührten Sub-Areas GF (siehe
`harness/conventions.md` §Modus-Deklaration pro Sub-Area: `*` = GF
für das DocSearch-Lab als Ganzes). Reine Spec-Korrektur ohne
Konventions-Adaption — keine BF/Hybrid-Begründung nötig.

**Vorgelagert — offene Beobachtungen gesichtet:** Register
(`../observations.md`) durchgegangen. Berührt sind zwei Sub-Areas aus der
Modus-Tabelle (`harness/conventions.md`), abgelesen an §3: *Spec-Schreibung*
(`spec/spezifikation.md`) und *Planning-Lifecycle* (dieser Slice-Plan selbst).

**Ein offener Treffer:** `BEO-003` (*Spec-Schreibung*, 2×). Dazu eine bereits
**verkörperte** Zeile auf derselben Sub-Area, `BEO-007`: Sie steht mit Zähler
und Belegen im Register, trägt aber den Vermerk, wohin sie ging, und wirkt über
Lastenheft v0.2.0 von selbst. Auf *Planning-Lifecycle* steht keine Zeile.

`BEO-003` erreicht **mit diesem Slice** nicht 3×: Es meint den vergessenen
ADR-Bezug im Commit, und der ist hier nicht aufgetreten. Kein Folge-Slice. Was
diesem Slice auffällt, sind zwei *neue* Beobachtungen — `BEO-004` aus der
Closure-Beobachtung und `BEO-006` aus dem Risiko-Ausgang §6; beide legt §7 an,
beide auf *Spec-Schreibung*.

Voraussetzung-Wissen für den Block-Aufbau: Kurs
[Modul 5 §Worked Mini-Example](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#worked-mini-example-bootstrap-modus-pro-sub-area-für-einen-slice-begründen).
