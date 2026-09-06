# Arbeit an diesem Korpus

Autorität ist [`AGENTS.md`](../../AGENTS.md) — Rangfolge (§1), Spiegel-Disziplin
(§2), Wellen (§3), Gates (§4), Commits (§5), Release (§6). Diese Datei ist kein
zweiter Regelort: Sie führt nur die Regeln, die eine **sitzungsweite Vorgabe des
Werkzeugs sonst überschreibt**, und nennt je Regel ihre technische Entsprechung.
Alles andere wird in `AGENTS.md` nachgeschlagen, nicht hier.

## Commit-Attribution — kein Trailer

`AGENTS.md` §5: kein `Co-Authored-By`-Trailer. Entscheidung vom 2026-08-23; ältere
Commits führen ihn, neue nicht. Eine Harness kann eine eigene Attribution als
Sitzungs-Vorgabe setzen — dann gilt die Repo-Konvention, nicht die Vorgabe.

Technische Fassung in [`../settings.json`](../settings.json):
`attribution.commit: ""` (kein Commit-Trailer) und `attribution.sessionUrl: false`
(keine `Claude-Session`-Zeile). Ohne diese Datei greift der Werkzeug-Default und
die Prosa-Regel steht ohne Durchsetzung da.

## Nicht ungefragt committen

`AGENTS.md` §5: Änderungen liegen lassen, Gates laufen lassen, berichten —
committen auf ausdrückliches Wort. Keine technische Entsprechung; trägt allein
diese Zeile.

## Commit-Bodies ohne Umlaute

`AGENTS.md` §5: ASCII-Transliteration (`Aenderung`, `Fussabdruck`). Betrifft nur
die Commit-Message, **nicht** den Korpus — Kurs, Regelwerk, Templates und Beispiel
schreiben Umlaute normal.
