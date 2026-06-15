# Agents-Regelwerk — nach Modulen aufgeteilt

Die 17 Module (0–16) des
[Agents-Regelwerks](../../kurs/de/agents-regelwerk.md)
als einzelne Dateien. Inhaltlich **wortgleich** zur Quelle (reiner Modultext,
kein zusätzlicher Kopf); aufgeteilt, damit ein Agent ein einzelnes Modul laden
kann, ohne das gesamte Regelwerk im Kontext zu halten.

> **Was dieses Verzeichnis ist.** Eine **derivative Sicht** auf
> [`agents-regelwerk.md`](../../kurs/de/agents-regelwerk.md)
> — pro Modul eine Datei, sonst nichts. Es trägt keine eigenen Regeln und keine
> eigene Normativität.
>
> **Was dieses Verzeichnis NICHT ist.** Eine Quelle der Wahrheit. Bei Konflikt
> gilt die Quelle; und die Quelle ist *ihrerseits* derivativ (sie steht unter
> Konventionen, Klassifikation und den Modultexten der Phasen 01–05). Wer hier
> eine Regel ändert, ohne die Quelle zu ändern, erzeugt genau die Drift, die das
> Regelwerk selbst verbietet. Maßgeblich bleibt der Kurs unter
> [`/kurs/de/`](../../kurs/de/README.md).

**Nur die Modul-Sektionen.** Die Rahmen-Abschnitte des Regelwerks — Konventionen,
Klassifikation und Steering Loop, Durchsetzungsschicht — sowie der Stand stehen
nur in der
[Quelldatei](../../kurs/de/agents-regelwerk.md).

**Links.** Im Repo relativ (lokal navigierbar, vom Doku-Gate validiert). Die
Modul-Querverweise *innerhalb* dieses Verzeichnisses bleiben auch im
ausgelieferten `lab-regelwerk.zip` relativ (das Bundle ist self-navigierbar);
nur die Verweise *nach außen* (Kurs, Templates, Beispiel) werden beim Release auf
absolute, auf den Tag gepinnte GitHub-URLs umgeschrieben (`tools/rewrite-doc-links.py
--keep-within-src`).

## Module

### Einführung

- [Modul 0 — Einführung](modul-00-einfuehrung.md)

### Phase 01 — Spec und Architektur

- [Modul 1 — Der Entwicklungszyklus](modul-01-entwicklungszyklus.md)
- [Modul 2 — Harness-Bootstrap](modul-02-harness-bootstrap.md)
- [Modul 3 — Lastenheft und Spezifikation](modul-03-lastenheft.md)
- [Modul 4 — Architektur und ADRs](modul-04-architektur-adrs.md)

### Phase 02 — Planung

- [Modul 5 — Planning Harness](modul-05-planning-harness.md)
- [Modul 6 — Roadmap Engineering](modul-06-roadmap.md)
- [Modul 7 — Carveout Management](modul-07-carveouts.md)

### Phase 03 — Agenten

- [Modul 8 — Agentenrollen](modul-08-agentenrollen.md)
- [Modul 9 — Implementierung durch KI-Agenten](modul-09-implementierung.md)

### Phase 04 — Qualität

- [Modul 10 — Review Harness](modul-10-review-harness.md)
- [Modul 11 — Verification Harness](modul-11-verification.md)
- [Modul 12 — Replay und Evaluierung](modul-12-replay-evaluierung.md)
- [Modul 13 — Quality Gates](modul-13-quality-gates.md)

### Phase 05 — Betrieb

- [Modul 14 — Docker Harness](modul-14-docker-harness.md)
- [Modul 15 — Observability](modul-15-observability.md)
- [Modul 16 — Produktiver Betrieb](modul-16-produktiver-betrieb.md)

## Lizenz

Wie der übrige Kurs: Texte unter CC BY 4.0, Code-Artefakte unter MIT. Details in
[`LICENSE.md`](../../LICENSE.md).
