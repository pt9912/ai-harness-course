# Umgebungs-Zusage — Plan zur Erweiterung

**Stand:** umgesetzt in Welle 166 ([`CHANGELOG.md`](../CHANGELOG.md)), MINOR, nicht
released. Befund (§1) gegen den Arbeitsbaum nach `2f30660` belegt; A1–A9 in §5
entschieden, die Messungen in §6a gelaufen.

**Anlass.** [Modul 14](../kurs/de/05-betrieb/modul-14-docker-harness.md) führt den
Container als *den* „Reproduzierbarkeits-Anker“ (Begriff des Korpus; der Plan prüft
**Umgebungs-Zusage** als Ersatz, A1 entschieden). Die Frage: Welche Zusagen und Träger gibt es
noch, und fehlt ein Gate, das das Vorhandensein der benötigten Werkzeuge und
ihrer Versionen **prüft**?

**Richtung (Vorgabe des Maintainers, 2026-11-19).** Die **Umgebungs-Zusage**
(A1, Option a) ist der **Ausgangspunkt** für Docker und Dockerfile —
und ebenso für deren Alternative, den **Tool-/Versions-Check**. Docker ist damit
nicht mehr die Setzung, aus der alles folgt, sondern **ein Träger** einer
Anforderung. Der Plan folgt dieser Richtung (§2a).

## 1. Befund — was der Korpus heute als „Anker“ führt

Der heutige Begriff „Reproduzierbarkeits-Anker“ steht in Modul 14 als Lernziel
(„Image-Hash und Lock-Files als Reproduzierbarkeits-Anker *einsetzen*“), als
Fehlannahme und als Abschnitt „Zwei Formen des Reproduzierbarkeits-Ankers“
(Archiv · Rezept); als Satz „Image-Hash und Lock-Files sind die
Reproduzierbarkeits-Anker“ steht er in `lernpfade.md`, als Pflicht-Abschnitt der
Freigabe-Checkliste in der Lösung zu Modul 16. Er ist **nirgends** als eigene
Klasse definiert; die einzelnen Pins sind über sechs Module
verstreut. Die Zusammenstellung nach dem, was sie **pinnen** (jede Zeile ist ein Träger der Umgebungs-Zusage oder ein Teil davon):

| Träger | Pinnt | Drift-Klasse | Wo geführt | Wer prüft, dass er hält |
|---|---|---|---|---|
| **Image-Digest** (Archiv/Rezept) | Toolchain und Laufzeit-Image | Toolchain | Modul 14; Beleg `harness/image-hash.txt` | Replay-Diagnose Rang 1 (`runtime.image_hash` verglichen, Modul 12) und Release-Checkliste (identischer Hash in Klon und CI, Lösung zu Modul 16) — **manuell bzw. per Replay, kein Sensor** |
| **Base-Image per Digest** (`FROM …@sha256:`) | Eingangs-Image | Toolchain | Modul 14 | — |
| **Lock-File + `--frozen`** | Abhängigkeits-Versionen | Dependency | Modul 14 | der Build selbst (`--frozen` bricht) |
| **Installer-Pin** (`uv==…`) | das Werkzeug, das installiert | Toolchain | Modul 14 | — |
| **Replay-Manifest** (`image_hash`, `model.version`, `seed`, `determinism:`, `prompt_context`-Hash, `runtime.env`, `timestamp_masking`, `inputs_ref`) | Lauf: Toolchain, Modell, Zufall, Prompt, Umgebung, Daten | Toolchain · Modell · Erwartung | Modul 12 | Replay-Harness (Diagnose-Reihenfolge) |
| **Vendorte Baseline + `SHA256SUMS`** | Regelwerk und Templates des Adopters | Regelwerk | Modul 2 | Integritätsprüfung der Baseline, d-check `sources` (Integritäts-Hälfte, Modul 2) |
| **Pin des Prüfwerkzeugs** (`DCHECK_DIGEST`) | das Gate-Werkzeug selbst | Gate-Werkzeug | Modul 2 (`DCHECK_DIGEST`-Platzhalter, „bei jedem d-check-Bump“), Vorlage `lab/templates/Makefile` | — |
| *Querverweis, kein Träger:* **Reproduzierbarkeits-Bindung** | Klasse der Bindung-Spalte eines Gates (Image-Hash, Toolchain-Pin): das Gate hängt an einem bit-identischen Artefakt | — | `harness-dateien.md`, eine der vier kanonischen Klassen | — |

**Zwei Beobachtungen.**

1. **Zusage und Prüfung fallen auseinander — als Sensor.** Fast jede Zeile hat ein Pin, aber in
   der rechten Spalte steht oft nichts. Der Image-Digest wird **festgehalten**
   (`image-hash.txt`), aber kein Sensor vergleicht ihn mit dem, was gerade läuft.
   Ausnahmen sind `--frozen` (der Build bricht selbst) und der Replay-Vergleich.
2. **Ein Gate, das Werkzeug-Vorhandensein und -Version prüft, gibt es im Korpus
   nicht.** Gesucht wurde nach *tool-version*, *--version*, *toolchain-check*,
   *command -v*, *which*; Treffer sind nur Prosa („Host-Toolchain ist nicht
   versionsgleich mit CI“, Modul 14) und das Tool-Call-Gate `MR-004` aus
   [Modul 13](../kurs/de/04-qualitaet/modul-13-quality-gates.md), das den
   **Aufruf** am falschen Werkzeug verhindert, nicht die Version prüft.

## 2. Ordnungsprinzip: Wirkung statt Träger

Die Regel des Korpus ist nicht „benutze Docker“, sondern **„die Umgebung ist die,
die behauptet wird“**. Der Container ist ein *Träger* dieser Wirkung, nicht die
Wirkung. Für den Plan heißt das: Träger werden nach der **Frage** geordnet, die sie
beantworten, nicht nach dem Werkzeug.

| Frage | Zusage-Klasse | Träger (Beispiele) |
|---|---|---|
| *Welche Bytes laufen?* | Artefakt-Adresse | Image-Digest, Release-`SHA256SUMS`, vendorte Baseline |
| *Welche Version von was?* | Versions-Pin | Lock-File, Installer-Pin, Base-Image-Digest, **Tool-Versions-Manifest** |
| *Welche Eingaben und welcher Zufall?* | Lauf-Pin | Replay-Manifest: `inputs_ref`, `seed`, `determinism:` |
| *Welches Modell, welcher Prompt?* | Modell-Pin | `model.version` (ohne Alias), `prompt_context`-Hash |
| *Welcher Zustand beim Start?* | Umgebungs-Pin | `runtime.env`, Zeitzone, Locale |
| *Hält der Pin noch?* | **Zusage-Prüfung** | Vergleich Soll ↔ Ist — hier fehlt das Gate |

Die letzte Zeile ist die Lücke: Sie ist kein weiterer Träger, sondern die
**Prüfung**, dass die anderen noch tragen.

## 2a. Ausgangspunkt: die Anforderung, zwei Träger

**Befund, der die Umstellung trägt.** Der Korpus begründet die *Anforderung*
(lokal und CI sollen dasselbe laufen; Toolchain driftet) gut — aber nicht, dass
sie **mit Docker** zu erfüllen ist. Die Regel „kein `pip install` außerhalb
von Dockerfile-Stages“ (Modul 9) setzt Docker voraus und
kann **die Wahl von Docker** nicht begründen (innerhalb eines Docker-Repos trägt
die Regel: „Toolchain-Reproduzierbarkeit“ begründet das Nicht-Umgehen);
„Supply-Chain-Defense“ steht dort ohne Mechanismus (Modul 9; die Vorlage
`AGENTS.template.md` §3.1 übernimmt es, bedingt formuliert: „Wenn das Repo
Docker-only ist“). Modul 14 wägt Devcontainer
gegen Compose ab und begründet „Docker-only“ mit „Tools driften am schnellsten“;
**gegen konstruktive Alternativen** (Nix, devbox, asdf, mise, Podman, VM) wird
die Wahl nirgends abgewogen (Suche in Modul 14, Regelwerk und Modul 9: kein
Treffer).

