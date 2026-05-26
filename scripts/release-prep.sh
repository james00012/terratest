#!/usr/bin/env bash
# release-prep.sh — prepare the repo for a lockstep v2 release.
#
# What it does:
#   1. Strip all local `replace github.com/gruntwork-io/terratest/...` directives
#      from every submodule's go.mod.
#   2. Pin every cross-submodule `require` line to the version we're about to tag.
#   3. Run `go mod tidy` per submodule under GOWORK=off to update go.sum files.
#   4. Verify the no-replaces guard passes.
#
# Usage:
#   ./scripts/release-prep.sh v2.0.0-beta.1
#
# Run on a release-prep branch, NOT on main. Commit the result with the message
# tag "[release-prep]" so the v2-checks workflow runs the release-prep guard.

set -euo pipefail

VERSION="${1:?usage: $0 <version>  e.g. v2.0.0-beta.1}"

cd "$(git rev-parse --show-toplevel)"

echo "==> Stripping local terratest replaces..."
for gomod in modules/*/go.mod cmd/*/go.mod; do
  [ -f "$gomod" ] || continue
  # sed in-place differs between BSD (macOS) and GNU; use -i.bak then rm the backup.
  sed -i.bak '\|^replace github.com/gruntwork-io/terratest/|d' "$gomod"
  rm -f "${gomod}.bak"
done

echo "==> Pinning cross-submodule requires to $VERSION..."
for gomod in modules/*/go.mod cmd/*/go.mod; do
  [ -f "$gomod" ] || continue
  # Match either tagged versions or pseudo-versions on terratest module lines.
  sed -i.bak -E "s|(github\\.com/gruntwork-io/terratest/(modules\|cmd)/[a-zA-Z0-9_-]+/v2) v2[^[:space:]]+|\\1 $VERSION|g" "$gomod"
  rm -f "${gomod}.bak"
done

echo "==> Tidying each submodule (GOWORK=off)..."
for d in modules/*/ cmd/*/; do
  [ -f "$d/go.mod" ] || continue
  echo "    $d"
  (cd "$d" && GOWORK=off go mod tidy >/dev/null 2>&1) || {
    echo "::warning::tidy failed in $d (may need manual review)"
  }
done

echo "==> Verifying no-replaces guard..."
bash scripts/check-no-replaces.sh

echo
echo "Release prep complete for $VERSION."
echo "Next steps:"
echo "  1. Review the diff: git diff modules/*/go.mod cmd/*/go.mod"
echo "  2. Commit:  git commit -am 'release-prep: pin to $VERSION  [release-prep]'"
echo "  3. Push the release-prep branch and watch CI."
echo "  4. When CI is green, tag every submodule at the release commit (see docs/v2-release-runbook.md)."
