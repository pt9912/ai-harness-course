#!/usr/bin/env bash
# Team-Sim — Replay fuer Nebenlaeufigkeits-Szenarien (Modul-12-Bauform).
# KEIN Gate: laeuft auf Anlass, nicht in make check. Topologie je Lauf frisch:
# bare origin.git + zwei Clones (alice, bob) — die Team-Topologie, nicht
# Worktrees (die teilen ein .git und modellieren EINEN Entwickler).
# Erwartungen sind VORAB notiert (manifest.yaml, README-Tabelle); auch stille
# Ausgaenge sind Erwartungen.
#
# Aufruf:  bash run.sh              alle Gruppen
#          bash run.sh s04 s06      nur diese Gruppen (Kennung = Praefix der Verdikte)
# Umgebung: SIM_WORK=<dir>  Arbeitsverzeichnis (sonst mktemp; bleibt liegen)
#           SIM_CLEAN=1     Arbeitsverzeichnis nach dem Lauf entfernen
# Ergebnis: $WORK/ergebnis.tsv — je Verdikt eine Zeile (Szenario, erwartet,
#           beobachtet, PASS|FAIL|KAPUTT) unter einem Kopf mit Datum, Image,
#           Repo-Stand und Seed-Hash; der Lauf ist damit belegbar, nicht nur
#           notiert.
set -u
HIER="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$HIER/../.." && pwd)"
DIGEST="$(grep -m1 '^DCHECK_DIGEST' "$REPO_ROOT/Makefile" 2>/dev/null | sed 's/.*= *//')"
# Fail-closed: ohne Digest liefen die Git-Szenarien "gruen" und die
# Docker-Szenarien scheiterten kryptisch — ein halb-bestehender kaputter
# Lauf. Der Harness lebt im Kurs-Repo; die Kopie-Grenze steht im README.
[ -n "$DIGEST" ] || { echo "FEHLER: DCHECK_DIGEST nicht gefunden — run.sh braucht das Kurs-Repo (../../Makefile)."; exit 2; }
IMG="ghcr.io/pt9912/d-check@${DIGEST}"
WORK="${SIM_WORK:-$(mktemp -d)}"
TSV="$WORK/ergebnis.tsv"
PASS=0; FAIL=0; KAPUTT=0
SELECT="$*"

# ---- Ergebnisdatei: Kopf traegt, was den Lauf bestimmt --------------------
mkdir -p "$WORK"
{
  echo "# team-sim ergebnis"
  echo "# datum: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "# image: $IMG"
  echo "# repo: $(git -C "$REPO_ROOT" rev-parse --short HEAD 2>/dev/null || echo unbekannt)"
  echo "# seed: $(cd "$HIER/seed" && find . -type f | sort | xargs sha256sum | sha256sum | cut -c1-12)"
  printf 'szenario\terwartet\tbeobachtet\tverdikt\n'
} > "$TSV"

