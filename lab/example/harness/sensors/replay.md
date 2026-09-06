# `make replay RUN=<set-name>` — Golden-Set-Fixture validieren

Vertiefung zur Index-Zeile in [`../README.md` §Sensors](../README.md#sensors-feedback-gates).
Bindung: [Modul 12 §Golden-Set-Form](../../../../kurs/de/04-qualitaet/modul-12-replay-evaluierung.md)
(`MR-002`).

## Vertrag

Root-Target; `<set-name>` ist der Name unterhalb `evals/golden/`, z. B.
`welle-1-baseline`. Rot, wenn das Golden-Set-Verzeichnis unvollständig ist:
Manifest mit `model:`- und `runtime:`-Block, `inputs/`, `expectations/`,
mindestens drei Cases, gleiche Anzahl auf beiden Seiten.

## Grenze — was das Grün nicht abdeckt

1. **Der Replay läuft nicht.** Das Target prüft die *Form* der Fixture, nicht
   das Verhalten gegen sie (Modul 12). Ein vollständiges Golden Set, dessen
   Erwartungen nicht mehr stimmen, ist hier grün. Permanent — die Ausführung
   ist bewusst nicht Teil dieses Targets.
2. **Nicht Teil von `ci`.** Das Golden Set läuft nicht im Pflicht-Lauf; wer nur
   `make ci` fährt, hat über die Fixture keine Aussage. Heilbar — durch
   Aufnahme in `ci`, sobald der Replay selbst ausführbar ist.

Welche Sets es gibt und welche Grenzen je Set gelten, sagt
[`../../evals/golden/README.md`](../../evals/golden/README.md); die Liste steht
dort, nicht hier.
