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

Das letzte Item liegt bewusst HINTER dem `git mv` — es prueft, was erst in
`done/` sichtbar ist. Alle uebrigen sind vorher zu erfuellen.
-->

- [ ] LH-FA-<NN> erfüllt, Test referenziert.
- [ ] LH-QA-<NN> erfüllt, Messung dokumentiert.
- [ ] `make gates` grün.
- [ ] Doku-Update für <Schnittstelle X> falls öffentlicher Vertrag berührt.
- [ ] Closure-Notiz mit Steering-Loop-Lerneintrag.
- [ ] Beobachtungs-Register (`../observations.md`) fortgeschrieben — neue `BEO-<NNN>` oder Zähler +1 mit Beleg; keine Beobachtung angefallen ist ebenfalls eine Antwort und wird in §7 notiert.
- [ ] Jedes Risiko aus §6 trägt einen Ausgang (eingetreten / entfallen / weiter offen).
- [ ] Ohne laufende Welle: die drei Paarungen (Anker · Folge-Slice · Register) geprüft — **nach** dem `git mv` nach `done/`, weil sie dort suchen. Gehört der Slice zu einer Welle, prüft sie deren Closure.

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
BEGRUENDUNG — die verbindliche FORM steht im Rumpf darunter, nicht hier.
Dieser Kommentar wird beim Kopieren entfernt (README.md §Verwendung,
Schritt 5); alles, was den Adopter ueberleben muss, gehoert deshalb in die
Zeilen unter diesem Block oder ins Baseline-Regelwerk.

- Das Pflichtfeld `liegt in` ist der EINZIGE Ausloeser der Anker-Paarung, und
  es loest nur INNERHALB dieser Sektion aus. Eine blosse Erwaehnung eines
  Pfades im Fliesstext loest nichts aus — und der Trigger-Sprachgebrauch
  "SL-024 liegt in `done/`" (Modul 6) ebenfalls nicht, er steht nicht hier.
  Deshalb traegt die Folge-Slice-Zeile bewusst NICHT `liegt in`.
- Warum "keine Beobachtung" eine Antwort ist: Eine erfundene BEO-<NNN>
  verduennt den Zaehler mit Rauschen und kann nie ein zweites Mal auftreten.
  Eine benannte Spec-Luecke ist KEINE Ausnahme davon — sie durchlaeuft das
  Register wie die anderen zwei Lerneintrags-Klassen und traegt eine
  BEO-<NNN>; sie unterscheidet sich nur darin, WO sie verkoerpert wird
  (Lastenheft-Version / Folge-ADR statt Pfad), und traegt deshalb kein
  `liegt in`.
- Warum die drei Paarungen NACH dem `git mv` geprueft werden: Sie suchen in
  `done/`. Wer sie beim Schreiben dieser Sektion prueft, prueft eine Datei,
  die noch in `in-progress/` liegt — der Sensor laeuft dann gruen, weil er
  nichts sieht.
- Finding-Klassen aus dem Review dieses Slice (Summary-Zeile des
  Review-Reports): welche gehen als Beobachtung weiter? Vorhandene BEO-<NNN>
  ZITIEREN statt neu formulieren — sonst zaehlt das Register zwei Namen
  getrennt.
- Steering Loop, kanonische Definition: [Baseline-Regelwerk §Steering Loop](../../../../regelwerk/grundlagen-klassifikation.md#steering-loop)
-->

**Regeln dieser Sektion:** Baseline-Regelwerk `modul-06-roadmap.md`
§Das Beobachtungs-Register (Modul 6) · `grundlagen-konventionen.md`
§Herkunfts-Anker für Steering-Loop-Regeln. Das Feld `liegt in` steht nur,
wenn die Regel **mit diesem Slice** verkörpert wurde (wellenlos, 3× erreicht);
sonst entfällt es und der Eintrag ist *gezählt, nicht verkörpert*. Das
Beobachtungs-Register wird bei **jeder** Closure fortgeschrieben — auch mit
der Antwort *keine Beobachtung*.

- **Was hat funktioniert:** <…>
- **Was ging anders als geplant:** <…>
- **Steering-Loop-Eintrag:** <Guide oder Sensor> <geschärft/ergänzt>: <was genau>
  — liegt in `<AGENTS.md §X | Makefile:<target> | .harness/skills/…>`.
  Auslöser: `BEO-<NNN>` (<slice-NNN>, <slice-MMM>, <slice-KKK> — 3×).
  <!-- Das Ziel traegt dann `(seit slice-<NNN>)`. Feld und Pfad stehen auf
       EINER Zeile, die Sektionsangabe INNERHALB der Backticks — ein
       zeilenweiser Sensor greift sonst nicht. -->
- **Beobachtungs-Register (`../observations.md`):** <neue `BEO-<NNN>` angelegt (Sub-Area, 1×, Beleg slice-NNN) | `BEO-<NNN>` auf <N>× erhöht, Beleg slice-NNN ergänzt | keine Beobachtung angefallen>
- **Folge-Slices:** <slice-NNN (<Titel>) — ist eine Datei in `open/`; genannt heißt angelegt>
- **Risiken aus §6:** <jedes mit genau einem Ausgang — siehe §6>
- **Drei Paarungen** (nur ohne laufende Welle; nach dem `git mv` nach `done/`): <Anker · Folge-Slice · Register — Ergebnis>

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

**Beide *Vorgelagert*-Blöcke hängen nicht am Modus** — sie gelten auch bei
reinem GF, wo diese Sektion sonst nur aus dem Hinweis oben besteht. Der
Sichtungs-Block ist in einem Repo **ohne Wellen-Betrieb** der einzige Leser
für alles, was unter der Schwelle steht: Die Wellen-Eröffnung Schritt 2, die
ihn sonst trägt, findet dann nicht statt. Fällt er weg, ist das Register
unterhalb von 3× write-only — genau der Zustand, gegen den es gebaut wurde
(Baseline-Regelwerk `modul-06-roadmap.md` §Das Beobachtungs-Register).

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
