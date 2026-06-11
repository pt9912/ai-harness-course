# Lösung — Modul 10: Review Harness

Zugehöriges Modul: [Modul 10 — Review Harness](../04-qualitaet/modul-10-review-harness.md).

## Selbstcheck-Antworten

### (Erinnern) Welche vier Finding-Kategorien gibt es, und welche zwei blockieren typischerweise den Merge?

Die vier Kategorien:

- **HIGH** — blockiert Merge: Sicherheits-, Korrektheits- oder ADR-Verstoß.
- **MEDIUM** — sollte vor Merge geklärt werden; formal nicht *immer* Blocker, aber Standard-Erwartung.
- **LOW** — nice-to-fix, blockiert nicht.
- **INFO** — Hinweis ohne erwartete Aktion.

Harter Blocker: **HIGH**. Soll-Blocker: **MEDIUM**.

Die LOW/MEDIUM-Trennlinie ist *repo-spezifisch* und gehört in den
Reviewer-Skill (`.harness/skills/reviewer.md`). Ohne Skill-Eintrag
wandert dieselbe Beobachtung zwischen Läufen — und genau das war der
Anlass für das Skill-Konzept im Worked Example von Modul 10.

### Wann wird aus einem LOW-Finding ein HIGH-Finding?

Die Kategorie ist *kontextabhängig*. Ein und dasselbe Finding kann
wandern, wenn:

- Der **Geltungsbereich** sich erweitert. Eine unbenutzte Variable in einem Hilfsskript ist LOW. Dieselbe unbenutzte Variable in einem Sicherheits-Check-Pfad ist HIGH, weil sie nahelegt, dass ein Check vergessen wurde.
- Das **Wiederholungs-Muster** sichtbar wird. Ein einmaliges Typing-Lapsus ist LOW. Dasselbe Muster zum dritten Mal in derselben Sitzung ist ein Symptom — und damit MEDIUM oder HIGH, weil es auf eine Lücke in AGENTS.md oder einer ADR hinweist.
- **Externe Wirkung** sich ändert. Ein dokumentations-Tippfehler ist LOW. Derselbe Tippfehler in einer öffentlichen API-Beschreibung, die in eine Vertrags-Doku eingeht (Compliance-Repo), ist HIGH.
- Der **Slice in Produktion** geht. Was im Lab LOW war, kann im Release MEDIUM oder HIGH werden — Stichwort: fail-closed.

Faustregel: Wenn Reviewer und Implementer über die Kategorisierung
streiten, ist die Spec oder die ADR-Schicht zu vage. Streit über
Kategorisierung ist ein Steering-Loop-Signal: die Klassifikations-Regel
gehört geschärft.

### (Bewerten — aktiviert LZ 1) Zwei Findings: unbenutzter Import vs. fehlende Auth-Prüfung

- **A (unbenutzter Import im Auth-Modul) = LOW.** Stilistisch, keine
  semantische Auswirkung — exakt die LOW-Definition aus dem
  Reviewer-Skill ("unbenutzte Imports"). Dass er im *Auth-Modul* liegt,
  macht ihn nicht automatisch HIGH: der Anker ist die *Wirkung*, nicht
  der Ort. (Anders läge der Fall bei einer unbenutzten *Variable* in
  einem Sicherheits-Check-Pfad — die legt nahe, dass ein Check
  vergessen wurde; siehe LOW→HIGH-Wanderung oben.)
- **B (fehlende Auth-Prüfung an neuem Endpoint) = HIGH.**
  Sicherheits-Anti-Pattern im kritischen Pfad. "Noch nicht produktiv"
  mildert *nicht*: mit dem Merge wird der Endpoint erreichbar, und
  kein späteres Gate erinnert daran, die Prüfung nachzurüsten.

Die Grenzfall-Begründung: B kippt nicht durch gefühlte "Wichtigkeit"
nach HIGH, sondern durch den festen Anker *Sicherheit/Korrektheit im
kritischen Pfad* aus der HIGH-Liste. A bleibt LOW — würde aber bei
dreimaliger Wiederholung desselben Musters nach MEDIUM wandern
(Wiederholungs-Trigger). Beide Trennlinien gehören repo-spezifisch in
den Reviewer-Skill (`.harness/skills/reviewer.md`), sonst wandern sie
zwischen Läufen.

### (Analysieren — aktiviert LZ 1) Drei Prüf-Situationen — welche Review-Art?

