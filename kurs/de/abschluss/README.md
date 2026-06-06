# Abschluss

| Datei | Inhalt |
|---|---|
| [`abschlussprojekt.md`](abschlussprojekt.md) | AI Harness Platform — Features, Abgabekriterien |
| [`kalibrierungsbeispiele.md`](kalibrierungsbeispiele.md) | Beispielbewertungen für funktional, solide und exzellent |
| [`quellen.md`](quellen.md) | Quellenangaben: Böckeler, Lopopolo, Ford/Parsons/Kua, Nygard, OpenTelemetry, HarnessPrompt, drei Fallstudien-Repos |

## Harte Wahrheit

Ein KI-Agent versteht sich nicht durch Modellnamen. Man versteht ihn
durch Spec-Lücken, fehlende ADRs, halluzinierte Tool-Calls, übersehene
DoD-Bedingungen, Findings ohne Kategorie und Replay-Läufe, die nur
deshalb grün sind, weil das Golden Set überfittet ist.

Wenn ein Gate rot wird, ist das kein Nebenthema. Genau dort lernt man
den Harness.

Und: der Harness ist nie fertig. Jedes wiederkehrende Versagen ist ein
Auftrag, einen Guide oder Sensor nachzuziehen — das ist der Steering
Loop (siehe [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)),
und er ist die einzige Stelle, an der der Mensch im Prozess unersetzbar
bleibt.

Und noch eines: Der typische Ausgangszustand ist nicht
"Greenfield-Harness", sondern ein Repo mit guter Spec, guten ADRs,
guten Gates — aber ohne formellen Harness-Einstieg, ohne
`harness/README.md`, ohne AGENTS.md. Der erste Slice deines
Harness-Projekts ist deshalb fast immer: *die schon vorhandene Struktur
sichtbar machen*, nicht neue Struktur erzeugen. Das ist der
Brownfield-Modus (Trigger-Richtung Code → Doc, mit Konvergenz-Auftrag
zu Greenfield); systematische Sicht in
[`../grundlagen/konventionen.md` §Harness-Bootstrap](../grundlagen/konventionen.md#harness-bootstrap).
