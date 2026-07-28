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
- [ ] **Nur in einem Repo ohne Wellen-Betrieb:** die drei Paarungen (Anker · Folge-Slice · Register) geprüft. Dieses Item liegt als einziges **hinter** dem `git mv` — die Paarungen suchen in `done/`. Schneidet dein Repo Wellen, prüft sie die nächste Welle-Closure, auch für Slices ohne Wellen-Zugehörigkeit.

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

## 7. Closure-Notiz

<!--
BEDIENHINWEIS — keine Norm. Die Norm steht im Baseline-Regelwerk, der Zeiger
darauf im Rumpf darunter; dieser Kommentar wird beim Kopieren entfernt
(README.md §Verwendung, Schritt 5) und darf deshalb nichts Tragendes halten.

- REIHENFOLGE: Diese Sektion vor dem `git mv` nach done/ fuellen. Einzige
  Ausnahme ist das letzte DoD-Item in §2 — die drei Paarungen suchen in
  `done/` und werden danach geprueft.
- Die Feld-Zeile `liegt in` nur setzen, wenn mit diesem Slice wirklich etwas
  verkoerpert wurde; sonst die Zeile streichen. Feld und Zielort stehen auf
  EINER Zeile, die Sektionsangabe INNERHALB der Backticks — ein zeilenweiser
  Sensor greift sonst nicht.
- Beim Beobachtungs-Register vorhandene BEO-<NNN> ZITIEREN statt neu
  formulieren — sonst zaehlt das Register zwei Namen getrennt. Das gilt auch
  fuer Finding-Klassen aus dem Review dieses Slice (Summary-Zeile des
  Review-Reports).
-->

Regeln dieser Sektion: Baseline-Regelwerk `modul-06-roadmap.md`
§Das Beobachtungs-Register · `grundlagen-konventionen.md`
§Herkunfts-Anker für Steering-Loop-Regeln.

- **Was hat funktioniert:** <…>
- **Was ging anders als geplant:** <…>
- **Steering-Loop-Eintrag:** <Guide oder Sensor> <geschärft/ergänzt>: <was genau>
  — liegt in `<AGENTS.md §X | Makefile:<target> | .harness/skills/…>`.
  Auslöser: `BEO-<NNN>` (<slice-NNN>, <slice-MMM>, <slice-KKK> — 3×).
- **Beobachtungs-Register (`../observations.md`):** <neue `BEO-<NNN>` angelegt (Sub-Area, 1×, Beleg slice-NNN) | `BEO-<NNN>` auf <N>× erhöht, Beleg slice-NNN ergänzt | keine Beobachtung angefallen>
- **Folge-Slices:** <slice-NNN (<Titel>) — ist eine Datei in `open/`>
- **Risiken aus §6:** <jedes mit genau einem Ausgang — siehe §6>
- **Drei Paarungen:** <nur im Repo ohne Wellen-Betrieb — Anker · Folge-Slice · Register, Ergebnis>

## 8. Sub-Area-Modus-Begründung

**Status:** Diese Sektion steht in **jedem** Slice-Plan — was variiert, ist
ihr Umfang. Die beiden *Vorgelagert*-Blöcke unten sind immer auszufüllen, auch
bei reinem Refactor; der **Modus-Begründungsblock** danach ist Pflicht bei
mindestens einer berührten Sub-Area in BF oder Hybrid. Bei reinem GF genügt
dafür der Hinweis *"alle berührten Sub-Areas GF (siehe Baseline-Regelwerk
`modul-05-planning-harness.md` §Ziel-Form: Sub-Area-Modus-Begründung)"*; bei
reinem Refactor ohne neue Sub-Area-Berührung entfällt er ganz.
Die vier Pflichtkriterien (Konventionen-Dichte ·
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

Beide *Vorgelagert*-Blöcke hängen weder am Modus noch am Slice-Typ: In einem
Repo **ohne Wellen-Betrieb** ist der Sichtungs-Block der einzige Leser für
alles, was unter der Schwelle steht (Baseline-Regelwerk `modul-06-roadmap.md`
§Das Beobachtungs-Register).

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
