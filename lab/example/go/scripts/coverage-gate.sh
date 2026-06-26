#!/bin/sh
# Coverage-Gate, hermetisch im Container ausgeführt (kein Host-Artefakt):
# coverage.out entsteht im Image/Container, nie im Working Tree.
# Usage: coverage-gate.sh <packages> <threshold>
set -e
pkgs="${1:-./...}"
threshold="${2:-70}"
go test -coverprofile=coverage.out "$pkgs"
cov=$(go tool cover -func=coverage.out | tail -1 | awk '{print $3}' | tr -d '%')
echo "Coverage ($pkgs): ${cov}%"
awk "BEGIN{exit !($cov >= $threshold)}" || { echo "FAIL: coverage < ${threshold}%"; exit 1; }
