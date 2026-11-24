# Modul 4 — ADRs

> **Aufwand:** ca. 75 Min Lesen · 90 Min Übung. Spiralcurriculum: ID-Schema und Source Precedence (Module 1, 2) bekommen hier einen neuen Quadranten — ADRs sind *inferential feedforward* mit Brücke zu *computational feedback*.

## Mini-Glossar für dieses Modul

Fünf neue Begriffe — *ADR* und *Fitness Function* selbst kennst du aus
dem [Modul 1 Mini-Glossar](modul-01-entwicklungszyklus.md#mini-glossar-für-dieses-modul);
alle fünf werden in diesem Modul entfaltet. Für die ersten Seiten
reichen die Ein-Satz-Anker:

| Begriff                        | Ein-Satz-Definition                                                                                                                                                            | Bild im Kopf                                                         |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------- |
| **MADR**                       | Markdown-basiertes ADR-Format mit Kopf-Feldern (Status, Datum, Bezug, Supersedes) und Body-Blöcken (Kontext, Optionen mit Trade-offs, Entscheidung, Konsequenzen).             | ein Formular, das die Entscheidung zwingt, ihre Belege mitzubringen. |
| **Nygard-Format**              | Das ursprüngliche, schlankere ADR-Format nach Michael Nygard: Kontext, Entscheidung, Konsequenzen.                                                                             | der Urahn von MADR — gleiche Idee, weniger Felder.                   |
| **superseded**                 | ADR-Status: Entscheidung ist durch eine *neue* ADR abgelöst — der Bedarf bleibt, die Antwort wechselt.                                                                         | Schild "ersetzt durch Nr. N" am alten Protokoll.                     |
| **deprecated**                 | ADR-Status: Entscheidung entfällt *ersatzlos* — der zugrunde liegende Bedarf existiert nicht mehr.                                                                             | Akte geschlossen, kein Nachfolger nötig.                             |
| **Fitness-Function-Werkzeuge** | [a-check](https://github.com/pt9912/a-check), ArchUnit (Java), dep-cruiser (JS/TS), import-linter (Python) — prüfen Architektur-Aussagen maschinell, z. B. Layer-Importregeln. | der Prüfstand, auf den die ADR-Aussage geschnallt wird.              |

## Engage

Du fragst deinen Implementer-Agent: *"Warum hast du den Layer
Service direkt mit Runtime verbunden, ohne Adapter?"* — er antwortet:
*"Schien die einfachste Lösung."* In einem Repo *mit* ADR hätte er
antworten müssen: *"ADR-7 verbietet das. Adapter ist Pflicht."* Welcher
Unterschied liegt zwischen den beiden Antworten — und welches Artefakt
erzeugt ihn? Notiere deine Antwort; die Kernidee unten löst auf.

## Lernziele

Nach diesem Modul kannst du:

* einen ADR im MADR-Format mit Kontext, Optionen, Entscheidung, Konsequenzen und **Re-Evaluierungs-Trigger** *verfassen* (Erschaffen · prozedural),
* die Trennung ADR ↔ Spec ↔ Plan *erklären* und Grenzfälle *einordnen* (Analysieren · konzeptuell),
* eine ADR-Aussage in eine maschinell prüfbare Fitness-Function-*Aussage* übersetzen (Anwenden · prozedural; das volle *Erschaffen* der lauffähigen Fitness Function folgt in [Modul 13](../04-qualitaet/modul-13-quality-gates.md#worked-example-a-vom-adr-satz-zur-fitness-function)),
* zwischen `superseded` und `deprecated` ADRs *unterscheiden* und einen Folge-ADR *entwerfen* (Bewerten + Erschaffen · konzeptuell+prozedural),
* eine Bedrohung an einer Vertrauensgrenze einem Ausgang *zuordnen* — gemindert, akzeptiert, offen — und den akzeptierten als ADR *verfassen* (Anwenden + Erschaffen · prozedural).

## Lab-Bezug

* `docs/plan/adr/`
* [`../../../lab/example/exercises/03-adr.md`](../../../lab/example/exercises/03-adr.md)

## Themen

* Architekturentscheidungen
* ADR-Formate (MADR, Nygard)
* Architektur-Reviews
* ADRs als maschinell prüfbare Constraints
* Übersetzung ADR → Fitness Function
* Bedrohungen an Vertrauensgrenzen und ihr Ausgang (gemindert · akzeptiert · offen)

## Harness-Einordnung

ADR = *inferential feedforward* (für den Implementer-Agent) und
gleichzeitig Quelle für *computational feedback* (ArchUnit/Fitness
Functions, wenn die Entscheidung maschinell prüfbar ist). Eine ADR ohne
Fitness Function ist eine Absichtserklärung.

## Vorab — was hältst du heute für wahr?

*Bevor du die Kernidee liest:* notiere in einem Satz deine spontane
Antwort auf jede dieser drei Fragen.

1. *"Was begründet eine ADR — eine Anforderung oder eine Lösung?"*
2. *"Wenn du eine alte Entscheidung änderst, schreibst du die ADR um oder schreibst du eine neue?"*
3. *"Eine ADR sagt 'lose koppeln'. Ist das eine ADR, oder fehlt noch etwas?"*

Lass die Notiz neben dem Modul liegen. Am Modul-Ende prüft der
Selbstcheck genau diese drei Punkte — und der Block *Typische
Fehlvorstellungen* zeigt, wo die häufigsten Reibungen liegen.

## Kernidee

Ein ADR ist die einzige Stelle, an der "weil" gegen "ist halt so" gewinnt.
Wenn dein Reviewer-Agent den Grund nicht findet, kann er die Entscheidung
nicht verteidigen.

**Jede ADR trägt einen Re-Evaluierungs-Trigger** — eine beobachtbare
Bedingung, unter der die Entscheidung erneut geprüft wird (*„wenn
Bibliothek X v2 verfügbar ist", „wenn das Kostenbudget Y überschreitet",
„bei Meilenstein M3"*), oder ausdrücklich *permanent*. Eine ADR ohne
Trigger ist nicht falsch, aber unbefristet: Sie gilt weiter, auch wenn
ihre Voraussetzung längst weg ist. Geprüft wird der Trigger im
**Trigger-Audit** der Welle-Closure
([Modul 6](../02-planung/modul-06-roadmap.md#die-wellen-closure-prozedur),
Schritt 2) — zusammen mit Carveout- und Gate-Triggern; ein Trigger ohne
Wächter ist eine Absichtserklärung mit Verfallsdatum. Bei Eintreten:
Entscheidung bestätigen oder Folge-ADR mit `supersedes` (Accepted-ADRs
werden nie überschrieben).

**Eine ADR entsteht nicht nur aus Architektur-Fragen.** Auch ein Rollen-Konflikt
endet als ADR, wenn sein Verdikt bestritten wird — das Terminal des
Konflikt-Pfads ([Modul 8](../03-agenten/modul-08-agentenrollen.md#worked-example-einen-konflikt-pfad-als-rollen-sequenz-mit-übergabe-artefakten-modellieren)):
Die Entscheidung wird immutabel, Widerspruch braucht danach eine Folge-ADR mit
neuer Evidenz.

**Eine Gate-Erweiterung ist nicht automatisch ein ADR-Anlass.** Nimmt
`make gates` ([Modul 13](../04-qualitaet/modul-13-quality-gates.md)) einen
bereits existierenden, unabhängig lauffähigen Wächter neu in den
PR-blockierenden Satz auf, ist das keine neue Entscheidung — ein Verweis auf
die ADR reicht, die den Wächter ursprünglich trägt. Existiert keine, trägt
schon die *Einführung* des Wächters selbst eine, nicht seine spätere
Aufnahme in `make gates`. Eine neue Fehlerklasse, ein neuer Scope oder ein
Widerspruch zu einer bestehenden ADR braucht weiterhin eine eigene ADR. Im
Zweifel: ADR.

## Hard Rule (Beispiel aus c-hsm-doc, ADR 0001)

Begriff *Hard Rule* siehe Glossar in
[`../grundlagen/begriffe.md`](../grundlagen/begriffe.md#kernbegriffe).

*"Eine ADR mit Status `Accepted` wird nicht inhaltlich überschrieben.
Spätere Korrekturen oder Schärfungen entstehen als neue ADR mit
explizitem Verweis auf die abgelöste oder geschärfte Vorgängerin."*

Wirkung: ADRs sind Geschichtsdokumente, kein Wiki. Reviewer-Agent kann
auf ältere Entscheidungen vertrauen, ohne Versionsstände zu vergleichen.

### Nachzug ist keine Überschreibung

Die Hard Rule verbietet eine *inhaltliche* Überschreibung — nicht jede
spätere Berührung einer `Accepted`-ADR. Zwei Fälle bleiben davon
ausdrücklich getrennt, beide ohne Folge-ADR:

- **Referenz-/Pfad-Nachzug.** Eine ADR verweist über eine Kennung, nicht
  über eine Adresse (dieselbe Doktrin wie bei einfrierenden Artefakten,
  [`../grundlagen/harness-dateien.md`](../grundlagen/harness-dateien.md)) —
  wo das nicht möglich ist, etwa bei einem Verweis auf ein vergängliches
  Artefakt wie einen Review-Report, trägt die ADR einen deklarierten
  Vermerk: Der Verweis *verfällt*, wenn sein Ziel verschwindet; die
  Entscheidung bleibt davon unberührt gültig.
- **Template-Feld-Nachzug.** Gewinnt die Ziel-Form ein neues Pflichtfeld
  (etwa den Re-Evaluierungs-Trigger oben), tragen bestehende
  `Accepted`-ADRs es nicht rückwirkend. Ein Grandfathering-Vermerk (Feld
  fehlt, Datum des Feld-Zugangs) reicht.

Beide Fälle ändern die Entscheidung nicht — nur ihre Adresse oder ihre
Form. Was mehr ist als das, bleibt bei der Hard Rule: Folge-ADR mit
`supersedes`. Eine Formulierung wie „ist ja nur ein Pfad-Nachzug" für eine
tatsächlich geänderte Begründung ist selbst ein Bruch der Hard Rule, keine
Ausnahme von ihr.

## Bedrohung, Grenze, Ausgang

Sicherheit *erkennen* lehren andere Module: Der Reviewer meldet ein
Sicherheits-Anti-Pattern als HIGH
([Modul 10](../04-qualitaet/modul-10-review-harness.md#finding-kategorien)), ein
Security-Gate findet einen Datenfluss-Befund
([Modul 13](../04-qualitaet/modul-13-quality-gates.md)), Telemetrie zeigt
Injection-Symptome ([Modul 16](../05-betrieb/modul-16-produktiver-betrieb.md)).
Hier geht es um das Davor: Eine Bedrohung wird *vor* dem Code benannt, und ihr
Ergebnis braucht einen Ort im Harness. Der Kurs lehrt dafür keine Methode —
STRIDE (Spoofing, Tampering, Repudiation, Information Disclosure, Denial of
Service, Elevation of Privilege) und Verwandte sind Denkhilfen, um Bedrohungen
zu finden —, sondern die **Aufnahme**: wohin Grenze, Bedrohung und Ausgang
gehören.

**Die Grenze steht in der Sicht**, mit der `ARC-*` ihrer Schnittstelle
([Modul 3 §Die Architektur-Sicht](modul-03-spec.md#die-architektur-sicht-specarchitecturemd)).

**Jede Bedrohung bekommt einen von drei Ausgängen, und jeder hat schon ein
Zuhause:**

| Ausgang | Zuhause | Verweis (aufwärts) |
|---|---|---|
| **gemindert** | eine `LH-*` mit Prüfung — eine `LH-QA` mit Messmethode oder ein Boundary- bzw. Negative-Kriterium einer `LH-FA`; *wie* die Eigenschaft gehalten wird, entscheidet eine ADR, wenn der Weg Architektur-Wirkung hat | Slice → `LH-*` und `ARC-*` der Grenze |
| **akzeptiert** | ADR mit ihrem *Warum* und einem Re-Evaluierungs-Trigger, der nennt, wann die Annahme kippt | ADR → `LH-*`, die den Rahmen setzt (`Bezug:`), ADR → `ARC-*` (`Schärft:`) |
| **offen** | Slice in `open/` | Slice → `ARC-*` und, wo es sie gibt, `LH-*` |

Die Bedrohung selbst steht in ihrem Wortlaut beim Ausgang: im Kontext der ADR
oder im Ziel des Slices. Eine `LH-*` formuliert die *Eigenschaft*, nicht die
Bedrohung
([Modul 3 §Typische Fehlvorstellungen](modul-03-spec.md#typische-fehlvorstellungen)).
Eine neue `LH-*` entsteht vor der Abnahme des Lastenhefts frei, danach nur per
Change Request mit Version-Bump
([§Spec-Stratifizierung](../grundlagen/source-precedence.md#spec-stratifizierung)).

**Eine Bedrohung ist kein Risiko des Slices.** Ein Risiko im Slice-Plan gehört
zur Lieferung dieses Slices und schließt mit seiner Closure — eingetreten,
entfallen oder weiter offen
([Modul 5 §Offene Risiken](../02-planung/modul-05-planning-harness.md#offene-risiken-werden-bei-closure-aufgelöst)).
Eine Bedrohung gehört zur Grenze und überdauert den Slice. Notiert ein
Slice-Plan eine Bedrohung als Risiko, nennt ihr Closure-Ausgang die `LH-*`, die
ADR oder den Slice in `open/`, der sie trägt; das Beobachtungs-Register ist
nicht ihr Ort.

**Kein eigenes Register.** Eine Bedrohungsliste mit Status-Spalte wäre eine
zweite Quelle für Ausgänge, die schon in `LH-*`, ADR und Slice stehen — und sie
driftete gegen sie wie ein Status-Feld gegen das Verzeichnis
([Modul 5 §Lifecycle als State Machine](../02-planung/modul-05-planning-harness.md#lifecycle-als-state-machine)).
Die Übersicht je Grenze ist ein **Auslesestand** aus den Aufwärts-Verweisen:
die ADRs, die die `ARC-*` schärfen, und die Slices, die sie nennen — soweit ihr
Kontext oder Ziel eine Bedrohung nennt —, dazu die `LH-*`, die diese Slices
nennen. Wie die RTM
([`begriffe.md`](../grundlagen/begriffe.md#kernbegriffe)) ist sie kein Artefakt.

**Für einen Wächter liefert das Modell nur Kandidaten.** Gehärtet wird ein
Wächter erst nach Beobachtung
([Modul 13 §Worked Example B](../04-qualitaet/modul-13-quality-gates.md#worked-example-b-guard-härtung-als-steering-loop-am-wächter));
das Bedrohungsmodell des Produkts speist Anforderung, Sicht und ADR, nicht den
Hook. Das Modell des Harness selbst — Prompt-Injection über Repo-Inhalte, die
Rechte des Agenten, der Container — hat andere Angreifer und andere Grenzen;
dieser Abschnitt behandelt es nicht.

## Typische Fehlvorstellungen

- **"Eine ADR begründet eine Anforderung."** — Nein. ADRs begründen die *Lösung*. Anforderungen begründet die Spec. Wer ADRs zur Spec macht, kann später keine Architektur ohne Lastenheft-Änderung wechseln.
- **"Wenn ich die Entscheidung ändere, schreibe ich die ADR um."** — Hard Rule: Accepted-ADRs werden nicht überschrieben. Folge-ADR mit `supersedes ADR-N`. Sonst kann der Reviewer-Agent nicht auf ältere Entscheidungen vertrauen.
- **"Eine ADR ohne Fitness Function ist eine ADR."** — Eine ADR ohne Fitness Function ist eine Absichtserklärung. Wer architecture fitness im Kopf hat, schreibt parallel den ArchUnit-Test.
- **"MADR ist Pflicht."** — MADR ist ein Format unter mehreren (auch Nygard, Tyree/Akerman). Wichtig ist, dass dein Repo *eines* konsequent benutzt.
- **"Architektur ist Bilder zeichnen."** — Diagramme sind *eine* Output-Form, nicht die Sache selbst. Architektur in diesem Kurs heißt: *Entscheidungen mit Begründung (ADR), prüfbar gemacht (Fitness Function), versioniert (Accepted-Hard-Rule)*. Ein Diagramm ohne ADRs hinter sich ist Wandtapete; eine ADR ohne Fitness Function ist Absichtserklärung. `spec/architecture.md` ist explizit *diagrammatisch und enthält keine eigenen Anforderungen* (siehe Spec-Stratifizierung in [`source-precedence.md#spec-stratifizierung`](../grundlagen/source-precedence.md#spec-stratifizierung)) — genau weil sonst Bilder anfangen würden, die ADR-Schicht zu ersetzen. Die `ARC-*`-Kennungen der Sicht ändern daran nichts: Sie adressieren Komponenten, damit man auf sie zeigen kann, und behaupten selbst nichts ([§ID-Schema](../grundlagen/source-precedence.md#id-schema-als-klammer)).
- **"ADRs sind Dokumentation, nicht Constraints."** — Klingt harmlos, ist die folgenreichste Fehlvorstellung in diesem Modul. Eine ADR ohne maschinelle Durchsetzung ist eine *Absichtserklärung*, die der Implementer-Agent freundlich liest und dann ignoriert, wenn ein anderer Pfad "einfacher" wirkt. Eine ADR *mit* Fitness Function ist ein Constraint — die Layering-Regel, die ArchUnit dem Agenten als roten Build entgegenhält. Worked Example in [Modul 13 §Worked Example "ADR → import-linter"](../04-qualitaet/modul-13-quality-gates.md#worked-example-a-vom-adr-satz-zur-fitness-function) zeigt, was die Übersetzung kostet (kleine Tabelle: ADR-Satz, Werkzeug, Make-Target, Failure-Beispiel). Wer das nicht macht, dokumentiert *Hoffnung*.

Weitere Präkonzepte, die diesem Kurs zugrunde liegen: [`../grundlagen/lernervorstellungen.md`](../grundlagen/lernervorstellungen.md). Ergänze deine eigenen.

## Worked Example: vom Diskussionsfaden zum prüfbaren ADR

> **Wenn du MADR-/Nygard-ADRs routiniert schreibst und Fitness Functions formulieren kannst, springe zu [§Übungen](#übungen).** Wer das Schema bereits hat, profitiert von Worked Examples weniger als Anfänger (Expertise-Reversal); für letztere ist die Sieben-Schritt-Schablone unten der Hauptlernträger.

**Ausgangssituation:** Im Team kommt wiederholt der Vorschlag, den
Service direkt mit der externen API zu sprechen ("warum Adapter? das ist
doch nur ein REST-Call"). Drei Vorfälle innerhalb von zwei Wochen.

**Schritt 1 — Triggerschwelle erreichen.** Drei Vorfälle = Symptom →
Lücke im Harness. Architect-Agent legt ADR-Entwurf an: `0007-service-adapter-layer.md`.

**Schritt 2 — MADR-Kopf:**
```markdown
# ADR-0007 — Service-Schicht spricht externe APIs nur über Adapter

* Status: Accepted
* Datum: 2026-06-15
* Bezug: LH-QA-COUPLING-002
* Supersedes: —
```

**Schritt 3 — Kontext (Spec-Verweis statt -Wiederholung):**
> Wiederholter Wunsch, im `service/`-Layer direkt `http.Client` zu
> instanziieren. LH-QA-COUPLING-002 verlangt, dass externe Abhängigkeiten
> austauschbar bleiben (für Replay und für Provider-Wechsel).

Die Richtung ist nicht beliebig: Der Kontext verweist **aufwärts** auf die
stabilere Quelle (Lastenheft, Spezifikation), nie abwärts auf einen Slice —
ein Slice ist volatiler als die ADR und kann sie nicht begründen
([§Referenz-Richtung (SDP)](../grundlagen/referenz-richtung.md#referenz-richtung-sdp-wer-darf-wen-referenzieren)).

**Schritt 4 — Optionen mit Trade-offs:**
> 1. **Direkt-Calls in Service-Schicht** — minimal Boilerplate; bricht LH-QA-COUPLING-002 (kein Replay ohne API-Mocks).
> 2. **Adapter-Schicht mit Interface** — etwas Boilerplate; erfüllt LH-QA-COUPLING-002; Replay-fähig.
> 3. **Service-Mesh / Sidecar** — verschiebt das Problem in Infrastruktur; überdimensioniert für aktuelle Repo-Größe.

**Schritt 5 — Entscheidung:**
> Option 2. Service-Layer importiert ausschließlich aus `adapter/`-Paket.
> HTTP-Client lebt unter `adapter/http/`.

**Schritt 6 — Konsequenz mit Fitness Function:**
> ArchUnit-Test `arch_no_direct_http_in_service`:
> Keine Klasse in `service.*` darf `java.net.http.*` oder `okhttp.*`
> importieren.
> Gate: `make arch-check` (vergleichbar mit dep-cruiser/dep-rule für
> Python/Go).

**Schritt 7 — Lerneintrag in `done/`** (nach Schließen der Welle, in
der ADR-7 implementiert wird):
> Steering-Loop-Beleg: drei Vorfälle in zwei Wochen → ADR-7 →
> ArchUnit-Test → kein weiterer Vorfall in 6 Wochen.

Sieben Schritte, eine geprüfte Entscheidung. Vergleich:
[`/lab/example/docs/plan/adr/`](../../../lab/example/docs/plan/adr/).

## Worked Example: eine Vertrauensgrenze, drei Bedrohungen, eine ADR

> **Wenn du Bedrohungen schon routiniert einem Ausgang zuordnest, springe zu [§Übungen](#übungen).**

**Ausgangssituation:** Die HTTP-API des Such-Dienstes soll im Team-Netz
freigeschaltet werden. Die Sicht führt sie als `ARC-006` (UI / HTTP-API), der
Service-Layer schickt jeden Suchbegriff an das Embedding-Modell (`ARC-007`).
Das Lastenheft ist abgenommen.

**Schritt 1 — Grenze benennen.** In der Sicht, Abschnitt Vertrauensgrenzen:
`ARC-006`, außen ein beliebiger Client im Netz, innen der Service-Layer; es
kreuzen Suchbegriff `q` und Trefferzahl `k`. Kein Wort über Bedrohungen.

**Schritt 2 — Bedrohungen finden.** STRIDE als Denkhilfe, keine Pflicht:

> (a) Ein `k` von einer Million lädt den ganzen Index in eine Antwort —
> *Denial of Service*.
>
> (b) Ein Client schickt Anfragen ohne Pause; jede kostet einen Aufruf des
> Embedding-Modells — *Denial of Service*.
>
> (c) Die API hat keine Authentifizierung; jeder Client im Netz tritt als
> berechtigter Nutzer auf — *Spoofing*.

**Schritt 3 — Ausgang je Bedrohung:**

| Bedrohung | Ausgang | Zuhause |
|---|---|---|
| (a) | gemindert | `LH-FA-02` begrenzt `k` schon in einem Boundary-Kriterium (der Wert steht in der Spezifikation); der Test dieses Kriteriums ist die Prüfung; der Slice, der die API freischaltet, nennt `LH-FA-02` und `ARC-006` |
| (b) | offen | keine `LH-*` begrenzt die Anfragerate, und entschieden ist nichts → `slice-anfragerate` in `open/`, nennt `ARC-006` und `ARC-007` |
| (c) | akzeptiert | ADR, Schritt 4 |

**Schritt 4 — Die ADR für den akzeptierten Ausgang:**
```markdown
# ADR-0020 — Such-API ohne Authentifizierung im Team-Netz

* Status: Accepted
* Datum: 2026-11-24
* Bezug: LH-FA-02
* Schärft: ARC-006
* Supersedes: —
```

`Bezug:` nennt die Anforderung, die den Rahmen setzt — die Suche —, nicht eine
Sicherheits-Eigenschaft: Eine `LH-QA`, die Authentifizierung verlangte, würde
die Akzeptanz brechen.

> **Kontext:** Jeder Client im Netz kann über `ARC-006` suchen, ohne sich
> auszuweisen. Der Dienst läuft im Netz eines Teams, der Index enthält nur
> Dokumente, die dort ohnehin jeder lesen darf.
>
> **Optionen:** (1) Token pro Client — Verwaltung ohne Gegenwert, solange
> nichts Vertrauliches im Index liegt. (2) mTLS — schützt auch den
> Transport, verlangt eine PKI. (3) Keine Authentifizierung, die Netzgrenze
> trägt — kein Aufwand, solange beide Annahmen halten.
>
> **Entscheidung:** Option 3. Die API bindet nur an das interne Interface.
>
> **Konsequenz:** Ein Test prüft, dass die Bind-Adresse nicht `0.0.0.0` ist.
> Die Nutzer-Kennung, die das Audit-Log gehasht festhält (`LH-FA-03`), ist
> unter dieser Entscheidung eine Angabe des Clients, kein Nachweis.
>
> **Re-Evaluierungs-Trigger:** Der Index nimmt vertrauliche Dokumente auf,
> oder der Dienst wird außerhalb des Team-Netzes erreichbar.

Der Trigger ist hier die Hälfte der Entscheidung: Er nennt genau die zwei
Annahmen, unter denen das Risiko tragbar ist.

**Schritt 5 — Was nicht entsteht.** Keine Bedrohungsliste mit Status. Die
Übersicht für `ARC-006` liest sich aus den Verweisen: `LH-FA-02` über den
Slice, ADR-0020 über `Schärft:`, `slice-anfragerate` in `open/`. Wird (b)
entschieden, wandert sein Ausgang: Soll die Rate gemindert sein, braucht sie
eine `LH-*` — gegen das abgenommene Lastenheft nur per Change Request mit
Version-Bump, bis dahin bleibt der Ausgang *offen* —; wird sie akzeptiert,
endet der Slice in einer ADR. Die Übersicht folgt von selbst.

## Übungen

Die folgenden vier ADR-Übungen aktivieren LZ 1 (je ein ADR im MADR-Format
*verfassen*); die fünfte aktiviert LZ 3: eine ADR-Verletzung wird nur
erkannt, wenn die ADR-Aussage prüfbar formuliert ist — der Lauf testet
die Vorstufe der Fitness-Function-Übersetzung. LZ 4
(superseded/deprecated und Folge-ADR) proben die beiden
Selbstcheck-Items am Modul-Ende; die sechste Übung aktiviert LZ 5.

* ADR für Modellwahl
* ADR für Tool Calling
* ADR für Evaluierung
* ADR für Layering (Beispiel nach OpenAI: `Types → Config → Repo → Service → Runtime → UI` — jede Schicht darf nur "abwärts" importieren) und parallele Fitness Function in ArchUnit/dep-cruiser
* Lass einen Agenten gegen eine vorhandene ADR-Verletzung laufen und prüfe, ob er sie erkennt
* **(Anwenden + Erschaffen — aktiviert LZ 5)** *Eine Vertrauensgrenze aufnehmen.* Nimm eine Schnittstelle, an der Daten von außen kommen — etwa `ARC-006` in [`lab/example/spec/architecture.md`](../../../lab/example/spec/architecture.md) oder eine aus deinem Repo. Finde zwei Bedrohungen (STRIDE als Denkhilfe), ordne jeder einen Ausgang zu und nenne sein Zuhause: `LH-*` mit Prüfung, ADR oder Slice in `open/`. Verfasse für einen akzeptierten Ausgang die ADR mit `Bezug:`, `Schärft:` und Re-Evaluierungs-Trigger. Prüfe am Ende: Steht irgendwo ein Status, der eine dieser drei Stellen wiederholt?

### Minimaler Übungspfad

1. Starte mit
   [`../../../lab/example/exercises/03-adr.md`](../../../lab/example/exercises/03-adr.md).
2. Kopiere die Vorlage
   [`../../../lab/templates/docs/plan/adr/NNNN-title.template.md`](../../../lab/templates/docs/plan/adr/NNNN-title.template.md)
   in dein Übungs-Repo.
3. Prüfe am Ende, ob deine ADR mindestens eine spätere Fitness Function
   vorbereitet. Wenn nicht, ist sie nur Entscheidungsnotiz, noch kein
   Harness-Guide.

> *Lab-Grenze:* Der minimale Pfad führt zur ersten ADR mit
> *Fitness-Function-Anker*, nicht zur fertigen Fitness Function. Das LZ
> "ADR-Aussage in eine maschinell prüfbare Fitness Function *übersetzen*"
> (LZ 3) wird erst in [Modul 13 §Worked Example](../04-qualitaet/modul-13-quality-gates.md#worked-example-a-vom-adr-satz-zur-fitness-function)
> abgerufen — der minimale Pfad ist Aufwärm-, nicht Ziel-Niveau.

## Reflexion

Vier Standardfragen aus [`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)
nach jeder Übung, besonders nach dem ADR-Verletzungs-Lauf.
Modul-spezifische Trigger:

- **Beobachtung:** Hat der Agent die ADR erkannt? Hat er die Verletzung benannt? Oder "schien einfacher" geantwortet (siehe Engage)?
- **2×2-Quadrant:** ADR-Erkennung ist *inferential feedforward*, ArchUnit-Test ist *computational feedback*.
- **Steering-Loop:** fehlende Fitness Function nachziehen? ADR-Bezug in `harness/README.md` schärfen?
- **Conceptual Change:** Kandidaten in [`lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "ADR ohne Fitness Function ist eine ADR", "ADRs sind Dokumentation, nicht Constraints").

## Selbstcheck

* **(Erinnern)** Welche vier Pflichtabschnitte hat ein MADR-ADR (Kopf-Felder + Body-Blöcke)?
* **(Analysieren — aktiviert LZ 2)** Ordne jede der drei Aussagen genau
  einem Artefakt zu — ADR, Spec oder Plan — und begründe pro Aussage in
  einem Halbsatz: (1) *"Wir nehmen PostgreSQL statt MongoDB."*
  (2) *"Die Antwortzeit der Suche bleibt unter 200 ms."*
  (3) *"Slice slice-trigram-index implementiert den Trigram-Index."* Eine der drei
  ist ein Grenzfall: Welche wandert in ein anderes Artefakt, sobald
  sich der Kontext ändert — und an welchem Kriterium entscheidest du
  das? (Das beantwortet zugleich Vorab-Frage 1: Was begründet eine
  ADR — Anforderung oder Lösung?)
* Wann wird aus einer ADR eine Architekturtest-Regel?
* **(Bewerten — aktiviert LZ 4 Bewerten-Hälfte)** Gegeben: ADR-0003 steht auf `deprecated`, ein Nachfolger ist *nicht* benannt. Ist `deprecated` hier der *korrekt gewählte* Status — oder eine verdeckte `superseded`-Lücke (Regel entfällt, aber kein Ersatz, also faktisch eine offene Entscheidung)? Entscheide mit Begründung und nenne das Kriterium, das den Ausschlag gibt: wann ist `deprecated` legitim, wann ist es ein falsch etikettiertes `superseded`?
* **(Anwenden)** Nimm eine ADR aus dem Lab oder einem eigenen Repo — formuliere in einem Satz, *was* eine Fitness Function maschinell prüfen würde, wenn du sie dazu schreiben müsstest.
* **(Erschaffens-Prozess)** Welcher Schritt deines ADR-Schreibens war der *unsicherste* — und warum? (Erfahrungsgemäß: Schritt 4 "Optionen mit Trade-offs" oder Schritt 6 "Fitness Function".)
* **(Anwenden — aktiviert LZ 5)** Ein Team legt `docs/security/threats.md` an: je Bedrohung eine Zeile mit Grenze, Beschreibung und Status (`offen` · `gemindert` · `akzeptiert`). Ordne jede Spalte ihrem Zuhause zu und bewerte die Datei: Was trägt sie, was doppelt sie?
* **(Erschaffen — aktiviert LZ 4 Erschaffens-Hälfte)** Gegeben: ADR-0007 *"In-Memory-Cache vor Index-Layer"* steht auf `superseded`, der Folge-ADR ist noch nicht geschrieben. Entwirf den Kopf des Folge-ADR (Status, `supersedes: ADR-0007`, `LH-*`-Bezug) plus einen Drei-Zeilen-Body-Entwurf, der mindestens *eine* explizit benannte Option und einen Trade-off enthält, der gegen ADR-0007 spricht.

### Selbstcheck-Rubrik

| Frage                                                                             | rudimentär                                                                  | solide                                                                                                                                                                                                                                                                                                                                                          | exzellent                                                                                                                                                                                                                                                                                                                                                    |
| --------------------------------------------------------------------------------- | --------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| MADR-Pflichtabschnitte (inkl. Re-Evaluierungs-Trigger)?                           | "Titel, Text."                                                              | Kopf-Felder (Status, Datum, Bezug, ggf. Supersedes) + Body-Blöcke (Kontext, Optionen mit Trade-offs, Entscheidung, Konsequenzen).                                                                                                                                                                                                                               | + Eine fehlende *Optionen*-Sektion ist die häufigste Drift: dann ist die ADR ein Postulat, kein Entscheidungsprotokoll — und Reviewer kann sie nicht verteidigen.                                                                                                                                                                                            |
| Drei Aussagen ADR/Spec/Plan zugeordnet, Grenzfall eingeordnet?                    | "1 ADR, 2 Spec, 3 Plan." — Zuordnung ohne Begründung, kein Grenzfall.       | Zuordnung mit Kriterium: die ADR begründet die *Lösung* (PostgreSQL), die Spec die *Anforderung* (200 ms), der Plan das *Wann/Wie pro Slice* (slice-trigram-index, mit ID-Bezug auf beide). Antwort auf Vorab-Frage 1: eine ADR begründet eine Lösung, nie eine Anforderung.                                                                                                 | + Grenzfall erkannt: *"Wir nehmen PostgreSQL"* wandert in die Spec, sobald der Kunde es vertraglich vorgibt — dann ist es Anforderung, und die ADR begründet nur noch das *Wie* darunter. Kriterium: Wer trägt den Bedarf — Auftraggeber (Spec) oder Lösungsraum (ADR)? Verknüpfung per ID-Bezug statt Wiederholung.                                         |
| Wann wird aus einer ADR eine Architekturtest-Regel?                               | "Wenn man sie prüfen will."                                                 | Wenn die ADR-Aussage maschinell formulierbar ist (Modul `X` darf `Y` nicht importieren; Layer `A` ruft `B` nicht direkt auf); Übersetzung in ArchUnit/dep-cruiser/import-linter.                                                                                                                                                                                | + Hinweis, dass ohne Fitness Function die ADR Absichtserklärung bleibt; und dass *jede* ADR diese Frage beantworten muss — auch wenn die Antwort "lässt sich nicht maschinell prüfen" lautet.                                                                                                                                                                |
| `deprecated` ohne Nachfolger — korrekt gewählt oder verdeckte `superseded`-Lücke? | "Deprecated heißt alt, passt schon." — kein Urteil, nur Etikett wiederholt. | Urteil mit Kriterium: `deprecated` ist legitim, wenn die Regel *ersatzlos* entfällt (der Bedarf existiert nicht mehr). Es ist ein falsch etikettiertes `superseded`, wenn der *Bedarf bleibt*, aber kein Nachfolger benannt ist — dann ist `deprecated` nur ein Etikett für eine offene Entscheidung. Kriterium: existiert der zugrunde liegende Bedarf weiter? | + Folge für Reviewer und Steering Loop: bei verdeckter Lücke fordert der Reviewer einen Folge-ADR und markiert HIGH; tritt das Muster dreimal auf, ist die ADR-Status-Vergabe selbst die Lücke (Guide: Status-Definition in die ADR-Vorlage). Superseded → Reviewer prüft gegen Nachfolger; echtes deprecated → Constraint-Scan entfernt den toten Codepfad. |
| Fitness-Function-Übersetzung in einem Satz?                                       | "Test schreiben."                                                           | Eine maschinell prüfbare Aussage in der Form "Komponente/Datei/Layer X darf (nicht) Y" — mit konkretem Werkzeug (ArchUnit/dep-cruiser/import-linter) und konkreter Gate-Verdrahtung (`make arch-check`).                                                                                                                                                        | + Wenn dir kein Satz einfällt: ADR-Aussage ist zu vage formuliert (nicht "lose koppeln", sondern "Service-Layer importiert nicht aus `runtime.*`"). Vage ADRs sind unprüfbare ADRs.                                                                                                                                                                          |
| Unsicherster Schritt des ADR-Schreibens?                                          | "Alles klar." (verdächtig)                                                  | Konkret benannter Schritt + Begründung (z. B. "Schritt 4 Optionen, weil ich zwei der drei erst beim Hinschreiben nachträglich überhaupt erwogen habe").                                                                                                                                                                                                         | + Pointe: wer Schritt 4 (Optionen mit Trade-offs) überspringt oder schwammig hält, postet ein *Entscheidungs-Ergebnis* ohne *Entscheidungs-Belege* — und genau das macht ADRs unverteidigbar im Review. Schritt 6 (Fitness Function) ist die zweite häufige unsichere Stelle; wer hier "lässt sich nicht prüfen" schreibt, hat oft nur zu vage formuliert.   |
| Bedrohungsliste mit Status bewertet? | „Gute Übersicht, behalten." | Die Status-Spalte doppelt die Ausgänge: gemindert steht als `LH-*` mit Prüfung, akzeptiert als ADR, offen als Slice in `open/` — die Liste driftet gegen sie wie ein Status-Feld gegen das Verzeichnis. Grenze → Sicht (`ARC-*`), Beschreibung → beim Ausgang (Kontext der ADR, Ziel des Slices). | + Die Übersicht bleibt erreichbar, als Auslesestand aus den Aufwärts-Verweisen wie die RTM; und eine Zeile ohne Ausgang ist der eigentliche Befund — sie wird ein Slice in `open/`, kein „offen" in einer Tabelle. |
| Folge-ADR zu superseded ADR-0007 entworfen?                                       | Kopf vorhanden, Body sagt nur "neue Entscheidung".                          | Kopf mit `supersedes: ADR-0007` und `LH-*`-Bezug; mindestens eine explizit benannte Option (z. B. *Read-through-Cache hinter Index-Layer* vs. *Cache entfernen*) plus ein Trade-off, der ADR-0007 widerlegt (z. B. *"Stale-Reads im Worked Example von Modul 10 zeigen, dass die ursprüngliche Annahme 'Cache kann nicht stale werden' nicht hält"*).           | + Eine Konsequenzen-Zeile, die explizit auf die Fitness Function des Vorgänger-ADR zurückwirkt: bleibt sie? wird sie verschärft? entfällt sie? Wer das offen lässt, verschiebt das Drift-Risiko nur.                                                                                                                                                         |

## Weiterlesen

* Repo mit 10 ADRs als Beispiel-Korpus: `pt9912/u-boot` in [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
* Nächstes Modul: [Modul 5 — Planning Harness](../02-planung/modul-05-planning-harness.md)
