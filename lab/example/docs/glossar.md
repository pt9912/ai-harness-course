# Glossar — DocSearch-Harness

Dieses Glossar ist der kleine Nachschlagepunkt fuer Modul 0. Es
verwendet bewusst dieselben Begriffe wie der Kurs, aber bezogen auf das
DocSearch-Beispiel.

| Begriff | Bedeutung im Lab |
|---|---|
| LLM | Textmodell, das Such-, Review- oder Verifikationsschritte unterstuetzen kann. |
| Tool-Call | Strukturierter Aufruf eines Werkzeugs, z. B. `make verify SLICE=slice-009`. |
| Agent | LLM plus Tool-Ausfuehrung plus Schleife ueber Plan, Diff, Sensors und Bericht. |
| Harness | Spec, ADRs, Planning, AGENTS.md, Make-Gates, Replay und Telemetrie rund um den Agenten. |
| Guide | Feedforward-Quelle vor der Handlung, z. B. Lastenheft, ADR oder AGENTS.md. |
| Sensor | Feedback-Quelle nach der Handlung, z. B. Linter, Architekturtest oder Replay. |
| Replay | Wiederholbarer Lauf gegen `evals/golden/` mit Modellversion, Seed und Erwartung. |
| Trace | Zeitlich geordnete Belegspur eines Agentenlaufs mit Rolle, Tool-Call und Ergebnis. |

## Mini-Check

Wenn du eine Datei nicht einem Guide oder Sensor zuordnen kannst,
notiere sie als offene Frage. Genau solche Unklarheiten werden im Kurs
spaeter als Harness-Luecken behandelt.