topo() {  # frische Topologie
  rm -rf "$WORK/sim"; mkdir -p "$WORK/sim"; cd "$WORK/sim"
  git init -q --bare -b main origin.git
  git clone -q origin.git seedclone 2>/dev/null && cd seedclone
  cp -r "$HIER/seed/." . && git add -A && git -c user.name=seed -c user.email=s@s commit -qm "seed" && git push -q origin main
  cd "$WORK/sim"
  git clone -q origin.git alice 2>/dev/null && git clone -q origin.git bob 2>/dev/null
  # Wachsamkeit gegen den Leer-Checkout-Fehler des ersten Laufs:
  [ -f alice/.d-check.yml ] || { echo "TOPO-DEFEKT: alice leer"; exit 9; }
  for w in alice bob seedclone; do git -C $w config user.name $w; git -C $w config user.email $w@sim; done
}
# Volle Ausgabe, kein tail: ein zweiter Befund schoebe den erwarteten Code
# sonst aus dem Fenster; die Verdikte zeigen selbst nur die letzte Zeile.
dcheck() { docker run --rm --network none -v "$1:/repo:ro" "$IMG" 2>&1; }
# Befund-Zeile gezielt: <datei>:<zeile> TAB <target> TAB <code>. Ein Code
# irgendwo in der Ausgabe reichte nicht — wave-drift auf dem falschen Ziel
# waere sonst auch "bestanden".
befund() { printf '%s' "$1" | grep -q "$(printf '\t%s\t%s' "$2" "$3")"; }
verdikt() { # $1 name  $2 erwartet  $3 beobachtet  $4 ok(0/1)
  if [ "$4" = 0 ]; then echo "  PASS  $1"; PASS=$((PASS+1)); v=PASS;
  else echo "  FAIL  $1"; echo "        erwartet:  $2"; echo "        beobachtet: $3"; FAIL=$((FAIL+1)); v=FAIL; fi
  printf '%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$v" >> "$TSV"
}
# Vorbedingungs-Schritt: scheitert er, ist das Szenario KAPUTT, nicht FAIL —
# ein Verdikt ueber einen Zustand, der nie hergestellt wurde, waere keines.
schritt() { "$@" || { echo "  KAPUTT ($CUR): Schritt fehlgeschlagen: $*"; printf '%s\t%s\t%s\t%s\n' "$CUR" "Vorbedingung" "Schritt fehlgeschlagen: $*" "KAPUTT" >> "$TSV"; KAPUTT=$((KAPUTT+1)); return 1; }; }
lauf() { # $1 gruppen-kennung  $2 funktion
  if [ -n "$SELECT" ]; then case " $SELECT " in *" $1 "*) ;; *) return 0;; esac; fi
  CUR="$1"; "$2" || true
}

s01_doppel_anspruch() {
  topo
  # alice beansprucht slice-003 auf main (Datei anlegen + mv-Aequivalent: neu in in-progress)
  cd "$WORK/sim/alice"; printf '# Slice slice-003\n\n**Welle:** welle-2-ausbau\n\n**Verantwortlich:** alice.\n' > docs/plan/planning/in-progress/slice-003-ausbau.md
  schritt git add -A && schritt git commit -qm "claim slice-003 (alice)" && schritt git push -q origin main || return 1
  # bob, OHNE zu pullen, beansprucht denselben Slice auf seinem main
  cd "$WORK/sim/bob"; printf '# Slice slice-003\n\n**Welle:** welle-2-ausbau\n\n**Verantwortlich:** bob.\n' > docs/plan/planning/in-progress/slice-003-ausbau.md
  schritt git add -A && schritt git commit -qm "claim slice-003 (bob)" || return 1
  out=$(git push origin main 2>&1); rc=$?
  [ $rc -ne 0 ] && echo "$out" | grep -q "rejected\|fetch first\|fast-forward" && ok=0 || ok=1
  verdikt "s01 Doppel-Anspruch: zweiter Push laut abgelehnt" "push rejected (non-fast-forward)" "rc=$rc" $ok
  # und nach dem Pull SIEHT bob den Anspruch samt Inhaber
  git pull -q --no-rebase origin main 2>/dev/null
  # Merge-Konflikt in der Datei selbst ist auch "laut" — beides akzeptabel:
  if git ls-files -u | grep -q slice-003; then ok=0; beob="Merge-Konflikt in der Slice-Datei (laut)"; else grep -q "alice" docs/plan/planning/in-progress/slice-003-ausbau.md && ok=0 && beob="alice als Inhaber sichtbar" || { ok=1; beob="weder Konflikt noch Inhaber sichtbar"; }; fi
  verdikt "s01b Anspruch nach Pull sichtbar oder Konflikt laut" "sichtbar/Konflikt" "$beob" $ok
}

