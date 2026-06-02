# Runbook — Agent veraendert produktive Daten falsch

## Erste 15 Minuten

1. Schreibzugriff des betroffenen Agenten stoppen.
2. Trace des letzten Agentenlaufs sichern.
3. Betroffene `slice.id`, `requirement.id` und Tool-Calls identifizieren.
4. Entscheiden: Rollback, Fix-Forward oder Datenkorrektur.
5. Incident-Notiz mit Belegen anlegen.

## Rollback ist falsch, wenn

- eine nicht rueckwaertskompatible Migration bereits produktiv lief,
- fehlerhafte Daten bereits an Folgesysteme verteilt wurden,
- der Rollback-Pfad nicht selbst getestet ist.

## Mindesttelemetrie

- Eingabe-Log mit Redaction,
- Tool-Call-Audit-Log,
- Output-vs-Eingabe-Konsistenzmarker,
- Cache-Miss- und Tool-Allowlist-Reject-Zaehler.
