# Review-Runde 11 — offen

**Stand:** 2026-07-29. **Status:** noch kein Review-Lauf. Diese Datei sammelt,
was **vor** der Runde aufgefallen ist. `V11-01` ist behoben, die Ü-Posten sind
offen.

**Gegenstand, wenn die Runde läuft:** der Diff `5e061dc..HEAD` — die Nacharbeit
zu [Runde 10](review-runde-10.md) (dort abgelegt, vollständig behoben).

**Verfahrens-Vorgabe aus Runde 10:** Drei Reviewer mit getrennten Linsen und
getrenntem Kontext. Wer Break-Tests fährt, braucht ein **isoliertes Worktree** —
in Runde 10 hat ein schreibender Reviewer den Baum verschmutzt und ein anderer
die Verschmutzung als Befund gemeldet.

---

## Vorab-Befund — aus einer Nutzer-Frage, nicht aus einem Review-Lauf

### V11-01 — Der Slice-Zyklus hat eine Rollen-Sequenz, der Wellen-Zyklus keine ✅

Modul 8 trägt `## Rollen-Sequenz für einen Slice` (Quelle `:37`, Spiegel `:10`)
mit einem `sequenceDiagram` über sechs Teilnehmer und einer eigenen Sektion
*Die neun Übergaben und ihre Artefakte*. Die Regel dazu lautet: *„Ein
Rollen-Sprung ohne Artefakt ist der häufigste Pfad zu blinden Flecken."*

Die Wellen-Prozedur hat **drei Eröffnungs- und fünf Closure-Schritte** und
**keinen benannten Träger**. Die Rollen-Nennungen in Modul 6 sind vollständig
diese zwei — beide keine Zuweisung:

```
kurs/de/02-planung/modul-06-roadmap.md:83   | Trigger-Anker (Stakeholder) | Slice(s) (Implementer-Ebene) |
kurs/de/02-planung/modul-06-roadmap.md:489  Der Implementer-Agent bekommt … nicht
```

Im Spiegel `lab/regelwerk/modul-06-roadmap.md` genau eine, ebenfalls negativ
(`:139`).

**Warum das ein Befund ist und nicht eine Auslassung:** Die Schritte sind nicht
Planner-allein.

