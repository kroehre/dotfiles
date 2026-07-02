#!/bin/sh
#
# Plannotator
#
# Sets plannotator's default review diff type to the whole-branch (merge-base /
# GitHub-PR) view. plannotator has no per-invocation override, so this is the
# global default in ~/.plannotator/config.json. Idempotent: merges the single
# key with jq, preserving any other settings plannotator writes there.

CONFIG_DIR="$HOME/.plannotator"
CONFIG="$CONFIG_DIR/config.json"

if ! command -v jq > /dev/null 2>&1; then
  echo "  jq not found; skipping plannotator config (install jq first)"
  exit 0
fi

mkdir -p "$CONFIG_DIR"
[ -f "$CONFIG" ] || echo '{}' > "$CONFIG"

tmp="$(mktemp "${TMPDIR:-/tmp}/plannotator-config.XXXXXX")"
if jq '.diffOptions.defaultDiffType = "branch"' \
     "$CONFIG" > "$tmp" 2>/dev/null; then
  mv "$tmp" "$CONFIG"
  echo "  plannotator default diff type set to branch"
else
  rm -f "$tmp"
  echo "  Warning: could not update $CONFIG (invalid JSON?); leaving as-is"
fi
