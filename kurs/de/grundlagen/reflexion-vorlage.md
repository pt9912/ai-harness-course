# Reflexionsvorlage für Fehler-Provokations-Übungen

Mehrere Module enthalten Übungen, in denen du *absichtlich* einen Fehler
provozierst — eine Halluzination, eine Spec-Lücke, eine DoD-Verletzung,
einen Coverage-Failure.

## Was diese Methode ist (und was nicht)

Das, was der Kurs durchgängig macht, ist **Error Provocation /
Misconception Confrontation**: erst Lehre (Konzept, Kernidee, Worked
Example), dann gezielter Fehler, dann strukturierte Reflexion.

Das ist *nicht* dasselbe wie *Productive Failure* nach **Manu Kapur**
(2008, 2014). Kapur-PF verlangt Exploration und Scheitern **vor** der
Instruktion — Lernende ringen mit einem komplexen Problem ohne
Lösungsstrategie und werden erst danach unterrichtet. Diese stärkere
Form findet sich im Kurs nur punktuell als *optionaler* Einstiegspfad
(z. B. in [Modul 0](../00-einfuehrung/modul-00-einfuehrung.md#optionale-explorations-vorab-übung-kapur-stil)
und [Modul 2](../01-spec-und-architektur/modul-02-lastenheft.md#optionale-explorations-vorab-übung-kapur-stil)).

Die Reflexion unten macht beide Formen erst zu Lernen. Verwende sie nach
jeder Fehler-Provokations- *und* nach jeder Exploration-Vorab-Übung.
Schreibe die Antworten auf — nicht nur "im Kopf durchspielen".

## Die vier Standardfragen

### 1. Was ist beobachtbar passiert?

Beschreibe das Ergebnis ohne Bewertung. Konkret, nicht "der Agent war
schlecht", sondern: *Welche Tool-Calls hat er gemacht? Welche Dateien
geändert? Welche Meldung hat das Gate produziert? An welcher Stelle in
der Spec ist er aus dem Korridor gefallen?*

Maßstab: Wenn jemand anderes nur deinen Bericht liest, kann er den Lauf
reproduzieren.

### 2. Welche Harness-Lücke war Ursache?

Ordne den Fehler genau einem Quadranten der 2×2-Matrix zu (siehe
[`klassifikation.md`](klassifikation.md)):

- *Computational + Feedforward* fehlte? (z. B. Tool war nicht in der Allowlist eingeschränkt, Typ-Signatur war zu offen)
- *Computational + Feedback* fehlte? (z. B. kein Linter-Gate für diese Klasse von Fehlern)
- *Inferential + Feedforward* fehlte? (z. B. Spec war an dieser Stelle stumm, ADR fehlte, AGENTS.md sagte nichts)
- *Inferential + Feedback* fehlte? (z. B. Reviewer-Skill hatte diese Failure-Klasse nicht im Blick)

Anti-Antwort: "Das Modell war zu dumm." Modelle werden besser oder
schlechter, aber der Quadrant bleibt — die Frage ist, welche Kontrolle
*du* aus dem Lauf lernen kannst.

### 3. Welche Steering-Loop-Aktion folgt?

Eine konkrete Änderung am Harness, nicht eine vage Absicht. Drei
Beispiele für gute Antworten:

- "Ich ergänze in AGENTS.md den Satz: 'Optimierer darf nie direkt aufs Gerät schreiben — Output fließt durch Statemachine.' (Inferential Feedforward)"
- "Ich schreibe einen ArchUnit-Test, der `optimizer.*` → `device.*`-Imports verbietet. (Computational Feedback)"
- "Ich erweitere die Tool-Allowlist des Implementation-Agenten um `--no-direct-device-write`. (Computational Feedforward)"

Schlechte Antworten: "Ich werde aufmerksamer", "Wir müssen besser
testen", "Vielleicht ein anderes Modell". Diese sind nicht reproduzierbar
und nicht prüfbar.

### 4. Welche eigene Vorstellung wurde durch den Vorfall unzufriedenstellend?

Conceptual Change im engeren Sinn (Posner et al. 1982) verlangt, dass
*deine* bisherige Sicht ins Wanken gerät — nicht nur, dass *der Harness*
geändert wird. Frage dich:

- Welcher Satz aus [`lernervorstellungen.md`](lernervorstellungen.md)
  beschreibt am ehesten *die* Vorstellung, mit der du in die Übung
  gegangen bist? (Posner-Unzufriedenheit, Bedingung 1.)
- Wodurch genau wurde sie unzufriedenstellend — *was* hast du beobachtet,
  das mit deiner Vorstellung nicht vereinbar war?
- Warum erscheint dir die neue Sicht *plausibel*? Verweise auf einen
  Beleg — eine Stelle im Kurs, ein Tool-Call-Trace, eine Fallstudie,
  eine empirische Quelle. *"Klingt logisch"* ist keine Plausibilität;
  *"die Fallstudien in `fallstudien.md` zeigen es so"* ist eine.
  (Posner-Plausibilität, Bedingung 2.)
- Welche neue Sicht erklärt die Beobachtung besser, **und wo könnte
  sie wiederum scheitern**? (Posner-Fruchtbarkeit, Bedingung 4.)

Die zwei mittleren Stichworte (Verständlichkeit, Bedingung 3) sind
nicht eigens abgefragt — sie sind operativ: wenn du den neuen Satz in
einem Satz erklären kannst, ist er für dich verständlich. Wenn nicht,
formuliere ihn um, *bevor* du Bedingung 4 angehst.

Anti-Antwort: "Ich wusste das eigentlich schon." Wenn das stimmte,
hättest du den Fehler nicht erzeugt. Schreib die *unzufriedenstellend
gewordene Vorstellung* hin, auch wenn sie peinlich klein wirkt — genau
das ist der Lernschritt.

## Wann darf eine Reflexion *nicht* zu einer Harness-Änderung führen?

Nicht jeder Einzelfehler verdient einen neuen Sensor. Faustregel
(Steering Loop, siehe [`klassifikation.md`](klassifikation.md#steering-loop)):

- **Einmal:** notieren, keine Aktion.
- **Zweimal:** Symptom — beobachten, kategorisieren.
- **Dreimal:** Lücke im Harness — Guide oder Sensor nachziehen.

Wer auf jeden Einzelfehler mit einem neuen Gate reagiert, baut sich einen
Harness, der vor lauter Schutzschichten nicht mehr atmet. Wer auf
*keinen* wiederkehrenden Fehler reagiert, baut sich einen Harness, der
mit der Zeit irrelevant wird.

## Eintrag in den Lern-Trace

Lege pro Modul-Übung einen kurzen Eintrag an:

```
Modul: <nummer>
Übung: <kurztitel>
Datum: <YYYY-MM-DD>

1. Beobachtung: <2-3 Sätze>
2. Harness-Lücke (Quadrant): <Q + Begründung>
3. Steering-Loop-Aktion: <konkret oder "noch nicht — Erstvorfall">
4. Conceptual Change:
   - alte Vorstellung, die unzufriedenstellend wurde: <ein Satz oder "keine — schon vorher gewusst">
   - neue Sicht + Plausibilitäts-Beleg: <Satz + Beleg-Quelle, z. B. "fallstudien.md §grid-gym">
   - mögliche Bruchstelle der neuen Sicht: <ein Satz oder "noch unklar">
```

Diese Einträge sind dein eigenes Golden Set für den späteren Vergleich:
*Welche Harness-Lücken treten in meinen Projekten wiederholt auf?*