| Schritt | verlangt | plausibler Träger |
|---|---|---|
| Closure 1 | „`make gates` und der Replay-Lauf sind grün" | Verifier |
| Closure 2 | Trigger-Audit, **ADR**-Zweig | Architect („Architect entscheidet", Modul 8) |
| Closure 3 | Verkörperung in `AGENTS.md`, Gates, Skills | nicht Planner allein |
| Eröffnung 2 | Sichtung — „ist Planungs-Leistung" | Planner *(der einzige angedeutete)* |

Vier Kontexte, kein benannter. Nach dem eigenen Maßstab des Kurses ist das
dieselbe Klasse wie ein Artefakt ohne Konsumenten
([`konventionen.md` §Jedes Artefakt hat einen Konsumenten](../../kurs/de/grundlagen/konventionen.md#jedes-artefakt-hat-einen-konsumenten)):
**ein Schritt ohne Träger.** Und Modul 8 argumentiert ausdrücklich, dass
Rollen-Trennung Kontext-Trennung ist — eine Prozedur, die vier Kontexte berührt
und keinen benennt, lädt zum Ein-Kontext-Durchlauf ein.

**Warum es keiner der drei Reviewer in Runde 10 gefunden hat:** Sie suchten
Widersprüche. Das hier ist keiner — es fehlt etwas. Zwei strukturelle Gründe
verstecken es zusätzlich: Modul 6 kommt *vor* Modul 8 und kann die Rollen noch
nicht zuweisen; und Modul 8 legt seinen Scope im Titel offen („für einen
Slice"), wodurch die Lücke wie Absicht aussieht.

**Behoben — die Vorfrage war zu messen, nicht zu entscheiden.** Sie lautete:
Soll die Wellen-Prozedur überhaupt Rollen tragen? Antwort: Sie tut es schon, nur
unvollständig und an der falschen Stelle. Zwei Belege:

1. Die **Validator-Kanten sind bereits wellen-skopiert** — *„Validierung greift
   nach einem MVP-Slice und vor der Implementation größerer Wellen"* steht mitten
   in einer Sektion, die „für einen Slice" heißt.
2. **Jeder Closure-Schritt hat einen aus dem Kurs ableitbaren Träger.** Die
   Tätigkeits-Tabelle in [Lösung Modul 8](../../kurs/de/loesungen/modul-08-loesung.md)
   ordnet die beiden schwersten schon zu: *„Aktualisiere AGENTS.md mit einer
   neuen Hard Rule" → Architect (ADR-Folge) + Planner (Slice)* und *„Entscheide,
   ob `coverage-gate` 70 % oder 80 % verlangt" → Architect (ADR) + Planner*. Es
   war keine neue Norm zu erfinden, sondern eine unausgesprochene Folge
   aufzuschreiben — derselbe Fall wie R10-04.

Encodiert als [Modul 8 §Rollen-Sequenz für eine Welle](../../kurs/de/03-agenten/modul-08-agentenrollen.md#rollen-sequenz-für-eine-welle),
Spiegel nachgezogen, Vorwärts-Verweis an beiden Prozedur-Überschriften in
Modul 6. Die Eröffnung ist Planner-Arbeit **ohne Übergabe** — eine Aussage, keine
Leerstelle. Die Closure hat **drei** Übergaben gegen neun auf Slice-Ebene.

**Beide Sequenzen sind nötig, weil ein Repo auch ohne Wellen arbeiten kann.**
Ohne Wellen-Betrieb bleiben zwei der drei Übergaben (getragen von Slice-Closure
und Slice-Planung), und die **Verifier→Planner-Kante entfällt** — der repo-weite
Beleg über die Slice-DoDs hinaus *ist* das *Mehr*, an dem sich entscheidet, ob
eine Welle vorliegt. Rollen-Sequenz und Wellen-Kriterium sind damit dieselbe
Aussage aus zwei Richtungen.

---

## Übernommen aus der Stand-Sichtung — bekannt, nicht behoben

Diese Punkte sind keine Review-Befunde, sondern offene Posten aus früheren
Runden. Sie stehen hier, damit sie nicht wieder einzeln erhoben werden müssen.

### Ü-01 — Release-Rückstand: zwölf Wellen committet, nicht getaggt

```
letzter Tag:       v3.8.0  =  Welle 48
CHANGELOG jetzt:             Welle 60
Commits seit Tag:  33
```

Adoptierende Repos vergleichen ihren Baseline-`Stand:` gegen das Register
([`CHANGELOG.md`](../../CHANGELOG.md)) — sie sehen Welle 60 im Repo und
bekommen per Release-Asset Welle 48.

### Ü-02 — `verify-slice` meldet einen Mangel und sagt trotzdem `ok`

```
$ make -C lab/example verify SLICE=slice-020
Missing gates evidence in DoD: …/slice-020-referenz-richtung-repariert.md
verify-slice ok: …/slice-020-referenz-richtung-repariert.md
exit=0
```

Dieselbe Klasse wie R10-21 (Gate grün auf unausgefülltem Rumpf), eine Ebene
weiter: Ein Prüfer, der einen Mangel benennt und `ok` sagt, ist schlimmer als
einer, der schweigt — er erzeugt Vertrauen und Ausgabe zugleich.

### Ü-03 — C# hat kein wirksames Coverage-Gate

`csharp/Makefile:44` setzt `/p:Threshold=70`, was `coverlet.msbuild` voraussetzt;
`csharp/Directory.Packages.props:14` referenziert nur `coverlet.collector` — der
misst, wertet aber keine Schwelle aus. In
[`CO-001`](../../lab/example/docs/plan/carveouts/CO-001-index-coverage.md)
§Offen ehrlich benannt. Braucht ein lauffähiges `dotnet restore` zum Verifizieren.

### Ü-04 — `AGENTS.template.md` lehrt einen zentralen Ort für Qualitätsdefinitionen ohne Quell-Verankerung

`lab/templates/AGENTS.template.md:171`: *„Quality-Gate-Definitionen leben in
`<docs/user/quality.md` oder Äquivalent>."* Modul 13 sagt das so nicht.
Fix-Richtung wäre Quelle → Template, wie bei R10-04.

### Ü-05 — Die Drift-Übung in Modul 12 ist nicht ausführbar

`kurs/de/04-qualitaet/modul-12-replay-evaluierung.md:235` schickt in eine Kopie,
um einen Modellwechsel-Drift zu messen. Das Skelett kann den Replay nicht
ausführen (Lab-Grenze). Entweder als Lab-Grenze deklarieren oder die Übung auf
das Machbare zuschneiden.

### Ü-06 — Geparkt, bewusst

- Der `.harness/`-Beleg für die Durchsetzungsschicht im Kurs-Repo (siehe
  R10-30: Der Reviewer-Skill existiert nur als Adopter-Template).
- Die Discovery-Register-Frage — vertagt bis zum zweiten Konsument-Repo.