s02_stille_nummer() {
  topo
  cd "$WORK/sim/alice"; schritt git switch -qc a/cache || return 1; printf '# Slice slice-003: Cache\n' > docs/plan/planning/open/slice-003-cache.md
  schritt git add -A && schritt git commit -qm "slice-003-cache" && schritt git push -q origin a/cache || return 1
  cd "$WORK/sim/bob"; schritt git switch -qc b/index || return 1; printf '# Slice slice-003: Index\n' > docs/plan/planning/open/slice-003-index.md
  schritt git add -A && schritt git commit -qm "slice-003-index" && schritt git push -q origin b/index || return 1
  # beide "PRs" mergen
  cd "$WORK/sim/seedclone" && git fetch -q origin && git merge -q --no-edit origin/a/cache >/dev/null 2>&1 && git merge -q --no-edit origin/b/index >/dev/null 2>&1; rc=$?
  n=$(ls docs/plan/planning/open/slice-003-*.md 2>/dev/null | wc -l)
  [ $rc -eq 0 ] && [ "$n" = 2 ] && ok=0 || ok=1
  verdikt "s02 stille Nummern-Kollision: Merge glatt, zwei slice-003" "rc=0, 2 Dateien" "rc=$rc, $n Dateien" $ok
}

s03_register_doppelzeile() {
  topo
  cd "$WORK/sim/alice"; schritt git switch -qc a/beo || return 1
  sed -i 's/| 1× | slice-001 |/| 2× | slice-001, slice-003 |/' docs/plan/planning/observations.md
  schritt git add -A && schritt git commit -qm "BEO-001 erhoeht" && schritt git push -q origin a/beo || return 1
  cd "$WORK/sim/bob"; schritt git switch -qc b/beo || return 1
  printf '| BEO-005 | Fixture-Pfade driften (neu benannt) | Kern | 1× | slice-004 | offen |\n' >> docs/plan/planning/observations.md
  schritt git add -A && schritt git commit -qm "neue Zeile fuers selbe Phaenomen" && schritt git push -q origin b/beo || return 1
  cd "$WORK/sim/seedclone" && git fetch -q && git merge -q --no-edit origin/a/beo >/dev/null 2>&1 && git merge -q --no-edit origin/b/beo >/dev/null 2>&1; rc=$?
  zeilen=$(grep -c "Fixture-Pfade driften" docs/plan/planning/observations.md)
  [ $rc -eq 0 ] && [ "$zeilen" = 2 ] && ok=0 || ok=1
  verdikt "s03 Register (mit Abstand): Doppel-Zeile mergt STILL" "rc=0, 2 Zeilen fuers selbe Phaenomen" "rc=$rc, $zeilen Zeilen" $ok
}

# s04 — Offene Wellen: Singleton (mode one) gegen Bijektion (mode many),
# beide Richtungen der Bijektion. Reihenfolge der Verdikte: a b e f i.
s04_zwei_wellen_und_waves() {
  topo
  cd "$WORK/sim/alice"
  printf '# Welle welle-2-ausbau: Ausbau\n\n**Verantwortlich:** bob. **Datum:** 2026-08-16.\n' > docs/plan/planning/welle-2-ausbau.md
  sed -i 's|- \[welle-1-basis\](../welle-1-basis.md)|- [welle-1-basis](../welle-1-basis.md)\n- [welle-2-ausbau](../welle-2-ausbau.md)|' docs/plan/planning/in-progress/roadmap.md
  sed -i '/welle-2-ausbau | welle-1 done/d' docs/plan/planning/in-progress/roadmap.md
  schritt git add -A && schritt git commit -qm "zweite offene Welle" && schritt git push -q origin main || return 1
  out=$(dcheck "$WORK/sim/alice"); echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s04a zwei offene Wellen: planning ohne waves GRUEN" "0 Befunde" "$(echo "$out"|tail -1)" $ok
  # waves einschalten -> Singleton-Semantik (Default mode: one) muss beissen
  printf '  waves:\n    dir: docs/plan/planning\n' >> .d-check.yml
  out=$(dcheck "$WORK/sim/alice"); befund "$out" "docs/plan/planning" "wave-drift" && ok=0 || ok=1
  verdikt "s04b waves.dir an: Singleton meldet wave-drift" "wave-drift (target: Verzeichnis)" "$(echo "$out"|tail -1)" $ok
  # Bijektion statt Singleton (d-check v0.62.0, der CR dieses Repos): derselbe
  # Zustand unter mode: many — Kennungs-Mengen in beide Richtungen, Marker aussen vor.
  printf '    mode: many\n' >> .d-check.yml
  out=$(dcheck "$WORK/sim/alice"); echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s04e waves.dir + mode: many: zwei offene Wellen GRUEN" "0 Befunde" "$(echo "$out"|tail -1)" $ok
  # Gegenprobe: die Bijektion muss beissen — dritte Welle flach OHNE Zeiger.
  # Ohne diesen Lauf waere "many prueft die Liste" nur behauptet (gruen ist
  # auch ein Sensor, der nichts liest).
  printf '# Welle welle-3-x: X\n\n**Verantwortlich:** alice. **Datum:** 2026-08-22.\n' > docs/plan/planning/welle-3-x.md
  out=$(dcheck "$WORK/sim/alice"); befund "$out" "welle-3" "wave-drift" && ok=0 || ok=1
  verdikt "s04f many: Datei ohne Zeiger meldet wave-drift (Bijektion beisst)" "wave-drift (target: welle-3)" "$(echo "$out"|tail -1)" $ok
  # Die andere Richtung: Zeiger ohne Datei. Bare Kennung statt Link, damit
  # allein die Bijektion spricht und nicht zusaetzlich `links` (target-missing).
  rm docs/plan/planning/welle-3-x.md
  sed -i 's|^- \[welle-2-ausbau\](../welle-2-ausbau.md)$|- [welle-2-ausbau](../welle-2-ausbau.md)\n- welle-5-x (Zeiger ohne Datei)|' docs/plan/planning/in-progress/roadmap.md
  out=$(dcheck "$WORK/sim/alice"); befund "$out" "welle-5" "wave-drift" && ok=0 || ok=1
  verdikt "s04i many: Zeiger ohne Datei meldet wave-drift (beide Richtungen)" "wave-drift (target: welle-5)" "$(echo "$out"|tail -1)" $ok
}

