# Modul 6 — Carveout Management

> **Aufwand:** ca. 60 Min Lesen · 60 Min Übung. Spiralcurriculum: Carveouts sind dein erstes konkretes Werkzeug für *Entropy Management* (Säule 3, [Klassifikation](../grundlagen/klassifikation.md#drei-operative-säulen-openai)).

## Mini-Glossar für dieses Modul

Drei neue Begriffe in diesem Modul. Volldefinitionen in
[`../grundlagen/konventionen.md`](../grundlagen/konventionen.md#kernbegriffe).

| Begriff | Ein-Satz-Definition | Bild im Kopf |
|---|---|---|
| **Carveout** | Dokumentierte Ausnahme von einem Gate oder einer Architekturregel — mit Trigger oder explizit als permanent markiert. | ein Loch im Zaun, mit Notiz "wann wird zugemacht?". |
| **Auflösungs-Trigger** | Beobachtbare Bedingung, mit der ein temporärer Carveout endet (nicht "wenn wir Zeit haben"). | die Kerze, die *anzeigt*, dass es jetzt soweit ist. |
| **Bootstrap-aware Gate** *(Vorgriff)* | Gate mit dokumentierter Reifestufe: weich in der Frühphase, hart ab Trigger. **Vollform in [Modul 12](../04-qualitaet/modul-12-quality-gates.md#bootstrap-aware-gates)**. | Tempolimit, das in der Bauzone gilt, später verschwindet. |

## Engage

Ein Repo trägt 14 dokumentierte Carveouts. Acht davon sind "temporär".
Trigger: *"sobald wir Zeit haben"*. Wann tritt der Trigger ein? Nie. Die
acht Carveouts sind faktisch permanent — aber ihre Permanenz ist eine
Lüge im Repo. Das ist Doku-Drift in einer der gefährlichsten Formen.

## Lernziele

Nach diesem Modul kannst du:

* einen Carveout mit Trigger, Folge-Slice und Auflösungs-Kriterium *dokumentieren* (Erschaffen · prozedural),
* zwischen temporärem und permanentem Carveout *unterscheiden* und einen falsch klassifizierten Carveout *erkennen* (Bewerten · konzeptuell),
* den Unterschied Carveout ↔ bootstrap-aware Gate *einordnen* (Analysieren · konzeptuell),
* ein Carveout-Audit als wiederkehrenden Slice *entwerfen* (Erschaffen · prozedural).

## Lab-Bezug

* `docs/plan/carveouts/`

## Themen

* Temporäre Ausnahmen
* Permanente Ausnahmen
* Trigger für die Auflösung
* Folge-Slices

## Harness-Einordnung

Carveout-Pflege ist ein Pfeiler von *Entropy Management* (siehe
[`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)):
ein Carveout-Audit pro Welle verhindert, dass temporäre Ausnahmen zu
permanenten Lügen werden.

## Kernidee

Jeder temporäre Carveout benötigt einen Plan. Ein Carveout ohne
Auflösungs-Trigger ist ein permanenter Carveout, der lügt.

## Typische Fehlvorstellungen

- **"Carveout = Workaround."** — Carveout = *dokumentierter* Workaround mit Trigger. Ohne Trigger ist es eine versteckte Annahme.
- **"Carveouts gehören ins Issue-Tracker."** — Sie gehören ins Repo, neben Spec und ADRs. Tracker können vergessen werden, Repo-Files kommen mit beim Klonen.
- **"Wenn der Trigger eintritt, lösen wir den Carveout auf."** — Realität: er bleibt liegen. Deshalb braucht jeder temporäre Carveout einen *Folge-Slice mit ID*, der das Auflösen plant. Slice schlägt Memo.

## Worked Example A: einen Carveout dokumentieren

> **Wenn du temporäre Carveouts routiniert mit Trigger und Folge-Slice anlegst und sie bei jeder Welle-Closure auditierst, springe zu [§Worked Example B](#worked-example-b-ein-carveout-audit-als-wiederkehrenden-slice-entwerfen).** Worked Example A führt die Mindestform vor (Expertise-Reversal-Schutz: das ist *nicht* der vertiefte Audit-Loop).

**Ausgangssituation:** Das Coverage-Gate `coverage-gate-critical` ist
rot. Der Index-Layer (`internal/index/`) hat 76 % statt der geforderten
90 %. Grund: Binär-Format-Parser mit Fehlerpfaden (`E099` bei korrupter
Datei), die nur partiell durch Unit-Tests abgedeckt sind. Eine
Property-Test-Suite wird die verbleibenden Pfade abdecken — ist aber
erst in Welle 2 eingeplant.

Die Versuchung: das Gate in der CI-Konfiguration herunterdrehen. Das
ist eine *stille* Senkung — sie taucht weder in `harness/README.md`
noch in der Spec auf. Der bessere Weg: ein Carveout.

**Schritt 1 — Carveout-Datei anlegen.** Konvention:
`docs/plan/carveouts/CO-<NNN>-<kurztitel>.md`. ID läuft in `CO-*`-Reihe
(separat von `LH-`, `ADR-`, `SL-` — siehe
[`../grundlagen/konventionen.md`](../grundlagen/konventionen.md#id-schema-als-klammer)).
Für unseren Fall: `CO-001-index-coverage.md`.

**Schritt 2 — Pflichtfelder im Frontmatter / Header festlegen.** Ein
temporärer Carveout, der nicht heimlich permanent werden soll, braucht
sechs Felder:

```markdown
# CO-001: Bootstrap-Coverage `internal/index/`

**Status:** Aktiv.
**Datum angelegt:** 2026-05-20. **Letzte Prüfung:** 2026-06-01.
**Betroffenes Gate:** `coverage-gate-critical`.
**Geltungsbereich:** `internal/index/` (Index-Layer, alle Sprachen).
**Folge-Slice:** [`slice-013-property-tests.md`](../planning/in-progress/slice-013-property-tests.md)
```

Wenn `Folge-Slice` fehlt oder leer ist, ist der Carveout *de facto*
permanent — und gehört dann offen so markiert (siehe Schritt 6).

**Schritt 3 — Auflösungs-Trigger als beobachtbare Bedingung
formulieren.** Anti-Form: *"sobald wir Zeit haben"*, *"nach dem nächsten
Refactoring"*, *"wenn das Team Kapazität hat"*. Gute Form: eine
Bedingung, die ein anderer Mensch ohne Rückfrage als eingetreten oder
nicht eingetreten beurteilen kann.

```markdown
## Auflösungs-Trigger

Welle 2 (welle-2-qualitaet) done — Property-Test-Suite läuft 100
Generationen und deckt die Fehlerpfade.

Konkret: `internal/index/`-Coverage erreicht ≥ 90 %, geprüft in
`make coverage-gate-critical` ohne Ausnahmen.
```

Zwei Sätze: einer für den Welle-Bezug (Roadmap-Anker), einer für die
*messbare* Schwelle. Die messbare Schwelle ist der wichtigere — sie
ist es, was die CI prüft.

**Schritt 4 — Geltungs-Konfiguration mit ID-Kommentar verdrahten.** Die
Gate-Konfiguration *zeigt* auf den Carveout, damit der Carveout im
`make gates`-Output nicht versteckt ist:

```diff
  # <sprache>/coverage.config
  critical_paths:
-   exceptions: []
+   exceptions:
+     - "internal/index/"  # CO-001 — bis Welle 2 done
```

Der `# CO-001`-Kommentar ist nicht Kosmetik: er ist die Brücke zwischen
Gate-Konfiguration und Carveout-Datei. Ohne ihn weiß niemand, *warum*
diese Pfad-Ausnahme existiert.

**Schritt 5 — Verifikations-Checkliste für den Auflösungs-Zeitpunkt
hinterlegen.** Damit nach Trigger-Eintritt klar ist, was zu tun ist:

```markdown
## Verifikation (nach Auflösung)

- [ ] `internal/index/`-Coverage in allen Sprach-Skeletten ≥ 90 %.
- [ ] Carveout-Konfiguration aus Coverage-Config entfernt.
- [ ] `make coverage-gate-critical` grün ohne Ausnahmen.
- [ ] Diese Datei nach `done/CO-001-index-coverage.md` bewegt (reiner `git mv`).
- [ ] slice-013 Closure-Notiz schließt diese Auflösung mit ein.
```

Vier Häkchen, eines davon ein `git mv`. Auflösung ohne Verschiebung in
`done/` ist eine zweite Lüge — der Carveout wirkt "aufgelöst", liegt
aber weiter im aktiven Verzeichnis.

**Schritt 6 — Permanent statt temporär?** Stelle dir die Frage: *Was
würde es konkret kosten, den Trigger zu erreichen — und steht das in
einem realistischen Verhältnis zum Nutzen?* Wenn die ehrliche Antwort
lautet "nichts davon werden wir in absehbarer Zeit tun", ist der
Carveout permanent. Permanente Carveouts gehören nicht in `carveouts/`,
sondern in eine ADR — als Architekturentscheidung mit Begründung. Der
`Status:`-Wechsel ist:

```markdown
**Status:** Permanent — übergeführt in ADR-0009.
```

Das ist nicht Aufgabe; das ist Ehrlichkeit. Vergleich:
[`../../../lab/example/docs/plan/carveouts/CO-001-index-coverage.md`](../../../lab/example/docs/plan/carveouts/CO-001-index-coverage.md).

## Worked Example B: ein Carveout-Audit als wiederkehrenden Slice entwerfen

> **Wenn du bereits einen Carveout-Audit pro Welle laufen lässt, der Status, Trigger-Eintritt und Permanenz-Frage prüft, springe zu [§Übungen](#übungen).** Worked Example A reicht für die Doku-Disziplin; B ist der Schritt, mit dem der Steering Loop um die Carveout-Pflege schließt.

**Ausgangssituation:** Das Repo hat sechs Carveouts. Drei sind seit
über sechs Monaten "aktiv". Niemand hat sie kürzlich geprüft. Faktisch
sind sie permanent — aber im Repo lügen sie weiter unter `aktiv`. Dies
ist die genaue Doku-Drift, die der Carveout-Mechanismus eigentlich
verhindern sollte.

**Schritt 1 — Audit-Slice als ID-Reihe einplanen.** Konvention: ein
Slice `SL-CO-AUDIT-<welle>` pro Welle-Closure, *bevor* die Welle nach
`done/` wandert. ID-Schema-Ergänzung in
[`konventionen.md`](../grundlagen/konventionen.md): Audit-Slices haben
ein Präfix, das sie vom regulären Implementierungs-Slice unterscheidet
— sie liefern *keinen Code*, nur Doku-Updates.

```markdown
# SL-CO-AUDIT-welle-2: Carveout-Audit vor Welle-2-Closure

**DoD:**
- Jeder aktive Carveout in `docs/plan/carveouts/` hat ein aktuelles
  `Letzte Prüfung:`-Datum (≤ heute).
- Jeder Carveout, dessen Trigger eingetreten ist, ist nach `done/`
  verschoben.
- Jeder Carveout, der seit > 2 Wellen "aktiv" ist, wurde *explizit*
  entweder als weiter-gültig bestätigt oder in eine ADR überführt.
- Audit-Bericht als Closure-Notiz in `done/welle-2-results.md`.
```

Vier DoD-Punkte: drei Status-Aktionen plus ein Belegartefakt. Mehr
braucht es nicht — Audit ist *Disziplin*, nicht *Forschung*.

**Schritt 2 — Audit-Bericht-Schablone festlegen.** Damit der Audit
nicht jedes Mal neu erfunden wird, eine Tabelle als
Closure-Notiz-Block:

```markdown
## Carveout-Audit — Welle 2 (2026-06-12)

| Carveout | Status vorher | Status nachher | Aktion |
|---|---|---|---|
| CO-001 (Index-Coverage) | aktiv, Trigger Welle 2 | aufgelöst | git mv nach `done/`; coverage.config-Ausnahme entfernt |
| CO-004 (Compose-Devmode) | aktiv, Trigger "Compose v2.20" | permanent | überführt in ADR-0014 (Devmode als bewusste Architektur) |
| CO-005 (Lock-File-Pin) | aktiv, Letzte Prüfung 2025-12 | aktiv, geprüft | Datum 2026-06-12 nachgetragen, Folge-Slice slice-018 angelegt |
```

Drei Status-Übergänge sind möglich: *aufgelöst* (Trigger eingetreten),
*permanent* (Trigger wird nie eintreten — in ADR überführen),
*weiterhin aktiv* (Trigger weiterhin sinnvoll — Datum nachtragen).

**Schritt 3 — Wer führt den Audit aus?** Rollen-Bezug (Modul 7):
*Planner* identifiziert die fälligen Carveouts vor Welle-Closure,
*Architect* entscheidet bei "permanent" über die ADR-Überführung,
*Implementer* führt die `git mv`-Operationen und Config-Updates aus.
Der Audit-Slice landet damit über drei Rollen verteilt — was *nicht*
ein Defekt ist, sondern Absicht: Carveout-Aufräumen ohne Architect-Blick
verlängert das Lügen.

**Schritt 4 — Audit-Lauf-Gate optional einbauen.** Maschinell prüfbar
ist mindestens die "Letzte Prüfung"-Frische:

```makefile
verify-carveout-freshness:  ## Modul 6 — Audit-Pflicht pro Welle
	@python tools/check_carveout_freshness.py --max-age-days 90

verify: verify-carveout-freshness
```

Ein Carveout, dessen letzte Prüfung > 90 Tage zurückliegt, ist ein
HIGH-Warnsignal — egal, ob der Trigger nominell noch gilt. *Beobachtung
schlägt Behauptung*: ein nicht geprüfter Carveout ist ein nicht
existierender Audit.

**Schritt 5 — Audit-Slice als Schablone festschreiben.** Damit der
Slice in jeder Welle wiederverwendet wird, kommt eine Vorlage unter
`docs/plan/planning/templates/carveout-audit.md`. Der Planner kopiert
sie für jede neue Welle und passt nur das Datum, die betroffenen
Carveouts und den Welle-Bezug an. Ohne Vorlage wird der Audit-Slice
beim dritten Mal vergessen — und die Drift kehrt zurück.

**Schritt 6 — Bewusstes Brechen.** Lasse eine Welle bewusst *ohne*
Audit schließen. Zwei Wellen später: drei aktive Carveouts, deren
Trigger längst eingetreten ist, liegen weiterhin in `carveouts/`. Das
ist die Drift in Aktion. Re-Audit: die drei landen mit `git mv` in
`done/`, eine vierte Drift wandert in eine ADR. Die zentrale Erkenntnis
— *Drift entsteht nicht durch falsches Tun, sondern durch
nicht-getanes Auditieren* — ist genau der Conceptual-Change-Punkt, den
Modul 06 transportiert.

Sechs Schritte, ein wiederkehrender Slice. Der Carveout-Mechanismus
hält nur, wenn er von einem *zweiten* Mechanismus auditiert wird;
sonst ist er eine schöne Konvention, die niemand prüft.

## Übungen

* **Carveout dokumentieren** (Lernziel 1 · Erschaffen·prozedural; folgt [Worked Example A](#worked-example-a-einen-carveout-dokumentieren)). Lege für eine fehlende Coverage-Schwelle eine `CO-<NNN>-*.md`-Datei mit den sechs Pflichtfeldern an (Status, Datum, betroffenes Gate, Geltungsbereich, Folge-Slice, Auflösungs-Trigger). Trage den `# CO-<NNN>`-Kommentar in die Gate-Konfiguration ein. Vergleich: [`../../../lab/example/docs/plan/carveouts/CO-001-index-coverage.md`](../../../lab/example/docs/plan/carveouts/CO-001-index-coverage.md).
* **Folge-Slice verknüpfen** (Lernziel 1, fortgesetzt). Schreibe den Folge-Slice mit konkretem DoD und beobachtbarem Trigger so, dass die Auflösung des Carveouts maschinell erkennbar wird (Schritt 5 in Worked Example A).
* **Carveout-Audit-Slice entwerfen** (Lernziel 4 · Erschaffen·prozedural; folgt [Worked Example B](#worked-example-b-ein-carveout-audit-als-wiederkehrenden-slice-entwerfen)). Schreibe für die *nächste* Welle deines Repos einen `SL-CO-AUDIT-<welle>`-Slice mit vier DoD-Punkten und Rollen-Zuweisung (Planner identifiziert · Architect entscheidet bei Permanenz · Implementer führt aus). Lege die Audit-Bericht-Tabelle (vorher/nachher/Aktion) als Closure-Notiz-Block bei. Provoziere als Fehlerfall: lass *eine* Welle ohne Audit schließen und beobachte, was nach zwei Wellen mit den unauditiierten Carveouts passiert.

## Reflexion

Vier Standardfragen aus [`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)
nach der Carveout-Dokumentation und der Folge-Slice-Verknüpfung.
Modul-spezifische Trigger:

- **Beobachtung:** War dein Trigger beobachtbar oder eine Form von "sobald wir Zeit haben"? Lebt dein Carveout in `docs/plan/carveouts/` oder im Tracker?
- **2×2-Quadrant:** Trigger-Disziplin ist *inferential feedforward*; Carveout-Audit-Lauf ist *computational feedback*.
- **Steering-Loop:** Carveout-Audit als wiederkehrender Slice (siehe Lernziel 4)? Trigger-Pflichtfeld als Frontmatter-Check?
- **Conceptual Change:** Kandidaten in [`lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "Carveout = Workaround", "Wenn der Trigger eintritt, lösen wir den Carveout auf").

## Selbstcheck

* **(Erinnern)** Welche zwei Pflichtfelder hat jeder *temporäre* Carveout, damit er nicht heimlich permanent wird?
* **(Erinnern)** Wo im Repo lebt ein Carveout — Verzeichnis und Datei-Konvention?
* Wann darf ein Carveout das `make gates`-Ziel grün halten, und wann nicht?
* Wie unterscheidet sich ein Carveout von einem Bootstrap-aware Gate (siehe [Modul 12](../04-qualitaet/modul-12-quality-gates.md))?
* **(Erschaffen)** Skizziere einen Carveout-Audit-Slice für die nächste Welle deines Repos: DoD, beteiligte Rollen, Belegartefakt. Welche drei Status-Übergänge muss er möglich machen — und welcher davon ist der unbequemste?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Zwei Pflichtfelder eines temporären Carveouts? | "Beschreibung." | Auflösungs-Trigger (beobachtbar, nicht "sobald wir Zeit haben") + gekoppelter Folge-Slice mit ID. | + Fehlt eines der beiden: der Carveout ist *de facto* permanent — und gehört dann offen als permanenter Carveout markiert oder in eine ADR überführt, statt unter "temporär" zu lügen. |
| Wo lebt ein Carveout? | "Im Tracker." | `docs/plan/carveouts/` als Datei — kommt mit beim Klonen, ist neben Spec/ADR/Plan auditierbar. *Nicht* nur im Issue-Tracker. | + Folge: ein Carveout, der nur im Tracker existiert, taucht im `make gates`-Output nicht auf — und damit weiß ein Implementation-Agent nicht, dass die Schwelle bewusst gesenkt wurde. Das ist eine versteckte Spec-Lücke. |
| Wann hält Carveout `make gates` grün? | "Wenn dokumentiert." | Nur wenn Carveout *im Repo* liegt, einen Auflösungs-Trigger nennt und an einen Folge-Slice gekoppelt ist; sonst muss das Gate rot bleiben. | + Hinweis: ein Carveout, der dauerhaft `make gates` grün hält, *ohne* dass jemals sein Trigger eintritt, ist eine versteckte Architekturentscheidung — sie gehört dann in eine permanente ADR überführt. |
| Carveout vs. bootstrap-aware Gate? | "Beides macht das Gate weicher." | Carveout = Ausnahme für *einen* Fall mit Folge-Slice. Bootstrap-aware Gate = Stufung *des Gates selbst* (z. B. 40 % heute → 70 % bei M2). | + Folge: Bootstrap-aware Gate skaliert mit dem Repo; Carveout ist punktueller Vertrag. Verwechslung führt zu "Bootstrap-Schlupfloch" — Stufung ohne Trigger ist Carveout-Wildwuchs. |
| Carveout-Audit-Slice skizzieren? | "Schaue mir die Carveouts an." | DoD-Punkte: Frische aller `Letzte Prüfung:`-Daten · Auflösung aller Carveouts mit eingetretenem Trigger · explizite Permanenz-Entscheidung für alles, was zwei Wellen "aktiv" stand · Audit-Bericht als Closure-Notiz. Rollen: Planner identifiziert, Architect entscheidet bei Permanenz, Implementer führt `git mv` und Config-Updates aus. Drei Status-Übergänge: *aufgelöst*, *permanent (→ADR)*, *weiterhin aktiv mit nachgetragenem Datum*. | + Der unbequemste Übergang ist *permanent → ADR*: er gibt zu, dass ein angeblich temporäres Konstrukt eine stille Architekturentscheidung war. Wer diesen Übergang nie vollzieht, hat keinen Carveout-Mechanismus, sondern eine Sammlung gut formatierter Lügen. Steering-Loop-Aktion: Audit-Slice als Schablone unter `docs/plan/planning/templates/carveout-audit.md`, sonst bricht der Mechanismus beim dritten Mal. |

## Weiterlesen

* Nächstes Modul: [Modul 7 — Agentenrollen](../03-agenten/modul-07-agentenrollen.md)
