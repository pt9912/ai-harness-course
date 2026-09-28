# Regelwerk-Audit über fünf Konsumenten-Repos — Befund

**Stand:** 2026-09-28 — Erstauswertung abgeschlossen (Fünf-Repo-Audit,
read-only). Keine Regelwerk-Änderung daraus umgesetzt. Verbesserungsvorschläge
dazu: [regelwerk-audit-konsumenten-vorschlaege.md](regelwerk-audit-konsumenten-vorschlaege.md).

## Ausgangsfrage

Lässt sich das Regelwerk verbessern, indem man Repos analysiert, die es real
adoptiert haben — statt nur Einzelfall-Rückmeldungen abzuwarten? Einzelne
Konsumenten liefern bereits Change Requests (z. B. die Beobachtungs-Register-
Nebenläufigkeit von d-check), aber ein Einzelfall lässt sich nicht von einer
Repo-Idiosynkrasie unterscheiden. Fünf unabhängige Repos schon.

## Methode

Fünf real vendorende Repos (bestätigt über `.claude/rules/AGENTS.md`,
eigene `harness/conventions/MR-*`, `docs/plan/adr/`, Gates via
`stop-require-gates.sh`):

- d-check
- ai-harness-init
- pg-change-feed
- a-check
- m-trace

(eigenständige Repositories neben diesem Kurs-Repo, nicht Teil davon —
Pfade sind lokal/host-spezifisch und hier bewusst nicht genannt.)

Pro Repo, read-only, kein Diff gegen die kanonische Baseline (bewusst
ausgeklammert — Versions-Drift ist kein Befund, nur die inhaltlichen
Anpassungen zählen):

1. lokale MRs (`harness/conventions/*.md`)
2. `AGENTS.md`/`conventions.md`-Zusätze mit erkennbar realem Auslöser
3. Sensoren/Gates (`a-check.mk`, `.a-check.yml`, `.claude/hooks/*.sh`) —
   Ausnahmen, Ignores, benannte blinde Flecken
4. ADR-/Beobachtungs-Register-Reibung (`docs/reviews/`, `docs/plan/adr/`)
5. Git-Historie der Regelwerk-Pflege
6. offene Slices (`docs/plan/planning/open/`, `next/`) als zusätzliches Signal

## Systematische Befunde (mehrere Repos unabhängig)

### 1. ADR-Immutabilität kollidiert mit Veränderlichem — 4/5 Repos

Jedes Repo hat dasselbe Grundproblem unabhängig und unterschiedlich gelöst:

- **m-trace** (`harness/conventions/MR-002-*.md`, `MR-009-*.md`): Das
  Template gewann nachträglich ein Pflichtfeld (`## Re-Evaluierungs-
  Trigger`). Alte `Accepted`-ADRs (0001–0008) können es nicht rückwirkend
  tragen, ohne die Immutabilitäts-Hard-Rule zu brechen. MR-009 zitiert
  MR-002 explizit als Vorbild — zwei unabhängige Lösungen desselben
  Musters, sechs Wochen auseinander.
- **ai-harness-init** (ADR-0042, bewacht durch `test/mutations/312`,
  `/313`): automatisierte Nachzug-/Move-Werkzeuge
  (`internal/archive/scan.go`, `harness/tools/slice-mv.sh`) mussten
  explizit von `docs/plan/adr/` ausgenommen werden, sonst schreiben sie in
  `Accepted`-ADRs zurück.
- **pg-change-feed** (`docs/reviews/architect-verdict-adr-review-zitat-
  korrektur.md`): 25 `Accepted`-ADRs verlinken live in `docs/reviews/`, die
  laut Baseline-Modell ohne eigene Identität archiviert werden —
  `archive-welle --vorschau` bricht real mit `[haenger]`-Sperre bei 12+
  ADRs ab.
- **a-check** (MR-024, `harness/conventions/MR-024-*.md`): Das Kern-Drift-
  Gate (`make doc-immutable`) kann nicht zwischen einer echten
  Entscheidungsänderung und reinem Pfad-Nachzug in `Accepted`-ADRs
  unterscheiden — drei historische ADRs mussten manuell als „deklarierter
  Befund" freigestellt werden.

