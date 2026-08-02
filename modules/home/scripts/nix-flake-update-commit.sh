#!/usr/bin/env bash

# Run from repo root, or pass a path as the first arg
FLAKE_DIR="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
cd "$FLAKE_DIR"

if [ ! -f flake.lock ]; then
  echo "No flake.lock in $FLAKE_DIR" >&2
  exit 1
fi

OLD_LOCK=$(mktemp)
trap 'rm -f "$OLD_LOCK"' EXIT
cp flake.lock "$OLD_LOCK"

# Forward any extra args to `nix flake update` (e.g. specific input names)
nix flake update "$@"

if diff -q "$OLD_LOCK" flake.lock >/dev/null 2>&1; then
  echo "flake.lock unchanged, nothing to commit."
  exit 0
fi

# Diff the two lockfiles at the JSON level to find changed inputs
CHANGES=$(jq -n --slurpfile old "$OLD_LOCK" --slurpfile new flake.lock '
  ($old[0].nodes) as $o | ($new[0].nodes) as $n |
  [ $n | keys[] | select(. != "root")
    | select($o[.] != null)
    | select($n[.].locked != $o[.].locked)
    | {
        name: .,
        oldRef: ($o[.].locked.rev // ($o[.].locked.lastModified | tostring)),
        newRef: ($n[.].locked.rev // ($n[.].locked.lastModified | tostring))
      }
  ]
')

if [ "$(echo "$CHANGES" | jq 'length')" -eq 0 ]; then
  echo "Lockfile changed but no per-input diffs detected; committing generically."
  git add flake.lock
  git commit -m "flake.lock: update inputs"
  exit 0
fi

SUMMARY_LINE=$(echo "$CHANGES" | jq -r '[.[].name] | join(", ")')
BODY=$(echo "$CHANGES" | jq -r '.[] | "- \(.name): \(.oldRef[0:7]) -> \(.newRef[0:7])"')

git add flake.lock
git commit -m "flake.lock: update $SUMMARY_LINE" -m "$BODY"
echo "Committed:"
echo "$BODY"
