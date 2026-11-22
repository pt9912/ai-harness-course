# Sprache der Dateinamen — Plan

**Stand:** Plan-Entwurf, **nichts umgesetzt**. Kein Kurs-, Regelwerk-, Template-
oder Beispiel-Text berührt. Zählungen in §3 gegen den Arbeitsbaum vom 2026-11-22.

**Anlass.** In `lab/templates/spec/` heißen zwei Vorlagen deutsch
(`lastenheft`, `spezifikation`) und eine englisch (`architecture`). Über alle
Vorlagen mischen sich die Sprachen auch innerhalb eines Namens (`welle-results`,
`archiv-stub-slice`). Eine Regel dazu führt der Kurs nicht. Die Vorgabe des
Maintainers: Die Namen sollen **durchgängig und erklärbar** sein.

## 1. Die Regel

**Entschieden (Maintainer, 2026-11-22):**

> Dateinamen sind englisch. Deutsch bleibt ein Name nur, wenn das Artefakt kein
> gängiges englisches Wort hat.

- **Deutsch bleibt:** `lastenheft`. Für das Lastenheft gibt es nur Umschreibungen
  („requirements specification“), kein gängiges Wort.
- **Fest bleiben** Namen, die ein fremdes Werkzeug erwartet: `AGENTS.md`,
  `README.md`, `Makefile`, `.d-check.yml`.
- **Die Prosa bleibt deutsch.** Der Kurs sagt weiter *Welle* und *Spezifikation*;
  nur der Dateiname folgt der Regel.
