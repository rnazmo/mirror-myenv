#!/usr/bin/env bash
set -eu
echo "=== 03: platform 間の継承（arch → cachyos） ==="

export DEMO_ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "--- CachyOS で実行 ---"
source "${DEMO_ROOT}/lib/platform.bash"
source "${DEMO_ROOT}/platforms/cachyos.bash"   # ← 内部で arch.bash を source
source "${DEMO_ROOT}/components/greet.bash"
setup_greet

echo ""
echo "--- 継承の解決順序 ---"
echo "cachyos.bash"
echo "  └─ source arch.bash（cachyos.bash の先頭で source）"
echo "       └─ pre_greet: cachyos が上書き → 使われる"
echo "       └─ get_os:    cachyos が上書き → 使われる"
echo "       └─ post_greet: cachyos も arch も上書きなし → デフォルト（no-op）が使われる"
echo ""
echo "→ 差分が発生した層だけ上書きし、残りは継承元またはデフォルトに委ねられる"
