# Sprache der Dateinamen — Plan

**Stand:** umgesetzt in Welle 165 ([`CHANGELOG.md`](../CHANGELOG.md)), MAJOR,
nicht released. Zählungen in §3 gegen den Arbeitsbaum vom 2026-11-22, vor der
Welle. Drei Stellen fehlten im Plan und sind nach der Regel mitgezogen
(`archiv.zip`, `architektur.md` in Modul 3, die Ergebnis-Notiz in Modul 16);
siehe den Welle-Eintrag.

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
| **N1** | **Der Kennungs-Präfix `welle-`.** Die Welle-Datei heißt nach ihrer Kennung (`<welle-id>.md`, etwa `welle-mvp.md`), die Ergebnis-Notiz `welle-<Kennung>-results.md`. | **entschieden (Maintainer, 2026-11-22): ja, `wave-<Kennung>`.** Die Datei heißt nach ihrer Kennung; bliebe der Präfix deutsch, stünde `wave.template.md` neben `welle-*.md`, und die Regel bräuchte eine Ausnahme. Folge: `wave-<x>.md`, `wave-<x>-results.md`, die Kennung in der Prosa (Kurs ~80 Stellen), Team-Sim (197) und Beispiel. Der Archiv-Pfad folgt von selbst: Der Kurs schreibt ihn als `done/<welle-id>/` (Modul 6, Modul 8), er leitet sich aus der Kennung ab; umzubenennen ist nur der Platzhalter (`<welle-id>` → `<wave-id>`). **Nebenfund:** Modul 16 Schritt 6 nennt `done/welle-1-closure.md`, überall sonst heißt die Ergebnis-Notiz `welle-<Kennung>-results.md` — vor dem Plan schon uneinheitlich; in der Welle mit bereinigen, nachdem geprüft ist, ob Modul 16 dort ein anderes Artefakt meint. |
| **N2** | **d-check-Defaults.** `planning.waves.glob` (Default `welle-*.md`) und `planning.waves.results-glob` (Default `welle-*-results.md`) sind einstellbar (d-check `spec/spezifikation.md` §2-Schema). Unberührt: `trace.requirements.source` (`spec/lastenheft.md`) und die Überschriften-Defaults (Prosa). | **entschieden (Maintainer, 2026-11-22): d-check behält seine Defaults; die Vorlage setzt die Globs ausdrücklich** (`wave-*.md`, `wave-*-results.md` in `lab/templates/.d-check.yml`). Grund: Änderte d-check die Defaults, fänden alle Repos, die noch `welle-*` führen und keine Globs setzen, keine Wellen-Dateien mehr. Kein CR an d-check. **Korrektur (2026-11-22):** `lab/templates/.d-check.yml` führt heute **keinen** `planning`-Block — die beiden Globs kommen also mit einem neuen, auskommentierten `planning.waves`-Block nach dem Aktivierungs-Muster der Vorlage (Block entkommentieren **und** Modul in `modules`). Der Pflichtschritt in N3 gilt für Repos, die `planning.waves` nutzen. |
| **N3** | **Übergang für Adopter.** Jede Umbenennung ist Asset-Entfernung und Layout-Bruch auf Datei-Ebene → **MAJOR** (`AGENTS.md` §6). | Keine Doppelnamen (zwei Namen für dasselbe Artefakt driften). Eine Migrations-Liste im Release (alt → neu, je Datei), **Pflichtschritt: die beiden Glob-Zeilen aus N2 setzen**. Bestehende Repos laufen unverändert, bis sie migrieren. **Migrations-Hinweis:** d-check nutzt das Regelwerk selbst (vendored, `spec/spezifikation.md`, `welle-*`) und migriert als Konsument, wenn es den Tag übernimmt — eine Folge, kein Grund für oder gegen die Regel (`AGENTS.md` §1). |
| **N4** | **Spiegel.** `lab/regelwerk` nennt dieselben Dateien. | Wortgleicher Nachzug (`AGENTS.md` §2), `Stand:`-Zeile zieht mit. |
| **N5** | **Team-Sim.** Seed und Szenarien führen `welle-*`; Befund-Erwartungen prüfen Code **und** Ziel (`wave-drift` auf `welle-5`). | Seed und Erwartungen nachziehen, Lauf wiederholen; die Zahl der Verdikte bleibt gleich, sonst ist der Nachzug falsch. |
| **N6** | **Historie.** `CHANGELOG.md`, abgeschlossene Pläne und Reviews nennen die alten Namen. | **entschieden (Maintainer, 2026-11-22): Historie bleibt, wie sie ist** — Protokoll, kein Verweis zum Reparieren. Links darin, die auf umbenannte Dateien zeigen, meldet der Link-Check; die werden nachgezogen. |
| **N7** | **Inhalt der Vorlagen.** Nicht nur die Dateinamen: 17 Vorlagen nennen betroffene Namen im Text (Zählung 2026-11-22). Häufigste Formen: Platzhalter `<welle-id>` (22×), `spec/spezifikation.md` (13×), `welle-<Kennung>` (6×), `welle-<Kennung>-results.md` (5×), Verweise auf die umbenannten Vorlagen (`welle-results.template.md`, `archiv-stub-*.template.md`, `NNNN-titel`, `MR-NNN-titel`, je 2–4×). Meiste Treffer: `README.md` (Vorlagen-Liste und §Verwendung, 11), `welle.template.md` (9), `welle-results.template.md` (8), `roadmap.template.md`, `archiv-stub-*` und `.d-check.yml` (je 5), `lastenheft.template.md` (4). In `.d-check.yml`: die auskommentierte `matrix`-Klasse `welle` (Name, `paths` `welle-*.md`, `token` `welle-…`, zwei Regeln) und die `spec`-Klasse (`paths`/`order` mit `spec/spezifikation.md`); dazu der neue `planning.waves`-Block (N2). | Arbeitsschritt, mit §5 Schritt 3. Die `matrix`-Klasse heißt danach `wave` — der Klassenname ist frei, er folgt der Kennung. Nach dem Nachzug muss die Zählung aus §3 für die Vorlagen auf 0 stehen (außer `lastenheft`). |

