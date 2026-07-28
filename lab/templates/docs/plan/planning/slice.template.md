# Slice <slice-id>: <Titel>

> **Template-Hinweis.** Vorlage für einen Slice-Plan. Kopiere nach
> `docs/plan/planning/open/slice-<NNN>-<kurzer-titel>.md` und ersetze
> Platzhalter. Lösche diesen Block.

**Lifecycle:** Der Zustand dieses Slice ist das Verzeichnis, in dem diese
Datei liegt — eines von `open/`, `next/`, `in-progress/`, `done/`. Er
wechselt nur durch `git mv`, siehe
Baseline-Regelwerk `modul-05-planning-harness.md` §Lifecycle als State Machine.

**Welle:** <welle-id> oder "ohne Welle" — ohne Welle immer dann, wenn es
keine Closure-Bedingung gibt, die von der DoD dieses Slice verschieden
ist, siehe Baseline-Regelwerk `modul-06-roadmap.md`
§Wann Arbeit eine Welle braucht (Modul 6).

**Bezug:** `<LH-FA-NN>`, `<LH-QA-NN>`, ADR-<NNNN>.

**Autor:** <Name>. **Datum:** YYYY-MM-DD.

---

## 1. Ziel

<!--
Was liefert dieser Slice in einem Satz? Liefer-Fokus, kein "wir
machen aufräumen".
-->

<…>

## 2. Definition of Done

<!--
Was muss erfüllt sein, damit der Slice in done/ wandert?
Liste mit jeweils prüfbarem Kriterium.
-->

- [ ] LH-FA-<NN> erfüllt, Test referenziert.
- [ ] LH-QA-<NN> erfüllt, Messung dokumentiert.
- [ ] `make gates` grün.
- [ ] Doku-Update für <Schnittstelle X> falls öffentlicher Vertrag berührt.
- [ ] Closure-Notiz mit Steering-Loop-Lerneintrag.
- [ ] Beobachtungs-Register (`../observations.md`) fortgeschrieben — neue `BEO-<NNN>` oder Zähler +1 mit Beleg; keine Beobachtung angefallen ist ebenfalls eine Antwort und wird in §7 notiert.
- [ ] Jedes Risiko aus §6 trägt einen Ausgang (eingetreten / entfallen / weiter offen).

## 3. Plan (vor Code)

<!--
Welche Änderungen sind geplant? Datei- oder Komponenten-Ebene reicht.
Der Implementation-Agent erweitert diese Liste in seinem ersten Lauf.
-->

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| <…> | neu / update / refactor | <…> |

## 4. Trigger

<!--
Wann beginnt dieser Slice? (`next` → `in-progress`: Implementer beginnt.)
Beispiele: "Wenn Welle X done." / "Wenn Carveout CO-NN aufgelöst."