Der Kanon (`modul-04-adrs.md`) kennt die Immutabilitäts-Hard-Rule und die
Re-Evaluierungs-Trigger-Pflicht, aber kein generisches Verfahren für „die
Welt um eine akzeptierte ADR ändert sich" (neues Pflichtfeld, verschobene
Referenz, vergänglicher Verweis).

### 2. Prosa-Regel ohne Sensor ist der strukturelle Schwachpunkt — 3/5 Repos

- **pg-change-feed**: Die Eskalationsleiter „3×-Beobachtung → Architect-
  Verdikt → geschärfte Prosa-Instruktion" versagt mehrfach beim 4.
  Auftreten derselben Fehlerklasse (`architect-verdict-slice-chronik-in-
  code-kommentar-4x.md`, `architect-verdict-report-nackte-id-ohne-link-
  4x.md`, `architect-verdict-negativtest-eingabeseite-4x.md`).
- **a-check**: Dieselbe Stelle (ID-Schema-Deklaration in `MR-000`) wurde
  viermal in Folge geflickt (MR-007→013→017→020→023), bevor
  `slice-190` sie strukturell umbaut. Auslöser laut Slice-Text: **3×** hat
  ein Adaptions-Eintrag eine Repo-Aussage statt einer Baseline-Regel
  korrigiert (`slice-097`, `slice-162`, `slice-187`) —
  `BEO-HARNESS/adaption-korrigiert-repo-aussage`.
- **ai-harness-init**: Der mit Abstand größte Cluster im 75-teiligen
  Slice-Rückstau (≈20 von 77 Titeln) ist wörtlich „X hat noch keinen
  Wächter/Sensor/Prüfer" (z. B. `slice-078`, `slice-115`, `slice-142`,
  `slice-222`).

