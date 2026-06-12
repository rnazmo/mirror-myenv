# CachyOS 用の上書き（一部のフックだけ上書きする）

platform_pre_greet() {
    echo "  [CachyOS] Removing conflicting packages..."
}

platform_get_os() {
    echo "CachyOS"
}

# platform_post_greet は上書きしない → デフォルト（no-op）が使われる
