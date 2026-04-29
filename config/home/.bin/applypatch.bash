#!/usr/bin/env bash
set -eu

# Apply unified diff from X11 clipboard to a file.
#
# Usage:
#   applypatch <target_file>
#
# Note:
#   Tries -p1 first (Git-style: "--- a/foo"), then falls back to -p0.
#   Requires xclip and patch.

readonly TARGET="$1"

DIFF="$(xclip -sel c -o)"

if echo "$DIFF" | patch -p1 --dry-run "$TARGET" &>/dev/null; then
  echo "$DIFF" | patch -p1 "$TARGET"
elif echo "$DIFF" | patch -p0 --dry-run "$TARGET" &>/dev/null; then
  echo "$DIFF" | patch -p0 "$TARGET"
else
  echo "ERROR: patch failed to apply (tried -p1 and -p0)" >&2
  exit 1
fi
