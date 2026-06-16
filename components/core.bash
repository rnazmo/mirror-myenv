#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

# ======================================================
# ===== 便利関数（コンポーネント単位）                ===
# ======================================================

setup_core() {
    platform_ensure_build_deps
    platform_update_mirrorlist
    platform_refresh_packages

    setup_git
    setup_aur_helper
    setup_mise
    setup_aqua
    setup_golang
    setup_nodejs
    setup_directories
}
readonly -f setup_core

# ======================================================
# ===== 個別関数（ソフトウェア単位）                  ===
# ======================================================

# ===== Git =====

setup_git() {
    platform_install_git
    platform_install_delta
    _setup_git_config
}
readonly -f setup_git

_setup_git_config() {
    remove_unused_config "${HOME}/.gitconfig"
    remove_unused_config "${HOME}/.gitignore"
    remove_unused_config "${HOME}/.gitignore_global"
    link_file "${MYENV_ROOT}/config/home/.config/git/config" "${HOME}/.config/git/config"
    link_file "${MYENV_ROOT}/config/home/.config/git/ignore" "${HOME}/.config/git/ignore"
}
readonly -f _setup_git_config

# ===== AUR helper =====

setup_aur_helper() {
    platform_install_yay
}
readonly -f setup_aur_helper

# ===== Runtime version manager =====

setup_mise() {
    platform_install_mise
    _setup_mise_config
}
readonly -f setup_mise

_setup_mise_config() {
    link_file "${MYENV_ROOT}/config/home/.config/mise/config.toml" "${HOME}/.config/mise/config.toml"
}
readonly -f _setup_mise_config

# ===== CLI version manager =====

setup_aqua() {
    _install_aqua
}
readonly -f setup_aqua

_install_aqua() {
    if ! check_if_command_exists "aqua"; then
        local -r ORIGINAL_DIR="$(pwd)"
        cd "$(mktemp -d)"

        curl -sSfL -O https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.0.1/aqua-installer
        echo "fb4b3b7d026e5aba1fc478c268e8fbd653e01404c8a8c6284fdba88ae62eda6a  aqua-installer" | sha256sum -c
        chmod +x aqua-installer
        ./aqua-installer

        cd "$ORIGINAL_DIR"
    fi
    link_file "${MYENV_ROOT}/config/home/.config/aquaproj-aqua/aqua.yaml" "${HOME}/.config/aquaproj-aqua/aqua.yaml"
}
readonly -f _install_aqua

# ===== Programming languages =====

setup_golang() {
    _mise_use_global_if_needed "go" "latest"
}
readonly -f setup_golang

setup_nodejs() {
    _mise_use_global_if_needed "node" "latest"
}
readonly -f setup_nodejs

_mise_use_global_if_needed() {
    local -r TOOL="$1"
    local -r VERSION="$2"
    local -r STAMP_FILE="${XDG_CACHE_HOME:-${HOME}/.cache}/myenv/mise/${TOOL}_last_updated"
    local -r INTERVAL_SEC=$((24 * 60 * 60))

    if [[ -f "$STAMP_FILE" ]]; then
        local -r NOW=$(date +%s)
        local -r LAST=$(date -r "$STAMP_FILE" +%s)
        if ((NOW - LAST < INTERVAL_SEC)); then
            log_info "mise ${TOOL} update skipped (last updated within 24 hours)"
            return 0
        fi
    fi

    mise use --global "${TOOL}@${VERSION}"

    mkdir -p "$(dirname "$STAMP_FILE")"
    touch "$STAMP_FILE"
}
readonly -f _mise_use_global_if_needed

# ===== Directories =====

setup_directories() {
    local -r DIRS=(
        "${HOME}/repos"
        "${HOME}/workspace"
        "${HOME}/workspace/sandboxes"
        "${HOME}/workspace/temp"
    )
    for DIR in "${DIRS[@]}"; do
        mkdir -p -v "$DIR"
    done

    remove_unused_config "${HOME}/.bin"
    link_dir "${MYENV_ROOT}/config/home/.bin" "${HOME}/.bin"
}
readonly -f setup_directories
