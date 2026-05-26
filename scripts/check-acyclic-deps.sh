#!/usr/bin/env bash
# check-acyclic-deps.sh — fails CI if any submodule imports a module from a strictly
# higher tier. Enforces the v2 layering rule: core → helpers → tooling → platforms → IaC.
#
# Test-only imports (inside _test.go in an external test package) are NOT scanned here;
# they may form module-level cycles per the RFC. Production imports must be acyclic
# and downward-only.

set -euo pipefail

# Tier assignment. Lower tier number = lower layer. Anything missing is treated
# as tier 99 (top) so unrelated paths don't trip the check.
declare -A TIER=(
  [core]=0
  [shell]=1
  [ssh]=1
  [http-helper]=1
  [dns-helper]=1
  [docker]=2
  [packer]=2
  [database]=2
  [slack]=2
  [oci]=2
  [opa]=2
  [aws]=3
  [azure]=3
  [gcp]=3
  [k8s]=3
  [helm]=3
  [terraform]=4
  [terragrunt]=4
  [test-structure]=4
  [version-checker]=4
)

fail=0

for dir in modules/*/; do
  importer=$(basename "$dir")
  importer_tier="${TIER[$importer]:-99}"

  # Production .go files only (exclude _test.go)
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    importee=$(echo "$line" | sed -E 's|.*"github.com/gruntwork-io/terratest/modules/([^/"]+).*|\1|')
    importee_tier="${TIER[$importee]:-99}"
    if [ "$importee_tier" -gt "$importer_tier" ]; then
      echo "::error file=${dir}::tier violation — $importer (tier $importer_tier) imports $importee (tier $importee_tier)"
      fail=1
    fi
  done < <(grep -rh '"github.com/gruntwork-io/terratest/modules/' "${dir}"*.go 2>/dev/null \
    | grep -v '_test\.go:' \
    | sort -u)
done

if [ "$fail" -ne 0 ]; then
  echo "::error::Tier-violation imports detected. Imports must flow downward only."
  exit 1
fi

echo "acyclic-deps check: OK"
