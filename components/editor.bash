#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_neovim() {
    platform_install_neovim
    _setup_neovim_config
    _ensure_neovim_plugins
}
readonly -f setup_neovim

_setup_neovim_config() {
    link_dir "${MYENV_ROOT}/config/home/.config/nvim" "${HOME}/.config/nvim"
}
readonly -f _setup_neovim_config

_ensure_neovim_plugins() {
    local -r FINGERPRINT_FILE="${XDG_CACHE_HOME:-${HOME}/.cache}/myenv/nvim/plugins_fingerprint"
    local -r CURRENT_FINGERPRINT="$(_calculate_neovim_plugins_fingerprint)"

    if _should_skip_neovim_plugins_restore "$FINGERPRINT_FILE" "$CURRENT_FINGERPRINT"; then
        log_info "Neovim plugin restore skipped (fingerprint unchanged)"
        return 0
    fi

    nvim --headless "+Lazy! restore" "+Lazy! clean" +qa

    mkdir -p "$(dirname "$FINGERPRINT_FILE")"
    printf '%s\n' "$CURRENT_FINGERPRINT" >"$FINGERPRINT_FILE"
}
readonly -f _ensure_neovim_plugins

_should_skip_neovim_plugins_restore() {
    local -r FINGERPRINT_FILE="$1"
    local -r CURRENT_FINGERPRINT="$2"
    local -r LAZY_NVIM_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/nvim/lazy/lazy.nvim"

    if [[ ! -d "$LAZY_NVIM_DIR" ]]; then
        return 1
    fi
    if [[ ! -f "$FINGERPRINT_FILE" ]]; then
        return 1
    fi

    [[ "$(<"$FINGERPRINT_FILE")" == "$CURRENT_FINGERPRINT" ]]
}
readonly -f _should_skip_neovim_plugins_restore

_calculate_neovim_plugins_fingerprint() {
    local -r NVIM_CONFIG_DIR="${MYENV_ROOT}/config/home/.config/nvim"

    (
        cd "$NVIM_CONFIG_DIR"
        find \
            init.lua \
            lazy-lock.json \
            lazyvim.json \
            lua/config/lazy.lua \
            lua/plugins \
            -type f \
            \( -name '*.lua' -o -name 'lazy-lock.json' -o -name 'lazyvim.json' \) \
            -print \
            | sort \
            | xargs sha256sum \
            | sha256sum \
            | awk '{print $1}'
    )
}
readonly -f _calculate_neovim_plugins_fingerprint

setup_editorconfig() {
    link_file "${MYENV_ROOT}/config/home/.editorconfig" "${HOME}/.editorconfig"
}
readonly -f setup_editorconfig
