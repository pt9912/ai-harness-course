# Lösung — Modul 1: Der Entwicklungszyklus

Zugehöriges Modul: [Modul 1 — Der Entwicklungszyklus](../01-spec-und-architektur/modul-01-entwicklungszyklus.md).

## Selbstcheck-Antworten

### (Anwenden) Den Lebenszyklus aus dem Gedächtnis als gerichteten Graphen zeichnen

Gefordert ist ein *Graph*, kein Aufzählungs-Ergebnis. Als Teilschritt
darf die Stationsliste vorkommen — Spec → ADR → Plan → Code → Review →
Verifikation → Closure —, aber sie trägt allein nicht: Wer nur die
sieben Stationen aufzählen, nicht aber als Graph mit Kanten *anordnen*
kann, bleibt auf der Erinnern-Stufe.

Eine vollständige Musterantwort als Text-Diagramm:

```text
Spec ──▶ ADR ──▶ Plan ──▶ Code ──▶ Review ──▶ Verifikation ──▶ Closure
 ▲▲                                  │              │             ││
 │└──────────────────────────────────┼──────────────┘ Spec-Lücke  ││
 │        ┌──────────────────────────┘ Folge-ADR                  ││
 │        ▼                                                       ││
 │       ADR ◀───────────────────────────── Lerneintrag ──────────┘│
 └──────────────────────────────────────── Lerneintrag ────────────┘
```

Oder gleichwertig als Adjazenzliste:

- **Vorwärtskanten:** Spec → ADR, ADR → Plan, Plan → Code,
  Code → Review, Review → Verifikation, Verifikation → Closure.
- **Rückwärtskanten (gestrichelt):**
  - Closure → Spec *und* Closure → ADR (Lerneintrag aus dem
    abgeschlossenen Slice),
  - Verifikation → Spec (entdeckte Spec-Lücke),
  - Review → ADR (entdeckter Folge-ADR-Bedarf).

Beim Vergleich mit dem Modul-Diagramm typischerweise vergessen:
Closure als *eigene* Station (nicht "Merge = fertig") und mindestens
eine der drei Rückwärtskanten — am häufigsten Review → ADR.

Warum die Rückwärtskanten zählen: Ohne sie ist es eine Liste, keine
Kette. Eine Liste ist nicht auditierbar — Auditierbarkeit verlangt,
dass jeder Schritt nach oben (Begründung) und nach unten (Konsequenz)
verweist, und dass der Harness aus jedem Lauf *lernt* (Rückwärtspfad).

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

### (Erschaffen) Source-Precedence-Block für ein eigenes Repo entwerfen

Eine ausgearbeitete Beispiel-Konstruktion (Greenfield-Repo mit
dreigeteilter Spec; deine Rangordnung darf abweichen, muss aber
begründet sein):

```markdown
## Source precedence

| Rang | Quelle | Charakter |
|---|---|---|
| 1 | `spec/lastenheft.md` | vertraglich abnahmebindend |
| 2 | `spec/spezifikation.md` + `spec/architecture.md` | technisch fortschreibbar |
| 3 | `docs/plan/adr/` | Architekturentscheidungen |
| 4 | `AGENTS.md` | Agent-Briefing |
| 5 | `README.md` / Beispiel-Repos | Überblick, illustrativ |

Wenn eine niedriger rangierende Quelle einer höheren widerspricht,
**gewinnt die höhere**, und die niedrigere wird angepasst.
```

Begründung der Reihenfolge: Lastenheft/Spec stehen oben, weil sie das
Lieferversprechen sind — alles andere ist Ableitung. ADRs unter der
Spec, weil eine Entscheidung die Spezifikation schärfen darf, nie das
Lastenheft. AGENTS.md unter den ADRs, weil ein Briefing keine
Entscheidung überschreiben darf, die es nur *zusammenfasst*.
Beispiel-Repos ganz unten, weil sie illustrieren, nicht normieren.

