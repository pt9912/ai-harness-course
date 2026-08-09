# Slice 024: Konsist-Regeln auf den Quelltext heben

**Lifecycle:** Der Zustand dieses Slice ist das Verzeichnis, in dem diese
Datei liegt — eines von `open/`, `next/`, `in-progress/`, `done/`. Er wechselt
nur durch `git mv` (Kurs
[Modul 5 §Lifecycle als State Machine](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#lifecycle-als-state-machine)).

**Welle:** ohne Welle — die Closure-Bedingung ist die DoD dieses Slice.

**Bezug:** [ADR-0001](../../adr/0001-hexagonale-architektur.md) (die Aussage,
die beide Sensoren prüfen),
[ADR-0017](../../adr/0017-kotlin-luecke-am-bestandssensor-geschlossen.md)
(Entscheidung)

**Berührte Spec-Stellen:** —

**Autor:** Kurs-Lab. **Datum:** 2026-08-09.

## 1. Ziel

Den einzigen verbliebenen geteilten blinden Fleck schließen: Im Kotlin-Skelett
sahen **beide** Sensoren eine voll qualifizierte Nutzung ohne Import nicht.
Die Konsist-Regeln waren gegen `file.imports` geschrieben und lagen damit auf
derselben Ebene wie a-check.

## 2. Definition of Done

- [x] Konsist-Regeln prüfen den Quelltext (ohne Kommentare, ohne die eigene
      `package`-Zeile) statt nur `file.imports`.
- [x] Fünfte Regel ergänzt: `types` darf keine andere Schicht nennen — dafür
      gab es bisher keinen Test.
- [x] Break-Test: `service → ui` und `index → service` jeweils voll
      qualifiziert ohne Import → rot; unveränderter Baum → grün.
- [x] `constructs`-Regel in `kotlin/.a-check.yml` entfernt, nachdem gemessen
      ist, dass sie nichts mehr trägt.
- [x] `ADR-0017` löst `ADR-0016` ab und trägt deren Entscheidung **vollständig**
      weiter; Verweise umgehängt, Abschnitts-Zeiger geprüft.
- [x] `make gates` grün (`COURSE_LANG=kotlin`), `make verify` grün.
- [x] Closure-Notiz.

## 3. Plan (vor Code)

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| `kotlin/src/test/.../ArchitectureTest.kt` | update | Quelltext statt Import-Liste; fünfte Regel |
| `kotlin/.a-check.yml` | update | `constructs`-Regel entfällt |
| `kotlin/AGENTS.md`, `kotlin/harness/README.md` | update | Was die beiden Sensoren sehen |
| `docs/plan/adr/0017-…` | neu | Nachfolge-ADR |

## 4. Trigger

- Re-Evaluierungs-Trigger der abgelösten ADR: *Konsists Regeln werden auf
  Typ-Referenzen gehoben.*

## 5. Risiken

| Risiko | Wahrscheinlichkeit | Gegenmaßnahme |
|---|---|---|
| Der Text-Vergleich meldet Kommentare und die eigene `package`-Zeile | hoch | beide gefiltert; Kontrolllauf am unveränderten Baum |
| Die Zusatzregel wird aus Gewohnheit behalten | mittel | gemessen, dass sie nichts mehr trägt, bevor sie fällt |
| Pauschales Umhängen der ADR-Verweise lässt Gliederungs-Zeiger stehen | eingetreten | siehe §7 |

## 6. Offene Risiken zur Wellen-Abnahme

- Entfällt — Slice ohne Welle.

## 7. Steering-Loop-Beobachtungen

- **Ein Nachfolger muss die Entscheidung seiner Vorgängerin vollständig
  tragen.** Die erste Fassung dieser Nachfolge-ADR entschied nur den Kotlin-Fall. Damit
  zeigten drei Verweise aus `slice-021` auf `§Entscheidung 2` und `3` — Punkte,
  die es in der schmalen Fassung gar nicht gab. Dasselbe war beim vorigen Supersede-Übergang
  passiert und dort einzeln repariert worden; die Ursache ist
  nicht das Umhängen, sondern eine Nachfolge-ADR, die weniger trägt als ihre
  Vorgängerin. [ADR-0017](../../adr/0017-kotlin-luecke-am-bestandssensor-geschlossen.md)
  übernimmt die Nummerierung deshalb **absichtlich**.
- **Konsist kann keine Typ-Auflösung.** Es ist quell-basiert (PSI), nicht
  Bytecode-basiert wie ArchUnit. Die neue Prüfung ist ein Text-Vergleich —
  besser als die Import-Liste, aber ein Typ-Alias oder eine Extension aus einem
  anderen Paket bleibt unsichtbar. Die Grenze ist gewandert, nicht
  verschwunden, und steht als Kommentar über den Regeln.

## 8. Sub-Area-Modus-Begründung

Berührte Sub-Area: *Sprach-Skelette* (`kotlin/`). Modus **RK** — es gibt einen
gewachsenen Regel-Stand, gegen den zu rekonziliieren ist.

## 9. Closure-Notiz

**Ergebnis.** Der letzte geteilte blinde Fleck ist zu. Gemessen, je Fall beide
Sensoren:

| Fall | a-check | Konsist vorher | Konsist jetzt |
|---|---|---|---|
| unveränderter Baum | grün | grün | grün |
| `service → ui`, voll qualifiziert ohne Import | grün | **grün** | **rot** |
| `index → service`, voll qualifiziert ohne Import | grün | grün | **rot** |

Die mittlere Zeile ist der Fall, der die abgelöste ADR zu ihrer Grenze zwang; die
untere zeigt, dass die damalige `constructs`-Regel ihn ohnehin nicht gedeckt
hätte — sie kannte nur die Richtung auf `ui`.

**Die Regel entfällt, nachdem sie gemessen wurde**, nicht weil sie unbequem
war: `index → service` liegt außerhalb ihrer Zone und wird jetzt vom
Bestandssensor gefangen. Kotlin verhält sich damit wie Java und C# — a-check
ist die Allow-Liste über Importe, der Bestandssensor sieht tiefer.

**Was bleibt:** C++ ist das einzige Skelett mit zwei textnahen Sensoren; dort
trägt die `constructs`-Regel weiter. Der Trigger dafür steht in
[ADR-0017](../../adr/0017-kotlin-luecke-am-bestandssensor-geschlossen.md).

**Gates:** `make gates COURSE_LANG=kotlin` grün, `make verify` grün, Root
`make check` 0 ERROR / 0 WARN.