s04g_eroeffnet_unter_waves() {
  # Der Handbuch-Fall: EINE Welle eroeffnet (Zeiger steht), nichts beansprucht
  # (Marker steht, in-progress/ leer). Unter mode: one absichtlich rot — der
  # Block wird gegen genau eine Datei gehalten —, unter many gruen. Bewusst
  # NICHT der s04c-Zustand mit zwei flachen Wellen: dort ist one zufaellig
  # gruen, weil der Bool-Vergleich bei stehendem Marker nur "ungleich 1" prueft.
  topo
  cd "$WORK/sim/alice"
  schritt git mv docs/plan/planning/in-progress/slice-001-kern.md docs/plan/planning/open/ || return 1
  sed -i 's|^- \[welle-1-basis\](../welle-1-basis.md)$|- [welle-1-basis](../welle-1-basis.md)\n\nNichts in Arbeit.|' docs/plan/planning/in-progress/roadmap.md
  printf '  waves:\n    dir: docs/plan/planning\n' >> .d-check.yml
  schritt git add -A && schritt git commit -qm "Welle eroeffnet, nichts beansprucht, waves im Default" && schritt git push -q origin main || return 1
  out=$(dcheck "$WORK/sim/alice"); befund "$out" "docs/plan/planning" "wave-drift" && ok=0 || ok=1
  verdikt "s04g eine Welle eroeffnet + Marker, mode one: wave-drift (Singleton)" "wave-drift (target: Verzeichnis)" "$(echo "$out"|tail -1)" $ok
  printf '    mode: many\n' >> .d-check.yml
  out=$(dcheck "$WORK/sim/alice"); echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s04h dito unter mode many: GRUEN (Marker geht nicht ein)" "0 Befunde" "$(echo "$out"|tail -1)" $ok
}