Benannter Konfliktfall mit Auflösungs-Regel: AGENTS.md sagt
"Direkt-DB-Zugriff im Service-Layer erlaubt", ADR-0001 schreibt
hexagonale Architektur fest (Zugriff nur über Ports/Adapter).
Auflösung: ADR (Rang 3) gewinnt über AGENTS.md (Rang 4) — also wird
*AGENTS.md korrigiert*, nicht die ADR aufgeweicht und nicht der Code
nach AGENTS.md gebaut.

Exzellent wird der Entwurf mit einem zweiten Konfliktfall aus einem
*anderen* Quellpaar — z. B. Spec verlangt "auslieferbar als statisches
Binary", ein Beispiel-Repo zeigt einen Docker-only-Build: Spec (Rang 1)
gewinnt, das Beispiel ist nur Illustration — plus einem Verweis auf die
Kontrolle, die den ersten Konflikt *deterministisch* verhindert (etwa
eine ArchUnit-Fitness-Function "kein Repository-Import außerhalb der
Adapter-Schicht", die den AGENTS.md-Irrtum gar nicht erst in den Code
laufen lässt).

Anti-Antwort: eine Quellen-*Liste* ohne Reihenfolge und ohne
Konfliktfall. Der Block existiert genau für den Konfliktmoment — ohne
Auflösungs-Regel ist er Dekoration.

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

### Source-Precedence-Block für ein eigenes Repo schreiben

Arbeite entlang der sechs Schritte des Worked Example: Konfliktinventar
→ Quellen klassifizieren → Tabelle entwerfen →
Konfliktauflösungs-Klausel → Spec-Stratifizierung → bewusstes Brechen.
Die Vorlage liegt in
[`/lab/templates/harness/README.template.md`](../../../lab/templates/harness/README.template.md).

Maßstab für einen guten Block:

- Maximal neun Ränge — wer mehr braucht, hat Mehrfach-Repräsentationen,
  die gebündelt gehören.
- Die Konfliktauflösungs-Klausel steht *neben* der Tabelle ("höhere
  Quelle gewinnt, niedrigere wird angepasst") und ist spiegelbildlich
  in `AGENTS.md` wiederholt — eine Tabelle ohne Klausel wirkt nicht.
- Die Rangordnung ist projektspezifisch begründet (Adaptions-Block),
  nicht aus dem Beispiel kopiert.

Eine ausgearbeitete Beispiel-Konstruktion samt Konfliktfall steht oben
in der Selbstcheck-Antwort zum Erschaffen-Item (LZ 4) — die Übung und
das Selbstcheck-Item teilen sich das Artefakt.

### Nachgeholter Schritt 6: Bewusstes Brechen (Fehlerfall-Übung)

Wer das Worked Example übersprungen hat, holt dessen Schritt 6 jetzt
nach — sie ist die einzige Fehler-Provokation des Moduls. Erwartung:
Eine Hard Rule in `AGENTS.md` so ändern, dass sie einer ADR
widerspricht, und beobachten, welche der drei Diagnosen aus der
Schritt-6-Tabelle eintritt (Implementer baut gegen AGENTS.md /
Implementer stoppt und meldet den Konflikt / Implementer "löst" den
Konflikt in die falsche Richtung, indem er die ADR ändert). Nur die
mittlere Beobachtung zeigt gelebte Source Precedence. Wichtig für die
Reflexion: nicht das Ergebnis schönreden, sondern festhalten, *welche*
Beobachtung eintrat — genau sie verrät, ob die Precedence im Repo
durchgesetzt ist oder nur Papier.

## Häufige Fehler

- "Wir brauchen erst die Architektur, dann die Spec." — Umgekehrt. Spec definiert *was*, Architektur entscheidet *wie* — und kann auf die Spec reagieren.
- "Closure ist optional." — Genau das macht aus einem Harness einen Karteileichen-Friedhof.

## Verweise

- Source Precedence im Detail: [`../grundlagen/konventionen.md#source-precedence`](../grundlagen/konventionen.md#source-precedence)
- Vorherige Lösung: [Modul 0](modul-00-loesung.md)
- Nächste Lösung: [Modul 2](modul-02-loesung.md)
