#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_util_clis() {
    platform_install_tree
    platform_install_xclip
    platform_install_unzip
    platform_install_ghq
    platform_install_fzf
    platform_install_zoxide
    platform_install_eza
    platform_install_ripgrep
    platform_install_bat
    platform_install_fd
    platform_install_bottom
    platform_install_jq
}
readonly -f setup_util_clis

setup_fastfetch() {
    platform_install_fastfetch
    _setup_fastfetch_config
}
readonly -f setup_fastfetch

_setup_fastfetch_config() {
    remove_unused_config "${HOME}/.config/fastfetch/config.jsonc"
    link_file "${MYENV_ROOT}/config/home/.config/fastfetch/config.jsonc" "${HOME}/.config/fastfetch/config.jsonc"
}
readonly -f _setup_fastfetch_config

setup_yazi() {
    platform_install_yazi
    _setup_yazi_config
}
readonly -f setup_yazi

_setup_yazi_config() {
    remove_unused_config "${HOME}/.config/yazi/yazi.toml"
    link_file "${MYENV_ROOT}/config/home/.config/yazi/yazi.toml" "${HOME}/.config/yazi/yazi.toml"
}
readonly -f _setup_yazi_config

setup_proper7y() {
    if check_if_command_exists "proper7y"; then
        return 0
    fi

    local -r ORIGINAL_DIR="$(pwd)"
    cd "$(mktemp -d)"

    local -r DEST_DIR="${HOME}/.local/bin"
    curl -O https://raw.githubusercontent.com/rnazmo/proper7y/main/install.bash
    chmod +x ./install.bash
    ./install.bash "$DEST_DIR"

    cd "$ORIGINAL_DIR"
}
readonly -f setup_proper7y