s04c_leerer_anspruch() {
  # Spiegelrichtung zur bekannten Negativ-Probe (Marker BEI beanspruchtem Slice
  # meldet rot): offene Wellen in der Liste UND nichts beansprucht — der
  # baseline-legitime Zustand nach der Wellen-Eroeffnung. Misst, dass der
  # Waechter die MARKER-Haelfte prueft und die Liste ihn nicht stoert.
  topo
  cd "$WORK/sim/alice"
  printf '# Welle welle-2-ausbau: Ausbau\n\n**Verantwortlich:** bob. **Datum:** 2026-08-16.\n' > docs/plan/planning/welle-2-ausbau.md
  sed -i 's|- \[welle-1-basis\](../welle-1-basis.md)|- [welle-1-basis](../welle-1-basis.md)\n- [welle-2-ausbau](../welle-2-ausbau.md)|' docs/plan/planning/in-progress/roadmap.md
  sed -i '/welle-2-ausbau | welle-1 done/d' docs/plan/planning/in-progress/roadmap.md
  # Anspruch zuruecknehmen: in-progress/ traegt keinen Slice mehr ...
  schritt git mv docs/plan/planning/in-progress/slice-001-kern.md docs/plan/planning/open/ || return 1
  # ... und der Ruhe-Marker tritt NEBEN die Liste, nicht an ihre Stelle.
  sed -i 's|- \[welle-2-ausbau\](../welle-2-ausbau.md)|- [welle-2-ausbau](../welle-2-ausbau.md)\n\nNichts in Arbeit.|' docs/plan/planning/in-progress/roadmap.md
  schritt git add -A && schritt git commit -qm "Anspruch zurueck, Ruhe-Marker neben der Liste" && schritt git push -q origin main || return 1
  out=$(dcheck "$WORK/sim/alice"); echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s04c Marker NEBEN Liste (Wellen offen, nichts beansprucht): planning GRUEN" "0 Befunde" "$(echo "$out"|tail -1)" $ok
  # Gegenprobe, zweite Richtung derselben Aequivalenz: Marker weg, in-progress/
  # weiter leer. Ohne diesen Lauf waere "haelt in BEIDE Richtungen" behauptet.
  sed -i '/^Nichts in Arbeit\.$/d' docs/plan/planning/in-progress/roadmap.md
  schritt git add -A && schritt git commit -qm "Marker entfernt (Gegenprobe)" && schritt git push -q origin main || return 1
  out=$(dcheck "$WORK/sim/alice"); echo "$out" | grep -q "planning-drift" && ok=0 || ok=1
  verdikt "s04d Marker FEHLT bei leerem in-progress/: planning ROT" "planning-drift (Ruhe-Marker fehlt)" "$(echo "$out"|tail -1)" $ok
}

s05_mr_hybrid() {
  topo
  cd "$WORK/sim/alice"; schritt git switch -qc a/mr || return 1
  mkdir -p harness/conventions && printf '# MR-001: Alpha\n' > harness/conventions/MR-001-alpha.md
  sed -i 's/| MR-000 | 2026-08-16 | Baseline-Aussage |/| MR-000 | 2026-08-16 | Baseline-Aussage |\n| MR-001 | 2026-08-16 | Alpha |/' harness/conventions.md
  schritt git add -A && schritt git commit -qm "MR-001 alpha" && schritt git push -q origin a/mr || return 1
  cd "$WORK/sim/bob"; schritt git switch -qc b/mr || return 1
  mkdir -p harness/conventions && printf '# MR-001: Beta\n' > harness/conventions/MR-001-beta.md
  sed -i 's/| MR-000 | 2026-08-16 | Baseline-Aussage |/| MR-000 | 2026-08-16 | Baseline-Aussage |\n| MR-001 | 2026-08-16 | Beta |/' harness/conventions.md
  schritt git add -A && schritt git commit -qm "MR-001 beta" && schritt git push -q origin b/mr || return 1
  cd "$WORK/sim/seedclone" && git fetch -q && git merge -q --no-edit origin/a/mr >/dev/null 2>&1
  git merge --no-edit origin/b/mr >/dev/null 2>&1; rc=$?
  dateien=$(ls harness/conventions/MR-001-*.md 2>/dev/null | wc -l)
  konflikt=$([ $rc -ne 0 ] && git ls-files -u | grep -q conventions.md && echo ja || echo nein)
  [ "$dateien" = 2 ] && [ "$konflikt" = ja ] && ok=0 || ok=1
  verdikt "s05 MR-Hybrid: Dateien still (2x MR-001), Index-Zeile LAUT" "2 Dateien + Index-Konflikt" "$dateien Dateien, Konflikt=$konflikt" $ok
}

