# CachyOS 固有の差分。arch.bash を継承し、一部を上書き。

source "${DEMO_ROOT}/platforms/arch.bash"

platform_pre_info() {
    echo "  [CachyOS] Removing conflicting packages..."
}
platform_get_os() { echo "CachyOS"; }
