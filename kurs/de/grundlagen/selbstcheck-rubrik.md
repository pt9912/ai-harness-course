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

Faustregel: wenn deine Antwort *jeder* der drei Stufen entsprechen
könnte, ist sie rudimentär. Mehrdeutigkeit nach oben ist Selbstbetrug.

## Wann sollst du eine niedrigere Stufe akzeptieren?

- Beim ersten Lesen: rudimentär reicht. Du sollst *weiter*, nicht
  abschließen.
- Vor einem Phasen-Checkpoint (siehe [`checkpoints.md`](checkpoints.md)):
  mindestens solide auf *allen* Selbstchecks der Phase.
- Vor dem Abschlussprojekt: exzellent auf mindestens der Hälfte aller
  Selbstchecks; solide auf allen anderen.

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
