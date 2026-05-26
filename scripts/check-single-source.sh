#!/usr/bin/env bash
# check-single-source.sh — fails CI if more than one submodule exposes the same
# Go package path. Catches the "ambiguous import" class of bug from prior modularization
# attempts where root and a submodule both served `modules/<name>`.
#
# Strategy: for every .go file outside vendor/, compute its declared package's full
# import path based on its containing module's go.mod. Then look for duplicates.

set -euo pipefail

# Build a list of (import-path, source-file) tuples.
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

for gomod in $(find . -name go.mod -not -path '*/vendor/*' -not -path '*/test-external/*' -print 2>/dev/null); do
  mod_dir=$(dirname "$gomod")
  mod_path=$(grep '^module' "$gomod" | head -1 | awk '{print $2}')
  [ -z "$mod_path" ] && continue

  # For each .go file under this module, compute its import path.
  while IFS= read -r gofile; do
    rel=$(dirname "${gofile#$mod_dir/}")
    if [ "$rel" = "." ]; then
      echo "${mod_path} ${gofile}" >> "$tmp"
    else
      echo "${mod_path}/${rel} ${gofile}" >> "$tmp"
    fi
  done < <(find "$mod_dir" -maxdepth 8 -name '*.go' -not -name '*_test.go' -not -path '*/vendor/*' 2>/dev/null)
done

# Find duplicates (multiple files claiming the same import path is fine — that's
# one package across multiple files. Multiple MODULES claiming the same import path
# is the bug we want to catch.)
fail=0
sort -u "$tmp" | awk '{print $1}' | sort | uniq -c | awk '$1 > 1 && $2 != "" {print $2}' > "${tmp}.dups"

# For each duplicate import path, check if it spans multiple modules.
while IFS= read -r path; do
  [ -z "$path" ] && continue
  module_dirs=$(grep -F " $path " "$tmp" 2>/dev/null | awk '{print $2}' | xargs -n1 dirname 2>/dev/null | sort -u | wc -l | tr -d ' ')
  if [ "$module_dirs" -gt 1 ]; then
    echo "::error::Package path served by multiple modules: $path"
    grep -F " $path " "$tmp" | head -10 | sed 's/^/    /'
    fail=1
  fi
done < "${tmp}.dups"

if [ "$fail" -ne 0 ]; then
  echo "::error::Single-source-of-truth check failed."
  exit 1
fi

echo "single-source check: OK"
