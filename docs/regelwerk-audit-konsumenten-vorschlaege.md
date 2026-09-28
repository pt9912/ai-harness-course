# Regelwerk-Verbesserungen aus dem Konsumenten-Audit — Vorschläge

**Stand:** 2026-09-28 — A, B und C sind umgesetzt (Wellen 151–153; Kurs +
Spiegel, Gates grün), noch nicht committet. Zuvor unabhängig gegengeprüft
(Zitat-Treue, Ketten, „bereits vorhanden"-Check gegen `kurs/de`) und danach
korrigiert. A und B hatten je einen Zitat-/Ketten-Fehler (korrigiert). D
wurde nach der Gegenprüfung zurückgezogen: die zugrunde liegende
Beobachtung war real, aber der Kanon deckt sie bereits narrativ ab (Modul
13 §Worked Example B) und die vorgeschlagene Form widerspräche einer
dortigen expliziten Regel gegen Härtung ohne eigene Beobachtungs-Evidenz —
s. Abschnitt „Vorschlag D". Beleggrundlage:
[regelwerk-audit-konsumenten-befund.md](regelwerk-audit-konsumenten-befund.md).
Weitere, schwächer belegte Kandidaten aus Einzelfällen am Ende ohne
Ausarbeitung gelistet.

Die Vorschläge sind unabhängig voneinander entscheidbar.

## Vorschlag A — ADR-Nachzug-Verfahren bei sich änderndem Kontext (Modul 4 ergänzen)

Vier Repos (m-trace, ai-harness-init, pg-change-feed, a-check) haben
unabhängig dasselbe Problem gelöst: Eine `Accepted`-ADR bleibt inhaltlich
unveränderlich, aber ihr *Kontext* ändert sich — ein neues Pflichtfeld
kommt ins Template, ein automatisiertes Werkzeug verschiebt eine Datei, auf
die die ADR zeigt, oder die ADR verlinkt ein vergängliches Artefakt (Review-
Report). Der Kanon kennt die Immutabilitäts-Hard-Rule und die
Re-Evaluierungs-Trigger-Pflicht (Digest `modul-04-adrs.md:28-45`), aber kein
Verfahren für diese Klasse — jeder Adopter erfindet eine eigene MR.

Vorschlag: `modul-04-adrs.md` um eine **Nachzug-Klasse** ergänzen, die
explizit von einer inhaltlichen Änderung unterscheidet:

- **Referenz-/Pfad-Nachzug**: Eine ADR verweist über eine Kennung statt
  eine Adresse (bereits kanonische Doktrin, Digest
  `grundlagen-harness-dateien.md:316-317`) — wo das nicht möglich ist
  (z. B. Verweis auf ein vergängliches Artefakt wie einen Review-Report),
  braucht die ADR einen deklarierten Vermerk, dass der Verweis beim
  Verschwinden des Ziels *verfällt*, nicht die Entscheidung ungültig wird.
- **Template-Feld-Nachzug**: Gewinnt die Ziel-Form ein neues Pflichtfeld,
  tragen bestehende `Accepted`-ADRs es nicht rückwirkend — ein
  Grandfathering-Vermerk (Feld fehlt, Datum des Feld-Zugangs) reicht,
  keine Folge-ADR nötig, solange die Entscheidung selbst unverändert
  bleibt.
- Beide Fälle bleiben klar getrennt von einer **inhaltlichen Änderung**
  (weiterhin nur per Folge-ADR mit `supersedes`).

- **Kette:** `kurs/de/01-spec-und-architektur/modul-04-adrs.md`
  §„Hard Rule (Beispiel aus c-hsm-doc, ADR 0001)" → Spiegel
  `lab/regelwerk/modul-04-adrs.md` §„Hard Rule für Accepted-ADRs" (im
  Digest umbenannter, inhaltsgleicher Abschnitt).
