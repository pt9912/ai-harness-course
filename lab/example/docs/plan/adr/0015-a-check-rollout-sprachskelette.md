# ADR-0015: a-check als zweites Layering-Gate — Rollout über die Sprach-Skelette

**Status:** Accepted

**Datum:** 2026-08-09

**Autor:** Kurs-Lab

**Supersedes:** [ADR-0014](0014-a-check-zweites-layering-gate.md) (dort auf den
C++-Pilot beschränkt; diese ADR weitet den Geltungsbereich und übernimmt die
Begründung unverändert)

**Bezug:** [ADR-0001](0001-hexagonale-architektur.md) (Layering und dessen
Fitness Function)

**Schärft:** — (Prozess-ADR ohne Spec-Stratum: die Werkzeugwahl eines Gates ist
kein Vertragspunkt gegenüber einem Abnehmer, sondern eine Harness-Entscheidung)

---

## Kontext

Der C++-Pilot aus ADR-0014 ist gelaufen. Drei Beobachtungen tragen die
Ausweitung:

1. **Der jeweilige Bestandssensor hat blinde Flecken, und es sind andere.**
   `cmake/arch-check.sh` nennt zwei Adapter beim Namen — ein dritter ist
   ungeprüft. Die C#-`ArchitectureTests` prüfen vier Namespace-Paare — für die
   `Types`-Schicht gibt es **gar keine** Regel. Beide Lücken entstehen aus
   derselben Bauform: eine Verbotsliste wächst nur dort, wo jemand an einen
   Fall gedacht hat.
2. **Eine Deklaration ist eine Allow-Liste.** `edges` sagt, was erlaubt ist;
   alles andere ist ein Befund. Damit ist der neue Fall abgedeckt, bevor ihn
   jemand aufschreibt.
3. **Die Deklaration muss so fein sein wie die Aussage von ADR-0001.** Im
   Pilot trug eine gemeinsame `adapters`-Schicht die Vereinigung beider
   Adapter-Kanten und war damit **schwächer** als Regel D des Skripts — im
   Review gefunden, vor dem Merge behoben. Wer gröber deklariert als die Norm,
   baut ein Gate, das grün ist, wo die Norm rot wäre.

## Entscheidung

a-check ist das **zweite Layering-Gate in jedem Sprach-Skelett**. Der jeweilige
Bestandssensor bleibt — die Mechanismus-Vielfalt ist Lehrinhalt des Beispiels,
kein Altlast-Zustand.

1. **Eine Config pro Skelett, Scan-Wurzel ist das Sprachverzeichnis.** **Kein**
   gemeinsamer Scan über `lab/example/`: Go-Importe tragen den Modulpfad
   (`github.com/example/docsearch/internal/ui`) und lösen gegen
   sprach-präfixierte Schicht-Globs (`go/internal/ui/**`) nicht auf. Geprüft:
   Ein eingebauter `service → ui`-Verstoß blieb im Mono-Scan unentdeckt — das
   Gate wäre still grün.
2. **Modelliert wird, was gebaut ist.** Rollen (`role: app`, `role: adapter`)
   nur dort, wo die Schicht sie trägt: Das C++-Skelett hat Ports, das
   C#-Skelett ist geschichtet ohne Ports. Eine Rolle zu setzen, die der Code
   nicht einlöst, meldete Architektur-Verstöße gegen eine Architektur, die hier
   niemand gebaut hat.
3. **Ein Gate, zwei Sensoren.** `make arch-check` ruft beide — und zwar beide
   vollständig, auch wenn der erste rot ist: Der Vergleich der Befund-Mengen
   (siehe Re-Evaluierungs-Trigger) braucht sie nebeneinander. Das Ziel-Set von
   `make gates` bleibt unverändert.
