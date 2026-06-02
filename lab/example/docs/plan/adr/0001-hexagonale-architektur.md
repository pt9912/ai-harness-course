# ADR-0001: Hexagonale Architektur mit Layering

**Status:** Accepted

**Datum:** 2026-05-15

**Autor:** Kurs-Lab

**Bezug:** LH-FA-01, LH-FA-02, LH-FA-03

---

## Kontext

DocSearch hat (Stand jetzt) drei externe Abhängigkeiten: das
Embedding-Modell, das Index-Storage und die HTTP-Schnittstelle.
Mindestens zwei davon (Modell, Storage) werden sich im Lebenszyklus
ändern (siehe ADR-0002, ADR-0003). Die Service-Schicht darf von keiner
dieser Änderungen direkt betroffen sein.

## Entscheidung

Wir wählen **hexagonale Architektur (Ports & Adapters) mit explizitem
Layering**.

Layer-Reihenfolge: `Types → Index → Embedding → Audit → Service → UI`.
Jeder Layer darf nur "abwärts" importieren, niemals seitwärts oder
aufwärts.

## Verglichene Alternativen

### Option A — Klassische 3-Schicht-Architektur

- Pro: Schnell zu schreiben, intuitiv.
- Contra: Verkabelt Service direkt mit konkretem LLM-Client. Modell-Wechsel teuer.

### Option B — Microservices pro Domäne

- Pro: Vollständige Isolation.
- Contra: Overkill für DocSearch-Größe, betriebliche Komplexität ohne Mehrwert.

### Option C — Hexagonale Architektur mit Layering (gewählt)

- Pro: Adapter-Pattern macht Modell- und Storage-Wechsel zu reinen Adapter-Änderungen. Layering ist maschinell prüfbar.
- Contra: Mehr Boilerplate, Lernkurve für neue Mitarbeiter.

## Konsequenzen

- Positiv: Modell-Migration (siehe ADR-0002) berührt nur `internal/embedding/`. Storage-Migration nur `internal/index/`.
- Negativ: Initialer Schreibaufwand höher; jede neue Schicht braucht Test-Doubles für die ports.
- Folgepflicht: Pro Sprach-Skelett ein Architekturtest (siehe Fitness Function).

## Fitness Function

| Tooling | Regel | Make-Target |
|---|---|---|
| Go: `depguard` | `internal/service` darf nicht `internal/ui` importieren. UI darf nur `internal/service` und `internal/types`. | `make arch-check` |
| Python: `import-linter` | Contract `forbidden: ui -> {index, embedding, audit}` und `forbidden: service -> ui`. | `make arch-check` |
| Java/Kotlin: ArchUnit | `noClasses().that().resideInAPackage("..service..").should().dependOnClassesThat().resideInAPackage("..ui..")` u.a. | `make arch-check` |
| C#: NetArchTest | Analog für Namespaces `DocSearch.Service`, `DocSearch.UI` etc. | `make arch-check` |

## Re-Evaluierungs-Trigger

- Wenn DocSearch zu Multi-Tenancy migriert (aktuell out-of-scope, siehe Lastenheft §5).
- Wenn der Architekturtest in jeder Sprache mehr als 20 explizite Ausnahmen brauchen würde.

## Geschichte

| Datum | Ereignis | Verweis |
|---|---|---|
| 2026-05-15 | Proposed | slice-001 |
| 2026-05-15 | Accepted | PR initial commit |
