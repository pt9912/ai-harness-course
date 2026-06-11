# Lösung — Modul 8: Agentenrollen

Zugehöriges Modul: [Modul 8 — Agentenrollen](../03-agenten/modul-08-agentenrollen.md).

## Selbstcheck-Antworten

### (Erinnern) Nenne die sechs Rollen in Reihenfolge

Planner → Architect → Implementation → Reviewer → Verifier → Validator.

Wichtig: Rollen-Trennung ist *Kontext-Trennung*, nicht Personen-Trennung.
Eine Person kann mehrere Rollen spielen — aber nicht im selben
Kontextfenster, sonst wiederholen sich die blinden Flecken. Wer
implementiert hat, soll nicht im selben Lauf reviewen; wer ADRs schreibt,
soll nicht im selben Lauf verifizieren.

### (Erinnern) Welches Übergabe-Artefakt gehört zu jeder der neun Übergaben?

Neun Übergaben in der Rollen-Sequenz, jede mit ihrem Artefakt (siehe
Sequenzdiagramm in
[Modul 8](../03-agenten/modul-08-agentenrollen.md#rollen-sequenz-für-einen-slice)):

1. **Planner → Architect:** Slice-Plan mit `LH-*`-Bezug
2. **Architect → Planner:** ADR-Bezug bestätigt oder Folge-ADR
3. **Planner → Implementation:** Slice in `in-progress/`
4. **Implementation → Reviewer:** PR mit Diff + Plan-Verweis
5. **Reviewer → Implementation:** Findings HIGH/MEDIUM/LOW/INFO
6. **Implementation → Verifier:** DoD-Bestätigung + Sensor-Belege
   (Übergabe erst *nach* Review-Schluss — so beschriftet das
   Sequenzdiagramm diesen Pfeil)
7. **Verifier → Planner:** DoD-/ADR-Konformitätsbericht +
   Plan-vs-Code-Diff
8. **Verifier → Validator:** Build-Artefakt + Slice-Resultat
9. **Validator → Planner:** Validierungsbeleg gegen realen Bedarf

Pointe: ohne *jedes* dieser Artefakte gibt es keinen Rollenwechsel — nur
einen Kontext-Switch ohne Übergabe. Ein Rollen-Sprung ohne Artefakt ist
der häufigste Pfad zu blinden Flecken.

### (Analysieren — aktiviert LZ 4) Warum braucht es Verification *und* Validation?

Sie prüfen unterschiedliche Fragen:

- **Verification** ("Bauen wir es richtig?" — Original: "built the thing right", Boehm 1981): *Wurde das umgesetzt, was geplant war?* Vergleich von Code gegen Plan/ADR/Spec.
- **Validation** ("Bauen wir das Richtige?" — Original: "built the right thing", Boehm 1981): *Trifft das Ergebnis den realen Bedarf?* Vergleich von Spec/Plan gegen das, was Benutzer/Markt/Realität tatsächlich brauchen.

Verifikation kann komplett grün sein und Validierung trotzdem rot —
das ist der gefährlichste Fall: das Team baut perfekt das Falsche.
Umgekehrt: Validierung grün und Verifikation rot bedeutet, dass der
Lieferprozess Spec/Plan ignoriert hat, auch wenn das Ergebnis zufällig
passt — auch das ist Drift, weil reproduzierbar wird das nicht
gelingen.

### Welche Rolle besitzt ein ADR — wer darf es ändern?

**Der Architect-Agent** schlägt ADRs vor und schreibt sie. Akzeptiert
werden sie nach Review durch den **Reviewer-Agent** (für interne
Konsistenz) und gegen das Lastenheft (für vertragliche
Verträglichkeit).

*Niemand* schreibt eine Accepted-ADR um — auch nicht der Architect.
Korrekturen entstehen als neue ADR mit `supersedes ADR-N` (siehe
[Hard Rule aus c-hsm-doc](../grundlagen/fallstudien.md) und
[Lösung Modul 4](modul-04-loesung.md)).

Der Implementation-Agent *liest* ADRs als Constraint und darf sie
nicht ignorieren — er darf höchstens eine Folge-ADR vorschlagen, wenn
er die Entscheidung im Implementierungs-Detail nicht halten kann.

### (Analysieren) Welche Rolle bearbeitet (a) Folge-ADR-Vorschlag, (b) DoD-Verletzung, (c) Replay-Set-Update?

- **(a) Folge-ADR-Vorschlag:** Der *Implementer* schlägt vor (er stößt
  im Detail auf die Grenze der Entscheidung), der *Architect*
  entscheidet (er hütet die ADR-Kette und das `supersedes`-Feld), der
  *Reviewer* prüft anschließend auf Konsistenz mit den bestehenden
  ADRs. Drei Rollen, drei Eingabe-Kontexte — keine davon ersetzbar.
- **(b) DoD-Verletzung:** Der *Verifier* erkennt sie (sein Kontext ist
  DoD/Spec, nicht der Code-Entstehungsweg), der *Planner* entscheidet
  über die Konsequenz: Plan-Update, Slice-Rückführung nach
  `in-progress/` oder Folge-Slice.
- **(c) Replay-Set-Update:** Der *Validator* pflegt das Golden Set
  (sein Kontext ist der reale Bedarf — er weiß, welche Fälle die
  Realität abbilden), der *Verifier* nutzt es als Sensor.

Sinnvolle Mehrfachzuweisung mit Begründung: genau (c). Validator und
Verifier müssen *beide* auf das Replay-Set schauen, aber mit
unterschiedlichem Eingabe-Kontext — der Validator fragt *"bildet das
Set die Realität ab?"*, der Verifier fragt *"besteht der Code das
Set?"*. Würde eine Rolle beides tun, prüfte derselbe Kontext seine
eigene Fallauswahl — exakt der blinde Fleck, gegen den die
Rollen-Trennung gebaut ist. Mehrfachzuweisung ist nur dann sauber,
wenn jede beteiligte Rolle einen *anderen* Eingabe-Kontext hat; sonst
ist es doppelte Arbeit mit geteilten blinden Flecken.

### (Bewerten) Konfliktfall: Wer entscheidet, in welcher Reihenfolge, mit welchem Übergabe-Artefakt?

Der **Architect** entscheidet — aber in einer festen Reihenfolge:
*zuerst* die ADR-Aktualität prüfen (gilt ADR-0001 noch, oder gibt es
eine Lockerung mit ID?), *dann* den Code. Wer die Reihenfolge
umdreht, belohnt "schnell widersprechen": der Implementer könnte
jeden HIGH mit einer vagen Lockerungs-Behauptung aufschieben.

Das Übergabe-Artefakt der Entscheidung ist eines von zweien:

- **Folge-ADR mit `supersedes`** — wenn die Lockerung legitim ist,
  aber nie dokumentiert wurde; oder
- **bestätigter HIGH mit Begründungs-Verweis** — wenn die ADR
  unverändert gilt und der Code korrigiert werden muss.

*Nicht* zulässig: das Finding herabstufen, weil der Implementer
widerspricht. Das wäre der vierte, falsche Pfad — er existiert nur
dort, wo Übergabe-Artefakte fehlen. Tritt derselbe Konflikt-Typ
dreimal auf, ist das ein Steering-Loop-Signal: die ADR-Verteilung an
die Implementer hat eine Lücke (Schritt 2 des 8-Schritt-Workflows
verschärfen). Die ausgearbeitete Sequenz steht unten in der
Übung *(Bewerten — aktiviert LZ 3)*.

## Übungshinweise

### (Analysieren — aktiviert LZ 1) Ordne die 10 typischen Tätigkeiten den sechs Rollen zu

Beispielsortierung (Nummerierung wie im Modul):

| # | Tätigkeit | Rolle |
|---|---|---|
| 1 | "Prüfe, ob der PR die ADR-7-Schichtung einhält" | Reviewer |
| 2 | "Schneide das Feature in drei Slices" | Planner |
| 3 | "Aktualisiere AGENTS.md mit einer neuen Hard Rule" | Architect (ADR-Folge) + Planner (Slice) |
| 4 | "Prüfe, ob alle Akzeptanzkriterien aus LH-FA-3 erfüllt sind" | Verifier |
| 5 | "Schreibe den Adapter für PostgreSQL" | Implementation |
| 6 | "Entscheide, ob `coverage-gate` 70 % oder 80 % verlangt" | Architect (ADR) + Planner (Slice für Schwelle) |
| 7 | "Prüfe, ob das Feature das Benutzerbedürfnis trifft" | Validator |
| 8 | "Schreibe einen Replay-Test gegen das Golden Set" | Implementation, im Auftrag des Verifiers |
| 9 | "Wähle zwischen REST und gRPC" | Architect |
| 10 | "Identifiziere, dass dieselbe Halluzination dreimal aufgetreten ist" | Planner (Steering-Loop-Eintrag) |

Begründung der Mehrfachzuweisungen (Maßstab des Moduls: zwei Rollen,
zwei *verschiedene* Eingabe-Kontexte):

- **#3 und #6 (Architect + Planner):** Der Architect entscheidet die
  Regel bzw. Schwelle (Kontext: ADR-Kette, Fitness-Functions), der
  Planner macht daraus einen Slice mit DoD (Kontext: Roadmap,
  Kapazität). Entscheidung und Einplanung sind zwei Sichten — wer
  beides in einem Kontext macht, plant Schwellen ohne ADR-Bezug oder
  beschließt ADRs ohne Umsetzungspfad.
- **#8 (Implementation + Verifier):** Der Implementer *schreibt* den
  Replay-Test (Kontext: Code), aber der Auftrag und das Golden Set
  kommen aus dem Verifier-Kontext (DoD/Spec). Würde der Implementer
  die Fälle selbst auswählen, prüfte er gegen seine eigene
  Interpretation.

Häufiger Fehler bei #4: "Reviewer macht das schon mit." → Reviewer
prüft gegen Plan/ADR (Maintainability), nicht gegen Akzeptanzkriterien
der Spec; Letzteres ist Verification.

### (Erschaffen — aktiviert LZ 2) Übergabe-Sequenz für einen zweiten Konflikttyp modellieren

Beispiel: *Der Verifier findet eine DoD-Lücke erst **nach** dem
Review-Schluss.* Maßstab: keine Kante ohne Übergabe-Artefakt. Eine
saubere Modellierung sieht so aus:

| Pfeil | Übergabe-Artefakt | Inhalt minimal |
|---|---|---|
| Verifier → Planner | DoD-Lücken-Befund | welches Akzeptanzkriterium aus der Spec ist *nicht* durch einen Test/Beleg gedeckt · `LH-*`-Bezug |
| Planner → Implementer | Re-Open-Slice oder Folge-Slice | Slice zurück nach `in-progress/` (Lücke im selben Slice) *oder* neuer Slice in `next/` (Scope-Erweiterung) |
| Implementer → Reviewer | Nachtrag-PR | Diff, der die Lücke schließt, mit Plan-Verweis |
| Reviewer → Verifier | erneuter Review-Schluss | Findings (oder Negativbefund) zum Nachtrag-PR |
| Verifier → Planner | Verifikationsbeleg | DoD jetzt vollständig gedeckt — oder erneuter Lücken-Befund |

Der Test, ob die Modellierung trägt: An *keiner* Kante steht "kurz
mündlich geklärt". Die zentrale Disziplin ist dieselbe wie im Worked
Example — der Befund des Verifiers darf den Review-Schluss **nicht**
überspringen (Implementer → Reviewer → Verifier, nicht Implementer →
Verifier direkt), sonst entsteht genau der blinde Fleck, gegen den die
Rollen-Trennung gebaut ist.

Häufiger Fehler: die DoD-Lücke wird still im selben Lauf "nachgebessert",
ohne Re-Open und ohne erneuten Review. Das ist Drift mit Kaffeepause —
der Slice gilt als `done/`, obwohl seine Kette gerissen ist.

### (Bewerten — aktiviert LZ 3) Konfliktfall: Reviewer lehnt ab, Implementer widerspricht

Eskalationspfad:

1. Reviewer benennt das Finding *kategorisiert* (HIGH/MEDIUM/LOW/INFO, siehe [Modul 10](../04-qualitaet/modul-10-review-harness.md)) und mit Bezug auf eine ADR-ID.
2. Implementer hat zwei Optionen: a) Befund umsetzen, b) Folge-ADR vorschlagen, die die ADR-Lücke schließt oder die alte ADR superseded.
3. Architect-Agent (oder Mensch in dieser Rolle) entscheidet zwischen den beiden Pfaden — und zwar *zuerst* über die ADR-Aktualität, dann über den Code.
4. **Niemand** entscheidet "Reviewer hat überreagiert, wir ignorieren". Das wäre ein Carveout — und Carveouts brauchen eigene Disziplin (siehe [Modul 7](../02-planung/modul-07-carveouts.md)).

