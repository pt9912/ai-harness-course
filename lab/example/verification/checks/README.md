# Verification Checks — DocSearch

Diese Checks sind absichtlich leichtgewichtig. Sie zeigen fuer Modul 11,
welche Belege ein Verifier mindestens gegen einen Slice prueft.

## Minimaler Check fuer `slice-009`

Der Root-Target

```bash
make verify SLICE=slice-009
```

prueft:

1. Es gibt eine Slice-Datei unter `docs/plan/planning/`.
2. Die Datei enthaelt eine Definition of Done.
3. Die Datei nennt mindestens eine `LH-*`- oder `ADR-*`-ID.
4. Die DoD dokumentiert `make gates`.

Das ersetzt keinen semantischen Verifier-Agent. Es ist ein
computational feedback, der die haeufigsten DoD-Luecken sichtbar macht.
