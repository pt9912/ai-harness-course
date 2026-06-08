# Lösung — Modul 1: Der Entwicklungszyklus

Zugehöriges Modul: [Modul 1 — Der Entwicklungszyklus](../01-spec-und-architektur/modul-01-entwicklungszyklus.md).

## Selbstcheck-Antworten

### (Erinnern) Nenne die sieben Stationen des Lebenszyklus in Reihenfolge

Spec → ADR → Plan → Code → Review → Verifikation → Closure.

Wichtig sind nicht nur die sieben Stationen, sondern auch die drei
*Rückwärtspfade* aus dem Diagramm in Modul 1:

- Closure → Spec/ADR (Lerneintrag aus dem abgeschlossenen Slice).
- Verifikation → Spec (entdeckte Spec-Lücke).
- Review → ADR (entdeckter Folge-ADR-Bedarf).

Ohne Rückwärtspfade ist es eine Liste, keine Kette. Eine Liste ist nicht
auditierbar — Auditierbarkeit verlangt, dass jeder Schritt nach oben
(Begründung) und nach unten (Konsequenz) verweist.

### (Analysieren) Review und Verifikation den Eingabe-Artefakten zuordnen

Beide prüfen denselben Code, aber gegen *unterschiedliche* Artefakte —
und genau daraus folgt, dass sie unterschiedliche Fehler fangen:

- **Review** prüft den Diff gegen **Plan und ADR**. Frage: *Ist der Diff
  riskant?* (Schichtung verletzt, Abhängigkeit falsch, Hard Rule
  gebrochen.)
- **Verifikation** prüft den Diff gegen **DoD und Spec** (und dort
  referenzierte ADRs). Frage: *Erfüllt der Diff die Anforderung?*
  (Akzeptanzkriterium fehlt, Out-of-Scope geliefert.)

Die Kreuzung — der eigentliche Lernpunkt:

- Review **übersieht eine Spec-Lücke**, wenn der Plan deren ADR-Bezug nie
  hatte: Review prüft ja nur gegen den Plan, und der war an der Stelle
  stumm. Die Verifikation fängt sie, weil sie gegen die *Spec* prüft.
- Verifikation **übersieht ein lokales Architektur-Risiko**, das in
  keiner DoD-Zeile steht (z. B. eine riskante, aber DoD-erfüllende
  Abkürzung im Diff). Review fängt es, weil es gegen *ADR/Plan* prüft.

Deshalb sind es getrennte Stationen: jede einzelne Sicht hat einen
blinden Fleck, den nur die andere abdeckt. Wer beide in *einen* Lauf
legt, bekommt nicht beide Prüfungen, sondern eine mit zwei Lücken (siehe
[Modul 8](../03-agenten/modul-08-agentenrollen.md) zur Rollen-Trennung).

### Welche Information darf nur in der Spec stehen, welche nur im ADR?

**Nur in der Spec** gehört: *was* gebaut wird, *für wen*, mit welchen
Akzeptanzkriterien und Out-of-Scope-Abgrenzungen. Spec ist eine
Aussage über das Lieferversprechen.

**Nur im ADR** gehört: *warum so und nicht anders*. Konkret die
verglichenen Alternativen, die Annahmen, die Konsequenzen und
ggf. Rückzieher (superseded by). ADR ist eine Aussage über eine
Entscheidung im Zeitpunkt X.

**Häufig falsch verortet:**

- Technologie-Wahl in der Spec ("System wird in Go gebaut") — gehört ins ADR. Spec verlangt höchstens Eigenschaften ("muss als statisches Binary auslieferbar sein").
- Anforderungs-Begründung im ADR ("weil Kunde X das in Meeting Y forderte") — gehört in die Spec oder eine separate Anforderungs-Historie.
- Roadmap-Daten in beiden — gehört in `docs/plan/planning/`, nicht in Spec oder ADR.

### Was passiert, wenn ein Slice fertig ist, aber kein Closure-Eintrag existiert?

Der Harness verliert ab da seine Selbstauskunft. Konkrete Folgen:

- Doku-Drift wird unsichtbar (`done/` zeigt die Realität nicht).
- Wiederkehrende Steering-Loop-Lerngelegenheit geht verloren — Closure ist die Stelle, wo "was haben wir gelernt" festgehalten wird.
- Nachfolge-Slices, die auf der Closure-Erkenntnis aufbauen sollten, finden keinen Ankerpunkt.

Konsequenz: `make plan-status` (oder das Äquivalent) muss als Sensor
laufen und ungeschlossene Slices in `in-progress/`, die längst gemerged
sind, als Drift melden.

## Übungshinweise

### Zeichne den Zyklus für ein Mini-Feature auf einem Blatt

Maßstab für eine gute Zeichnung:

- Spec → ADR → Plan → Code → Review → Verifikation → Closure als gerichtete Kette.
- Rückkanten (Rückverweise) sind eingezeichnet: jeder Knoten verweist auf den vorgelagerten.
- Jeder Knoten hat ein Artefakt (`spec/lastenheft.md`, `docs/plan/adr/NNNN-*.md`, …).
- Mindestens *eine* Schleife ist sichtbar (Steering Loop: Review-Finding → ADR-Update oder Spec-Klärung).

Häufiger Fehler: Die Kette wird einseitig dargestellt. In Wirklichkeit
ist jeder Schritt rückwirksam — ein Review-Finding kann ein ADR
schärfen, eine Verifikations-Lücke kann die Spec präzisieren.

### Identifiziere im Begleit-Repo einen Slice und folge der Kette

Das Lab unter [`/lab/example/`](../../../lab/example/) liefert mindestens
einen voll ausgespielten Slice. Übung: in der `done/`-Datei die
referenzierten IDs (LH-*, ADR-*) suchen, sie in `spec/` und
`docs/plan/adr/` aufschlagen, prüfen, ob die ID-Verweise konsistent
sind. Wenn ein Verweis ins Leere zeigt → Doku-Drift gefunden.

## Häufige Fehler

- "Wir brauchen erst die Architektur, dann die Spec." — Umgekehrt. Spec definiert *was*, Architektur entscheidet *wie* — und kann auf die Spec reagieren.
- "Closure ist optional." — Genau das macht aus einem Harness einen Karteileichen-Friedhof.

## Verweise

- Source Precedence im Detail: [`../grundlagen/konventionen.md#source-precedence`](../grundlagen/konventionen.md#source-precedence)
- Vorherige Lösung: [Modul 0](modul-00-loesung.md)
- Nächste Lösung: [Modul 3](modul-03-loesung.md)
