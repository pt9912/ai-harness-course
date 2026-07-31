# CO-002: Replay-Verifikation deklariert, nicht durchgesetzt

**Status:** Aktiv.

**Datum angelegt:** 2026-07-31. **Letzte Prüfung:** 2026-07-31.

**Betroffenes Gate:** `make replay` (validiert die *Struktur* des
Golden-Set-Verzeichnisses; es führt keinen Lauf aus).

**Geltungsbereich:** `evals/golden/welle-1-baseline/` — der `verification`-
und der `runtime`-Block des Manifests.

**Folge-Slice:** [`slice-015-replay-runner.md`](../planning/open/slice-015-replay-runner.md)

---

## Begründung

Das Manifest deklariert einen Verifikations-Vertrag, den kein Target
einlöst:

```yaml
verification:
  per_case_hash: sha256
  determinism_check: two_runs_same_hash
```

`make replay` prüft Existenz und Form — Manifest vorhanden, `model:`- und
`runtime:`-Block vorhanden, mindestens drei Cases, `inputs` und
`expectations` gleich lang. Es liest keinen Wert *innerhalb* dieser Blöcke.
Belegt per Break-Test: Ein Wechsel von `model.name`/`model.version` und eine
verfälschte Erwartung lassen das Target unverändert grün.

Ein echter Runner ist hier nicht nur Arbeit, sondern braucht eine Grundlage,
die das Lab nicht hat: Die Erwartungen referenzieren ein Korpus
(`top_doc_path: docs/init.md`), das im Repo nicht existiert. Ohne Korpus
lässt sich kein Lauf ausführen und keine Erwartung kalibrieren — `top_score_min`
ist gegen die tatsächliche Ausgabe des `MockEmbedder` zu bestimmen, nicht zu
raten.

Warum nicht einfach den `verification`-Block streichen: Er ist die **Ziel-Form**
und wird im Kurs
([Modul 12](../../../../../kurs/de/04-qualitaet/modul-12-replay-evaluierung.md))
als Pflichtinhalt eines Replay-Manifests gelehrt. Ein Fixture ohne ihn wäre
als Vorbild schlechter, nicht besser. Was falsch war, ist die Behauptung, er
werde durchgesetzt — die ist entfernt.

## Auflösungs-Trigger

- Wenn `slice-015-replay-runner` done ist: Der Runner vergleicht
  `runtime.image_hash`, `model.name`/`model.version` und den Case-Hash gegen
  den Vorlauf; `make replay` wird von der Struktur- zur Ergebnis-Prüfung.
- Ersatzweise permanent, falls entschieden wird, dass das Lab bewusst kein
  ausführbares Korpus trägt — dann ist die Lab-Grenze der Endzustand und
  wandert per ADR in die Architektur-Entscheidungen (Modul 7: *permanent →
  ADR*).

## Geltungs-Konfiguration

| Datei | Zeile/Section | Wert |
|---|---|---|
| `evals/golden/welle-1-baseline/manifest.yaml` | `verification:` | mit `# CO-002` markiert: deklariert, nicht durchgesetzt |
| `Makefile` | Target `replay` | Struktur-Validierung; Beschreibung nennt die Grenze |

## Verifikation (nach Auflösung)

- [ ] `make replay RUN=welle-1-baseline` führt die Cases aus und vergleicht gegen `expectations/`.
- [ ] Ein geändertes `model.version` macht das Target **rot** (Break-Test).
- [ ] Eine verfälschte Erwartung macht das Target **rot** (Break-Test).
- [ ] `verification.determinism_check` ist eingelöst: zwei Läufe, gleicher Case-Hash.
- [ ] `# CO-002`-Markierung aus dem Manifest entfernt.
- [ ] Datei wird nach `docs/plan/carveouts/done/` bewegt (reiner `git mv`).

## Geschichte

| Datum | Ereignis | Verweis |
|---|---|---|
| 2026-07-31 | Angelegt | Review-Runde 11, `Ü-11` |