- **Trade-off:** Größter inhaltlicher Eingriff der drei Vorschläge — berührt
  die Immutabilitäts-Hard-Rule direkt. Risiko: eine zu weich formulierte
  „Nachzug-Klasse" wird zur Rationalisierung für echte inhaltliche
  Änderungen missbraucht („ist ja nur ein Pfad-Nachzug"). Braucht eine
  scharfe, wenige Sätze lange Abgrenzung, keine Ermessens-Klausel.

## Vorschlag B — Eskalationsstufe „wiederholtes Scheitern der Verkörperung" (Modul 6 schärfen)

`modul-06-roadmap.md` §3 (Welle-Closure) hat bereits den Mechanismus:
Beobachtungs-Register-Einträge, die **3×** erreichen, werden „im Regelfall
*verkörpert*" und zum Steering-Loop-Eintrag. Drei Repos zeigen aber, dass
„verkörpert" in der Praxis oft als geschärfte Prosa-Instruktion gelesen
wird — und dass Prosa dieselbe Fehlerklasse nicht zuverlässig verhindert:
pg-change-feed dokumentiert mehrere **4.** Auftreten trotz vorherigem
3×-Verdikt, a-check hat dieselbe Stelle viermal in Folge geflickt, bevor
ein struktureller Umbau (`slice-190`) kam.

Vorschlag: Ergänzung im Closure-Lese-Schritt — erreicht dieselbe
Fehlerklasse ein **4.** Mal, nachdem eine Verkörperung bereits stattfand,
gilt Prosa als ausgeschöpfte Form. Der Steering-Loop-Eintrag muss dann
entweder einen mechanischen Sensor benennen oder explizit begründen, warum
keiner möglich ist (dieselbe Ehrlichkeitspflicht wie bei Guard-Grenzen, Digest
`grundlagen-durchsetzungsschicht.md:89`, wortgleich Zeile 88-90 im
Kurs-Original: „Ein Gate, das so tut, als decke es mehr ab, als es tut, ist
selbst eine Harness-Lüge" — hier
umgekehrt: eine Prosa-Regel, die als geschlossen gilt, obwohl sie es nicht
ist, dieselbe Klasse).

- **Kette:** `kurs/de/02-planung/modul-06-roadmap.md` §Welle nach `done/`
  schließen (Beobachtungs-Register-Lese-Schritt) → Spiegel
  `lab/regelwerk/modul-06-roadmap.md`.
- **Trade-off:** Kleinerer Eingriff als A — schärft einen bestehenden
  Mechanismus um eine Stufe, erfindet keinen neuen. Risiko: nicht jede
  Fehlerklasse ist sensorisierbar (der Kanon kennt das bereits, z. B.
  „Herkunfts-Pflicht für Zahlen" bei pg-change-feed ist explizit „kein
  Sensor möglich, tragende Instanz bleibt Reviewer") — die Regel braucht
  denselben ehrlichen Opt-out wie die Guard-Grenzen, sonst erzeugt sie
  Druck auf unsensorisierbare Fälle.

## Vorschlag C — ADR-Schwelle für Config-/Gate-/Tooling-Erweiterungen (Modul 4 ergänzen)

Ein Repo (pg-change-feed) stellt zweimal unabhängig dieselbe Frage, beide
Male über Präzedenzfall statt Regel entschieden: „Braucht die Erweiterung
des Geltungsbereichs eines Gates (neuer Wächter unter `make gates`, neue
Scope-Gruppe) eine eigene ADR?" a-checks MR-024 zeigt dieselbe Unschärfe
von der Gate-Seite (kann Pfad-Nachzug nicht von neuer Entscheidung
unterscheiden).

Vorschlag: eine explizite Default-Regel in `modul-04-adrs.md`:

> Die Aufnahme eines bereits existierenden, unabhängig lauffähigen
> Wächters in den PR-blockierenden Satz (`make gates`) ist keine neue
> Entscheidung und braucht keine eigene ADR — ein Verweis auf die
> tragende ADR des Wächters selbst reicht. Eine neue Fehlerklasse, ein
> neuer Scope oder ein Widerspruch zu einer bestehenden ADR braucht
> weiterhin eine eigene ADR. Im Zweifel: ADR.

- **Kette:** `kurs/de/01-spec-und-architektur/modul-04-adrs.md` (neuer
  Absatz, Querverweis `kurs/de/04-qualitaet/modul-13-quality-gates.md`) →
  Spiegel `lab/regelwerk/modul-04-adrs.md` + `modul-13-quality-gates.md`.
- **Trade-off:** Kleinster Eingriff der drei Vorschläge, additiv. Risiko:
  eine Bright-Line-Regel trifft nicht jeden Fall — der „Im Zweifel: ADR"-
  Nachsatz ist deshalb nicht optional, sonst wird die Regel selbst zur
  Rationalisierungs-Lücke, die Vorschlag A gerade schließen soll.

## Vorschlag D — zurückgezogen: Referenzmuster existiert bereits, widerspräche zudem einer expliziten Kanon-Regel

**Ursprüngliche Fassung (entkräftet):** d-check und pg-change-feed haben
unabhängig fast identische Härtungen gegen dieselbe, vom Kanon bereits
ehrlich benannte Guard-Lücke gebaut. Der ursprüngliche Vorschlag war ein
optionaler Anhang unter §Grenzen mit einer Liste bereits beobachteter
Umgehungsklassen, damit künftige Adopter sie nicht neu entdecken müssen.

**Warum das nicht trägt:** Zwei Dinge widerlegen die Prämisse „keine
Referenz vorhanden":

1. Ein narratives Beispiel existiert bereits —
   [`kurs/de/04-qualitaet/modul-13-quality-gates.md` §Worked Example B:
   Guard-Härtung als Steering-Loop am Wächter](../kurs/de/04-qualitaet/modul-13-quality-gates.md#worked-example-b-guard-härtung-als-steering-loop-am-wächter)
   (Spiegel: `lab/regelwerk/modul-13-quality-gates.md`), verlinkt direkt
   aus `grundlagen-durchsetzungsschicht.md` §Die Schicht wird selbst
   gesteuert. Es benennt über zwei Wellen (`MR-004`, `MR-005`) exakt
   dieselbe Klasse, die dieses Audit fand — Interpreter-Umwege
   (`python -c "…"`), `env`-Umwege, Wrapper-Skripte — und zusätzlich
   Sub-Shell-Rekursion (`bash -c`/`sh`/`zsh` mit kombinierten Flags), die
   im Audit-Befund gar nicht vorkam, obwohl sie im Kanon am
   ausführlichsten dokumentiert ist.
2. Genau die von Vorschlag D vorgeschlagene Form — eine **vorab
   zusammengestellte Liste** bekannter Umgehungsklassen — benennt
   dasselbe Worked Example als **erste Entgleisung**: „Welle 1 ‚gleich
   richtig' bauen wollen. Statt der beobachteten Lücke wird ein
   Bedrohungsmodell abgearbeitet … eine Regel ohne Sensor-Evidenz, die in
   sechs Monaten niemand mehr begründen kann." Die Pointe der Tabelle dort
   ist ausdrücklich, die nächste Zeile leer zu lassen: „die nächste Welle
   wird **beobachtet, nicht geplant**." Ein Referenz-Anhang mit
   Umgehungsklassen, die das eigene Repo noch nicht beobachtet hat, ist
   exakt das, wovor der Kanon an dieser Stelle warnt.

**Was übrig bleibt, ohne der eigenen Regel zu widersprechen:** Zwei der
vier ursprünglich gelisteten Klassen (Pipes/Redirects/`tee`,
wortinterne Splices) stehen nicht in der `Grenze:`-Zeile von `MR-005` im
Kanon-Beispiel — sie sind aber real in zwei unabhängigen Repos beobachtet
(d-check, pg-change-feed), keine Phantome. Das wäre kein neuer Anhang,
sondern höchstens eine Ergänzung der bestehenden Beispiel-Grenze um zwei
zusätzlich beobachtete Klassen — und selbst das nur, wenn Modul 13 dieses
Beispiel künftig um eine dritte Welle erweitert. Kein eigenständiger
Vorschlag mehr.

## Einordnung

A und C hängen an derselben Wurzel (ADR-Modul) und ergänzen sich eher, als
dass sie konkurrieren: C nimmt eine wiederkehrend gestellte Frage *vor* der
ADR-Erstellung vorweg, A regelt, was *nach* der Erstellung passiert, wenn
sich der Kontext einer bereits akzeptierten ADR ändert. Beide sind am
besten belegt (vier bzw. zwei-plus-verwandte unabhängige Fälle).

B ist der am direktesten aus echtem Wiederholungs-Versagen abgeleitete
Vorschlag (3/5 Repos, davon einer mit dokumentiertem 4.-Auftreten trotz
Fix) — aber auch der, der am meisten Sorgfalt in der Formulierung braucht,
damit er nicht zum Sensor-Zwang für unsensorisierbare Fälle wird.

D ist zurückgezogen (s. o.): Die zugrunde liegende Beobachtung war real,
aber der Kanon deckt sie bereits narrativ ab und die vorgeschlagene Form
(vorab zusammengestellte Liste) widerspricht einer expliziten Kanon-Regel
gegen ungeplante Härtung ohne eigene Beobachtungs-Evidenz.

## Umsetzung

A, B und C sind umgesetzt als eigene Wellen (getrennt, wie oben
entschieden), Rangfolge nach `AGENTS.md` §1 eingehalten (`kurs/de` zuerst,
Spiegel wortgleich nachgezogen), `lab/templates`/`lab/example` nicht
berührt, da keiner der drei Vorschläge dort etwas ändert:

- **Welle 151 (C):** `modul-04-adrs.md` §Kernidee, neuer Absatz „Eine
  Gate-Erweiterung ist nicht automatisch ein ADR-Anlass".
- **Welle 152 (B):** `modul-06-roadmap.md` §Die Wellen-Closure-Prozedur,
  Schritt 3, neuer Absatz „Verkörpert heißt nicht zwangsläufig
  automatisiert".
- **Welle 153 (A):** `modul-04-adrs.md` §Hard Rule, neuer Unterabschnitt
  „Nachzug ist keine Überschreibung".

Alle drei ohne beobachtbares Verhalten (Einordnungsregeln für
Reviewer/Architect-Agenten, keine neuen Sensoren) — kein Team-Sim-Szenario
nach `AGENTS.md` §3 nötig. `make check` grün nach jeder Welle. Nicht
committet.

## Weitere Kandidaten — Parkplatz, kein Vorschlag

Anders als A–C tragen die folgenden drei nur **ein** Repo als Beleg (1/5),
nicht mehrere unabhängige. Das war beim ursprünglichen, inzwischen
zurückgezogenen Vorschlag D schon bei 2/5 Repos nicht genug, um einer
adversarialen Prüfung standzuhalten (s. o.) — deshalb hier bewusst nicht zu
Vorschlägen ausgearbeitet. Sie warten auf ein zweites/drittes Repo mit
demselben Muster oder auf einen eigenen Audit-Durchgang, bevor daraus ein
Vorschlag wird:

- Zweite Durchsetzungsschicht als Muster (d-check MR-047/048).
- CVE-Cluster-Carveout als zweite Ziel-Form neben der Einzel-CO-Datei
  (m-trace MR-006, `modul-07-carveouts.md`).
- Klarere Trennung, wann ein Baseline-Bump einen eigenen
  Re-Evaluierungs-Trigger auslöst (m-trace).

## Entscheidungen zur Umsetzungsform

- **B als Ergänzung, kein neuer Abschnitt.** B erweitert einen Mechanismus,
  der in `modul-06-roadmap.md` §3 bereits vollständig beschrieben ist
  (3×-Beobachtung → „im Regelfall verkörpert" → Steering-Loop). Ein
  separater Abschnitt würde denselben Mechanismus zweimal beschreiben und
  driftet mit der Zeit auseinander — dieselbe Logik, die Vorschlag D oben
  zu Fall gebracht hat: neue Struktur nur, wenn wirklich keine vorhandene
  sie trägt.
- **A und C getrennt umsetzen.** Sie teilen sich nur den Modul-Ort, keine
  inhaltliche Abhängigkeit (anders als F/C im Präzedenzfall
  `dod-verifikation-testbindung.md`, die tatsächlich zusammengehörten). A
  ist laut eigenem Trade-off der größte Eingriff der drei Vorschläge
  (berührt die Immutabilitäts-Hard-Rule direkt), C der kleinste (rein
  additiv). Getrennt heißt: C kann schnell und risikoarm landen, ohne auf
  die schwierigere Formulierungsarbeit von A zu warten — passt zum
  Slice-Prinzip des Korpus (kleine, unabhängig reviewbare Einheiten).
