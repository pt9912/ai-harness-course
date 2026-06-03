# Selbstcheck-Rubrik

Jedes Modul endet mit einem Selbstcheck — offene Fragen, keine
Multiple-Choice. Damit du deine Antwort *ohne Lösungsdatei*
diagnostizieren kannst, hat jedes Modul eine eigene Rubrik mit drei
Stufen pro Frage. Diese Datei erklärt die Stufen einmal generisch.

## Die drei Stufen

| Stufe | Bedeutung | Typisches Indiz |
|---|---|---|
| **rudimentär** | Du hast den Kernbegriff erkannt und einen Halbsatz dazu. Eine korrekte, aber oberflächliche Antwort. | Eine Definition aus dem Glossar zitiert, ohne sie auf den Fall anzuwenden. |
| **solide** | Du hast den Kernbegriff angewendet, mindestens *ein* Beispiel aus dem Kurs benutzt, eine Grenze gezogen. | Du argumentierst mit einer Quelle (ADR-ID, Hard Rule, Quadrant der 2×2-Matrix). |
| **exzellent** | Solide *plus* ein Transfer: ein Gegenbeispiel, ein Grenzfall, eine Verbindung zu einem anderen Modul, oder eine Vorhersage ("wenn X gilt, dann ändert sich Y"). | Du nennst, was die Antwort *nicht* tut, und warum. |

### Verhältnis zur Vier-Stufen-Abschluss-Rubrik

Die Abschluss-Rubrik in [`../abschluss/abschlussprojekt.md`](../abschluss/abschlussprojekt.md#bewertungsraster-rubric)
hat **vier** Stufen — *rudimentär · funktional · solide · exzellent*.
Das ist kein Konflikt, sondern eine Erweiterung um die Mittelstufe
*funktional*: ein Artefakt existiert und ist formal korrekt, aber noch
nicht inhaltlich verknüpft. *Funktional* ist die häufigste Stufe bei
Erstabgaben.

| Selbstcheck-Stufe (Modul) | Abschluss-Stufe (Projekt) | Kurzformel |
|---|---|---|
| rudimentär | rudimentär | Kernbegriff erkannt, sonst nichts. |
| — | **funktional** | Artefakt existiert, ist aber nicht durchgängig verknüpft. |
| solide | solide | Anwendung mit Bezug zu Quelle/ID. |
| exzellent | exzellent | Transfer, Gegenbeispiel, Vorhersage. |

Lesart: Ein Modul-Selbstcheck kennt *funktional* nicht, weil eine
Antwort entweder oberflächlich (rudimentär) oder schon mit Beispiel
verbunden (solide) ist. Ein Abschluss-Repo dagegen kann formal komplett
und trotzdem nicht verknüpft sein — dafür ist *funktional* die richtige
Stufe.

### Warum die Asymmetrie kein Defekt ist

Der Grund liegt in der Frage-Art:

* Modul-Selbstchecks prüfen *Konzepte* — "Wo verläuft die Grenze
  zwischen X und Y?", "Welche drei Felder muss Z tragen?". Eine
  Antwort, die ein Konzept *nennt*, ohne es *anzuwenden*, ist
  rudimentär. Es gibt keinen "Konzept vorhanden, aber nicht verknüpft"-
  Zwischenraum — die Verknüpfung ist die Anwendung, und sie ist binär
  vorhanden oder nicht.
* Die Abschluss-Rubrik prüft *Artefakte* — "Ist die ADR im Repo?",
  "Verweist der Slice auf die ADR?". Hier gibt es einen echten
  Zwischenraum: das Artefakt liegt im Repo, aber ohne Bezug — formal
  da, inhaltlich tot. Genau das ist *funktional*.

Ein häufiger Selbstbetrug: ein Modul-Selbstcheck wird beantwortet mit
"die Definition steht im Mini-Glossar, ich kann sie zitieren". Das ist
*rudimentär*, nicht *funktional* — auch wenn die Versuchung groß ist,
"vorhanden" mit *funktional* zu verwechseln. Wer im Modul-Selbstcheck
zur Zwischenstufe greifen will, hat in Wahrheit eine rudimentäre Antwort
und sollte sie auf *solide* anheben (Anwendung + Quelle), nicht
umetikettieren.

Faustregel: wenn deine Antwort *jeder* der drei Stufen entsprechen
könnte, ist sie rudimentär. Mehrdeutigkeit nach oben ist Selbstbetrug.

## Wann sollst du eine niedrigere Stufe akzeptieren?

- Beim ersten Lesen: rudimentär reicht. Du sollst *weiter*, nicht
  abschließen.
- Vor einem Phasen-Checkpoint (siehe [`checkpoints.md`](checkpoints.md)):
  mindestens solide auf *allen* Selbstchecks der Phase.
- Vor dem Abschlussprojekt: exzellent auf mindestens der Hälfte aller
  Selbstchecks; solide auf allen anderen.
- Wenn du einen [Lernpfad](lernpfade.md) läufst (A/B/C): die
  *Mindest-Stufen-Liste* deines Pfads in
  [`lernpfade.md` §Selbstcheck-Anker pro Pfad](lernpfade.md#selbstcheck-anker-pro-pfad)
  ist das pfad-spezifische Minimum; Module außerhalb der Liste dürfen
  auf *rudimentär* bleiben.

## Wie du dich selbst schärfer beurteilen kannst

Drei kleine Tests, die helfen, exzellent von solide zu trennen:

1. **Transfer-Test:** Kannst du deine Antwort auf eines der vier
   Fallstudien-Repos ([`fallstudien.md`](fallstudien.md)) übertragen,
   ohne sie umzuschreiben?
2. **Falsifikations-Test:** Welche Bedingung *im Kurs* würde deine
   Antwort umkehren? Wenn du keine findest, ist die Antwort nicht
   differenziert genug.
3. **Negativtest:** Kannst du angeben, *was deine Antwort nicht ist* —
   eine plausible falsche Antwort, gegen die du dich abgrenzt?

Die drei Tests sind dieselbe Logik, die der Kurs an Akzeptanzkriterien
([Modul 2](../01-spec-und-architektur/modul-02-lastenheft.md)) anlegt:
Happy Path, Boundary, Negative.

## Wo finde ich die Rubrik pro Modul?

Direkt unter dem Selbstcheck-Block jedes Moduls steht eine Tabelle
"Selbstcheck-Rubrik" mit drei Stufen pro Frage. Die Tabelle ist
*kein Ersatz* für die Lösungsdatei (siehe
[`../loesungen/`](../loesungen/)), sondern eine Brücke davor: erst
selbst einschätzen, dann mit der Musterantwort vergleichen.
