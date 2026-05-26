# Changelog

All notable changes to Terratest are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/). This project
follows [semantic versioning](https://semver.org/) at the per-submodule
level starting with v2; see the [migration guide](docs/_docs/04_migrating-to-v2/overview.md)
for the v1 → v2 cut-over.

## Unreleased

### Added
- Per-submodule `go.mod` files; every public submodule is now an
  independently versioned Go module.
- `modules/core/v2` — bundles the eight tier-0 utility packages
  (collections, random, files, testing, environment, git, retry, logger)
  into a single submodule.
- `go.work` at the repo root for local cross-module development.
- `test-external/` consumer-simulation project that exercises the
  external-consumer experience under `GOWORK=off`.
- CI enforcement: acyclic dependency graph, single source of truth per
  package path, `/v2` SIV placement, no-replaces guard on release tags.
- `scripts/v2-import-rewrite.sh` — codemod for migrating v1 imports.
- `scripts/release-prep.sh` and `.github/workflows/v2-release.yml` —
  automation for the lockstep tag procedure described in
  `docs/v2-release-runbook.md`.
- `docs/_docs/04_migrating-to-v2/` — user-facing migration guide.

### Changed
- Import paths for every previously top-level module move under their
  respective v2 submodule (e.g. `modules/aws` → `modules/aws/v2`). The
  eight tier-0 utilities additionally relocate into `modules/core/v2/<name>`.
- Minimum Go version raised to 1.26 (Go 1.21+ consumers build via the
  automatic toolchain feature).
- `.github/workflows/go-mod-tidy-check.yml`, `lint.yml`, and
  `build-and-release.yml` iterate over every `go.mod` so each submodule
  is checked independently.

### Removed
- No code or features were removed. The runtime API is unchanged from v1
  except for the import paths.

### Backward compatibility
- v1 (`github.com/gruntwork-io/terratest`) is frozen at its last tag and
  remains served by `proxy.golang.org`. Pinned consumers are unaffected.
- v1 and v2 can be required in the same `go.mod`; they are separate Go
  modules. File-by-file migration is supported.
- `go get -u` does not jump between major versions.

---

## v1.0.0 — see git history

Older entries pre-date this `CHANGELOG.md`. Refer to the project's
[GitHub Releases](https://github.com/gruntwork-io/terratest/releases) and
`docs/_docs/03_migrating-to-v1/` for v1.0.0 details.
