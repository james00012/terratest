#!/usr/bin/env bash
# check-single-source.sh — fails CI if two different submodules' declared module
# paths overlap, which would cause Go's loader to see ambiguous packages.
#
# The "ambiguous import" class of bug occurs when two go.mod files declare module
# paths where one is a prefix of the other (e.g. github.com/foo/bar and
# github.com/foo/bar/baz). Go cannot tell which module serves the package at the
# prefix path. This check catches that.

set -uo pipefail

# Collect every submodule's declared module path.
declare -a paths=()
for gomod in $(find . -name go.mod -not -path '*/vendor/*' 2>/dev/null); do
  mod_path=$(grep '^module' "$gomod" | head -1 | awk '{print $2}' || true)
  [ -z "$mod_path" ] && continue
  paths+=("$mod_path|$gomod")
done

fail=0

# Pairwise: for each pair (a, b) where a != b, check that neither is a prefix of the other.
n=${#paths[@]}
for ((i=0; i<n; i++)); do
  a_path="${paths[$i]%%|*}"
  a_file="${paths[$i]##*|}"
  for ((j=i+1; j<n; j++)); do
    b_path="${paths[$j]%%|*}"
    b_file="${paths[$j]##*|}"

    if [ "$a_path" = "$b_path" ]; then
      echo "::error::Duplicate module path '$a_path' declared in:"
      echo "    $a_file"
      echo "    $b_file"
      fail=1
      continue
    fi

    case "$a_path" in
      "$b_path"/*)
        echo "::error::Module path '$a_path' is nested under '$b_path' — ambiguous package resolution."
        echo "    $a_file"
        echo "    $b_file"
        fail=1
        ;;
    esac
    case "$b_path" in
      "$a_path"/*)
        echo "::error::Module path '$b_path' is nested under '$a_path' — ambiguous package resolution."
        echo "    $a_file"
        echo "    $b_file"
        fail=1
        ;;
    esac
  done
done

if [ "$fail" -ne 0 ]; then
  echo "::error::Single-source-of-truth check failed."
  exit 1
fi

echo "single-source check: OK"
