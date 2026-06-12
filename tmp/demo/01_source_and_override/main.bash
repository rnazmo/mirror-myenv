#!/usr/bin/env bash
set -eu
echo "=== 01: source と関数の上書き ==="

DEMO_DIR="$(cd "$(dirname "$0")" && pwd)"

source "${DEMO_DIR}/lib.bash"
say_hello

# 関数を再定義（上書き）
say_hello() {
    echo "Hello from main.bash (overridden)!"
}
say_hello

# 再定義した後でも、元の関数を呼びたいなら別名保存が必要
echo "→ source した関数は、同名で再定義すると上書きされる"