Auch die zwei Rückführungen vorab benennen — unter welcher Bedingung
geht dieser Slice zurück?
- `in-progress` → `next`: zu groß, zurück zur Zerlegung.
- `in-progress` → `open`: blockiert (Carveout? siehe Modul 7).
(kanonische Definition: [Baseline-Regelwerk §Lifecycle als State Machine](../../../../regelwerk/modul-05-planning-harness.md#lifecycle-als-state-machine))
-->

<…>

## 5. Closure-Trigger

<!--
Wann ist der Slice done?
"DoD vollständig + PR gemerged + Closure-Notiz geschrieben."
-->

<…>

## 6. Risiken und offene Punkte

<!--
Was könnte schief gehen? Welche Carveouts entstehen ggf.?

JEDES Risiko bekommt bei Closure genau EINEN Ausgang (Baseline-Regelwerk
`modul-05-planning-harness.md` §Offene Risiken werden bei Closure aufgelöst):
  eingetreten  -> Carveout CO-<NNN> oder Folge-Slice, ID hier eintragen
  entfallen    -> gestrichen MIT Begründung (ohne sie ist es stilles Vergessen)
  weiter offen -> Zeile im Beobachtungs-Register (`../observations.md`) anlegen
                  oder hochzählen; die BEO-<NNN> hier eintragen
Ein Slice geht nicht nach done/, während ein Risiko ohne Ausgang dasteht.
-->

- <Risiko> — **Ausgang:** <eingetreten: CO-NNN / slice-NNN | entfallen: Grund | weiter offen: → BEO-NNN im Register>

## 7. Closure-Notiz (bei Closure zu füllen)

<!--
Wird bei der Closure gefüllt, vor dem `git mv` nach `done/`. Inhalt:
- Was hat funktioniert?
- Was ging anders als geplant?
- Steering-Loop-Eintrag: welcher Guide/Sensor sollte verbessert werden?
  (kanonische Definition: [Baseline-Regelwerk §Steering Loop](../../../../regelwerk/grundlagen-klassifikation.md#steering-loop))
  Wurde die Regel HIER verkoerpert (wellenlos, Schwelle 3x erreicht, keine
  laufende Welle)? Dann das PFLICHTFELD setzen — dieselbe Form wie in der
  Welle-Closure, und NUR dieses Feld loest die Anker-Paarung aus:

      liegt in `<AGENTS.md §X | Makefile-Target | .harness/skills/…>`

  Das Ziel traegt dann `(seit slice-<NNN>)`. Ohne dieses Feld ist der Eintrag
  gezaehlt, nicht verkoerpert — eine blosse Erwaehnung eines Pfades im
  Fliesstext ist KEIN Zielort und loest nichts aus.
  OHNE LAUFENDE WELLE gibt es keine Welle-Closure, die anschliessend prueft:
  Dann die drei Paarungen (Anker · Folge-Slice · Register) direkt hier nach
  der Closure pruefen — sonst prueft sie niemand.
- PFLICHTSCHRITT — Beobachtungs-Register (`../observations.md`) fortschreiben,
  vor dem `git mv` nach done/:
    keine Beobachtung angefallen -> NICHTS eintragen; hier "keine Beobachtung"
                                    notieren. Das ist ebenfalls eine Antwort —
                                    eine erfundene BEO-<NNN> verduennt den
                                    Zaehler mit Rauschen. Ebenso zaehlt eine
                                    benannte Spec-Luecke NICHT: sie traegt
                                    ihre LH-*-ID;
    Beobachtung schon im Register -> Zähler +1, Beleg `slice-NNN`
                                     ergänzen, hier die BEO-<NNN>
                                     ZITIEREN statt neu formulieren;
    sonst                         -> neue BEO-<NNN> vergeben, Zeile
                                     anlegen (Sub-Area, 1x, Beleg).
  Das ist der Punkt, an dem der Zähler unabhängig von jeder Welle läuft: Die
  Welle-Closure LIEST das Register nur noch (was hat 3x erreicht).
- Folge-Slices: welche neuen open/-Einträge? (*derivativ* — der Folge-Slice
  selbst ist eine Datei in `open/`, diese Zeile zeigt nur darauf; genannt
  heißt angelegt, sonst schlägt die Folge-Slice-Paarung der Welle-Closure an.
  Bewusst NICHT „liegt in" — diese Form ist dem Pflichtfeld oben vorbehalten
  und wuerde hier die Anker-Paarung ausloesen)
- Risiken aus §6: hat jedes einen Ausgang?
- Finding-Klassen aus dem Review dieses Slice (Summary-Zeile des
  Review-Reports): welche gehen als Beobachtung weiter? Stabile
  Bezeichnung übernehmen bzw. die vorhandene `BEO-<NNN>` zitieren —
  sonst zählt das Register zwei Namen getrennt.
-->

<!-- Bei der Closure füllen — vor dem `git mv` nach `done/` (siehe Kommentar
oben), nicht danach. -->

## 8. Sub-Area-Modus-Begründung

**Status:** Pflicht-Sektion bei mindestens einer berührten Sub-Area
in BF oder Hybrid. Bei reinem GF genügt der Hinweis
*"alle berührten Sub-Areas GF (siehe Baseline-Regelwerk
`modul-05-planning-harness.md` §Ziel-Form: Sub-Area-Modus-Begründung)"*. Optional bei reinem Refactor ohne neue
Sub-Area-Berührung. Die vier Pflichtkriterien (Konventionen-Dichte ·
Phase-Reife · Evidenz-/Diskrepanz-Risiko · Reconciliation-Aufwand)
stehen in
Baseline-Regelwerk `modul-05-planning-harness.md` §Ziel-Form: Sub-Area-Modus-Begründung.

**Vorgelagert — Sub-Area-Wahl prüfen:** Jede hier aufgeführte Sub-Area
muss das Inklusionskriterium erfüllen (drei Achsen, Schwelle ≥ 2; siehe
Baseline-Regelwerk `grundlagen-konventionen.md` §Was ist eine Sub-Area?).
Zu grobe Sub-Areas (*"Backend"*) vorher ausdifferenzieren — sonst trägt
der Begründungsblock mehrere Modi vermischt.

**Vorgelagert — offene Beobachtungen sichten:** Das Beobachtungs-Register
(`../observations.md`) durchgehen: Steht eine der hier
berührten Sub-Areas dort? Dann gehört der Zähler-Stand unten ins
*Evidenz-/Diskrepanz-Risiko* — und erreicht der Eintrag mit diesem Slice
3×, ist er keine Notiz mehr, sondern eine Lücke und braucht einen eigenen
Folge-Slice. Keine Treffer sind ebenfalls eine Antwort und werden
notiert.

<!-- Block für jede berührte Sub-Area duplizieren. Format identisch
mit dem im Baseline-Regelwerk §Ziel-Form: Sub-Area-Modus-Begründung
abgedruckten Block. -->

### Sub-Area: <Name>

- **Modus:** GF | BF | Hybrid
- **Konventionen-Dichte:** <Beleg aus `harness/conventions.md`,
  Adaptions-Block oder Code>
- **Phase-Reife:** Phase 0–5 <Begründung gegen die Phase × Modus-Matrix>
- **Evidenz-/Diskrepanz-Risiko:** <bei BF/Hybrid: was kann die
  Inventur sichtbar machen? bei GF: meist niedrig>
- **Reconciliation-Aufwand:** <Slice-Schätzung;
  Graduation-/Folge-Slice-Trigger>