s06_branch_protection() {
  topo
  cat > "$WORK/sim/origin.git/hooks/pre-receive" <<'HOOK'
#!/bin/sh
while read old new ref; do
  [ "$ref" = "refs/heads/main" ] && echo "main ist geschuetzt (Branch-Protection-Simulation)" && exit 1
done
exit 0
HOOK
  chmod +x "$WORK/sim/origin.git/hooks/pre-receive"
  cd "$WORK/sim/alice"; printf '# Slice slice-003\n\n**Verantwortlich:** alice.\n' > docs/plan/planning/in-progress/slice-003-ausbau.md
  schritt git add -A && schritt git commit -qm "claim auf main" || return 1
  out=$(git push origin main 2>&1); rc=$?
  [ $rc -ne 0 ] && echo "$out" | grep -q "geschuetzt" && ok=0 || ok=1
  verdikt "s06 Branch-Protection: TA-7-Anspruch scheitert am Hook" "push abgelehnt (Hook-Meldung)" "rc=$rc" $ok
}

s07_sichtung_liest_alt() {
  topo
  cd "$WORK/sim/alice"; schritt git switch -qc a/closure || return 1
  sed -i 's/| 1× | slice-001 |/| 3× | slice-001, slice-005, slice-006 |/' docs/plan/planning/observations.md
  schritt git add -A && schritt git commit -qm "BEO-001 auf 3x (im PR)" && schritt git push -q origin a/closure || return 1
  cd "$WORK/sim/bob" && git pull -q origin main
  stand=$(grep -o "| [0-9]×" docs/plan/planning/observations.md | head -1)
  [ "$stand" = "| 1×" ] && ok=0 || ok=1
  verdikt "s07 Sichtung liest gemergten Stand: 1x trotz 3x im offenen PR" "1×" "$stand" $ok
}

# s08 — Closure-Seite unter Nebenlaeufigkeit (Modul 6 §Wellen-Closure-Prozedur,
# Schritt 1 "Alle Slices der Welle liegen in done/" ist Prozedur, kein Sensor).
s08_closure_unter_anspruch() {
  topo
  cd "$WORK/sim/bob"; schritt git switch -qc b/arbeit || return 1
  sed -i 's/^Offen\.$/In Arbeit: Kern-Modul, erster Schnitt./' docs/plan/planning/in-progress/slice-001-kern.md
  schritt git add -A && schritt git commit -qm "slice-001: Arbeit im PR" && schritt git push -q origin b/arbeit || return 1
  # alice schliesst welle-1-basis auf main — schlampig: Zeile im Register, keine Ergebnisnotiz
  cd "$WORK/sim/alice"
  printf '  waves:\n    dir: docs/plan/planning\n    mode: many\n' >> .d-check.yml
  schritt git mv docs/plan/planning/welle-1-basis.md docs/plan/planning/done/ || return 1
  sed -i '/^- \[welle-1-basis\](..\/welle-1-basis.md)$/d' docs/plan/planning/in-progress/roadmap.md
  printf '| welle-1-basis | 2026-08-22 | done/welle-1-results.md |\n' >> docs/plan/planning/in-progress/roadmap.md
  schritt git add -A && schritt git commit -qm "welle-1-basis geschlossen (ohne Notiz)" && schritt git push -q origin main || return 1
  out=$(dcheck "$WORK/sim/alice"); befund "$out" "welle-1" "wave-results-missing" && ok=0 || ok=1
  verdikt "s08a Welle geschlossen ohne Ergebnisnotiz: wave-results-missing" "wave-results-missing (target: welle-1)" "$(echo "$out"|tail -1)" $ok
  # sauber nachgezogen: Ergebnisnotiz liegt — der Slice der Welle ist weiter
  # beansprucht (in-progress/, und in bobs offenem PR): sieht das ein Sensor?
  printf '# Welle 1 — Basis — Closure-Notiz\n\n**Welle:** welle-1-basis\n\nGeliefert: Kern-Schnittstelle. Offen geblieben: slice-001.\n' > docs/plan/planning/done/welle-1-results.md
  schritt git add -A && schritt git commit -qm "welle-1-results" && schritt git push -q origin main || return 1
  out=$(dcheck "$WORK/sim/alice"); echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s08b Welle sauber geschlossen, Slice der Welle weiter beansprucht: STILL" "0 Befunde (kein Sensor sieht den Widerspruch)" "$(echo "$out"|tail -1)" $ok
}

