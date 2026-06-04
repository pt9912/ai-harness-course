# Lösung — Modul 7: Agentenrollen

Zugehöriges Modul: [Modul 7 — Agentenrollen](../03-agenten/modul-07-agentenrollen.md).

## Selbstcheck-Antworten

### (Erinnern) Nenne die sechs Rollen in Reihenfolge

Planner → Architect → Implementation → Reviewer → Verifier → Validator.

Die Übergaben tragen jeweils ein Artefakt — siehe Sequenzdiagramm in
[Modul 7](../03-agenten/modul-07-agentenrollen.md#rollen-sequenz-für-einen-slice):
Slice-Plan (P → A), ADR-Bezüge (A → P), Slice in `in-progress/` (P → I),
PR mit Diff + Plan-Verweis (I → R), Findings (R → I), Verifikationsbeleg
(Vf → P), Validierungsbeleg (Vl → P).

Wichtig: Rollen-Trennung ist *Kontext-Trennung*, nicht Personen-Trennung.
Eine Person kann mehrere Rollen spielen — aber nicht im selben
Kontextfenster, sonst wiederholen sich die blinden Flecken. Wer
implementiert hat, soll nicht im selben Lauf reviewen; wer ADRs schreibt,
soll nicht im selben Lauf verifizieren.

### Warum braucht es Verification *und* Validation?

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
[Lösung Modul 3](modul-03-loesung.md)).

Der Implementation-Agent *liest* ADRs als Constraint und darf sie
nicht ignorieren — er darf höchstens eine Folge-ADR vorschlagen, wenn
er die Entscheidung im Implementierungs-Detail nicht halten kann.

## Übungshinweise

### Ordne 10 typische Tätigkeiten den Rollen zu

Beispielsortierung:

| Tätigkeit | Rolle |
|---|---|
| "Schneide das Feature in drei Slices" | Planner |
| "Wähle zwischen REST und gRPC" | Architect |
| "Schreibe den Adapter für PostgreSQL" | Implementation |
| "Prüfe, ob der PR die ADR-7-Schichtung einhält" | Reviewer |
| "Prüfe, ob alle Akzeptanzkriterien aus LH-FA-3 erfüllt sind" | Verification |
| "Prüfe, ob das Feature das Benutzerbedürfnis trifft" | Validation |
| "Entscheide, ob `coverage-gate` 70 % oder 80 % verlangt" | Architect (ADR) + Planner (Slice für Schwelle) |
| "Schreibe einen Replay-Test gegen das Golden Set" | Implementation, im Auftrag von Verification |
| "Identifiziere, dass dieselbe Halluzination dreimal aufgetreten ist" | Planner (Steering-Loop-Eintrag) |
| "Aktualisiere AGENTS.md mit einer neuen Hard Rule" | Architect (ADR-Folge) + Planner (Slice) |

Häufiger Fehler: "Reviewer macht das schon mit." → Reviewer prüft
gegen Plan/ADR, nicht gegen Anforderung; das ist Verification.

### Konfliktfall: Reviewer lehnt ab, Implementer widerspricht

Eskalationspfad:

1. Reviewer benennt das Finding *kategorisiert* (HIGH/MEDIUM/LOW/INFO, siehe [Modul 9](../04-qualitaet/modul-09-review-harness.md)) und mit Bezug auf eine ADR-ID.
2. Implementer hat zwei Optionen: a) Befund umsetzen, b) Folge-ADR vorschlagen, die die ADR-Lücke schließt oder die alte ADR superseded.
3. Architect-Agent (oder Mensch in dieser Rolle) entscheidet zwischen den beiden Pfaden.
4. **Niemand** entscheidet "Reviewer hat überreagiert, wir ignorieren". Das wäre ein Carveout — und Carveouts brauchen eigene Disziplin (siehe [Modul 6](../02-planung/modul-06-carveouts.md)).

## Häufige Fehler

- **Eine Person spielt mehrere Rollen ohne Trennung.** Klassisch: Implementer reviewt sich selbst, weil "ich kenne den Code". Das ist genau die Klasse von Fehlern, gegen die der Harness gebaut ist.
- **Rollen werden technisch identisch gestartet** (gleicher Prompt, gleicher Kontext). → Sie wiederholen denselben Fehler. Rollen-Trennung heißt auch: *unterschiedlicher Eingabe-Kontext, unterschiedliche Skills*.
- **Validation wird "wir machen vor Release".** → Zu spät. Validation gehört zumindest *vor* die Implementation größerer Wellen (Spec-Validierung beim Kunden) und nach jedem MVP-Slice.

## Verweise

- Spec/ADR/Plan-Trennung: [`../grundlagen/konventionen.md#trennschärfen`](../grundlagen/konventionen.md#trennschärfen)
- Vorherige Lösung: [Modul 6](modul-06-loesung.md)
- Nächste Lösung: [Modul 8](modul-08-loesung.md)
