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

<!-- BEDIENHINWEIS: ein Satz, Liefer-Fokus, kein "wir machen aufraeumen". -->

Regeln dieser Sektion: Baseline-Regelwerk `modul-05-planning-harness.md`
§Ziel-Form: Slice — Schnitt nach Lieferwert, nicht nach Schichten; jeder Slice
ist einzeln lieferbar.

<…>

## 2. Definition of Done

<!-- BEDIENHINWEIS: je Zeile ein pruefbares Kriterium. -->

Regeln dieser Sektion: Baseline-Regelwerk `modul-05-planning-harness.md`
§Ziel-Form: Slice — **≤ 3 DoD-Punkte**; mehr heißt: der Slice ist zu groß und
gehört zurück zur Zerlegung.

- [ ] LH-FA-<NN> erfüllt, Test referenziert.
- [ ] LH-QA-<NN> erfüllt, Messung dokumentiert.
- [ ] `make gates` grün.
- [ ] Doku-Update für <Schnittstelle X> falls öffentlicher Vertrag berührt.
- [ ] Closure-Notiz mit Steering-Loop-Lerneintrag.
- [ ] Beobachtungs-Register (`../observations.md`) fortgeschrieben — neue `BEO-<NNN>` oder Zähler +1 mit Beleg; keine Beobachtung angefallen ist ebenfalls eine Antwort und wird in §7 notiert.
- [ ] Jedes Risiko aus §6 trägt einen Ausgang (eingetreten / entfallen / weiter offen).
- [ ] **Nur in einem Repo ohne Wellen-Betrieb:** die drei Paarungen (Anker · Folge-Slice · Register) geprüft. Dieses Item liegt als einziges **hinter** dem `git mv` — die Paarungen suchen in `done/`. Schneidet dein Repo Wellen, prüft sie die nächste Welle-Closure, auch für Slices ohne Wellen-Zugehörigkeit.

## 3. Plan (vor Code)

<!-- BEDIENHINWEIS: Datei- oder Komponenten-Ebene reicht; der
Implementation-Agent erweitert die Liste in seinem ersten Lauf. -->

Regeln dieser Sektion: Baseline-Regelwerk `grundlagen-konventionen.md`
§Was ist eine Sub-Area? — diese Liste ist die Pfad-Kandidatenliste für §8:
welche Sub-Areas der Slice **berührt**, liest sich hier ab.

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| <…> | neu / update / refactor | <…> |

## 4. Trigger

<!-- BEDIENHINWEIS: Beispiele — "Wenn Welle X done." / "Wenn Carveout CO-NN
aufgeloest." -->

Regeln dieser Sektion: Baseline-Regelwerk `modul-05-planning-harness.md`
§Trigger je Lifecycle-Übergang und WIP-Limit.

**Start** (`next` → `in-progress`): <…>

**Rückführungen — vorab benennen, nicht erst im Nachhinein begründen:**

- `in-progress` → `next` (zu groß, zurück zur Zerlegung): <Bedingung>
- `in-progress` → `open` (blockiert — Carveout?): <Bedingung>

## 5. Closure-Trigger

<!-- BEDIENHINWEIS: z.B. "DoD vollstaendig + PR gemerged + Closure-Notiz
geschrieben." -->

Regeln dieser Sektion: Baseline-Regelwerk `modul-05-planning-harness.md`
§Closure- und Lerneintrag-Regeln — zwei beobachtbare Kriterien **und** ein
Lerneintrag; ohne ihn ist der Slice nur abgelegt.

<…>

## 6. Risiken und offene Punkte

<!-- BEDIENHINWEIS: Was koennte schief gehen? Welche Carveouts entstehen
ggf.? Die drei Ausgaenge stehen als Form in der Zeile darunter. -->

Regeln dieser Sektion: Baseline-Regelwerk `modul-05-planning-harness.md`
§Offene Risiken werden bei Closure aufgelöst — **jedes** Risiko bekommt genau
**einen** Ausgang, und kein Slice geht nach `done/`, während eines ohne Ausgang
dasteht.

- <Risiko> — **Ausgang:** <eingetreten: CO-NNN / slice-NNN | entfallen: Grund | weiter offen: → BEO-NNN im Register>

## 7. Closure-Notiz

<!-- BEDIENHINWEIS — keine Norm; faellt beim Kopieren weg (README.md
§Verwendung, Schritt 5) und darf deshalb nichts Tragendes halten. Reihenfolge:
diese Sektion vor dem `git mv` nach done/ fuellen — einzige Ausnahme ist das
letzte DoD-Item in §2. -->

Regeln dieser Sektion: Baseline-Regelwerk `modul-06-roadmap.md`
§Das Beobachtungs-Register (vorhandene `BEO-<NNN>` **zitieren** statt neu
formulieren — sonst zählt das Register zwei Namen getrennt) ·
`grundlagen-konventionen.md` §Herkunfts-Anker für Steering-Loop-Regeln (das
Feld `liegt in` steht **nur**, wenn mit diesem Slice wirklich etwas verkörpert
wurde; Feld und Zielort auf **einer** Zeile, Sektionsangabe innerhalb der
Backticks).

- **Was hat funktioniert:** <…>
- **Was ging anders als geplant:** <…>
- **Steering-Loop-Eintrag:** <Guide oder Sensor> <geschärft/ergänzt>: <was genau>
  — liegt in `<AGENTS.md §X | Makefile:<target> | .harness/skills/…>`.
  Auslöser: `BEO-<NNN>` (<slice-NNN>, <slice-MMM>, <slice-KKK> — 3×).
  *(Wurde mit diesem Slice nichts verkörpert — der Normalfall —, entfällt die
  Teil-Zeile `— liegt in …` ersatzlos. Der Eintrag ist dann gezählt, nicht
  verkörpert.)*
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
Regeln dieser Sektion: Baseline-Regelwerk `modul-05-planning-harness.md`
§Ziel-Form: Sub-Area-Modus-Begründung — dort die vier Pflichtkriterien
(Konventionen-Dichte · Phase-Reife · Evidenz-/Diskrepanz-Risiko ·
Reconciliation-Aufwand), vier und nicht mehr.

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