**Die Zusage** (A1, Option a — die belegbare Selbstaussage der Umgebung): *Die Umgebung, in der ein
Lauf stattfindet, ist die, die behauptet wird — und das lässt sich belegen.*
Sie hat zwei Teile: Die Umgebung ist **festgelegt**
(gepinnt) und sie ist **adressierbar** (es gibt einen Beleg, der sagt, welche es
war).

**Beide Träger sind zulässig** (Maintainer, 2026-11-19): **Docker/Dockerfile**
und **Tool-Pin mit Tool-/Versions-Check**. Der Check allein erfüllt nur den Teil
*adressierbar/belegbar*, nicht *festgelegt*; der zweite Träger ist deshalb das
Paar aus **Tool-Pin** (die Versionen der Werkzeuge sind deklariert oder gelockt:
Manifest, Lock, Versionsmanager) und **Check** (stellt fest, ob die Umgebung sie
trägt). Der Pin legt fest, der Check belegt. Beide Träger erfüllen damit beide
Teile der Zusage, auf verschiedenem Weg. Weitere konstruktive Träger (Nix,
devbox, asdf, mise, VM) behandelt der Korpus nicht; sie sind ein offener Faden
(A6), keine Behauptung.

**Zwei Träger, mit verschiedener Wirkungsweise:**

| | **Docker / Dockerfile** | **Tool-Pin + Tool-/Versions-Check** |
|---|---|---|
| Wirkungsweise | **konstruktiv** — baut die Umgebung aus gepinnten Eingaben; sie soll dann die behauptete sein | **deklarativ und feststellend** — der Pin legt die Versionen fest, der Check stellt fest, ob die vorhandene Umgebung sie trägt |
| Festlegung durch | Digest, Lock-File, Stages | Tool-Pin: deklariertes Soll (Manifest, Lock oder aus der Pin-Stelle abgeleitet, A2) |
| Beleg / Adresse | Image-Digest, `image-hash.txt` | Prüfprotokoll: Werkzeug, Soll, Ist |
| Isolation | ja (eigenes Dateisystem; kein Netz nur mit `--network none`) | nein — die Umgebung bleibt die des Hosts |
| Voraussetzung | Docker am Host (selbst ungepinnt) | Werkzeuge am Host; kein Container nötig |
| Schwäche | Host-Abhängigkeit; Rootless/Mount-Besitz; ein Pin, der etwas anderes installiert, als er behauptet | prüft nur, was das Soll nennt; Drift **zwischen** zwei Prüfungen bleibt unbemerkt; keine Isolation |
| Trägt, wenn … | das Repo Docker nutzen darf und die Toolchain im Image liegt | kein Container möglich ist (Embedded, Host-gebundene Toolchain, Agent-Umgebung) oder der Container **geprüft** werden soll |

**Sie schließen sich nicht aus.** Wo Docker trägt, ist der Check die
**Zusage-Prüfung** (§1 Beobachtung 1: Der Digest wird festgehalten, aber nicht
gegen das Laufende verglichen). Wo Docker nicht trägt, ist der Check **selbst der
Träger**. Das ist derselbe Mechanismus in zwei Rollen — und der Grund, ihn *nicht*
als bloßes Anhängsel des Containers zu führen.

**Was der Kurs daraus lehrt:** Anforderung zuerst; dann zwei zulässige Träger mit
ihren Folgen; die Wahl trifft der Adopter (wie bei A2) und kann sie als ADR
festhalten, mit den betrachteten Optionen. Modul 14 behält seine Disziplinen
(Digest, Stages, Besitz der Belege) und bekommt den zweiten Träger daneben
(Teil B).

## 3. Das Tool-/Versions-Gate

**Idee.** Ein Gate, das vor den fachlichen Gates feststellt: Sind die benötigten
Werkzeuge **da**, und haben sie die **deklarierte Version**? Schlägt es an, ist
„rot“ dann ein Umgebungs-Befund und kein Befund über den Code. Das ist die
Diagnose-Reihenfolge aus Modul 12 (Rang 1: Toolchain-Drift) als Vorabprüfung.

**Warum es auch bei Docker-only etwas prüft.** Man könnte meinen, der Image-Digest
mache es überflüssig. Das stimmt nur, wenn das Image tut, was sein Name behauptet:

| Fall | Was der Digest sagt | Was nur das Versions-Gate fängt |
|---|---|---|
| **Host** (Docker, `make`, `buildx`, `git`) | nichts — der Host liegt außerhalb des Images | Host-Werkzeug fehlt oder ist zu alt (der Start des Gates scheitert sonst kryptisch) |
| **Im Image** | *dass* es dieses Image ist | dass **darin** die Version steckt, die die Deklaration behauptet (ein Pin, der etwas anderes installiert, als das Manifest sagt) |
| **Host-Werkzeuge außerhalb des Images** (`bash`, `make`, `sed`, `awk`, `grep`, `git`, `docker`) | nichts — sie liegen vor dem Image und rufen es auf | **alle**, die ein Skript aufruft: Am Host sind sie nicht versionsgleich mit dem Image (`bash` 3.2, `make` 3.81, BSD-Varianten). Auch sie gehören ins Inventar. |
| **Repo ohne Docker** (Rezept-Form ohne Container) | nichts — es gibt keinen Digest | das Gate **ist** der Träger der Zusage; ohne es gibt es keinen |
| **Agent-Umgebung** | nichts | Tool-Allowlist und tatsächliche Werkzeuge stimmen überein (vgl. Release-Checkliste in der Lösung zu Modul 16: „Tool-Allowlist = Stand der AGENTS.md“) |

**Das Gate im Rahmen dieses Korpus — Randbedingungen.**

1. **Eine Quelle für „Soll“.** Das Gate vergleicht Ist gegen Soll. Steht das Soll
   in einer *zweiten* Datei neben dem Pin (`Dockerfile`, Lock-File), driften beide
   auseinander: Das Gate prüft dann seine eigene Abschrift. Entweder wird das Soll
   **aus dem Pin abgeleitet** (Soll = was das `Dockerfile` installiert), oder das
   Manifest ist die einzige Quelle und das Dockerfile liest daraus. Welcher der
   beiden Wege gilt, entscheidet **der Adopter** (A2); der Kurs lehrt beide.
