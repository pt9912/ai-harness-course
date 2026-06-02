# Modul 12 — Quality Gates

## Lernziele

* Gates als `make`-Targets aufsetzen
* Critical Coverage von Gesamt-Coverage trennen
* Gates im CI verankern

## Lab-Bezug

```bash
make lint
make typecheck
make arch-check
make coverage-gate
make coverage-gate-critical
make gates
```

## Themen

* Linter
* Typecheck
* Architekturtests
* Coverage Gates
* Critical Coverage Gates
* Security Gates

## Harness-Einordnung

Gates = *computational feedback* (siehe
[`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)).
Schnellste und billigste Sensoren des Harness. Was hier prüfbar wird,
muss nicht mehr im Review-Agent landen — das ist die wichtigste
Einsparung im gesamten System.

## Kernidee

Gates sind Aussagen, die *immer* gelten müssen. Wenn ein Gate "manchmal"
rot sein darf, ist es kein Gate, sondern ein Vorschlag.

## Hard Rule (Doku-Disziplin)

In `harness/README.md` und in jeder Doku, die Gates aufzählt: keine
Befehle behaupten, die es nicht gibt. Wenn `make fullbuild` aktuell rot
ist, wird das dokumentiert (mit Datum und Trigger), nicht ausgelassen
oder geschönt. Halluzinierte Gates sind die häufigste Form von
Harness-Lüge — und der Implementation-Agent vertraut ihnen.

## Bootstrap-aware Gates

In der Frühphase eines Projekts ist eine harte Coverage-Schwelle Unsinn.
Statt sie zu verschweigen: bekenne den Reifegrad. Ein bootstrap-aware
Gate dokumentiert seine Stufe und seinen Hochschalt-Trigger im
Make-Target:

```
coverage-gate: ## Coverage threshold gate (bootstrap-aware, LH-FA-BUILD-008).
```

Das Gate prüft heute z. B. 40 %, schaltet bei Meilenstein M2 auf 70 %
hoch. Das macht "bootstrap-aware" nicht zum Schlupfloch, sondern zum
explizit terminierten Carveout.

## Reichhaltige Gate-Landschaft als Inspiration

Ein reifes Repo (Beispiel `pt9912/grid-gym`, siehe
[`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)) hat
deutlich mehr als sechs Gates:

```
lint · format-check · typecheck
arch-check · arch-check-imports · arch-check-custom
docs-check · spdx-check · noqa-check · noqa-gate
test-unit · test-determinism · test-replay · test-fault
test-integration
coverage-gate · coverage-gate-critical
dep-audit · image-audit · openapi-validate
```

Pointe: Domänenspezifische Gates (`test-determinism`, `test-replay`,
`noqa-gate`) entstehen aus dem Steering Loop — nicht aus einem
Standard-Setup. Wenn dein Repo nur die generischen sechs hat, weißt du
nur, dass du noch keine Schmerzen hattest.

Ein zweites Beispiel in einer anderen Sprach-Welt: `pt9912/bess-ems`
(C#/.NET, Safety/Control) bringt Gate-Familien mit, die `grid-gym`
nicht hat — `solid-suppression-gate` (C#-Pendant zum noqa-gate),
`test-mpc-property` (Property-Based-Sensor für Regelungstechnik),
`native-sanitizer` (für C/C++-Interop-Anteile), `test-hil-*`
(Hardware-in-the-Loop). Voll ausgeschrieben in
[`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md).

Pro Sprache wachsen also unterschiedliche Gate-Familien. Der Harness
ist sprach-unabhängig im Konzept, aber sprach-abhängig in der
Konkretion — genau deshalb deckt das Begleit-Lab fünf Sprachen
parallel ab.

## Übungen

* Schreibe einen Architekturtest, der ADR-3 als Regel umsetzt
* Provoziere absichtlich einen Coverage-Gate-Failure auf einer kritischen Datei

## Selbstcheck

* Warum braucht es Critical Coverage zusätzlich zur Gesamt-Coverage?
* Welcher Gate-Typ erkennt eine SQL-Injection — Linter, Typecheck oder Security Gate?

## Weiterlesen

* Nächstes Modul: [Modul 13 — Docker Harness](../05-betrieb/modul-13-docker-harness.md)
