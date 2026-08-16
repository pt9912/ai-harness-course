#!/usr/bin/env bash
# Team-Sim — Replay fuer Nebenlaeufigkeits-Szenarien (Modul-12-Bauform).
# KEIN Gate: laeuft auf Anlass, nicht in make check. Topologie je Lauf frisch:
# bare origin.git + zwei Clones (alice, bob) — die Team-Topologie, nicht
# Worktrees (die teilen ein .git und modellieren EINEN Entwickler).
# Erwartungen sind VORAB notiert; auch stille Ausgaenge sind Erwartungen.
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
PASS=0; FAIL=0

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
dcheck() { docker run --rm --network none -v "$1:/repo:ro" "$IMG" 2>&1 | tail -2; }
verdikt() { # $1 name  $2 erwartet  $3 beobachtet  $4 ok(0/1)
  if [ "$4" = 0 ]; then echo "  PASS  $1"; PASS=$((PASS+1));
  else echo "  FAIL  $1"; echo "        erwartet:  $2"; echo "        beobachtet: $3"; FAIL=$((FAIL+1)); fi
}

s01_doppel_anspruch() {
  topo
  # alice beansprucht slice-003 auf main (Datei anlegen + mv-Aequivalent: neu in in-progress)
  cd "$WORK/sim/alice"; printf '# Slice slice-003\n\n**Welle:** welle-2-ausbau\n\n**Verantwortlich:** alice.\n' > docs/plan/planning/in-progress/slice-003-ausbau.md
  git add -A && git commit -qm "claim slice-003 (alice)" && git push -q origin main
  # bob, OHNE zu pullen, beansprucht denselben Slice auf seinem main
  cd "$WORK/sim/bob"; printf '# Slice slice-003\n\n**Welle:** welle-2-ausbau\n\n**Verantwortlich:** bob.\n' > docs/plan/planning/in-progress/slice-003-ausbau.md
  git add -A && git commit -qm "claim slice-003 (bob)"
  out=$(git push origin main 2>&1); rc=$?
  [ $rc -ne 0 ] && echo "$out" | grep -q "rejected\|fetch first\|fast-forward" && ok=0 || ok=1
  verdikt "s01 Doppel-Anspruch: zweiter Push laut abgelehnt" "push rejected (non-fast-forward)" "rc=$rc" $ok
  # und nach dem Pull SIEHT bob den Anspruch samt Inhaber
  git pull -q --no-rebase origin main 2>/dev/null
  grep -q "Verantwortlich:\*\* alice" docs/plan/planning/in-progress/slice-003-ausbau.md 2>/dev/null || grep -q "Verantwortlich" docs/plan/planning/in-progress/slice-003-ausbau.md
  # Merge-Konflikt in der Datei selbst ist auch "laut" — beides akzeptabel:
  if git ls-files -u | grep -q slice-003; then ok=0; beob="Merge-Konflikt in der Slice-Datei (laut)"; else grep -q "alice" docs/plan/planning/in-progress/slice-003-ausbau.md && ok=0 && beob="alice-Anspruch sichtbar" || { ok=1; beob="Anspruch nicht sichtbar"; }; fi
  verdikt "s01b Anspruch nach Pull sichtbar oder Konflikt laut" "sichtbar/Konflikt" "$beob" $ok
}

s02_stille_nummer() {
  topo
  cd "$WORK/sim/alice"; git switch -qc a/cache; printf '# Slice slice-003: Cache\n' > docs/plan/planning/open/slice-003-cache.md
  git add -A && git commit -qm "slice-003-cache" && git push -q origin a/cache
  cd "$WORK/sim/bob"; git switch -qc b/index; printf '# Slice slice-003: Index\n' > docs/plan/planning/open/slice-003-index.md
  git add -A && git commit -qm "slice-003-index" && git push -q origin b/index
  # beide "PRs" mergen
  cd "$WORK/sim/seedclone" && git fetch -q origin && git merge -q --no-edit origin/a/cache >/dev/null 2>&1 && git merge -q --no-edit origin/b/index >/dev/null 2>&1; rc=$?
  n=$(ls docs/plan/planning/open/slice-003-*.md 2>/dev/null | wc -l)
  [ $rc -eq 0 ] && [ "$n" = 2 ] && ok=0 || ok=1
  verdikt "s02 stille Nummern-Kollision: Merge glatt, zwei slice-003" "rc=0, 2 Dateien" "rc=$rc, $n Dateien" $ok
}