Die drei sauberen Verdikte (die Übung verlangt *strukturierte*
Auflösung, nicht "der Strengere gewinnt"):

| Verdikt | Bedeutung | Übergabe-Artefakt |
|---|---|---|
| **bestätigt** | ADR gilt unverändert, der Code verstößt wirklich | bestätigter HIGH mit Begründungs-Verweis; Implementer korrigiert |
| **zurückgewiesen** | Reviewer hat gegen veralteten ADR-Stand geprüft | Folge-ADR mit `supersedes` (bzw. Verweis auf die dokumentierte Lockerung) + Skill-Patch für den Reviewer |
| **eskaliert** | weder ADR-Stand noch Lockerung sind belegbar (z. B. SL-024 behauptet etwas, das nirgends dokumentiert ist) | ADR-Aktualitäts-Anfrage an den Planner: Slice-Plan-Auszug vorlegen; danach fällt der Fall in eines der ersten beiden Verdikte |

Jedes Verdikt endet mit einem Artefakt, das der Reviewer in seine
Skill-Datei übernehmen kann — "mündliche Klärung" ist keine Übergabe,
sondern Drift mit Kaffeepause.

## Häufige Fehler

- **Eine Person spielt mehrere Rollen ohne Trennung.** Klassisch: Implementer reviewt sich selbst, weil "ich kenne den Code". Das ist genau die Klasse von Fehlern, gegen die der Harness gebaut ist.
- **Rollen werden technisch identisch gestartet** (gleicher Prompt, gleicher Kontext). → Sie wiederholen denselben Fehler. Rollen-Trennung heißt auch: *unterschiedlicher Eingabe-Kontext, unterschiedliche Skills*.
- **Validation wird "wir machen vor Release".** → Zu spät. Validation gehört zumindest *vor* die Implementation größerer Wellen (Spec-Validierung beim Kunden) und nach jedem MVP-Slice.

## Verweise

- Spec/ADR/Plan-Trennung: [`../grundlagen/konventionen.md#trennschärfen`](../grundlagen/konventionen.md#trennschärfen)
- Vorherige Lösung: [Modul 7](modul-07-loesung.md)
- Nächste Lösung: [Modul 9](modul-09-loesung.md)