# s09 — Vorvergabe (source-precedence §Vergabe: "lokal ableitbar hat eine
# Grenze — den PR-Rest faengt das Schema nicht"; TB-010).
s09_vorvergabe() {
  topo
  # welle-1-basis §4 vergibt slice-002 (Rand) — ohne Datei. bob zieht dieselbe
  # Nummer fuer etwas anderes, im PR.
  cd "$WORK/sim/bob"; schritt git switch -qc b/cache || return 1
  printf '# Slice slice-002: Cache\n\n**Welle:** ohne Welle\n\n**Verantwortlich:** bob.\n' > docs/plan/planning/open/slice-002-cache.md
  schritt git add -A && schritt git commit -qm "slice-002-cache" && schritt git push -q origin b/cache || return 1
  cd "$WORK/sim/seedclone" && git fetch -q && git merge -q --no-edit origin/b/cache >/dev/null 2>&1; rc=$?
  plan=$(grep -c "slice-002 (Rand)" docs/plan/planning/welle-1-basis.md)
  out=$(dcheck "$WORK/sim/seedclone"); echo "$out" | grep -q "0 Befund" && d=0 || d=1
  [ $rc -eq 0 ] && [ "$plan" = 1 ] && [ $d = 0 ] && ok=0 || ok=1
  verdikt "s09 Vorvergabe: slice-002 im Wellen-Plan, anderswo vergeben — STILL" "Merge rc=0, beide Bedeutungen, 0 Befunde" "rc=$rc, Plan-Nennung=$plan, $(echo "$out"|tail -1)" $ok
}

# s10 — Rolleninhaber-Feld (TA-1; Modul 5 §Lifecycle: Verantwortlich wird
# beim Uebergang gesetzt). Laut nur, wenn beide dieselbe Zeile anfassen.
s10_inhaber_feld() {
  topo
  cd "$WORK/sim/alice"; schritt git switch -qc a/own || return 1
  sed -i 's/^\*\*Verantwortlich:\*\* alice\.$/**Verantwortlich:** alice (bestaetigt 2026-08-22)./' docs/plan/planning/in-progress/slice-001-kern.md
  schritt git add -A && schritt git commit -qm "Inhaber bestaetigt (alice)" && schritt git push -q origin a/own || return 1
  cd "$WORK/sim/bob"; schritt git switch -qc b/own || return 1
  sed -i 's/^\*\*Verantwortlich:\*\* alice\.$/**Verantwortlich:** bob./' docs/plan/planning/in-progress/slice-001-kern.md
  schritt git add -A && schritt git commit -qm "Inhaber uebernommen (bob)" && schritt git push -q origin b/own || return 1
  cd "$WORK/sim/seedclone" && git fetch -q && git merge -q --no-edit origin/a/own >/dev/null 2>&1
  git merge --no-edit origin/b/own >/dev/null 2>&1; rc=$?
  konflikt=$([ $rc -ne 0 ] && git ls-files -u | grep -q slice-001 && echo ja || echo nein)
  [ "$konflikt" = ja ] && ok=0 || ok=1
  verdikt "s10a beide setzen das Inhaber-Feld: Konflikt (LAUT)" "Merge-Konflikt in der Slice-Datei" "rc=$rc, Konflikt=$konflikt" $ok
  git merge --abort 2>/dev/null || true
  # zweite Probe vom Seed-Stand aus, nicht vom halb gemergten
  schritt git reset -q --hard origin/main || return 1
  # Uebernahme ohne Gegenwehr: bob setzt das Feld, alice aendert nur den Rumpf
  cd "$WORK/sim/alice"; schritt git switch -q main || return 1; git pull -q origin main 2>/dev/null; schritt git switch -qc a/body || return 1
  sed -i 's/^Offen\.$/In Arbeit: Kern-Modul./' docs/plan/planning/in-progress/slice-001-kern.md
  schritt git add -A && schritt git commit -qm "Rumpf (alice)" && schritt git push -q origin a/body || return 1
  cd "$WORK/sim/seedclone" && git fetch -q && git merge -q --no-edit origin/a/body >/dev/null 2>&1 && git merge -q --no-edit origin/b/own >/dev/null 2>&1; rc=$?
  inhaber=$(grep -o "Verantwortlich:\*\* [a-z]*" docs/plan/planning/in-progress/slice-001-kern.md | head -1)
  [ $rc -eq 0 ] && [ "$inhaber" = "Verantwortlich:** bob" ] && ok=0 || ok=1
  verdikt "s10b Uebernahme des Feldes, alice aendert nur den Rumpf: STILL" "rc=0, Inhaber=bob" "rc=$rc, $inhaber" $ok
}