4. **Die Auflösungs-Voraussetzung wird selbst geprüft.** Die Symbol-Auflösung
   setzt je Sprache eine Schreibweise voraus. In C++ ist das der gegen `src/`
   gewurzelte Include; ein elternrelativer (`"../../adapters/ui/x.h"` <!-- d-check:ignore (illustrative Schreibweise, keine Datei) -->) löst auf
   nichts auf **und** entgeht den Greps des Skripts — beide Sensoren blieben
   grün, obwohl der Verstoß compiliert. Eine `constructs`-Regel verbietet die
   Schreibweise und macht damit beide Sensoren erst belastbar. C# hat kein
   Gegenstück: `using` ist immer voll qualifiziert.
5. **Umsetzung skelettweise**, nicht in einem Zug. Stand:

   | Skelett | Bestandssensor | a-check |
   |---|---|---|
   | C++ | `cmake/arch-check.sh` | verdrahtet |
   | C# | NetArchTest | verdrahtet |
   | Go | depguard | verdrahtet |
   | Python | import-linter | verdrahtet |
   | Java | ArchUnit | offen |
   | Kotlin | Konsist | verdrahtet |

   Diese Tabelle ist der Stand der **Umsetzung**, nicht der Entscheidung. Ein
   „offen"-Skelett hat kein `make a-check` — `make help` des Skeletts bleibt
   die autoritative Liste.

## Verglichene Alternativen

### Option A — Alle sechs in einem Zug

- Pro: Kein Zwischenzustand, die Tabelle oben entfiele.
- Contra: Sechs Konfigurationen ohne Zwischen-Auswertung. Der Pilot hat gezeigt,
  dass die Feinheit der Deklaration je Skelett eine eigene Entscheidung ist
  (Rollen ja/nein, Adapter getrennt/gemeinsam) — sechs davon auf einmal
  bekommt kein Review sauber geprüft.

### Option B — Pro Skelett eine eigene ADR

- Pro: Jeder Schritt hat sein Dokument.
- Contra: Fünf `Supersedes`-Ketten für **eine** Werkzeugentscheidung. Der Leser
  müsste sechs ADRs lesen, um den Stand zu kennen.

### Option C — Eine ADR mit Umsetzungs-Stand (gewählt)

- Pro: Die Entscheidung steht einmal; der Fortschritt steht in einer Tabelle,
  die beim Verdrahten mitwandert.
- Contra: Die Tabelle ist eine zweite Stelle neben `make help`, an der der Stand
  steht. Sie kann veralten — deshalb nennt sie den Zustand grob
  (verdrahtet/offen) und nicht die Targets.

## Konsequenzen

- Positiv: Jedes Skelett bekommt eine Allow-Liste statt einer Verbotsliste. Die
  Fälle, an die niemand gedacht hat, fallen auf.
- Positiv: `make a-check-graph` erzeugt das Schichtbild aus derselben
  Deklaration, die das Gate prüft — Diagramm und Gate können nicht
  auseinanderlaufen.
- Grenze: Ein Sensor prüft nur, was seine Auflösung sieht. Bevor eine Schicht
  deklariert wird, gehört die Frage gestellt, welche Schreibweise die Auflösung
  voraussetzt — und ob etwas sie erzwingt. Ohne diesen Schritt ist eine grüne
  Deklaration kein Beleg.
- Negativ: Ein Image-Pin je Skelett, der altert. Er hängt an keinem
  Freshness-Sensor; das Anheben ist Handarbeit und muss dann alle verdrahteten
  Skelette treffen.
- Negativ: Zwei Sensoren für eine Aussage können divergieren. Bei Widerspruch
  gilt ADR-0001, nicht der strengere Lauf — beide sind Sensoren, keine Quelle.
- Grenze: In **Kotlin** teilen sich beide Sensoren eine Lücke — Konsists Regeln
  prüfen `file.imports`, a-check liest Import-Zeilen; eine voll qualifizierte
  Nutzung ohne Import sehen beide nicht. Gemessen: compiliert, a-check 0
  Befunde, Konsist grün. Eine `constructs`-Regel schließt die Richtung auf die
  äußerste Schicht; die übrigen Kanten so abzudecken hieße, den Kanten-Graphen
  ein zweites Mal als Zonen-Listen zu führen — zwei Fassungen einer Wahrheit.
  Der tragfähige Fix liegt im Bestandssensor: Konsist liest den AST ohnehin.
