# Lösung — Modul 2: Harness-Bootstrap

Zugehöriges Modul: [Modul 2 — Harness-Bootstrap](../01-spec-und-architektur/modul-02-harness-bootstrap.md).

## Selbstcheck-Antworten

### (Verstehen, durch Übung 1) Was unterscheidet GF-Modus von BF-Modus? Warum gilt der Modus *pro Sub-Area* und nicht pro Repo?

- **GF (Greenfield):** Doku führt, Code folgt. Die Konvention wird
  *behauptet* (Spec, ADR, `harness/conventions.md`), bevor Code sie
  realisiert.
- **BF (Brownfield):** Code führt, Doku folgt. Die Konvention wird
  aus dem Bestand *inventarisiert*, Diskrepanzen werden klassifiziert
  und durch Reconciliation-Slices oder Carveouts aufgelöst.
- **Hybrid:** beide Richtungen aktiv (typisch beim Übergang).

Pro Sub-Area, weil derselbe Repo in unterschiedlichen Sub-Areas
unterschiedlich reif ist: Konventionen können längst GF sein
(`harness/conventions.md` existiert mit `MR-*`-IDs), während die
Spec-Schreibung noch BF ist (`spec/lastenheft.md` muss aus Tests
und Commit-Messages rückgebaut werden). Wer das Repo *als Ganzes*
klassifiziert, gibt entweder die GF-Sub-Areas auf ("ist alles BF")
oder kommentiert die BF-Sub-Areas falsch ("ist doch GF, also wer
hat das verbockt?").

Die vier Fallstudien-Repos in
[`../grundlagen/fallstudien.md` §Beobachtung aus dem Ist-Zustand](../grundlagen/fallstudien.md#beobachtung-aus-dem-ist-zustand)
sind explizites Beleg: alle vier sind in BF, aber mit *unterschiedlich
weit fortgeschrittener Sub-Area-Inventur*.

**Verortung gegen die vier Harness-Linsen:** Die dokumentierte
Modus-Entscheidung bedient *zuerst* die **Drift**-Linse — der
festgehaltene Modus pro Sub-Area ist der erste Drift-Sensor: ohne ihn
bleibt jede spätere GF→BF-Abweichung unmessbar. Direkt danach
**Reproduzierbarkeit** (ein zweiter Lauf trifft dieselbe Klassifikation)
und **Auditierbarkeit** (die Begründung jeder Folge-Entscheidung ist
explizit); **Steering-Loop**, weil Bootstrap die initiale
Steering-Loop-Anwendung ist. Exzellent ist die Antwort, die die
Reihenfolge begründet — Drift vor Auditierbarkeit, weil ein Sensor erst
*messen* muss, bevor eine Begründung *nachvollziehbar* wird.

### (Verstehen, Vorstufe für Übung 2) Welche vier Trigger-Klassen gibt es? Nenne pro Klasse ein Beispiel aus den Worked Examples.

Vier Klassen aus
[`../grundlagen/konventionen.md` §Vier Trigger-Klassen](../grundlagen/konventionen.md#vier-trigger-klassen):

1. **Sync-Trigger** — Pointer-Update zwischen Dokumenten.
   Beispiel: **T1** (Pointer in `harness/README.md` auf
   `conventions.md`, GF-WE Schritt 3).
2. **Promotion-Trigger** — Eintrag wandert aus dem "Nicht
   behauptet"-Block in die Haupt-Tabelle. Beispiel: **T4**
   (Sensors-Roster bei erstem Code-Slice, GF-WE Schritt 6).
3. **Cross-Reference-Trigger** — Verlinkung zwischen Dokumenten,
   normativ nur *aufwärts* (volatil→stabil). Beispiel: **T6** (ADR-0001
   verweist via `Schärft:` aufwärts auf `spec/architecture.md` — nicht
   die Sicht auf die ADR; GF-WE Schritt 8).
4. **Acceptance-Trigger** — Phase-Übergang via Sign-off.
   Beispiel: **T7** (ADR-Review-Auslöser für *Proposed* →
   *Accepted*, GF-WE Schritt 8).

Plus **T3** als BF-spezifische **Sync-Trigger-Variante** in BF-WE
Schritt 5/8: Eine Diskrepanz ist konzeptuell ein impliziter
Pointer-Mismatch zwischen Code-Realität und Doku-Behauptung. In
GF-Modus ist der Pointer freiwillig (man legt ihn an, wenn ein
neues Dokument referenziert werden soll); in BF-Modus wird der
Pointer als *Fehlen* sichtbar (die Inventur stellt fest, dass kein
Sync-Pointer existiert, obwohl Code-Verhalten und Doku auseinander­
fallen). Die vier Klassen aus `konventionen.md` bleiben damit
erschöpfend; T3 ist nicht eine fünfte Klasse, sondern eine
BF-typische Auslöse-Variante von Sync. Pointe für *exzellent*:
genau diese Auslöse-Variante erklärt, warum BF-Repos *mehr* Sync-
Trigger pro Welle produzieren als GF-Repos.

### (Analysieren, durch Übung 2) Welcher Trigger in WE2 macht den BF-Modus-Übergang sichtbar — und warum gerade dieser?

**T3 (Sync-Trigger in BF-Diskrepanz-Auslöse-Variante)** in Schritt 5
(Sensors-Lücken) und Schritt 8 (Diskrepanz-Schock). Begründung:

In den vorigen Schritten arbeitet die Inventur "stumm" — Templates
adoptieren, `conventions.md` mit `MR-*` füllen, Sensors aus Makefile
ableiten. Erst wenn die Inventur auf *Bestand trifft, der keinem
Anforderungs-Anker entspricht* (orphan code), oder *Anforderungen,
die keinen Code-Anker haben* (orphan requirement), wird die
Diskrepanz explizit. T3 ist die Stelle, an der der BF-Modus seine
Daseins-Berechtigung *vorzeigt*: ohne ihn wäre die Inventur ein
Selbstzweck, mit ihm wird der Reconciliation-Pfad sichtbar.

**Pointe für *exzellent*-Stufe:** T3 ist nicht nur der Trigger,
sondern der Wendepunkt im BF-Lebenszyklus. Phase 4 in BF heißt
"Inventur abgeglichen, Diskrepanz-Schock sichtbar" — vorher arbeitet
die Inventur, nachher läuft Reconciliation. Wer T3 als ersten
Drift-Sensor im eigenen Repo erkennt, hat den Bootstrap-Begriff von
"Setup-Event" zu "fortlaufender Modus" verinnerlicht.

### (Erschaffen, durch Übung 3) Was bedeutet *Phase 4 kohärent* in GF vs. BF?

Aus der Phase × Modus-Matrix:

- **GF Phase 4:** *"Vertrag steht, Code wird daran gemessen."*
  Konkretes Indiz: CI-Gates greifen, weil die Spec scharf genug
  ist, um Verstöße automatisch zu erkennen (z. B.
  `make verify-lh-coverage` zählt LH-IDs gegen Tests und failt bei
  unter-deckten Anforderungen).
- **BF Phase 4:** *"Inventur abgeglichen, Diskrepanz-Schock
  sichtbar."* Konkretes Indiz: `CO-DS-*`-Backlog ist gefüllt
  (orphan code als dokumentierte Carveouts) und Reconciliation-
  Slices stehen in `docs/plan/planning/open/`. Der "Schock" ist
  paradoxerweise positiv: er bedeutet, dass die Inventur fertig
  ist und die Reconciliation-Arbeit *anfangen* kann.

**Pointe für *exzellent*-Stufe:** Phase 4 ist in BF die kritische
Stufe — vorher arbeitet die Inventur unsichtbar, nachher beginnt
die Reconciliation-Arbeit. Wer in Phase 3 stehen bleibt, hat den
Diskrepanz-Schock vermieden und damit auch die Reconciliation-
Pflicht — das Repo bleibt formal vollständig, ist aber inhaltlich
nicht abgeglichen.

### (Conceptual Change) Vergleiche deine Spontanantworten mit deiner heutigen Antwort.

Diese Frage hat keine universelle Lösung — die Antwort hängt von
*deiner* Vorab-Notiz ab. Was eine *solide* Selbsteinschätzung
auszeichnet:

- *Konkrete Benennung*: welche §Vorab-Frage hat sich verschoben?
  Welcher Halbsatz ist neu?
- *Fehlvorstellungs-Bezug*: welche der vier dokumentierten FVs hat
  deine Spontanantwort getragen (FV1 "einmaliges Setup", FV2
  "Repo-Eigenschaft", FV3 "GF braucht keine Trigger", FV4 "BF als
  Notlage")?
- *Was ist gleich geblieben*: welche Vorstellung hält weiterhin —
  und warum? Conceptual-Change-Reflexion ist nur dann sauber,
  wenn beides gezeigt wird (Verschiebung + Stabilität).

Häufiger Fehler in der Selbstbewertung: "Alles ist klarer." ist
keine Conceptual-Change-Antwort, sondern ein generisches
Wohlfühl-Statement.

## Übungshinweise

### Übung 1 — Modus pro Sub-Area klassifizieren

**Maßstab für *solide*:**

- Mindestens drei Sub-Areas befüllt, mit konkretem Beobachtungs-
  Indiz pro Zeile (kein "ist halt GF" ohne Begründung).
- Mindestens eine Sub-Area klassifiziert, die du *anders*
  klassifizierst, als deine Kapur-Vorab-Übung vermutet hat.
  Wenn beide Klassifikationen 1:1 übereinstimmen, hast du
  oberflächlich gearbeitet — oft, weil das Beobachtungs-Indiz aus
  der Vorab-Übung ungeprüft übernommen wurde.
- Pro Sub-Area mindestens *eine* der drei Inklusions-Achsen
  (Konventions-Härte / Inventur-Linie / Pfad-Cluster) als
  Granularitäts-Begründung notiert — spiegelt die Selbstcheck-Rubrik und
  prüft *beide* Granularitäts-Pole: die Sub-Area ist weder zu grob
  (Negativ-Fall *"Backend"*) noch zu fein (eine Struktur mit nur *einer*
  erfüllbaren Achse als Sub-Area geführt statt als Aspirantin — Schwelle
  ≥ 2) — beide Fälle in §Häufige Fehler. *Exzellent:* alle drei Achsen
  pro Sub-Area benennbar, oder eine Aspirantin korrekt als
  Nicht-Sub-Area erkannt.

**Falle:** "Alle Sub-Areas sind BF" ist zwar empirisch häufig
korrekt (siehe Fallstudien), aber pädagogisch verdächtig — selbst
in einem BF-Repo sind manche Sub-Areas reifer (z. B. ist die
Test-Infrastruktur oft GF, wenn der Code TDD-getrieben entstand).
Wer pauschal "alles BF" antwortet, hat die Sub-Area-Differenzierung
nicht ausgereizt.

**Pointe für *exzellent*:** explizite Hybrid-Klassifikation für
mindestens eine Sub-Area, mit Begründung *warum gerade hier* die
Mischung zustande kommt (z. B. "neue Module sind GF, Legacy-Module
sind BF — Hybrid in der Sub-Area *Konventionen*").

### Übung 2 — Trigger-Klassen zuordnen

**Maßstab für *solide*:**

- Fünf Trigger benannt, jeder einer der vier Klassen zugeordnet.
- Pro Zeile eine kurze Begründung, die auf das *Trigger-Merkmal*
  zeigt (z. B. "T6 = Cross-Reference, weil eine neue ADR normativ in
  den Artefakt-Graphen eingehängt wird (ADR → Spec/LH, aufwärts) — ein
  bloßer Pointer-Abgleich wäre ein Sync-Trigger").

**Typische Fehler:**

- T4 als Sync-Trigger einordnen — Promotion-Trigger geht *über*
  Sync hinaus, weil der Eintrag den Status-Block wechselt, nicht
  nur den Pointer.
- T6 und T7 zusammenwerfen — T6 ist Cross-Reference (statische
  Verlinkung), T7 ist Review/Acceptance (Phase-Übergang). Beide
  können am selben ADR-Artefakt auftreten, sind aber unterschiedliche
  Trigger.

**Pointe für *exzellent*:** Erschöpfungs-Argument — was würde
*nicht* in eine der vier Klassen passen? (Antwort: kaum etwas
Klassifikatorisches; die vier Klassen decken Pointer, Promotion,
Cross-Reference und Phase-Übergang ab — vier funktional disjunkte
Trigger-Modi.)

### Übung 3 — Phasen-Karte ausfüllen

**Maßstab für *solide*:**

- Mindestens drei Sektionen vollständig ausgefüllt mit Phase, Begründung
  und nächstem Modus-/Trigger-Anker.
- Mindestens eine Sektion in einer anderen Phase als die übrigen
  (Heterogenität sichtbar gemacht).

**Falle "alle Phasen sind gleich":** Wenn deine Phasen-Karte alle
Sektionen auf derselben Phase zeigt, hast du die Phasen-Begründung
zu grob gewählt. Sektionsweise Reife ist der Punkt — wenn alle
Sektionen auf 3 stehen, schaust du nicht genau genug hin. Ein
Artefakt, das durchgehend Phase 4 trägt, ist *fertig* (nicht mehr
in Bootstrap).

**Pointe für *exzellent*:** mindestens eine Sektion in einer
*niedrigeren* Phase als die Standard-Annahme (z. B. §Source
Precedence ist nicht durchverbunden, weil der zweite Konfliktfall
fehlt — Phase 2 statt erwarteter Phase 4). Erweiterte Pointe: eine
Sektion mit **Phase 0** tragen (*"Datei existiert nicht — sollte
aber"*) ist die häufigste übersehene Reife. Phase 0 zu nennen,
ohne ihn als Versagen zu interpretieren, zeigt, dass du die
Phase-Reife aus konkretem Verbundenheits-Kriterium ableitest, nicht
aus Selbstbild.

## Häufige Fehler

Diese Liste benennt Fehler in der *Ausführung* der Übungen; die
zugrunde liegenden konzeptuellen Fehlvorstellungen stehen in
Modul 2 §Typische Fehlvorstellungen (FV1–FV5) und werden hier nicht
wiederholt.

- **Sub-Area zu grob gewählt** (Übung 1). "Backend" oder "Frontend"
  als Sub-Area klassifizieren ist meistens zu grob — die
  Modus-Diagnose bleibt nutzlos, weil jede grobe Sub-Area in
  Wirklichkeit mehrere kleinere mit unterschiedlichen Modi
  zusammenfasst. Korrekt: Sub-Areas auf Konventionen, Spec-Schreibung,
  Architektur, Test-Infrastruktur, Build/CI etc. ausdifferenzieren.
  Der abstrakte Maßstab dahinter: Backend/Frontend verletzen Achse 1
  (keine *einzelne* `MR-NNN`-Adaption denkbar) und Achse 3 (mehrere
  Pfad-Familien) der drei Inklusions-Achsen aus
  [`../grundlagen/konventionen.md` §Was ist eine Sub-Area?](../grundlagen/konventionen.md#was-ist-eine-sub-area)
  — die Achsen erlauben die Diagnose *ohne* Erinnerung an die
  Beispielliste, ergänzen sie also.
- **Sub-Area zu fein gewählt** (Übung 1, Kehrseite). Ein substanzloses
  Verzeichnis zur Sub-Area erheben — *"Struktur ohne Substanz"*: ein
  Ordner existiert (Achse 3), trägt aber keine eigene Konvention (Achse 1)
  und keine eigenständig abgleichbare Inventur-Linie (Achse 2), erfüllt
  also nur *eine* der drei Achsen (unter der Schwelle von zwei). Das ist
  noch keine Sub-Area, sondern eine *Sub-Area-Aspirantin* (siehe
  [`../grundlagen/konventionen.md` §Was ist eine Sub-Area?](../grundlagen/konventionen.md#was-ist-eine-sub-area)).
  Symptom: eine Modus-Zeile, die nie einen eigenen Trigger oder eine
  eigene `MR-NNN` erzeugt — sie hängt immer an einer Nachbar-Sub-Area.
  Korrekt: erst ab zwei erfüllten Achsen als Sub-Area führen, darunter
  als Aspirantin notieren statt klassifizieren. Gemeinsame Wurzel mit
  *"zu grob"* oben: beide überspringen die Achsen-Qualifikation
  (Modul 2 §Typische Fehlvorstellungen FV5) — das eine Ende fasst zu viel
  zusammen, das andere erhebt zu wenig.
- **Hybrid als Notausgang** (Übung 1). Wer in jeder Zeile "Hybrid"
  schreibt, hat *nicht* differenziert, sondern die Entscheidung
  vermieden. Hybrid ist eine *Beobachtung* (Sub-Sub-Area-
  Heterogenität), keine Default-Antwort bei Unsicherheit. Bei einem
  Hybrid-Eintrag zusätzlich verlangen: welche Sub-Sub-Areas sind GF,
  welche BF?
- **Trigger-Zuordnung ohne Begründungs-Argument** (Übung 2). T1 =
  Sync ohne Erklärung "warum nicht Cross-Reference" macht die
  Klassifikation unprüfbar. Maßstab für *solide*: pro Zeile ein
  Argument, das das Trigger-Merkmal benennt (Pointer vs. Promotion
  vs. normative Aufwärts-Verlinkung (ADR→Spec) vs. Phase-Übergang).
- **Phasen-Karte ohne Heterogenität** (Übung 3). Zwei Symptome:
  (a) alle Sektionen auf einer oder zwei Stufen (typisch: alle auf
  Phase 3 oder 4) — die Heterogenität verfehlt, die das Lehr-Ergebnis
  trägt; (b) Phase 0 systematisch ausgeklammert — *"Datei existiert
  nicht"* als legitime Reife übersehen, obwohl gerade in BF-Sub-Areas
  mit Inventur-Auftrag ein gültiger Befund. Saubere Karten zeigen
  meist drei bis fünf der sechs Stufen *inklusive* Phase 0 als
  möglichen Wert.
- **Überzeugungs-Check vergessen am Modul-Ende.** Wer §Vorab vor der
  Lehre nicht notiert hat, kann am Modul-Ende keine Verschiebung
  benennen. Konsequenz: Selbstcheck-Frage 5 wird inhaltsleer.

## Weiterführende Verweise

- Konzept-Anker und Definitionen:
  [`../grundlagen/konventionen.md` §Harness-Bootstrap](../grundlagen/konventionen.md#harness-bootstrap).
- Vier Trigger-Klassen mit abstrakten Definitionen:
  [`../grundlagen/konventionen.md` §Vier Trigger-Klassen](../grundlagen/konventionen.md#vier-trigger-klassen).
- Fallstudien in GF/BF-Klassifikation:
  [`../grundlagen/fallstudien.md` §Beobachtung aus dem Ist-Zustand](../grundlagen/fallstudien.md#beobachtung-aus-dem-ist-zustand).
- Lernervorstellungen für Conceptual-Change-Reflexion:
  [`../grundlagen/lernervorstellungen.md`](../grundlagen/lernervorstellungen.md).
- Modus-*Wahl* als Folge-Übung (Diagnose aus Modul 2 →
  Begründungs-Pflicht pro Sub-Area im nächsten Slice-Plan):
  [Modul 5 §Worked Mini-Example "Bootstrap-Modus pro Sub-Area für einen Slice begründen"](../02-planung/modul-05-planning-harness.md#worked-mini-example-bootstrap-modus-pro-sub-area-für-einen-slice-begründen)
  mit zugehöriger Übung in §Übungen.

- Vorherige Lösung: [Modul 1](modul-01-loesung.md)
- Nächste Lösung: [Modul 3](modul-03-loesung.md)