# s11 — doc-immutable im Team (Modul 4: Accepted-ADR ist immutabel; Modul vcs
# braucht eine Commit-Range — der PR-Job). Geschichte-Zeile erlaubt, Kern nicht.
s11_adr_immutabel_im_team() {
  topo
  base=$(git -C "$WORK/sim/seedclone" rev-parse HEAD)
  cd "$WORK/sim/bob"; schritt git switch -qc b/geschichte || return 1
  printf -- '- 2026-08-22: im Team gesichtet.\n' >> docs/plan/adr/0001-kern.md
  schritt git add -A && schritt git commit -qm "ADR-0001 Geschichte" && schritt git push -q origin b/geschichte || return 1
  cd "$WORK/sim/alice"; schritt git switch -qc a/kern || return 1
  sed -i 's/^Der Kern ist ein eigenes Modul mit eigener Schnittstelle;/Der Kern ist ein Paket ohne eigene Schnittstelle;/' docs/plan/adr/0001-kern.md
  schritt git add -A && schritt git commit -qm "ADR-0001 Entscheidung geaendert" && schritt git push -q origin a/kern || return 1
  vcs() { docker run --rm --network none -v "$1:/repo:ro" "$IMG" --enable vcs --disable links --disable anchors --disable planning --range "$2" 2>&1; }
  cd "$WORK/sim/seedclone" && git fetch -q && git merge -q --no-edit origin/b/geschichte >/dev/null 2>&1
  out=$(vcs "$WORK/sim/seedclone" "$base..HEAD"); echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s11a Geschichte-Zeile per PR gelandet: kein Befund" "0 Befunde (Geschichte ist ausgenommen)" "$(echo "$out"|tail -1)" $ok
  git merge -q --no-edit origin/a/kern >/dev/null 2>&1
  out=$(vcs "$WORK/sim/seedclone" "$base..HEAD"); befund "$out" "docs/plan/adr/0001-kern.md" "core-drift-vcs" && ok=0 || ok=1
  verdikt "s11b Entscheidung einer Accepted-ADR per PR gelandet: core-drift-vcs" "core-drift-vcs auf der Range" "$(echo "$out"|tail -1)" $ok
}

echo "Team-Sim — Image: $IMG"; echo "Arbeitsverzeichnis: $WORK"; [ -n "$SELECT" ] && echo "Auswahl: $SELECT"; echo
lauf s01 s01_doppel_anspruch
lauf s02 s02_stille_nummer
lauf s03 s03_register_doppelzeile
lauf s04 s04_zwei_wellen_und_waves
lauf s04 s04g_eroeffnet_unter_waves
lauf s04 s04c_leerer_anspruch
lauf s05 s05_mr_hybrid
lauf s06 s06_branch_protection
lauf s07 s07_sichtung_liest_alt
lauf s08 s08_closure_unter_anspruch
lauf s09 s09_vorvergabe
lauf s10 s10_inhaber_feld
lauf s11 s11_adr_immutabel_im_team
echo; echo "Ergebnis: $PASS PASS, $FAIL FAIL, $KAPUTT KAPUTT — Ergebnisdatei: $TSV"
if [ "${SIM_CLEAN:-0}" = 1 ]; then cat "$TSV"; rm -rf "$WORK"; fi
[ $FAIL -eq 0 ] && [ $KAPUTT -eq 0 ]