s03_register_doppelzeile() {
  topo
  cd "$WORK/sim/alice"; git switch -qc a/beo
  sed -i 's/| 1× | slice-001 |/| 2× | slice-001, slice-003 |/' docs/plan/planning/observations.md
  git add -A && git commit -qm "BEO-001 erhoeht" && git push -q origin a/beo
  cd "$WORK/sim/bob"; git switch -qc b/beo
  printf '| BEO-005 | Fixture-Pfade driften (neu benannt) | Kern | 1× | slice-004 | offen |\n' >> docs/plan/planning/observations.md
  git add -A && git commit -qm "neue Zeile fuers selbe Phaenomen" && git push -q origin b/beo
  cd "$WORK/sim/seedclone" && git fetch -q && git merge -q --no-edit origin/a/beo >/dev/null 2>&1 && git merge -q --no-edit origin/b/beo >/dev/null 2>&1; rc=$?
  zeilen=$(grep -c "Fixture-Pfade driften" docs/plan/planning/observations.md)
  [ $rc -eq 0 ] && [ "$zeilen" = 2 ] && ok=0 || ok=1
  verdikt "s03 Register (mit Abstand): Doppel-Zeile mergt STILL" "rc=0, 2 Zeilen fuers selbe Phaenomen" "rc=$rc, $zeilen Zeilen" $ok
}

s04_zwei_wellen_und_waves() {
  topo
  cd "$WORK/sim/alice"
  printf '# Welle welle-2-ausbau: Ausbau\n\n**Verantwortlich:** bob. **Datum:** 2026-08-16.\n' > docs/plan/planning/welle-2-ausbau.md
  sed -i 's|- \[welle-1-basis\](../welle-1-basis.md)|- [welle-1-basis](../welle-1-basis.md)\n- [welle-2-ausbau](../welle-2-ausbau.md)|' docs/plan/planning/in-progress/roadmap.md
  sed -i '/welle-2-ausbau | welle-1 done/d' docs/plan/planning/in-progress/roadmap.md
  git add -A && git commit -qm "zweite offene Welle" && git push -q origin main
  out=$(dcheck "$WORK/sim/alice"); echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s04a zwei offene Wellen: planning ohne waves GRUEN" "0 Befunde" "$(echo "$out"|tail -1)" $ok
  # waves einschalten -> Singleton-Semantik muss beissen
  printf '  waves:\n    dir: docs/plan/planning\n' >> .d-check.yml
  out=$(dcheck "$WORK/sim/alice"); echo "$out" | grep -q "wave-drift" && ok=0 || ok=1
  verdikt "s04b waves.dir an: Singleton meldet wave-drift" "wave-drift" "$(echo "$out"|tail -1)" $ok
}

s05_mr_hybrid() {
  topo
  cd "$WORK/sim/alice"; git switch -qc a/mr
  mkdir -p harness/conventions && printf '# MR-001: Alpha\n' > harness/conventions/MR-001-alpha.md
  sed -i 's/| MR-000 | 2026-08-16 | Baseline-Aussage |/| MR-000 | 2026-08-16 | Baseline-Aussage |\n| MR-001 | 2026-08-16 | Alpha |/' harness/conventions.md
  git add -A && git commit -qm "MR-001 alpha" && git push -q origin a/mr
  cd "$WORK/sim/bob"; git switch -qc b/mr
  mkdir -p harness/conventions && printf '# MR-001: Beta\n' > harness/conventions/MR-001-beta.md
  sed -i 's/| MR-000 | 2026-08-16 | Baseline-Aussage |/| MR-000 | 2026-08-16 | Baseline-Aussage |\n| MR-001 | 2026-08-16 | Beta |/' harness/conventions.md
  git add -A && git commit -qm "MR-001 beta" && git push -q origin b/mr
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
  git add -A && git commit -qm "claim auf main"
  out=$(git push origin main 2>&1); rc=$?
  [ $rc -ne 0 ] && ok=0 || ok=1
  verdikt "s06 Branch-Protection: TA-7-Anspruch scheitert am Hook" "push abgelehnt" "rc=$rc" $ok
}

s07_sichtung_liest_alt() {
  topo
  cd "$WORK/sim/alice"; git switch -qc a/closure
  sed -i 's/| 1× | slice-001 |/| 3× | slice-001, slice-005, slice-006 |/' docs/plan/planning/observations.md
  git add -A && git commit -qm "BEO-001 auf 3x (im PR)" && git push -q origin a/closure
  cd "$WORK/sim/bob" && git pull -q origin main
  stand=$(grep -o "| [0-9]×" docs/plan/planning/observations.md | head -1)
  [ "$stand" = "| 1×" ] && ok=0 || ok=1
  verdikt "s07 Sichtung liest gemergten Stand: 1x trotz 3x im offenen PR" "1×" "$stand" $ok
}

echo "Team-Sim — Image: $IMG"; echo "Arbeitsverzeichnis: $WORK"; echo
s01_doppel_anspruch; s02_stille_nummer; s03_register_doppelzeile
s04_zwei_wellen_und_waves; s05_mr_hybrid; s06_branch_protection; s07_sichtung_liest_alt
echo; echo "Ergebnis: $PASS PASS, $FAIL FAIL"; [ $FAIL -eq 0 ]
