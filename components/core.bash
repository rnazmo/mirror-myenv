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

    setup_maintenance
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
    if check_if_command_exists "aqua"; then
        link_file "${MYENV_ROOT}/config/home/.config/aquaproj-aqua/aqua.yaml" "${HOME}/.config/aquaproj-aqua/aqua.yaml"
        return 0
    fi

    local -r AQUA_VERSION="v2.27.4"
    local -r OS="linux"
    local -r ARCH="amd64"
    local -r FILENAME="aqua_${OS}_${ARCH}.tar.gz"
    local -r URL="https://github.com/aquaproj/aqua/releases/download/${AQUA_VERSION}/${FILENAME}"

    local -r CHECKSUMS_LINUX_AMD64="0e6be7a87a5466fe3b236e1909904b0407a5d8b5ce3035f1f5a108ff8f3869e8"
    local -r AQUA_BIN_DIR="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-${HOME}/.local/share}/aquaproj-aqua}/bin"

    local -r TMP_DIR="$(mktemp -d)"
    (
        cd "$TMP_DIR"

        curl -sSfL -O "$URL"
        echo "${CHECKSUMS_LINUX_AMD64}  ${FILENAME}" | sha256sum -c

        tar xzf "$FILENAME"
        chmod a+x aqua

        mkdir -p "$AQUA_BIN_DIR"
        mv aqua "$AQUA_BIN_DIR/"
    )
    rm -rf "$TMP_DIR"

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