2. **Bindepunkt.** Es ist ein Gate (Preflight vor `make gates`), kein
   Tool-Call-Gate: Es soll nicht einen Aufruf verhindern, sondern die Umgebung
   feststellen. Einordnung in die drei Bindepunkte der
   [Durchsetzungsschicht](../kurs/de/grundlagen/durchsetzungsschicht.md#drei-bindepunkte)
   ist Teil des Plans.
3. **Rot muss lesbar sein.** Es meldet **welches** Werkzeug, **soll** und **ist**.
   Das ist die Fehlalarm-Frage aus Modul 13: Ein Gate, das bei jeder
   Patch-Abweichung rot wird, kostet sich die Existenz. Die Vergleichsstärke
   (exakt, Minor, Mindestversion) ist **A3**.
4. **Eine Prüfung muss prüfen.** Break-Test vor der Behauptung: absichtlich ein
   Werkzeug entfernen und eine Version verschieben, beides muss rot werden;
   unverändert muss grün bleiben. Ohne den Test wäre es „ein halluziniertes Gate“
   im Sinn von `AGENTS.md` §3/§4.
5. **Keine neuen Prüf-Skripte in *diesem* Repo** (`AGENTS.md` §4). Das betrifft
   die Umsetzung hier, nicht die Lehre: Der Kurs lehrt das Muster
   werkzeug-agnostisch; ob d-check ein Modul dafür trägt, ist vorab auf
   **Baubarkeit** zu klären (Ziel-Verzeichnis, Ignores, Scan-Roots), sonst
   behauptet der Plan ein Gate, das es nicht gibt (**A4**).

## 3a. Anschauung aus zwei Konsumenten-Repos

**Rang.** Gelesen wurden zwei Repos, die den Kurs als Baseline nutzen:
**u-boot** und **hetzner-viper** (nur gelesen, nichts ausgeführt; beide Stände
vom 2026-11-19). Sie sind **Anschauung, keine Begründung**: Fremd-Repos
begründen den Kurs nie, auch Konsumenten nicht — ein Stand ist ein Stand, und
eine Regel, die auf einem Fremd-Repo ruht, wird still falsch, sobald dort jemand
etwas ändert. Jede Aussage dieses Abschnitts ist **Entwurfsrichtung** für die
Fragen A2, A3 und A7; die Begründung muss der Kurs selbst tragen.

**Beide haben den Tool-/Versions-Check bereits.** Je ein Skript
`tool-pruefung.sh` (u-boot nennt es „das Laufzeit-Gate der Pin-Inventur“), und
dazu das d-check-Modul `pinsync` (§3b), das **beide** Repos fahren. Was daran für den Plan zählt:

| Frage | Beobachtung | Richtung für den Plan |
|---|---|---|
| **A2** Quelle des Solls | Beide lesen das Soll **aus der Pin-Stelle selbst**, nicht aus einer Kopie (u-boot: `repo.mk`; hetzner-viper: `Dockerfile` und `go.mod`). Kein eigenes Manifest. | Soll **ableiten**, kein zweites Manifest — das beantwortet die Zweite-Quelle-Sorge aus §3 Punkt 1. |
| **A2** zwei Prüfungen, nicht eine | **Stellen-Abgleich:** die Pins stimmen untereinander überein (u-boot: vier Stellen in einem Test; hetzner-viper: `go.mod` gegen `Dockerfile`). **Laufzeit-Gate:** die installierten Werkzeuge tragen den Pin. Das eine braucht keine Werkzeuge, das andere läuft im Kontext. | §3 führt beides als „das Gate“ zusammen. Der Plan trennt es: **Stellen-Abgleich** (statisch, prüft die Pins) und **Laufzeit-Gate** (dynamisch, prüft die Umgebung). Beide sind Prüfungen derselben Zusage. |
| **A3** Vergleichsstärke | Je Werkzeug eine von **drei Prüfformen:** exakt bzw. per Teilstring (`go`, `golangci-lint`, siehe unten), Mindestversion (`make`), Anwesenheit (`bash`, `curl`, `gh`, `git`, `docker`) — **`bash` nur auf Anwesenheit zu prüfen ist am Host zu schwach** (siehe unten). `sed`, `awk` und die Coreutils bleiben ungeprüft („Basis-Image-Grenze“). | „Exakt im Image, Mindestversion am Host“ war zu grob. **Die Ausnahme „ungeprüft“ trägt nur im bekannten Image:** Am Host gibt es von `sed`, `awk`, `make` und `grep` **GNU- und BSD-Varianten** mit verschiedenem Verhalten. Der Plan führt deshalb **vier Formen je Werkzeug:** exakt · Mindestversion · **Fähigkeit** (die Eigenschaft, die ein Skript braucht, wo sich Implementierungen unterscheiden) · Anwesenheit — siehe A3. **Kein Werkzeug bleibt ungeprüft** (Maintainer, 2026-11-19): Jedes Werkzeug, das ein Skript des Repos aufruft, steht im Inventar und trägt eine Prüfform. Auch „Anwesenheit“ ist eine Prüfform, aber eine **entschiedene** — keine Ausnahme von der Prüfung. Eine Pauschale „Coreutils“ gibt es nicht. Die Entscheidung je Werkzeug gehört in die Deklaration, nicht ins Skript. Offen bleibt, **woher das Inventar kommt** (A8). Zudem sind `sed` und `awk` **keine Coreutils**; die Pauschale hat zwei Pakete verdeckt. **Dieselbe Klasse trifft `bash`:** macOS liefert als `/bin/bash` die Version 3.2 (ohne assoziative Arrays, `mapfile`, `${var,,}`); die Anwesenheitsprüfung beider Konsumenten-Repos geht dort grün und lässt ein Skript scheitern, das Bash 4 voraussetzt. `bash` gehört auf **Mindestversion**, und zwar auf die, die die Skripte des Repos tatsächlich brauchen. Die Klasse ist allgemein: **Systemwerkzeuge des Hosts sind nicht versionsgleich mit dem Image** (`bash` 3.2, `make` 3.81, BSD-`sed`/`awk`/`grep`), und genau dort trägt „Anwesenheit“ nichts. |
| **A7** Bindepunkt und Ort | Das Gate hängt in `make gates` und läuft im **laufenden Kontext**; u-boot: „der Lauf-Ort ist egal, die Werkzeuge sind die Trägerschaft“. | Der Check ist **vom Träger unabhängig** (Devcontainer, CI, Host): Er prüft, was läuft, nicht wie es gebaut wurde. **Beobachtung:** Ob das die Trennung Zusage / Träger trägt, ist im Kurs herzuleiten (§2a), nicht aus diesen Repos. |
| **A7** Rot-Stufen | `sshd` fehlt → nur Warnung; sonst Rot mit Werkzeug- und Pin-Namen. | Zwei Stufen (Rot, Warnung) sind belegt; wann welche gilt, ist in §5 (A7) entschieden. |
| **A6** Docker-Wahl | u-boot-ADR-0043 wägt fünf Optionen ab (zwei Modi, Toolchain-Image ohne Devcontainer u. a.) — **innerhalb** von Docker. Gegen Nix, devbox, asdf, mise oder VM wägt keines der beiden Repos ab. | Beobachtung. Die Lücke belegt die Suche im Kurs (§2a), nicht dieses Repo. |
| **Supply-Chain** | u-boot-ADR-0041 verifiziert eine nutzergewählte Werkzeug-Version gegen die **offizielle Prüfsummen-Quelle** (SHA-256 je Architektur). | Ein **Mechanismus** für das, was Modul 9 nur als „Supply-Chain-Defense“ etikettiert. Der Kurs müsste ihn selbst herleiten (Pin und Prüfsumme statt „Container“), nicht von dort übernehmen. |

**Prüfqualität der Vorbilder (nachgeprüft, beides Anschauung für §3 Punkt 4).**
- **u-boot prüft „exakt“ per Teilstring:** `case *"$want"*` lässt `go1.27.30` auf
  den Pin `1.27.3` passen. hetzner-viper prüft exakt (Präfix mit Leerzeichen).
- **u-boots `make`-Mindestversion vergleicht per `awk` als Dezimalzahl:**
  `4.10 < 4.4` ergibt dort wahr, also ein falsches Rot. hetzner-viper prüft
  `make` nur auf Anwesenheit.
Beide Fehlerbilder zeigen, wofür die Break-Probe da ist: Eine Prüfung, die „richtig
aussieht“, ist keine geprüfte Prüfung.

**Eine Beobachtung zu stillen Ausgängen.** hetzner-viper setzt
`VIPER_REQUIRE_TOOLS=1` im `make test`: Ein fehlendes Werkzeug ist dort ein
Fehler, ohne die Variable würden die Tests **still überspringen**. Im Gate ist
der stille Ausgang also zu. Das ist die Klasse „erwartete Stille ist eine
Aussage“ (`AGENTS.md` §3) und ein Szenario für Teil B (*Werkzeug fehlt → rot,
nicht übersprungen*). Beide Vorbilder geben bei Erfolg eine **OK-Zeile** aus; das
Verdikt „still“ gilt dort nicht, es heißt Exit 0 ohne Befund.

**Nicht geprüft.** Ob die beiden Skripte **wirklich prüfen**, ist offen: Ein Break-Test
(Werkzeug entfernen, Version verschieben) ist in keinem der beiden Repos
belegt, und zwei Fehlerbilder stehen oben. Vor einer Übernahme der Form ist der
Break-Test Pflicht (§3 Punkt 4).

## 3b. d-check als Träger — was es kann, was nicht

**Rang.** Gelesen wurde das Benutzerhandbuch von d-check v0.91.0 (nichts
ausgeführt). d-check ist das Prüfwerkzeug dieses Repos (`AGENTS.md` §4); der Kurs
lehrt das Muster aber werkzeug-agnostisch und nennt d-check nur dort, wo er es
heute schon tut (Modul 2). Dieser Abschnitt beantwortet A4 für die Teile des
Gates, nicht die Frage, was der Kurs vorschreibt.

| Teil des Gates | d-check | Befund |
|---|---|---|
| **Stellen-Abgleich** (derselbe Wert an mehreren Stellen) | Modul **`pinsync`** (neu in v0.91.0, opt-in über `--enable pinsync`) | **trägt gut.** Ein Pin hat einen Namen und mindestens zwei Quellen (Datei plus Ausdruck mit genau einer Fanggruppe); gleich oder Befund auf der Zeile des Treffers. Hermetisch: kein git, kein Netz, **kein Programmstart**, kein Schreiben. Liest auch Dateien ohne Markdown-Endung (`Dockerfile`, `Makefile`). |
| **Laufzeit-Gate** (installierte Werkzeuge tragen den Pin) | — | **trägt nicht, konstruktiv.** d-check startet kein Programm und prüft Repo-Text, nicht die Umgebung; es läuft selbst in einem Container ohne Netz und sähe nur sein eigenes Image. `go version`, die Bash-Version, GNU oder BSD sind außerhalb seiner Reichweite. Braucht ein Skript im laufenden Kontext. |
| **Inventar-Vollständigkeit** (A8) | kein passendes Modul | Nichts parst Werkzeug-Aufrufe in Shell-Skripten gegen ein Inventar. `mentions` prüft Dateien einer Soll-Menge gegen Dokumente, nicht Werkzeugnamen; `targets` prüft Doku-Tabellen gegen Makefile-Regeln. **A8 (a) ist mit d-check heute nicht baubar.** |

**Grenzen von `pinsync` selbst** (Handbuch §4.27, „Was das Modul nicht sagt“):
- Verglichen wird **byte-genau**: `1.27` und `1.27.0` sind verschieden; ein
  führendes `v` steuert der Ausdruck, nicht ein Schalter.
- Es prüft nicht, ob der Ausdruck die **richtige** Stelle trifft: Ein Treffer in
  einer Kommentarzeile mit passendem Wortlaut ist ein Treffer.
- Die Bezugsmenge sagt, was gelesen wurde, nicht, dass **jeder** Pin des Repos
  erfasst ist — das ist dieselbe Vollständigkeitsfrage wie A8, eine Ebene tiefer.

**Folgen für die Entscheidungen:**
- **A2 öffnet sich.** Mit `pinsync` ist auch ein **eigenes Manifest** tragbar: Die
  Zweite-Quelle-Sorge aus §3 Punkt 1 löst sich, weil das Werkzeug Manifest und
  Pin-Stelle gegeneinander hält. „Ableiten, kein Manifest“ (§3a) ist nicht mehr
  die einzige Richtung; sie bleibt die einfachere (eine Quelle weniger).
- **A4 ist für zwei von drei Teilen beantwortet:** Stellen-Abgleich ja, Laufzeit-
  Gate nein, Inventar-Vollständigkeit nein.
- **A8 verliert Weg (a);** entschieden ist (c) + (d) (§5).
- **Das Laufzeit-Gate ist ein Skript des Adopters.** `AGENTS.md` §4 (keine neuen
  Prüf-Skripte) gilt für dieses Repo, das nur Doku führt; der Kurs lehrt das Gate
  für Repos, die Werkzeuge nutzen. Für dieses Repo selbst entsteht kein Skript.

**Im Einsatz (Anschauung, nicht Begründung).** Beide Konsumenten-Repos nutzen
`pinsync` bereits. **hetzner-viper** fährt es als eigenes Gate-Target (`pinsync`
in `GATE_CHECKS`, d-check v0.91.0 per Digest gepinnt) mit nur diesem Modul;
Pin-Gruppen: `go` (Dockerfile, Devcontainer-Dockerfile, `go.mod`) und
`golangci-lint`. **u-boot** hat das Modul in der Modulliste und fünf Quellen für
`go`. Drei Dinge daran sind für den Plan lehrreich:
- **Granularität je Quelle über die Fanggruppe.** u-boot fängt bei `go` nur
  `Major.Minor` (die `go`-Direktive in `go.mod` steht auf `1.27.0`, die Toolchain
  auf `1.27.3`) und lässt den Patch-Teil in den `GO_VERSION`-Stellen: Ein Pin
  kann an verschiedenen Stellen verschieden fein stehen, und der Ausdruck legt
  fest, was verglichen wird (vgl. A3).
- **Dieselbe Prüfung zweimal.** hetzner-vipers `tool-pruefung.sh` vergleicht
  `go.mod` und `Dockerfile` selbst, obwohl `pinsync` das übernimmt; die Aufteilung
  aus §3a (Stellen-Abgleich statisch, Laufzeit-Gate dynamisch) ist dort nur
  halb durchgeführt.
- **Beobachtung zur Ausnahme-Begründung.** u-boot begründet in der Konfiguration,
  `bash`, `sed` und weitere Shell-Werkzeuge trügen keine Einzel-Pins, weil ihre
  Versionen „mit dem Basis-Image des jeweiligen Pins“ kämen. Das gilt im Image und
  nicht am Host (Zeile „Host-Werkzeuge“ in §3). Warum A3 die Ausnahme verwirft,
  ist im Kurs herzuleiten (Host-Werkzeuge sind nicht versionsgleich mit dem
  Image, Modul 14), nicht aus diesem Repo.

**Versions-Stand.** Der Pin dieses Repos steht auf **d-check v0.91.0**
(`DCHECK_DIGEST` in `Makefile`, `sha256:5d2f650d…`; Beispiel und Fragmente
ebenso). `pinsync` ist damit verfügbar, **opt-in** und an der Wurzel **nicht
aktiviert**; ein Kapitel, das es nennt, braucht keinen weiteren Bump. Die
Beispiel-Stufe hat es mit Welle 166 aktiviert (ein Pin, `go`; `SPEC-028`).

## 4. Wohin im Kurs

- **Primär: Modul 14.** Die „Umgebungs-Zusage“ wird als **Anforderung**
  definiert (heute nur gebraucht, und dort für den Träger), Docker und der
  Versions-Check stehen als zwei Träger nebeneinander (§2a), dazu die
  Frage-Tabelle aus §2. Das Tool-/
  Versions-Gate steht neben `--frozen` und `image-hash.txt` als dritte Disziplin
  (*prüfen, dass der Pin hält*) — **in Teil B**, nicht in Teil A.
- **Sekundär: Modul 13.** Das Gate als Preflight-Klasse neben Gate/Beleg; der
  Worked Example MR-004 argumentiert, ein Gate stelle den Fehlaufruf nur
  *nachträglich* fest, der Tool-Call-Gate sei deshalb besser. Ein Preflight in
  `make gates` erreicht den direkten `pytest`-Aufruf **nicht**; das Versions-Gate
  ergänzt MR-004 (Umgebung feststellen), ersetzt es nicht. Die Abgrenzung muss in
  Modul 13 stehen.
- **Modul 12.** Die Diagnose-Reihenfolge (Rang 1 Toolchain-Drift) verweist auf das
  Gate als maschinelle Vorstufe.
- **`grundlagen/harness-dateien.md`.** „Reproduzierbarkeits-Bindung“ wird mit
  der neuen Klasse verbunden.
- **Vorlagen.** Sensor-Beschreibung für das Gate (neben `sensors/gate.template.md`),
  **keine** `Makefile`-Zeile mit Skript (A4: die Vorlage liefert nur das Muster), ggf. Abschnitt „Tool-Soll“ in
  `harness/README.template.md` neben `image-hash.txt`. Die Form richtet sich nach
  A2.

## 5. Offene Entscheidungen

| | Frage | Stand der Abwägung |
|---|---|---|
| **A1** | **Begriff.** | **entschieden: Option (a)** (Maintainer, 2026-11-19). **Umgebungs-Zusage** = die **belegbare Aussage der Umgebung über sich selbst**: „Die Umgebung, in der ein Lauf stattfindet, ist die behauptete — und das lässt sich belegen.“ Die Zusage ist die **Aussage**; der Sensor ist ihre **Prüfung**, nicht ihr Bestandteil (der Korpus kennt auch die „Zusage ohne Sensor“, Modul 2, und die „Zusage ohne Deckung“, Lösung zu Modul 12) Das ist der Gebrauch von „Zusage“ im Korpus (Selbstaussage einer Stelle, die ein Sensor sehen muss; `harness-dateien.md`, Modul 2, Modul 10; Modul 14 `nonroot`-Zusage). Die **Anforderung**, dass es sie geben muss, bleibt eine `LH-QA-*` des Projekts (Messmethode = der Sensor); der Kurs lehrt die Klasse, das Projekt trägt die Instanz. **Träger** legt die Umgebung fest (Docker/Dockerfile, ein Manifest, weitere), die **Prüfung** stellt fest, ob die Zusage hält. Der Tool-/Versions-Check hat **zwei Rollen**: Wo die Festlegung anderswo liegt (Lock, Manifest, Betriebssystem), ist er Träger; wo Docker festlegt, ist er die Prüfung. Das wird im Kurs ausdrücklich so benannt. **Abgrenzung** im Text: „Zusage“ des Lastenhefts (Modul 3, `source-precedence.md`: verpflichtende Aussage an den Auftraggeber) ist etwas anderes; das Präfix „Umgebungs-“ steht immer mit. `lab/example` begründet nichts (`AGENTS.md` §1). Folgen: Eintrag in `begriffe.md`; Lösungen, Lernervorstellungen und Konzeptkarte ziehen mit; die Fundstellen des alten Begriffs „Reproduzierbarkeits-Anker“ (§6 Teil A) werden umgestellt. |
| **A2** | **Quelle des Solls.** | **entschieden (Maintainer, 2026-11-19): Der Adopter entscheidet; der Kurs lehrt beide Wege mit ihren Folgen.** **Weg 1, ableiten:** das Soll steht in der Pin-Stelle (`Dockerfile`, Lock, `go.mod`), das Gate liest sie. Eine Quelle, aber nur, wo eine maschinell lesbare Pin-Stelle existiert — je Sprache verschieden, und für Host-Werkzeuge (`bash` ≥, `make` ≥) gibt es keine. **Weg 2, Manifest:** eine eigene Deklaration (Werkzeug, Prüfform, Soll). Sprach-neutral und vollständig deklarierbar, aber eine **zweite Quelle**; sie driftet gegen die Pin-Stelle, wenn niemand sie gegeneinander hält (`pinsync` leistet das, wo d-check zur Verfügung steht). **Mischform:** ableiten, wo eine Pin-Stelle existiert, Manifest für den Rest. Der Kurs gibt **Entscheidungskriterien**, keine Vorgabe: Gibt es eine Pin-Stelle? Läuft ein Host-Teil? Ist `pinsync` oder ein Gleichwertiges verfügbar? **A2a, entschieden (Maintainer, 2026-11-19): Der Adopter deklariert seine Wahl in `harness/conventions.md` als `MR-<NNN>`** — die Wahl ist eine Adaption der Baseline, und dort steht, was ein Repo von ihr abweichen lässt. **Default entschieden (Maintainer, 2026-11-22): keiner.** Die Vorlage zeigt beide Wege auskommentiert; ein voreingestellter Weg wäre durch die Hintertür doch eine Kurs-Vorgabe. **Entwurfsrichtung (§3a, §3b):** Stellen-Abgleich und Laufzeit-Gate getrennt führen; das Inventar muss vollständig sein (A8). |
| **A3** | **Prüfform je Werkzeug.** | **entschieden (Maintainer, 2026-11-19, D1 bis D3 auf Empfehlung).** **Kein Werkzeug bleibt ungeprüft; die Ausnahmeliste entfällt.** **Vier Formen:** *exakt* · *Mindestversion* · *Fähigkeit* · *Anwesenheit*; sie lassen sich kombinieren (`make`: Fähigkeit und Mindestversion). **Auswahlkriterium, Hauptachse (D2): kann das Repo das Werkzeug *festlegen* (Pin, Image, Lock), oder nur *fordern* (Host)?** Festlegen → exakt, weil es ein Soll gibt und jede Abweichung Drift ist. Nur fordern → Mindestversion oder Fähigkeit, denn exakt auf einem Host, den das Repo nicht kontrolliert, ist ein Fehlalarm. Unterscheiden sich Implementierungen → Fähigkeit. Genügt jede Version → Anwesenheit. **D1: die Fähigkeitsprobe** prüft, was das Skript braucht (etwa `declare -A` für assoziative Arrays), statt der Versionsnummer, und ist **der einzige tragfähige Weg für „Variante“**: Der Banner trägt nicht (nachgeprüft: BusyBox-`sed` meldet „This is **not GNU** sed“ und besteht einen Test auf „GNU“; auf der Prüf-Maschine ist `grep` ugrep, nicht GNU grep; es gibt mehr als zwei Varianten: GNU, BSD, BusyBox, ugrep). Die Form „Variante“ entfällt daher als eigene Form. **D3: Pflichtfeld *Grund* je Eintrag**, besonders bei *Anwesenheit* („jede Version genügt, weil …“) — sonst wird sie zur stillen Ausnahme, die A3 verwirft. **Vergleichsregeln (nachgeprüft, Bash 5.2 und 3.2.57):** Versionen **segmentweise** und **numerisch je Segment** vergleichen, nie als Zeichenkette oder Dezimalzahl: `4.10` ist größer als `4.4`, `1.27.30` ist nicht `1.27.3`; exakt heißt die ganze Zeichenkette, nie Teilstring. **Fähigkeitsprobe nachgeprüft:** Unter Bash 3.2.57 liefert `declare -A` den Exit-Code 2, `mapfile` fehlt (127), `${v,,}` ist eine „bad substitution“. **Nicht prüfbar hier:** BSD-`sed`/`awk`/`grep`, `make` 3.81 und Apples Bash-Build am Mac (die Version 3.2.57 ist Wissen von außen, das Image `bash:3.2` dieselbe Upstream-Version). Die Herleitung gehört in den Kurs (Host-Werkzeuge sind nicht versionsgleich mit dem Image), nicht in die Konsumenten-Repos. Die Form je Werkzeug steht in der Deklaration, nicht im Skript. **Illustration, kein Kurs-Inhalt:** `go`/`golangci-lint` exakt (gepinnt); `make` Fähigkeit und Mindestversion; `bash` Fähigkeit; `sed`/`awk`/`grep` Fähigkeit; `git`/`curl`/`jq` Anwesenheit mit Grund. |
| **A4** | **Baubarkeit in d-check — und was die Vorlage liefert.** | **entschieden (Maintainer, 2026-11-19): Die Vorlage liefert nur das Muster, kein Skript.** Stellen-Abgleich → `pinsync` (ab v0.91.0, Pin steht dort); Laufzeit-Gate und Inventar-Vollständigkeit → kein d-check-Modul (§3b). `lab/templates` bleibt skriptfrei, wie heute (kein `.sh`, `.py`, `.js`); der Adopter schreibt das Laufzeit-Gate selbst, nach dem Muster. **Folgen:** (1) Die Vorlage bekommt eine **Sensor-Beschreibung** (neben `gate.template.md`) und keine `Makefile`-Zeile, die ein nicht mitgeliefertes Skript aufriefe — das wäre ein behauptetes Gate. (2) Der Kurs formuliert das Gate als **Anforderung an das Skript des Adopters** („muss rot werden, wenn …“), nicht als beobachtetes Verhalten; der **Break-Test ist Pflicht des Adopters** (§3 Punkt 4). (3) Die Fehlerbilder der Vorbilder (Teilstring, Dezimalvergleich) gehören als Lehrstoff in den Kurs, nicht als Code in die Vorlage. **`pinsync`-Block entschieden (Maintainer, 2026-11-22): ja, auskommentiert,** nach dem Aktivierungs-Muster der Vorlage. `lab/templates` ist gate-ignoriert, der Block liefe dort ungeprüft — deshalb nutzt das Team-Sim-Szenario **denselben** Block (A9), und die Beispiel-Stufe belegt ihn. Ob dieses Repo `pinsync` selbst aktiviert, entscheidet sich nach dem Kurs. |
| **A5** | **Schnitt der Wellen.** | **entschieden (Maintainer, 2026-11-22): eine Welle in zwei Teilen (§6).** Teil A: Begriff und Bereinigung (A1, A6). Teil B: das Gate und der zweite Träger (A2–A4, A7–A9). Getrennt bliebe ein Zwischenstand, in dem Docker „der heutige Träger“ heißt und der Satz zu den zwei Trägern fehlt (A6); zusammen fällt er weg, und es gibt ein Release statt zwei (MINOR). Die Bezeichnungen „Teil A/B“ früherer Fassungen meinen diese Teile. |
| **A6** | **Docker: Stand des Kurses.** | **Richtung entschieden (Maintainer, 2026-11-19): beide Träger zulässig — Docker/Dockerfile und Tool-Pin mit Tool-/Versions-Check.** Docker ist der heutige Stand des Kurses, keine Abwägung gegen andere Träger; ein „weil …“ behauptete eine Wahl, die es nicht gab. Betrifft Modul 14 (ein Docker-Modul), die Zeile in Modul 9 (ein „Beispiel aus realen Repos“, kein Kurs-Gebot; „Supply-Chain-Defense“ hat keinen Mechanismus) und `AGENTS.template.md` §3.1 (bedingt formuliert). **Wortlaut-Entwurf für Modul 14:** „Die Umgebungs-Zusage lässt sich auf zwei Wegen erfüllen: mit Docker und Dockerfile, die die Umgebung aus gepinnten Eingaben bauen, oder mit Tool-Pins und einem Tool-/Versions-Check, der feststellt, ob die vorhandene Umgebung sie trägt. Dieses Modul behandelt den ersten Weg; der zweite folgt. Das ist der heutige Stand des Kurses, keine Abwägung zwischen beiden oder gegen weitere Träger.“ Die Abwägung gegen weitere Träger bleibt ein offener Faden, den der Kurs nicht behauptet. **Erledigt mit Welle 166:** Teil A und Teil B landeten in derselben Welle; der Satz zu den zwei Wegen steht mit dem zweiten Träger. Die Wahl *kann* das Repo als ADR festhalten (§2a). |
| **A7** | **Bindepunkt, Ausführungsort, Prüfer des Prüfers.** | **Bindepunkt entschieden (Maintainer, 2026-11-19): der erste Check in `make gates`.** Das Gate steht vor den fachlichen Gates, ein Rot hier ist ein Umgebungs-Befund und kein Befund über den Code. **Folge, im Kurs zu nennen:** Der Check läuft *in* `make`; ein zu altes `make` oder eine zu alte Shell scheitert beim Einlesen des Makefiles, bevor der Check dran ist (u-boot führt deshalb zusätzlich eine Mindestversion im Makefile selbst, als Parse-Guard). Der Host-Teil, der `make` und `bash` prüft, prüft also nur noch, was *trotz* dieser Grenze startete. **Ausführungsort entschieden (Maintainer, 2026-11-19): Der Kurs legt keinen Ort fest, er führt die Wege mit ihrer Lücke auf; der Adopter wählt und deklariert die Wahl** (in derselben `MR-<NNN>` wie bei A2/A2a). Es ist das Muster von A2 und A4: Wege mit Folgen statt Vorgabe. **Die Wege:** (1) *nur Host* (Docker-only, dem Image wird über den Digest vertraut) — prüft `docker`, `make`, `bash`; die Werkzeuge im Image sind adressiert, aber nicht verglichen: ein Pin, der etwas anderes installiert, als er behauptet, bleibt unbemerkt. (2) *nur Image* (erster Schritt im Image) — prüft die Pin-Werkzeuge; der Host bleibt ungeprüft, ein zu altes `make` oder `bash` zeigt sich erst beim Einlesen des Makefiles. (3) *Host und Image, zwei Läufe* — vollständig für beide Kontexte, zwei Instanzen desselben Musters mit je eigenem Kontext-Parameter. (4) *ein Kontext, ohne Docker* — der Host ist alles; ein Lauf. (5) *zusätzlich der CI-Runner* — das Runner-Image ist ein weiterer Kontext, der Check läuft dort als erster Schritt. **Jedes Inventar-Eintrag trägt ein Feld *Kontext*** (neben Form und Grund aus A3). Die Lücke jedes Weges steht im Kurs, damit niemand „fertig“ meint, wo ein Kontext ungeprüft bleibt. **Drei Restteile entschieden (Maintainer, 2026-11-21, auf Empfehlung).** **(a) Prüfer des Prüfers.** Vier Pflichten für das Adopter-Skript — (1) es prüft seine **eigene Bash zuerst**, nur mit Builtins (`BASH_VERSINFO`) und in Syntax, die auch eine **ältere Bash als die zugelassene** noch einliest; eine zu alte Bash bekommt eine Diagnose statt eines Syntaxfehlers. Die zugelassene Untergrenze legt der Adopter über die Prüfform *Mindestversion* (A3) fest; der Kurs nennt keine Zahl. (**Gemessen 2026-11-22**, `bash:3.2` (3.2.57) und `bash:5.2` im Container, Probe-Syntax `|&` (ab Bash 4): Steht der Guard als **erster Top-Level-Befehl**, endet 3.2 mit der Diagnose, Exit 3. Steht **davor** eine Funktion mit neuerer Syntax, scheitert 3.2 schon beim Einlesen, Syntaxfehler, Exit 2 — ebenso beim verbreiteten Muster, das alles in `main() { … }` einschließt und den Guard hineinsetzt. Folge für die Pflicht: Der Guard steht **vor jeder Funktionsdefinition und außerhalb jeder Funktion**; vor ihm steht nichts, was eine ältere Bash nicht einliest); (2) seine **eigenen Werkzeuge** (`sed`, `awk`, `grep`, mit denen es Pins parst) stehen selbst im Inventar; (3) der **Pin des Prüfwerkzeugs** (`DCHECK_DIGEST`) beim Stellen-Abgleich; (4) der **Break-Test** — ein Werkzeug entfernen, eine Version verschieben, eine Bash unterhalb der Mindestversion starten: jedes muss rot werden (Letzteres mit Diagnose), unverändert grün. Dazu die **Reihenfolge-Regel, ungeprüft (Überlegung des Plans):** Die ersten Proben nutzen nur Shell-Builtins (`command -v`, `case`, `[`); erst danach parst das Skript — sonst prüft man `sed`, indem man `sed` benutzt. **(b) Stufen Rot und Warnung.** **Rot ist der Standard; Warnung nur für ausdrücklich als `optional` deklarierte Einträge**, mit Pflichtgrund und der Angabe, **was ausfällt** („Tests mit echtem `sshd` werden übersprungen“). Hintergrund: Eine Warnung kann ein **stiller Ausgang** sein, die Klasse, die `AGENTS.md` §3 als Lehre führt; passt zum Pflichtfeld *Grund* aus A3 (D3). **(c) Einordnung.** Der Check ist ein **Gate in `make gates`** (computational feedback), keiner der drei Bindepunkte der Durchsetzungsschicht (Tool-Call-Gate, Handoff-Gate, Workflow-Skelett). Das Handoff-Gate prüft, dass die Gates liefen, und deckt ihn damit ab; `MR-004` (Tool-Call-Gate gegen Fehlaufrufe) bleibt das feedforward-Gegenstück. **Entwurfsrichtung (§3a):** das Gate läuft im laufenden Kontext und ist vom Träger unabhängig. |
| **A8** | **Woher kommt das Werkzeug-Inventar?** | **entschieden (Maintainer, 2026-11-22): (c) + (d) — handgepflegt, mit der Probe im leeren Kontext als Beleg; der Prüfer des Prüfers (A7a) bleibt die Mindestlage, wo ein Adopter die Probe nicht baut.** Ausgangslage: Wenn kein Werkzeug ungeprüft bleibt, muss das Inventar **vollständig** sein; handgepflegt driftet es (ein Skript ruft nach einem Jahr `jq` auf, das nirgends steht, und das Gate bleibt grün). Verworfen: (a) handgepflegt mit Sensor über die Aufrufe — **mit d-check heute nicht baubar** (§3b), eigene Prüf-Skripte scheiden aus (`AGENTS.md` §4); (b) aus den Skripten abgeleitet — Aufrufe in Shell sind nicht sauber parsbar. **Die Probe (d):** `make gates` läuft in einem Kontext, der genau das Inventar enthält; ein undeklariertes Werkzeug lässt es scheitern. Träger-neutral als **`PATH`-Käfig** (Wegwerf-Verzeichnis mit Verweisen nur auf die deklarierten Werkzeuge, `PATH` darauf gesetzt; läuft ohne Docker, deckt die Host-Werkzeuge). **Gemessen (2026-11-22, Scratchpad, Linux, GNU make, Bash 5 — nicht auf dem Mac):** undeklariertes `awk` → `Befehl nicht gefunden`, make Fehler 127 (der Kern trägt); `/usr/bin/awk` absolut → grün; `command -v awk` mit Fallback-Zweig → grün mit verschlechtertem Pfad; die Rezept-Shell von make ist `/bin/sh`, absolut aufgerufen; `#!/usr/bin/env bash` sucht `bash` im Käfig, `#!/bin/bash` nicht. **Was der Kurs dazu sagt (V2–V7):** (V2) **Beleg mit Lücke, kein Beweis der Vollständigkeit** — die Grenzen: absolute Pfade umgehen den Käfig (auch `#!/bin/bash` und die Rezept-Shell `/bin/sh`); Builtins liegen nicht im `PATH`; was im Lauf nicht ausgeführt wird, ist nicht geprüft; ein optionaler Fallback-Zweig weicht still aus. Was der Käfig nicht fangen kann (`sh`, absolut aufgerufene Werkzeuge), steht trotzdem im Inventar, von Hand und ohne Beleg. *(Korrigiert die frühere Aussage, `sh` müsse im Käfig liegen: make ruft es absolut auf.)* (V3) **Kein stiller Fallback:** Nutzt ein Skript ein Werkzeug optional, führt das Inventar es als `optional` mit Grund und Angabe, was ausfällt (A7b), und das Skript meldet den Ausfall sichtbar — erst dann zeigt der Käfig-Lauf etwas. Regel für das Skript, geprüft im Review, kein Sensor. (V4) **Werkzeuge über `PATH` aufrufen, nicht absolut;** daraus `#!/usr/bin/env bash` statt `#!/bin/bash` (passt zur Mac-Frage: eine neuere Bash liegt dort nicht unter `/bin`). Konvention mit Review; ob d-check absolute Aufrufe finden könnte, ist nicht geprüft. (V5) **Die Probe läuft auf Anlass, nicht vor jedem Commit:** Sie wiederholt `make gates`. Anlässe: das Inventar ändert sich, ein Skript kommt dazu, und in CI. Ein eigenes Target (etwa `make gates-probe`) ist ein Name im Muster, kein ausgeliefertes Skript (A4). (V6) **Im Docker-Repo läuft der Käfig auch im Image:** „Image mit genau dem Inventar“ gilt nur bei minimaler Basis; ein übliches Basis-Image bringt undeklarierte Werkzeuge mit, die der Käfig im Container trotzdem fängt. **Gemessen 2026-11-22** (`debian:stable-slim` + `make`, Inventar `bash`, `make`, `sed`, `grep`): Das Basis-Image bringt `awk`, `tar`, `find` und `perl` mit, die niemand deklariert hat. **Ohne** Käfig läuft ein Skript, das `awk` aufruft, grün durch — das Image allein ist also kein Inventar-Beleg. **Im** Käfig (`PATH=/cage`) wird derselbe Aufruf rot (`command not found`, make Fehler 127). Wie am Host: der Fallback-Zweig weicht still aus, die Rezept-Shell ist `/bin/sh`, absolut. **Review-Entscheidung (Maintainer, 2026-11-23, Review zu Welle 166):** Das Inventar ist eine **eigene Datei des Repos, die das Skript liest**, nicht eine Tabelle in der Sensor-Datei — sonst trüge diese Daten, die nach `harness-dateien.md` nicht in sie gehören. Beim Weg *Ableiten* nennt das Feld *Soll* die Pin-Stelle statt ihres Werts (sonst wäre das Inventar die zweite Quelle aus A2); ein Host-Werkzeug hat keine Pin-Stelle, wer am Host prüft, führt also die Mischform. Die **Regel** des Checks (Prüfformen, Vergleich, Stufen) steht in der Spezifikation, das Inventar trägt die **Daten**; die Sensor-Datei verlinkt die Festlegung und nennt den Pfad. Das Protokoll des Break-Tests steht im Skriptkopf oder in der ADR. Gemessen im Review: Ein Skript ohne `set -e` ruft ein undeklariertes Werkzeug auf, meldet es, läuft weiter, und `make` endet mit Exit 0 — die Probe belegt nur, wo Fehler bis zu `make` durchkommen. (V7) **Die Probe gilt je Kontext (A7):** Sie belegt nur, was im geprüften Kontext und in den geprüften Targets lief; das Feld *Kontext* sagt, welcher Lauf welchen Teil des Inventars belegt. |
| **A9** | **Was feuert im Team-Sim?** | **entschieden (Maintainer, 2026-11-22, E1–E3 auf Empfehlung).** Ausgangslage nach A4 (kein Skript in der Vorlage): Für das Laufzeit-Gate und den Käfig (A8) gibt es in diesem Repo nichts, das ein Szenario fahren könnte; ein Skript nur für den Team-Sim wäre ein Prüf-Skript, das dieses Repo nicht anlegt (`AGENTS.md` §4). **Befund (2026-11-22):** Der Team-Sim probt den gelehrten Korpus mit seiner **eigenen Seed-Konfiguration** (`lab/team-sim/seed/.d-check.yml`), nicht mit der des Repos — der Seed aktiviert `planning`, das die Wurzel-Konfiguration nicht führt, und Szenarien schalten `structure`, `targets` und `matrix` im Szenario zu (`run.sh`). „Konfiguration im Szenario, nicht im Repo“ ist dort schon die Praxis. **(E1)** `pinsync`-Szenarien gehören in den Team-Sim, konfiguriert im Szenario; ob dieses Repo `pinsync` selbst aktiviert, ist davon unabhängig. **(E2)** Szenarien nur für das, was der Kurs-Text über `pinsync` behauptet — Maßstab ist die Aussage, nicht der Werkzeug-Umfang. Nach Stand von Teil B: *Gleichheit → still*, mit **positiver Vorbedingung** über `schritt` (die Ausgabe trägt `pinsync: 1 Pin(s) geprüft`, sonst bestünde die Stille auch bei nicht gelaufenem Modul; `AGENTS.md` §3); *Abweichung → `pinsync-mismatch`*, geprüft mit Code **und** Ziel (Datei:Zeile der abweichenden Quelle); *Ausdruck trifft keine Zeile → `pinsync-no-match`*. Nur wenn der Kurs sie nennt: *zwei Treffer → `pinsync-ambiguous`*; *Block ohne Aktivierung → still trotz Abweichung* (die Gate-Lüge aus Modul 13 als geprobte Stille). **(E3)** Kein Szenario für das Laufzeit-Gate und den Käfig; der Wellen-Eintrag sagt das, damit das Fehlen sich nicht wie ein Versäumnis liest. Der Käfig-Versuch (A8) bleibt Beleg im Plan. **Folge für den A4-Rest:** Liefert die Vorlage einen `pinsync`-Block, nutzt das Szenario **denselben** Block — dann ist der gate-ignorierte Block geprobt, nicht nur beschrieben. **Gemessen 2026-11-22** an einer Nachbildung: Ein auskommentierter Block lässt sich mit `sed` zwischen `# pinsync:` und der nächsten Leer-Kommentarzeile ziehen und entkommentieren; d-check nimmt ihn an und meldet die Abweichung. `run.sh` liest schon heute aus dem Repo (den Digest aus `Makefile`, „eine Quelle, kein zweiter Pin“). **Bedingungen:** Die Form des Blocks in der Vorlage ist damit Schnittstelle (Anfangs- und Endzeile), und das Szenario bricht **fail-closed** ab, wenn der Auszug leer ist — sonst bestünde die Stille über einem nicht gelesenen Block. **Gemessen 2026-11-22 (d-check v0.91.0, Pin des Repos):** `modules: [..., pinsync]` **aktiviert** das Modul, `--enable pinsync` ebenso — beide melden `pinsync-mismatch` und die Zeile `pinsync: 1 Pin(s) geprüft, 2 Quelle(n) gelesen`, Exit 1. Steht der Block **ohne** Aktivierung, bleibt der Lauf still (Exit 0) **und die Zeile fehlt** — die „zwei Schritte“ der Vorlage gelten also auch für `pinsync`, und die Zeile taugt als positive Vorbedingung (E2). Die Handbuch-Formulierung „nicht über `modules:`“ beschreibt nur das Beispiel, nicht eine Grenze. |

## 6. Plan — falls der Faden dran ist

**Reihenfolge nach Rangfolge** (`AGENTS.md` §1): Kurs → Regelwerk-Spiegel
(wortgleich, netzlos) → Vorlagen → Beispiel.

**Eine Welle (A5), in zwei Teilen und in dieser Reihenfolge.** Sie läuft **nach**
der Dateinamen-Welle ([Plan](dateinamen-sprache-plan.md) §6); neue
Vorlagen-Inhalte entstehen deshalb gleich mit den neuen Namen
(`spec/specification.md`, `wave-*`).

1. **Teil A — Begriff und Bereinigung** (A1, A6).
   Modul 14 definiert die Umgebungs-Zusage als Anforderung und führt die
   Frage-Tabelle (§2); Docker steht darin als **der heutige Träger**, **ohne** den
   Satz zu den zwei Wegen — der kommt mit Teil B, in derselben Welle
   (A6). Modul 9: die Zeile „Supply-Chain-Defense“ entfällt, „Toolchain-
   Reproduzierbarkeit“ bleibt; die Vorlage `AGENTS.template.md` §3.1 zieht nach
   (Quelle zuerst). Modul 12 und `harness-dateien.md` verlinken. Regelwerk-
   Spiegel; `Stand:`-Zeile des Regelwerk-READMEs zieht nach. Kein beobachtbares
   Verhalten, **kein Team-Sim-Szenario** — das steht im Wellen-Eintrag. **Satelliten des heutigen Begriffs** (jede Fundstelle des Begriffs
   „Reproduzierbarkeits-Anker“ zieht mit): Modul 14 (Lernziel, Fehlannahme,
   Abschnitt „Zwei Formen…“, Reflexion; „drei Drift-Anker“ und „drei Anker“ in Übung und Selbstcheck), die Fehlannahme im Regelwerk-Spiegel, die Überschrift „Zwei Formen des
   Reproduzierbarkeits-Ankers“ im Regelwerk-Spiegel (Anker-Slug!), `lernpfade.md`,
   `fallstudien.md`, `lernervorstellungen.md`, die Überschrift „Reproduzierbarkeits-Anker“
   in der Lösung zu Modul 16 und der Pflicht-Abschnitt der Freigabe-Checkliste in Modul 16, Modul 9 im Spiegel (Supply-Chain-Zeile); **erst danach, in der Beispiel-Stufe,**
   zieht `lab/example/AGENTS.md` nach — es ist Folge, nicht Anlass. Release-Art: **MINOR** (neue Anforderungs-/Träger-Regel, Umbau von Modul 9).
2. **Teil B — das Gate.** Nach den Messungen in §6a (A1–A9 und alle Reste entschieden; A2 ist Adopter-Entscheidung). Vorlage: beide Soll-Wege auskommentiert, **kein Default** (A2a); ein **auskommentierter `pinsync`-Block** in `lab/templates/.d-check.yml` (A4), den das Team-Sim-Szenario übernimmt (A9). Kurs (Modul 14, Modul 13), Spiegel,
   Sensor-Beschreibung (kein Skript, A4), **Team-Sim-Szenarien nur für den
   Stellen-Abgleich** (`pinsync`: Abweichung → laut, Gleichheit → still; erwartete
   Stille ist eine Aussage und braucht ihr Szenario). Das Laufzeit-Gate trägt
   **kein Szenario**: Es ist eine Anforderung an das Adopter-Skript (*Werkzeug
   fehlt → rot*, *Version weicht ab → rot*, *alles stimmt → Exit 0 ohne Befund*;
   die Vorbilder geben dabei eine OK-Zeile aus, das Verdikt ist der Exit-Code),
   und das Wellen-Eintrag-Wort „kein beobachtbares Verhalten geprüft“ gilt dort. Nachzug in der
   Vorlage: `AGENTS.template.md` sagt „Host braucht nur Docker und GNU `make`“ —
   das Host-Inventar des Gates widerspricht dem. Beispiel nur,
   wo der Kurs ihn trägt.
3. **Satelliten prüfen, nicht vorab festlegen:** Lösungen 12/13/14, Begriffe,
   Lernervorstellungen, Konzeptkarte, `make alignment-check`.

Eine neue Regel ist **MINOR** (`AGENTS.md` §6). Committen, Pushen und Taggen sind
drei getrennte Freigaben (§5).

## 6a. Messungen vor Teil B

Gemessen wird im Scratchpad; das Repo bleibt unberührt (bis auf das Ergebnis hier).
**Stand 2026-11-22: alle vier gemessen** (Ergebnisse in A7, A8 V6, A9).

1. **`pinsync`-Aktivierung (A9):** Reicht `modules: [..., pinsync]`, oder nur
   `--enable`? Betrifft das Szenario und den Satz „zwei Schritte“ der Vorlage.
2. **Bash-Guard (A7a):** Liest Bash Top-Level-Befehle einzeln, sodass die
   Versionsprobe vor neuerer Syntax greift? Break-Test unter einer zu alten Bash.
3. **Käfig im Image (A8, V6):** Fängt ein `PATH`-Käfig im Container die
   undeklarierten Werkzeuge des Basis-Images? Braucht einen Image-Build.
4. **Block aus der Vorlage (A9):** Kann `run.sh` den `pinsync`-Block aus
   `lab/templates/.d-check.yml` lesen, statt ihn abzuschreiben?

## 7. Trigger

**Nach der Dateinamen-Welle, mit Freigabe des Maintainers** (entschieden
2026-11-22) — eine Entscheidung, kein Ereignis. Vorher die Messungen aus §6a.
Frühere Kandidaten für ein beobachtbares Ereignis, als Anlass weiter gültig: ein Konsumenten-Repo meldet einen Gate-Lauf, der an
einer abweichenden Werkzeug-Version rot wurde, ohne dass das Gate dies als
Umgebungs-Befund benannte; oder ein Replay-Befund, der erst auf Rang 4 landet,
weil Rang 1 nie maschinell geprüft wurde.
