# Slice X: Schnelle Such-Optimierung (Review-Fixture, BROKEN)

> **Hinweis:** Dieser Slice-Plan ist **absichtlich fehlerhaft** für die
> Übung in Modul 10. Drei Fehler sind eingebaut.

**Status:** in-progress

**Welle:** welle-2-qualitaet

**Bezug:** LH-QA-01 (Performance)

**Autor:** Kurs-Lab-Übung. **Datum:** 2026-06-02.

## 1. Ziel

Suche soll schneller werden. Wir cachen die letzten 1000 Anfragen mit
ihren Ergebnissen direkt im Service-Layer.

## 2. Definition of Done

- [ ] In-Memory-Cache in `internal/service/search.go` mit LRU-Strategie.
- [ ] Cache umgeht den Index-Layer komplett — bei Cache-Hit wird gar nicht erst gesucht.
- [ ] Tests grün.
- [ ] Latenz-Messung in Closure-Notiz.

## 3. Plan (vor Code)

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| `internal/service/search.go` | update | LRU-Cache plus direktem Embedding-Pfad |
| `internal/embedding/cache.go` | neu | Hilfsstruktur für Caching |
| `internal/service/search_test.go` | update | Cache-Hit-Test |

## 4. Trigger

Sofort. Lasttests in welle-1 zeigten 50 ms Reserve im p95-Budget; wir
nutzen die für UX-Spürbarkeit.

## 5. Closure-Trigger

DoD vollständig, Cache funktioniert.

## 6. Risiken und offene Punkte

Cache kann veraltete Ergebnisse liefern nach Reindex, aber das ist OK,
weil Cache eh nur 1 Minute TTL hat.

## 7. Closure-Notiz

<!-- Erst nach Abschluss. -->

## 8. Sub-Area-Modus-Begründung

**Status:** alle berührten Sub-Areas GF (siehe
`harness/conventions.md` §Modus-Deklaration pro Sub-Area).

<!-- §8 ist in dieser Fixture in der Minimal-GF-Form gehalten. Die
drei eingebauten Fehler des Slice betreffen Architektur, Carveout-
Pflicht und Spec-Anker (siehe Hinweis am Dateianfang) — §8 ist nicht
einer davon. Ein scharfer Reviewer wird allerdings bemerken, dass der
"alle GF"-Status zur eigentlichen Architektur-Bruchstelle des Slice
inkonsistent ist; diese Beobachtung ist Bonus, nicht Pflicht-Fund. -->