## 5. Plan

Eine Welle, **MAJOR**. Reihenfolge nach der Rangfolge (`AGENTS.md` §1):

1. **Kurs** — Ziel-Namen, Lab-Bezüge, Matrix in `referenz-richtung.md`, Bootstrap
   in Modul 2, Kennungen (N1).
2. **Regelwerk** — wortgleicher Nachzug (N4).
3. **Vorlagen** — Umbenennung per `git mv` (Move-Commit rein, Inhalt getrennt),
   dann der Inhalt nach N7: Platzhalter, Ziel-Namen, Verweise, `README.md`,
   `.d-check.yml` (`matrix`-Klassen, neuer `planning.waves`-Block, N2).
4. **Beispiel** — Dateien, Verweise, `.d-check.yml`.
5. **Team-Sim** — Seed, Szenarien, Lauf (N5).
6. **Werkzeuge des Repos** — `tools/` (Bundle-Bau) auf Namen prüfen; Stand der
   Zählung: keine Treffer.

Gates: `make check`, `make bundle-check`, Team-Sim-Lauf; Release mit
Migrations-Liste (N3).

## 6. Trigger

**Nächste Welle; startet mit Freigabe des Maintainers** (entschieden 2026-11-22).
Eine Entscheidung, kein Ereignis — kein Datum. Alle Fragen sind entschieden (Regel,
N1, N2, N6); offen sind nur die Umsetzungs-Punkte N3–N5 und N7.

**Reihenfolge: vor dem Zusage-Strang.** Beide fassen dieselben Dateien an
(`lab/templates/.d-check.yml`, Vorlagen, Regelwerk). Diese Welle ist vollständig
entschieden, der Zusage-Strang hat noch zwei Reste offen (A2a-Default, A4-Rest);
neue Vorlagen-Inhalte aus dessen Welle B entstehen danach gleich mit den neuen
Namen.
