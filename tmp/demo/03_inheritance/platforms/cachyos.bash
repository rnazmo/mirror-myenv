# CachyOS 固有の差分。
# Arch 系ベースなので arch.bash を source して、さらに差分だけ上書きする。

source "${DEMO_ROOT}/platforms/arch.bash"   # arch の差分を継承

# CachyOS だけ必要な前処理
platform_pre_greet() {
    echo "  [CachyOS] Removing conflicting packages..."
}

# get_os も CachyOS 用に上書き
platform_get_os() { echo "CachyOS"; }

# post_greet は上書きしない → arch.bash にもない → デフォルト（no-op）が使われる
