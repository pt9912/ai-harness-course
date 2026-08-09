# ADR-0016: a-check ist das zweite Layering-Gate in allen Sprach-Skeletten

**Status:** Superseded by [ADR-0017](0017-kotlin-luecke-am-bestandssensor-geschlossen.md)

**Datum:** 2026-08-09

**Autor:** Kurs-Lab

**Supersedes:** [ADR-0015](0015-a-check-rollout-sprachskelette.md) (dort mit
einer Stand-Tabelle des Rollouts; der Rollout ist abgeschlossen, die Tabelle
damit gegenstandslos — ihr Re-Evaluierungs-Trigger verlangt genau diese ADR)

**Bezug:** [ADR-0001](0001-hexagonale-architektur.md) (Layering und dessen
Fitness Function)

**Schärft:** — (Prozess-ADR ohne Spec-Stratum: die Werkzeugwahl eines Gates ist
kein Vertragspunkt gegenüber einem Abnehmer, sondern eine Harness-Entscheidung)

---

## Kontext

ADR-0015 entschied den Rollout und führte eine Tabelle mit, welche Skelette
schon verdrahtet waren. Alle sechs sind es. Die Tabelle beschreibt jetzt nur
noch, dass nichts mehr offen ist — sie stand in `§Entscheidung` und ist damit
Teil einer Aussage („skelettweise, nicht in einem Zug"), die sich erledigt hat.

Der Rollout hat außerdem eine Annahme widerlegt, die in ADR-0015 noch trug. Dort
hieß es sinngemäß, ein AST- oder Bytecode-basierter Bestandssensor decke die
Schreibweisen ab, für die a-check blind ist. Das stimmt für `import-linter`,
NetArchTest und ArchUnit — aber nicht für Konsist: Das Werkzeug *könnte* den AST
lesen, seine Regeln im Kotlin-Skelett sind gegen `file.imports` geschrieben und
liegen damit auf derselben Ebene wie a-check. Das tragende Merkmal ist die
**Bauform der Regel**, nicht die Klasse des Werkzeugs.

## Entscheidung

1. **a-check ist das zweite Layering-Gate in jedem Sprach-Skelett.** Der
   jeweilige Bestandssensor bleibt — die Mechanismus-Vielfalt ist Lehrinhalt
   des Beispiels, kein Altlast-Zustand. Ein Stand wird nicht mehr geführt;
   welche Targets ein Skelett hat, sagt sein `make help`.
2. **Eine Config pro Skelett, Scan-Wurzel ist das Sprachverzeichnis.** **Kein**
   gemeinsamer Scan über `lab/example/`: Go-Importe tragen den Modulpfad und
   lösen gegen sprach-präfixierte Schicht-Globs nicht auf; ein eingebauter
   Verstoß blieb im Mono-Scan unentdeckt — das Gate wäre still grün.
3. **Modelliert wird, was gebaut ist.** Rollen (`role: app`, `role: adapter`)
   nur dort, wo die Schicht sie trägt: Das C++-Skelett hat Ports, die übrigen
   fünf sind geschichtet ohne Ports und tragen deshalb reine Kanten.
4. **Ein Gate, zwei Sensoren.** `make arch-check` ruft beide, und zwar beide
   vollständig — ein Abbruch nach dem ersten roten zeigt immer nur eine
   Befund-Menge. Das Ziel-Set von `make gates` bleibt unverändert.
5. **Vor einem siebten Skelett: die Regeln des Bestandssensors lesen, nicht
   sein Datenblatt.** Welche Schreibweise setzt die Symbol-Auflösung voraus,
   welche umgeht sie, und erzwingt irgendetwas die vorausgesetzte? Die Antwort
   ist am Skelett zu belegen — Verstoß in der umgehenden Schreibweise einbauen,
   beide Sensoren laufen lassen. Ohne diesen Schritt ist eine grüne Deklaration
   kein Beleg.

## Verglichene Alternativen

### Option A — ADR-0015 stehen lassen, nur die Tabelle nachpflegen

- Pro: Keine dritte ADR in der Kette, keine 46 umgehängten Verweise.
- Contra: Die Tabelle steht in `§Entscheidung` und gehört zur Aussage
  „skelettweise, nicht in einem Zug". Sie dort zu entfernen wäre eine Änderung
  am Entscheidungstext einer `Accepted`-ADR — Nachpflege deckt Geschichte- und
  Index-Tabellen, nicht den Entscheidungs-Körper.

### Option B — Die Tabelle einfach vollständig stehen lassen

- Pro: Nichts zu tun.
- Contra: Sie wäre eine zweite Quelle für einen Zustand, der sich aus
  `make help` je Skelett ergibt — genau die Bauform, die
  [`docs/plan/planning/README.md` §Aktueller Stand](../planning/README.md#aktueller-stand)
  für Slices verbietet, und die ADR-0015 selbst als Contra ihrer Option C nannte.

### Option C — Nachfolge-ADR ohne Stand (gewählt)

- Pro: Der Entscheidungs-Körper enthält keinen Zustand mehr, der veralten kann.
- Pro: Die dauerhafte Erkenntnis des Rollouts — die Grenzen je Skelett — steht
  an einer Stelle statt verteilt über Rollout-Notizen.
- Contra: 46 Verweise in 29 Dateien mussten auf die aktive ADR umgehängt
  werden. Das ist der Preis der Immutability-Konvention und war Handarbeit.

## Konsequenzen

- Positiv: Jedes Skelett hat eine Allow-Liste statt einer Verbotsliste. Die
  Fälle, an die niemand gedacht hat, fallen auf — in jedem der sechs Skelette
  belegt (dritter Adapter, `Types`-Schicht ohne Regel, neues Paket, neues
  Modul).
- Positiv: `make a-check-graph` erzeugt das Schichtbild aus derselben
  Deklaration, die das Gate prüft.
- **Grenzen je Skelett.** a-check liest die Import-Anweisung; blind ist es für
  die Schreibweise, die daran vorbei koppelt. Ob daraus eine Gate-Lücke wird,
  entscheidet der Bestandssensor:

  | Skelett | Umgehende Schreibweise | Bestandssensor sieht sie? |
  |---|---|---|
  | C++ | elternrelativer `#include` | **nein** — Skript grept Text; per `constructs`-Regel verboten |
  | Kotlin | voll qualifizierter Typ ohne `import` | **nein** — Konsist prüft `file.imports`; `constructs` deckt nur die Richtung auf `ui` |
  | C# | voll qualifizierter Typ ohne `using` | ja — NetArchTest liest die Assembly |
  | Java | voll qualifizierter Typ ohne `import` | ja — ArchUnit importiert Bytecode |
  | Python | relativ, Subpaket-Form, Komma-Liste | ja — `import-linter` löst den AST auf |
  | Go | keine — der Compiler weist relative Importe ab | entfällt |

  In Python ist a-check damit der **schwächere** der beiden Sensoren; sein
  Beitrag liegt dort allein in der Allow-Liste.
- Negativ: Sechs Image-Pins, die altern. Sie hängen an keinem Freshness-Sensor;
  das Anheben ist Handarbeit und muss alle sechs in einem Commit treffen.
- Negativ: Zwei Sensoren für eine Aussage können divergieren. Bei Widerspruch
  gilt ADR-0001, nicht der strengere Lauf — beide sind Sensoren, keine Quelle.
- Grenze: Das generierte Fragment ruft `docker` wörtlich auf, nicht `$(DOCKER)`
  wie die übrigen Recipes. `make arch-check DOCKER=podman` fährt die beiden
  Sensoren auseinander. Behoben gehört das in `a-check --print-mk`, nicht in
  eine Handkorrektur des Fragments.
- Folgepflicht: Jedes Skelett trägt die Bindung in seinem
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
- **Konsists Regeln werden auf Typ-Referenzen gehoben**: Dann entfällt der
  geteilte blinde Fleck im Kotlin-Skelett, und die dortige `constructs`-Regel
  ist neu zu bewerten.

## Geschichte

| Datum | Ereignis | Verweis |
|---|---|---|
| 2026-08-09 | Proposed | Rollout abgeschlossen; Stand-Tabelle in ADR-0015 §Entscheidung 5 gegenstandslos, deren Re-Evaluierungs-Trigger eingetreten |
| 2026-08-09 | Accepted | 46 Verweise in 29 Dateien auf diese ADR umgehängt; Grenzen je Skelett aus dem Rollout hier zusammengeführt |
| 2026-08-09 | Superseded | [ADR-0017](0017-kotlin-luecke-am-bestandssensor-geschlossen.md) — Konsists Regeln auf Quelltext gehoben, die Kotlin-Zeile der Grenzen-Tabelle und die `constructs`-Regel damit ueberholt |
