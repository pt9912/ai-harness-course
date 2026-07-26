# Roadmap — offene Fäden des Kurs-Repos

**Stand:** 2026-07-26.

Dieses Repo führt einen **bewusst reduzierten Harness**: `CHANGELOG.md` ist das
Wellen-Register (Closure-Log), `make check` sind die Gates, d-check ist per
Digest gepinnt. Kein Slice-Lifecycle, keine ADRs, keine Spec — für ein
Doku-Repo wäre das Zeremonie ohne Substanz.

Diese Datei ist das **Gegenstück zum CHANGELOG**: dort steht, was geschlossen
wurde, hier, was offen ist und *woran man erkennt, dass es dran ist*. Ohne sie
liegen offene Fäden als Fließtext in alten Wellen-Einträgen und werden nie
wieder gelesen.

> **Pfad-Abweichung, deklariert.** Der Kurs lehrt
> `docs/plan/planning/in-progress/roadmap.md`
> ([`konventionen.md` §Verzeichniskonvention](../kurs/de/grundlagen/konventionen.md#verzeichniskonvention)).
> Dieses Repo führt die Roadmap **flach** unter `docs/roadmap.md`, weil der
> gelehrte Pfad die vier Lifecycle-Verzeichnisse voraussetzt — und die ohne
> Slice-Betrieb anzulegen wäre leere Form: Verzeichnisse, die keinen Betrieb
> tragen, behaupten Reife, die es nicht gibt. Das ist *analog* zur Warnung vor
> „Struktur ohne Substanz" in
> [`konventionen.md` §Was ist eine Sub-Area?](../kurs/de/grundlagen/konventionen.md#was-ist-eine-sub-area)
> — der dortige Drei-Achsen-Test wird hier **nicht** angewandt, er beantwortet
> eine andere Frage. Die Abweichung ist eine Entscheidung, kein Versehen.

## Offene Fäden

Form nach [Modul 6](../kurs/de/02-planung/modul-06-roadmap.md): **Trigger ist
ein beobachtbares Ereignis, kein Datum.** Ein Faden ohne Trigger ist ein
Wunsch, kein Plan — deshalb steht bei den betroffenen Zeilen ausdrücklich
*nicht gesetzt* statt eines erfundenen Termins.

| Faden | Trigger | Stand |
|---|---|---|
| **Discovery-/Kandidaten-Register** — eigener Kanal für Nicht-Slice-Register im Planning-Layout | **ein zweites Konsument-Repo zeigt denselben Druck unabhängig** — *Teilbedingung erfüllt*: es gibt zwei Adopter (`d-check`; `ai-harness-init` mit eigenen `MR-007/008/010`, die drei Kurs-Lücken aufdeckten). Offen bleibt der **zweite Halbsatz**: kein Beleg, dass dort *derselbe* Druck auftrat | bewusst vertagt seit Welle 33; die Verallgemeinerung braucht die wiederholte *Beobachtung*, nicht nur einen zweiten Adopter |
| **Lab Phase C** — Begleit-Lab deckt fünf Sprachen parallel ab | *nicht gesetzt* | in [Modul 2](../kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md) und [Modul 13](../kurs/de/04-qualitaet/modul-13-quality-gates.md) als „heute noch nicht ausgeliefert" benannt; Umfang ist ein eigenes Projekt, keine Welle |
| **`kurs/en`** — englische Fassung | *nicht gesetzt* | Skelett vorhanden — `kurs/en/README.md` trägt nur einen Platzhalter-Text, keinen Kursinhalt; im [README](../README.md) als „derzeit *nicht* Bestandteil des Kurses" deklariert |
| **Repo-eigener Harness ausbauen** — `harness/conventions.md` mit `MR-000` (Baseline) und einem `MR` für die Pfad-Abweichung oben | **die Roadmap braucht eine zweite Adaption gegenüber dem gelehrten Aufbau** — dann trägt die Prosa oben zu viel und gehört in einen Adaptions-Block | bewusst zurückgestellt: heute genügt der Kommentar in dieser Datei |

## Meilensteine

| Meilenstein | Bedingung | Stand |
|---|---|---|
| **v3.7.0** | **alle seit v3.6.0 im [CHANGELOG](../CHANGELOG.md) registrierten Wellen** getaggt, Bundle-Asset gebaut, `latest` umgehängt | ausstehend |

## Abgeschlossene Wellen

*Derivativ* — die Closure-Historie steht vollständig in
[`CHANGELOG.md`](../CHANGELOG.md) und wird hier nicht dupliziert. Diese Datei
trägt nur den Vorwärts-Blick.

## Historische Trigger-Verschiebungen

Noch keine. Wird ein Trigger oben verschoben oder ersetzt, bekommt er hier eine
Zeile mit Datum, Änderung und Grund — sonst ist die Verschiebung still.

| Datum | Faden | Änderung | Grund |
|---|---|---|---|
| — | — | — | — |