- Grenze: In **Python** ist a-check der schwächere der beiden Sensoren: Es sieht
  nur die absolute Import-Schreibweise, nicht `from ..ui import x`, nicht
  `from docsearch import ui` und nicht das zweite Modul einer Komma-Liste. Alle
  drei fängt `import-linter` über den AST. Der Beitrag von a-check liegt dort
  allein in der Allow-Liste — beim Modul, das kein Contract aufzählt. Gemessen,
  nicht angenommen.
- Grenze: a-check ist **text-heuristisch**. In C++ liest es `#include`, in C#
  `using`-Direktiven. Ein voll qualifizierter Typzugriff **ohne** `using`
  (`DocSearch.Index.VectorIndex x`) ist für a-check unsichtbar — NetArchTest
  sieht ihn, weil es die kompilierte Assembly liest. Das ist der Grund, warum
  der Bestandssensor nicht nur aus didaktischen Gründen bleibt.
- Grenze: Das generierte Fragment ruft `docker` wörtlich auf, nicht `$(DOCKER)`
  wie die übrigen Recipes der Skelette. `make arch-check DOCKER=podman` fährt
  die beiden Sensoren auseinander; auf einem Host ohne `docker`-Binary läuft
  das Gate nicht. Behoben gehört das in `a-check --print-mk`, nicht in eine
  Handkorrektur des Fragments.
- Folgepflicht: Jedes verdrahtete Skelett trägt die Bindung in seinem
  `<sprache>/harness/README.md` §Sensors — ohne diese Zeile wäre das Gate
  nirgends definiert (AGENTS.md §4).

## Fitness Function

| Tooling | Regel | Make-Target |
|---|---|---|
| Bestandssensor je Skelett | wie in ADR-0001 §Fitness Function | `make arch-check` |
| a-check (Container, digest-gepinnt) | `.a-check.yml` je Skelett: Schichten + erlaubte Kanten aus ADR-0001, Rollen nur wo gebaut | `make a-check` (läuft in `make arch-check` mit) |

## Re-Evaluierungs-Trigger

- **Ein Skelett lässt sich nicht ohne Ausnahme-Liste deklarieren**: Wächst
  `markers.ignore_symbols` oder `allow`, ist die Werkzeugwahl für dieses
  Skelett neu zu bewerten — nicht die Liste.
- **Die beiden Sensoren widersprechen sich**: kein stilles Abschalten eines
  Laufs, sondern Befund gegen ADR-0001 prüfen und die Ursache benennen.
- **Alle sechs verdrahtet**: Die Stand-Tabelle wird gegenstandslos; eine
  Nachfolge-ADR ersetzt sie durch die schlichte Aussage, dass a-check überall
  läuft.

## Geschichte

| Datum | Ereignis | Verweis |
|---|---|---|
| 2026-08-09 | Proposed | C++-Pilot (ADR-0014) ausgewertet; C#-Bestandssensor prüft die `Types`-Schicht nicht |
| 2026-08-09 | Accepted | C# verdrahtet (`.a-check.yml`, `a-check.mk`, `arch-check` ruft beide Sensoren); Verweise aus dem C++-Skelett auf diese ADR umgehängt |
| 2026-08-09 | Beleg | Die Asymmetrie der beiden Sensoren in beide Richtungen gemessen: `typeof(DocSearch.UI.Handler)` ohne `using` — a-check 0 Befunde, NetArchTest `Service_Should_Not_Depend_On_UI` rot; `Types → Service` — a-check rot, NetArchTest ohne Regel |
| 2026-08-09 | Nachtrag | Review-Befunde: elternrelativer Include passierte beide C++-Sensoren (`constructs`-Regel ergänzt); Pin auf v0.16.0 korrigiert — der `--print-mk`-Versatz hatte auf den Vorgänger gezeigt; `make arch-check` führt beide Sensoren vollständig aus; AGENTS.md und README beider Skelette nachgezogen |
