#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

# ===== 個別関数（ソフトウェア単位） =====

setup_git() {
    : # Phase 2: platform_install_git + platform_install_delta + _setup_git_config
}

setup_aur_helper() {
    : # Phase 2: platform_install_yay
}

setup_mise() {
    : # Phase 2: platform_install_mise + _setup_mise_config
}

setup_aqua() {
    : # Phase 2: _setup_aqua
}

setup_golang() {
    : # Phase 2: mise use go@latest
}

setup_nodejs() {
    : # Phase 2: mise use node@latest
}

setup_directories() {
    : # Phase 2: mkdir repos/workspace + link .bin
}

# ===== 便利関数（コンポーネント単位） =====

setup_core() {
    setup_git
    setup_aur_helper
    setup_mise
    setup_aqua
    setup_golang
    setup_nodejs
    setup_directories
}
