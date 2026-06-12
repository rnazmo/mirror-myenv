#!/usr/bin/env bash
set -eu

if [ $# -ne 1 ]; then
    echo "Usage: $0 <host_name>"
    echo "  host_name: udon | soba"
    exit 1
fi

export DEMO_ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "=== 04: 完全版 — host: $1 ==="
source "${DEMO_ROOT}/hosts/${1}.bash"
echo "--- done ---"
