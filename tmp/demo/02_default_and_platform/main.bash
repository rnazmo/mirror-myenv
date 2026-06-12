#!/usr/bin/env bash
set -eu
echo "=== 02: デフォルト + platform 上書き ==="

DEMO_DIR="$(cd "$(dirname "$0")" && pwd)"

# source する順序が重要！

# 1. まずデフォルトを読み込む
source "${DEMO_DIR}/lib/platform.bash"

# 2. 次にplatform固有の上書きを読み込む（遅い方が勝つ）
source "${DEMO_DIR}/platforms/cachyos.bash"

# 3. 最後にcomponent（OSに依存しない処理）を読み込む
source "${DEMO_DIR}/components/greet.bash"

echo "--- setup_greet 実行 ---"
setup_greet

echo ""
echo "→ component は platform_pre_greet / platform_get_os を呼ぶだけ"
echo "→ 実装は source 順で決まる：デフォルト → platform で上書き"