**Wichtig — der Kanon kennt den Mechanismus bereits, nur nicht diese
Grenze:** `modul-06-roadmap.md` §3 (Welle-Closure) beschreibt exakt die
3×-Beobachtungs-Register-Schwelle → „im Regelfall *verkörpert*" →
Steering-Loop-Eintrag, belegt dort schon an einem früheren
Konsumenten-Repo-Fall (Zeile 220–234: „100 % der offenen Slices waren
wellenlose Wartung"). Was die neue Evidenz hinzufügt: **„verkörpert" wird
in der Praxis oft als Prosa gelesen, nicht als Sensor** — und Prosa hat bei
mehreren Repos nachweislich nicht verhindert, dass dieselbe Fehlerklasse
ein weiteres Mal auftritt. Die Lücke liegt nicht im 3×-Schwellenwert
selbst, sondern darin, dass „verkörpert" keine Aussage über die *Form* der
Verkörperung trifft.

### 3. „Braucht eine Config-/Gate-Erweiterung eine eigene ADR?" ist ungeregelt

- **pg-change-feed**, zweimal unabhängig: `docs/reviews/architect-verdict-
  slice-d-check-tracked-modul-adr-frage.md` und `slice-sdk-public-doc-
  check-gate.md` (offene Beobachtung `BEO-PGC/gate-scope-erweiterung-
  ohne-adr-traeger`, 2×). Beide Male wird die Frage über Präzedenzfall
  entschieden, nicht über eine geschriebene Regel.
- Verwandt: **a-checks MR-024** (s. o.) zeigt dieselbe Unschärfe von der
  Gate-Seite — das Gate selbst kann „nur Pfad" nicht von „neue
  Entscheidung" unterscheiden.

`modul-04-adrs.md` hat keine Entscheidungsschwelle für Config-/Tooling-/
Gate-Erweiterungen — nur die generische Aussage „eine ADR entsteht nicht
nur aus Architektur-Fragen".

### 4. Durchsetzungsschicht-Guard-Lücke wird unabhängig identisch gepatcht — d-check + pg-change-feed

- **pg-change-feed** (`MR-003-guard-inplace-textwerkzeug.md`,
  `MR-004-guard-host-python-am-kopf.md`): PreToolUse-Guard blockt
  In-place-Textwerkzeuge und Host-Interpreter-Umwege.
- **d-check** (`.claude/hooks/pretooluse-command-guard.sh:28-37`,
  eigener Grenzen-Kommentar): listet dieselbe Umgehungsklasse
  (Shell-Keyword-Segmentköpfe, Wrapper außerhalb PREFIXES,
  wortinterne Splices, verschachtelte escapte Quotes).

Der Kanon benennt diese Grenze bereits ehrlich
(`grundlagen-durchsetzungsschicht.md` §Grenzen: „Stolperdraht, keine
Sandbox … Interpreter-Umwege bleiben möglich"), bietet aber kein
Referenzmuster — jeder Adopter entdeckt und härtet dieselbe
Umgehungsklasse neu.

## Einzelfall-Befunde mit Kanon-Relevanz

- **Kein Ort für Feedback/Änderungswünsche eines Konsumenten AN den Kanon
  selbst** (d-check, `MR-035-cr-ablage.md`, `MR-036-*.md`). Nicht zu
  verwechseln mit dem kanonischen Begriff „Change Request"
  (`grundlagen-begriffe.md:49`) — der meint die externe Vertragsänderung
  mit dem Auftraggeber (Lastenheft-Ebene) und ist bewusst kein
  Harness-Konstrukt. d-checks Bedarf ist ein anderer: eine Ablage-
  Konvention für ausgehende/eingehende Anfragen an die Baseline selbst —
  dafür hat der Kanon keine Entsprechung.
- **Beobachtungs-Register hat keine Team-/Branch-Nebenläufigkeit**
  (d-check, `docs/plan/cr/2026-08-31-cr-ai-harness-course-observations-
  relational.md`) — bereits als Change Request eingereicht, laut
  bisherigem Stand nach Rückfragen vom Absender selbst verkleinert.
  Bekannt, kein neuer Fund, hier nur der Vollständigkeit halber gelistet.
- **„Wellenlose Arbeit" hat kein Aging** (ai-harness-init): `MR-016` nimmt
  Arbeit ohne Welle bewusst aus dem Roadmap-/WIP-Fluss — Zustand ist das
  Verzeichnis (`open/`), nicht ein Status-Feld. Der 75-teilige Rückstau
  ist eine direkte Folge, kein vergessener Einzelfall (alle zehn ältesten
  offenen Slices tragen `Welle: ohne Welle` und begründen das ausdrücklich
  gegen MR-016). Der Kanon kennt das Muster bereits als „benannte Lücke,
  keine Pflicht" (`modul-06-roadmap.md:39`) — dieser Fund liefert die
  Cluster-Aufschlüsselung dazu (größter Cluster „kein Wächter", zweiter
  Cluster „Verweis-Form vor dem Einfrieren"), aber keinen neuen
  Mechanismus.
- **Zweite Durchsetzungsschicht als wiederverwendbares Härtungsmuster**
  (d-check, `MR-047`/`MR-048`): ein einzelner Guard als Single Point of
  Failure — bisher nur lokal gelöst, kanonisch nirgends als Muster
  vorgesehen.
- **Cross-Reference-Disziplin über Kennungen statt §/Tranche-Verweise**
  (m-trace, `AGENTS.md` §3.8 „Variante-B-Cross-Reference-Disziplin") — der
  Begriff „Variante A/B" existiert kanonisch nirgends, deckt sich aber
  inhaltlich mit dem ID-Schema aus `grundlagen-source-precedence.md`.
  Eher Umbenennung/Verschärfung eines vorhandenen Prinzips als eine echte
  Lücke — niedrige Priorität.
- **Uneinheitlich, ob ein Baseline-Bump eine eigene ADR braucht**
  (m-trace): v3.5.1→v6.8.0-Sprung ohne neue ADR, während ADR-0009 einen
  Kurs-Release mit strukturellen Änderungen selbst als Re-Evaluierungs-
  Trigger benannt hatte. Kein Fehler, aber ungeklärt, wann der Trigger
  greift.
- **CVE-Cluster-Carveout vs. Einzel-CO-Datei** (m-trace, `MR-006`): ein
  CVE-Cluster (transitive OS-CVEs) läuft über eine zentrale
  `.security/vulnignore.yaml` statt über ein `CO-<NNN>`-File je CVE —
  `modul-07-carveouts.md` kennt nur die Einzel-CO-Form als Ziel-Form.

## Offene Slices als Signal — Zusammenfassung

| Repo | Offen/Next | Befund |
| --- | --- | --- |
| d-check | 0 | kein Rückstau |
| m-trace | 0 | kein Rückstau |
| pg-change-feed | 3 | alle frisch (25.–27.9.2026), normaler Durchsatz; eine (`slice-sdk-public-doc-check-gate.md`) bestätigt Befund 3 |
| a-check | 5 | zwei alt (seit 2026-06-23 / 2026-07-25) aber bewusst vertagt mit Wiedervorlage-Trigger, kein Stau; eine (`slice-190`) bestätigt Befund 2 |
| ai-harness-init | 75 + 7 | struktureller Rückstau durch MR-016 (Befund „Wellenlose Arbeit hat kein Aging"); größter Cluster bestätigt Befund 2 |

## Belege (Pfade je Repo)

- **d-check**: `harness/conventions.md` (Tabelle „Ersetzt-Baseline-Regel"),
  `MR-035/036/039/047/048/052/053/054/066/069/070-*.md`,
  `.claude/hooks/pretooluse-command-guard.sh:28-37`, `.a-check.yml:15-21`,
  `harness/sensors/adr-check.md:18-25`, `.claude/hooks/stop-require-
  gates.sh:7-10`, `docs/plan/adr/0082-*.md`, `0083-*.md`, `docs/plan/cr/
  2026-08-31-cr-ai-harness-course-observations-relational.md`,
  `docs/reviews/2026-09-27-slice-238-*-review-r1.md:84-85`.
- **ai-harness-init**: `.harness/baseline/v6.9.0/regelwerk/*` (Symlinks),
  `harness/conventions/MR-031-*.md`, `MR-045-*.md`, `MR-052..073-*.md`
  (d-check-Pin-Kette), `.claude/hooks/pretooluse-agent-guard.sh:3-24`,
  `.claude/hooks/pretooluse-commit-msg-guard.sh`, `.claude/hooks/stop-
  require-gates.sh`, `test/mutations/312.sh`, `/313.sh`, `/299.sh`,
  `/300.sh`, `docs/plan/planning/open/*.md` (75 Dateien),
  `docs/plan/planning/next/*.md` (7 Dateien).
- **pg-change-feed**: `AGENTS.md:233-697` (§3.7–§3.15),
  `harness/conventions/MR-001..004-*.md`, `.a-check.yml:15-47`,
  `a-check.mk:4`, `.claude/hooks/pretooluse-command-guard.sh:22,50-58`,
  `.claude/hooks/stop-require-gates.sh:8-9`, `docs/reviews/architect-
  verdict-*.md` (256 Dateien insgesamt), `docs/plan/planning/open/
  slice-capture-transient-wiederholung.md`, `/slice-code-kommentare-
  bereinigung.md`, `/slice-sdk-public-doc-check-gate.md`.
- **a-check**: `harness/conventions/MR-012/014/015/016/019/020/022/023/
  024-*.md`, `docs/plan/planning/observations/BEO-HARNESS/adaption-
  korrigiert-repo-aussage/state.md`, `AGENTS.md:283-328`, `docs/reviews/
  2026-09-06-slice-166-mr020-adr-vorlage-generisch.md`,
  `docs/plan/planning/open/slice-013/045/189/190/191-*.md`.
- **m-trace**: `harness/conventions/MR-001/002/003/006/007/008/009-*.md`,
  `AGENTS.md:88-93,160-169`, `a-check.mk:1-4`, `.a-check.yml`,
  `.github/workflows/benchmark-observation.yml:5-8`, `docs/plan/adr/
  0009-*.md`, `0011-*.md`, `docs/reviews/2026-09-13-welle-02.md:93-98`.