| Fall | Review-Art | Wogegen wird geprüft |
|---|---|---|
| **A** — Slice-Plan sieht synchronen Index-Write im Request-Pfad vor, ADR-0012 verlangt Temp-File + Atomic Rename | **Plan-Review** | Plan gegen Spec und Accepted-ADRs (hier: ADR-0012) — der Verstoß steht schon im *Vorhaben*, es gibt noch keinen Diff |
| **B** — Diff führt in `service/` einen direkten `requests`-Import ein, obwohl der Plan den Adapter-Weg nennt | **Code-Review** | fertiger Diff gegen Plan und Konventionen (AGENTS.md, Hard Rules, Layer-Regel) |
| **C** — neue Komponente "Export-Worker" soll direkt auf den Index-Store zugreifen; Code existiert noch nicht, der Schnitt steht zur Diskussion | **Design-Review** | Komponenten-Schnitt gegen Architektur: Layer-Grenzen, Schnittstellen, ADR-Verträglichkeit |

Die drei Arten unterscheiden sich nicht im *Wie* (alle liefern
kategorisierte Findings), sondern im *Wogegen* und im *Wann*.
Kosten-Pointe: Fall A erst im Code-Review zu fangen kostet den ganzen
Implementierungs-Lauf — je früher die Review-Art, desto billiger das
Finding. Ein Plan-Review-HIGH kostet nur eine Plan-Korrektur.

### (Analysieren — aktiviert LZ 3) Dasselbe Finding zweimal mit unterschiedlicher Kategorie — erst Ursache, dann Gegenmaßnahme

Drei mögliche Ursachen, jede mit eigenem Erkennungszeichen und eigener
Gegenmaßnahme — die Diagnose kommt *vor* der Aktion:

| Ursache | Woran erkennbar | Gegenmaßnahme |
|---|---|---|
| **Kategorie-Drift** (unscharfe HIGH/MEDIUM-Grenze) | Beide Läufe hatten *denselben* Eingangs-Kontext; das Finding liegt an einer Grenze, die der Skill nicht fixiert (z. B. "fehlender Negativtest" — MEDIUM-Liste vage) | Reviewer-Skill schärfen: Klassifikations-Anker für genau diese Grenze in `.harness/skills/reviewer.md` ergänzen |
| **Kontext-Unterschied** | Diff der Eingangs-Kontexte zeigt Differenz: beim ersten Lauf war z. B. die ADR im Kontext, beim zweiten nicht — der Reviewer ist ohne Vertrag lascher oder strenger | Eingangs-Kontext fixieren: Pflichtblock "Kontext-Eingang" im Skill, nicht ad hoc zusammenstellen |
| **Nicht-Determinismus** | Kontext identisch, Regel scharf — und die Kategorie streut trotzdem über mehrere Läufe | Modell/Seed pinnen; Erwartung kalibrieren: *ähnliche* Findings, stabile Kategorien-*Verteilung*, nie Identität (inferential feedback ist nie deterministisch) |

Warum "die mildere Kategorie nehmen" die falsche Antwort ist: Der
Agent hat sich nicht "selbst korrigiert" — er sah einen anderen Kontext
oder würfelt an einer vagen Grenze. Die mildere Antwort als Wahrheit
zu akzeptieren belohnt Inkonsistenz und ist *Reward Hacking* der
Klassifikations-Disziplin: künftige Läufe lernen, dass Vagheit sich
auszahlt. Jede Divergenz ist ein Steering-Loop-Signal, kein
Auswahl-Angebot.

### (Anwenden) 17 Findings — welche ersten drei Aktionen?

1. **Nach Kategorie sortieren, HIGH zuerst lesen.** Findings ohne
   Kategorie sind Mängelliste, nicht Entscheidungsvorlage — wenn der
   Reviewer-Agent das nicht liefert, ist sein Skill zu schwach (Modul 10
   §"Reviewer berichtet auch, was er nicht gefunden hat").
2. **HIGH-Findings prüfen — gegen welche Quelle?** Jedes HIGH muss eine
   *Quelle* nennen (ADR-ID, Hard Rule, LH-ID). Wenn keine Quelle:
   Reviewer-Skill hat keine "Klassifikations-Anker" — Steering-Loop-Eintrag.
