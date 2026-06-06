# OTel-Fixtures — DocSearch

Dieses Verzeichnis enthaelt einen kleinen JSON-Trace fuer Modul 15. Er
ist kein vollstaendiger OpenTelemetry-Export, sondern ein didaktisch
reduziertes Fixture mit denselben Pflichtfeldern, die im Kurs geuebt
werden.

## Ausfuehren

```bash
make trace RUN=sl-009-agent-run
```

## Worauf achten?

- `slice.id` verbindet Kosten und Tool-Calls mit dem Slice.
- `agent.role` trennt Planner, Implementation, Review und Verification.
- `tool.name`, `tool.arguments.redacted` und `tool.result.status`
  belegen, was der Agent getan hat.
- `tokens.input`, `tokens.output` und `cache.hit` erlauben eine erste
  Kosten- und Cache-Analyse.