- **Verworfen:** „Dateiname = Kurs-Begriff“ (hätte `architecture` → `architektur`,
  `conventions` → `konventionen`, `observation` → `beobachtung` umbenannt) und
  Jira-Namen (`story` für Welle, `task` für Slice). Der Kurs ordnet beide
  anders zu; der Abgleich steht jetzt in
  [`begriffe.md` §Einordnung: Jira-Begriffe](../kurs/de/grundlagen/begriffe.md#einordnung-jira-begriffe)
  (Welle 164).

## 2. Was umbenannt wird — Vorlagen

| Heute (`lab/templates/…`) | Nach der Regel |
|---|---|
| `spec/spezifikation.template.md` | `spec/specification.template.md` |
| `docs/plan/planning/welle.template.md` | `docs/plan/planning/wave.template.md` |
| `docs/plan/planning/welle-results.template.md` | `docs/plan/planning/wave-results.template.md` |
| `docs/plan/planning/archiv-stub-slice.template.md` | `docs/plan/planning/archive-stub-slice.template.md` |
| `docs/plan/planning/archiv-stub-welle.template.md` | `docs/plan/planning/archive-stub-wave.template.md` |
| `docs/plan/adr/NNNN-titel.template.md` | `docs/plan/adr/NNNN-title.template.md` |
| `harness/conventions/MR-NNN-titel.template.md` | `harness/conventions/MR-NNN-title.template.md` |

Dazu die **Ziel-Namen beim Adopter**, die der Kurs lehrt: `spec/spezifikation.md`
→ `spec/specification.md`. Unverändert: alle übrigen Vorlagen und alle
Verzeichnisse (schon englisch).

## 3. Umfang (Zählung 2026-11-22, Vorkommen)

| Muster | Kurs | Regelwerk | Vorlagen | Beispiel | Team-Sim | docs |
|---|---|---|---|---|---|---|
| `spezifikation.md` | 29 | 17 | 17 | 72 | 8 | 2 |
| `spezifikation.template` | 2 | 2 | 2 | 0 | 0 | 1 |
| `welle.template` | 8 | 6 | 5 | 2 | 0 | 29 |
| `welle-results` | 4 | 6 | 3 | 1 | 0 | 33 |
| `archiv-stub` | 6 | 6 | 8 | 0 | 0 | 2 |
| `NNNN-titel` / `MR-NNN-titel` | 5 | 7 | 7 | 2 | 0 | 1 |
| Kennungs-Präfix `welle-<…>` (N1) | 80 | 37 | 45 | 125 | 197 | 161 |

Die `docs/`-Treffer sind überwiegend Historie (Pläne, Reviews) und werden **nicht**
umgeschrieben (N6). Die Zählung ist grob (Teilstring), sie zählt auch Fließtext.

## 4. Offene Entscheidungen

| Nr. | Frage | Stand / Empfehlung |
|---|---|---|
| **N1** | **Der Kennungs-Präfix `welle-`.** Die Welle-Datei heißt nach ihrer Kennung (`<welle-id>.md`, etwa `welle-mvp.md`), die Ergebnis-Notiz `welle-<Kennung>-results.md`. | **entschieden (Maintainer, 2026-11-22): ja, `wave-<Kennung>`.** Die Datei heißt nach ihrer Kennung; bliebe der Präfix deutsch, stünde `wave.template.md` neben `welle-*.md`, und die Regel bräuchte eine Ausnahme. Folge: `wave-<x>.md`, `wave-<x>-results.md`, die Kennung in der Prosa (Kurs ~80 Stellen), Team-Sim (197) und Beispiel. Ob der Archiv-Pfad einer Welle `welle-` im Namen trägt, wird beim Umsetzen geprüft. |
| **N2** | **d-check-Defaults.** `planning.waves.glob` (Default `welle-*.md`) und `planning.waves.results-glob` (Default `welle-*-results.md`) sind einstellbar (d-check `spec/spezifikation.md` §2-Schema). Unberührt: `trace.requirements.source` (`spec/lastenheft.md`) und die Überschriften-Defaults (Prosa). | **entschieden (Maintainer, 2026-11-22): d-check behält seine Defaults; die Vorlage setzt die Globs ausdrücklich** (`wave-*.md`, `wave-*-results.md` in `lab/templates/.d-check.yml`). Grund: Änderte d-check die Defaults, fänden alle Repos, die noch `welle-*` führen und keine Globs setzen, keine Wellen-Dateien mehr. Kein CR an d-check. |
| **N3** | **Übergang für Adopter.** Jede Umbenennung ist Asset-Entfernung und Layout-Bruch auf Datei-Ebene → **MAJOR** (`AGENTS.md` §6). | Keine Doppelnamen (zwei Namen für dasselbe Artefakt driften). Eine Migrations-Liste im Release (alt → neu, je Datei), **Pflichtschritt: die beiden Glob-Zeilen aus N2 setzen**. Bestehende Repos laufen unverändert, bis sie migrieren. **Migrations-Hinweis:** d-check nutzt das Regelwerk selbst (vendored, `spec/spezifikation.md`, `welle-*`) und migriert als Konsument, wenn es den Tag übernimmt — eine Folge, kein Grund für oder gegen die Regel (`AGENTS.md` §1). |
| **N4** | **Spiegel.** `lab/regelwerk` nennt dieselben Dateien. | Wortgleicher Nachzug (`AGENTS.md` §2), `Stand:`-Zeile zieht mit. |
| **N5** | **Team-Sim.** Seed und Szenarien führen `welle-*`; Befund-Erwartungen prüfen Code **und** Ziel (`wave-drift` auf `welle-5`). | Seed und Erwartungen nachziehen, Lauf wiederholen; die Zahl der Verdikte bleibt gleich, sonst ist der Nachzug falsch. |
| **N6** | **Historie.** `CHANGELOG.md`, abgeschlossene Pläne und Reviews nennen die alten Namen. | Nicht umschreiben — Protokoll, kein Verweis zum Reparieren. Links darin, die auf umbenannte Dateien zeigen, meldet der Link-Check; die werden nachgezogen. |

## 5. Plan

Eine Welle, **MAJOR**. Reihenfolge nach der Rangfolge (`AGENTS.md` §1):

1. **Kurs** — Ziel-Namen, Lab-Bezüge, Matrix in `referenz-richtung.md`, Bootstrap
   in Modul 2, Kennungen (N1).
2. **Regelwerk** — wortgleicher Nachzug (N4).
3. **Vorlagen** — Umbenennung per `git mv` (Move-Commit rein, Inhalt getrennt),
   Verweise in den Vorlagen, `.d-check.yml` der Vorlage (Globs, N2).
4. **Beispiel** — Dateien, Verweise, `.d-check.yml`.
5. **Team-Sim** — Seed, Szenarien, Lauf (N5).
6. **Werkzeuge des Repos** — `tools/` (Bundle-Bau) auf Namen prüfen; Stand der
   Zählung: keine Treffer.

Gates: `make check`, `make bundle-check`, Team-Sim-Lauf; Release mit
Migrations-Liste (N3).

## 6. Trigger

*Nicht gesetzt* — eine Entscheidung, kein Ereignis. N1 und N2 sind entschieden;
offen sind die Umsetzungs-Punkte N3–N6.