3. **MEDIUM-Findings clustern, LOW/INFO erstmal überspringen.** Wenn
   mehrere MEDIUM derselben Klasse vorliegen (z. B. "fehlende
   Negativtests in fünf Endpunkten"), wandert das Cluster nach oben — es
   ist ein Symptom einer Spec-Lücke, kein Einzelproblem.

Die Falle (siehe Engage von Modul 10): am ersten LOW-Finding hängenbleiben,
zwei Stunden Tippfehler beheben, vier HIGH-Findings unten gehen unter.
HIGH zuerst, immer — auch wenn die LOW-Findings einfacher aussehen.

## Übungshinweise

### (Anwenden — aktiviert LZ 2) Reviewer-Lauf reproduzierbar einrichten

Vorgehen: zweimal auf demselben Diff laufen lassen, Findings-Anzahl
und Kategorien-Verteilung vergleichen. Wenn die Läufe auseinanderlaufen,
fehlt (mindestens) eine der drei Reproduzierbarkeits-Voraussetzungen:

1. **Skill-Datei in `.harness/`** — ohne `.harness/skills/reviewer.md`
   driftet die Klassifikation zwischen Sessions (häufigste Ursache).
2. **Fixierter Eingangs-Kontext** — Diff, Spec-Auszug, referenzierte
   ADRs, AGENTS.md §Hard Rules müssen in *beiden* Läufen identisch
   geladen sein.
3. **Gepinntes Modell/Seed** — Modellversion und Sampling-Parameter
   konstant halten.

Stelle *eine* Voraussetzung her und lass erneut zweimal laufen — so
siehst du, welcher Hebel wie viel Stabilität bringt.

Erfolgskriterium richtig lesen: gleiche Eingabe → *ähnliche* Findings,
nicht identische. Der inferential-feedback-Quadrant ist nie
deterministisch; stabil werden muss die **Kategorien-Verteilung**
(dasselbe HIGH bleibt HIGH), nicht der Wortlaut. Weitere Maßstäbe für
einen brauchbaren Lauf:

- Jedes Finding ist *kategorisiert* — kein Finding ohne HIGH/MEDIUM/LOW/INFO.
- Jedes HIGH-Finding nennt die *Quelle* (ADR-ID, Anforderungs-ID oder Hard Rule).
- Reviewer berichtet auch das, was er *nicht* gefunden hat ("keine Sicherheits-Anti-Pattern in `internal/auth/`") — Negativbefunde sind Vertrauen.

### Reviewe den fingierten kaputten Slice

Der Slice unter
[`/lab/example/exercises/09-review-fixture/`](../../../lab/example/exercises/09-review-fixture/)
enthält drei eingebaute Fehler, die in *drei verschiedene Kategorien*
fallen sollen. Erwarteter Befund (bezogen auf das Cache/Service-Layer-Szenario):

- **Ein HIGH** — *ADR-Verstoß*: DoD-Item 2 *"Cache umgeht den Index-Layer komplett"* verletzt ADR-0001 (Hexagonale Architektur, [`/lab/example/docs/plan/adr/0001-hexagonale-architektur.md`](../../../lab/example/docs/plan/adr/0001-hexagonale-architektur.md)). Der Service-Layer darf den Index-Layer nicht überspringen. Korrektur: *Read-through-Cache* hinter dem Index-Layer, nicht davor. Reviewer muss ADR-0001 im Eingangs-Kontext haben — ohne ADR im Kontext bleibt der Verstoß unsichtbar (genau das ist Lehrstoff: Reviewer-Eingang ist Pflicht, nicht Komfort).
- **Ein MEDIUM** — *Spec-Lücken-Symptom plus Selbstabsolution*: Abschnitt 6 begründet das Stale-Read-Risiko mit *"… aber das ist OK, weil Cache eh nur 1 Minute TTL hat"*. Die Begründung absolviert sich selbst, ohne gegen LH-QA-01 (Performance + Korrektheit) evaluiert zu werden. Reviewer-Frage: was geschieht, wenn ein Reindex *gleichzeitig* mit Cache-Hits läuft? Wenn der Slice das nicht beantwortet, ist die Spec an dieser Stelle stumm — und 1 Minute TTL ist eine Setzung ohne Beleg.
- **Ein LOW** — *stilistisch ohne semantische Auswirkung*: Der Closure-Trigger (Abschnitt 5) lautet *"DoD vollständig, Cache funktioniert"*. Das ist tautologisch — ein Trigger soll ein *überprüfbares Ereignis* sein (Latenz-Messung im Closure-Eintrag, Cache-Hit-Rate über drei Tage), nicht ein Selbstbezug auf die DoD.

Wenn dein Reviewer-Agent nur HIGH-Findings produziert, ist er
übersensibilisiert; nur LOW deutet auf zu schwache Skills hin. Wenn er
das HIGH *nicht* findet, hatte er ADR-0001 nicht im Eingangs-Kontext —
prüfe die Reviewer-Eingabe, nicht das Modell.

### (Analysieren — aktiviert LZ 3) Reviewer-Konflikt diagnostizieren

Vorgehen: zwei Läufe auf demselben Slice vergleichen, einen Fall mit
divergierender Kategorie herausgreifen, *zuerst* die Ursache bestimmen,
*dann* die Gegenmaßnahme wählen. Die Diagnose-Tabelle steht oben im
Selbstcheck-Teil (Kategorie-Drift · Kontext-Unterschied ·
Nicht-Determinismus); für die Übung zählt die Reihenfolge:

1. **Eingangs-Kontexte diffen.** Unterschied gefunden → Ursache ist
   Kontext-Unterschied; Gegenmaßnahme: Kontext-Eingang als Pflichtblock
   fixieren. Kein Unterschied → weiter.
2. **Skill-Regel für die betroffene Grenze lesen.** Ist die
   HIGH/MEDIUM-Grenze für genau diesen Finding-Typ unscharf oder gar
   nicht geregelt → Kategorie-Drift; Gegenmaßnahme: Skill schärfen.
   Regel ist scharf → weiter.
3. **Mehrfach laufen lassen.** Streut die Kategorie trotz identischem
   Kontext und scharfer Regel → Nicht-Determinismus; Gegenmaßnahme:
   Seed/Modell pinnen und Stabilität auf Verteilungs-Ebene messen.

Häufiger Übungsfehler: bei der ersten Divergenz sofort "Skill schärfen"
rufen, ohne die Kontexte zu diffen. Wer die Gegenmaßnahme vor der
Diagnose wählt, repariert mit 2/3 Wahrscheinlichkeit den falschen Hebel.

### (Erschaffen — aktiviert LZ 4) Reviewer-Skill für ein konkretes Repo schreiben

Aufbau nach den sechs Schritten des Worked Example: Pfad/Kopf ·
Eingangs-Kontext · Kategorien-Regeln · Anti-Pattern/"Was bist du
nicht" · Output-Schema · Steering-Loop-Eintrag. Ablageort:
`.harness/skills/reviewer.md` im gewählten Repo.

Beispiel-Konstruktion für das Fallstudien-Repo `grid-gym`
(gekürzt auf die Repo-spezifischen Teile — der generische Rumpf folgt
dem Worked Example):

```markdown
# Reviewer-Skill — grid-gym

* Status: Accepted
* Bezug: AGENTS.md §"Hard Rules", noqa-gate, Docker-only-Regel
* Gilt für: `agent-review`-Make-Target

## Kontext-Eingang (Pflicht)

- Diff des PR
- AGENTS.md §"Hard Rules"
- ADRs, deren ID im PR/Commit vorkommt
- vorherige Findings am gleichen Modul (letzte 5 PRs)

## Klassifikation

**HIGH** — eines der folgenden:
- generisch: ADR-Verstoß, Sicherheits-Anti-Pattern,
  Korrektheitsfehler im kritischen Pfad
- repo-spezifisch 1: **`git mv` + Inhaltsänderung im selben
  Commit** — bricht die Rename-Detection (< 50 % Similarity),
  `git log --follow` wird unzuverlässig
- repo-spezifisch 2: **Toolchain-Aufruf außerhalb Docker**
  (`uv run`, `pip install`, lokales `.venv` im Diff oder in
  Skripten) — verletzt die Docker-only-Hard-Rule
- repo-spezifisch 3: **`# noqa` inline** ohne Eintrag in
  `pyproject.toml` — Suppression eines Gates ohne Begründung
```

Begründung der Konstruktion: Die Pflicht aus der Übung — mindestens
*zwei* Repo-spezifische HIGH-Regeln, die ein generischer Skill nicht
abdeckt — ist hier mit drei erfüllt; jede stammt aus einer dokumentierten
Hard Rule des Repos (Fallstudien-Anker), nicht aus allgemeinem
Geschmack. Genau das macht den Skill scharf: ein generischer Reviewer
würde `uv run python tools/foo.py` nie beanstanden.

Abnahme-Test der Übung: ein Lauf auf einem realen Diff muss mindestens
eines der Repo-spezifischen HIGHs *zur Anwendung* bringen. Wenn nicht,
ist entweder der Diff zu harmlos gewählt oder der Skill zu vage
formuliert ("achte auf saubere Commits" statt "git mv + Inhalt = zwei
Commits") — vage Anker werden vom Modell zu Geschmacks-Findings
verwässert. Zweiter Abnahme-Punkt: Negativbefund-Zeile pro betrachtetem
Verzeichnis im Output-Schema verankert, und die Pflege-Regel
(Skill wird versioniert, nie überschrieben) übernommen.

- **Reviewer als zweiter Implementer.** "Hier ist mein Vorschlag, wie du es schreiben könntest." → Reviewer kategorisiert Findings; Lösungsvorschläge sind nett, aber kein Reviewer-Ergebnis.
- **Reviewer ohne Skill-Datei.** → Verhalten driftet zwischen Sessions. Jeder Reviewer-Agent braucht ein Skill-Dokument mit "worauf achtest du in diesem Repo".
- **Findings-Liste ohne Prioritätssortierung.** → Auftragnehmer arbeitet sequenziell ab und steckt oft beim LOW-Finding fest. HIGH zuerst, immer.

## Verweise

- 2×2-Klassifikation + Maintainability-Kategorie: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md) — Review ist Inferential + Feedback, primär in der Maintainability-Kategorie.
- Vorherige Lösung: [Modul 9](modul-09-loesung.md)
- Nächste Lösung: [Modul 11](modul-11-loesung.md)
