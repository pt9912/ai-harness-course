# Lösung — Modul 1: Der Entwicklungszyklus

Zugehöriges Modul: [Modul 1 — Der Entwicklungszyklus](../01-spec-und-architektur/modul-01-entwicklungszyklus.md).

## Selbstcheck-Antworten

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

Das Lab unter [`/lab/example/`](../../lab/example/) liefert mindestens
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
- Nächste Lösung: [Modul 2](modul-02-loesung.md)
