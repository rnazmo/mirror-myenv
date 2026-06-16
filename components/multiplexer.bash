#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_tmux() {
    platform_install_tmux
    _setup_tmux_config
    _setup_tmux_theme
}
readonly -f setup_tmux

_setup_tmux_config() {
    remove_unused_config "${HOME}/.tmux.conf"
    link_file "${MYENV_ROOT}/config/home/.config/tmux/tmux.conf" "${HOME}/.config/tmux/tmux.conf"
}
readonly -f _setup_tmux_config

_setup_tmux_theme() {
    local -r TMUX_THEME_LOCAL_PATH="${HOME}/.config/tmux/themes.local"

    download_file \
        "https://raw.githubusercontent.com/nordtheme/tmux/refs/heads/develop/nord.tmux" \
        "${TMUX_THEME_LOCAL_PATH}/nord.tmux"

    download_file \
        "https://raw.githubusercontent.com/EdenEast/nightfox.nvim/refs/heads/main/extra/nordfox/nordfox.tmux" \
        "${TMUX_THEME_LOCAL_PATH}/nordfox.tmux"

    download_file \
        "https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/heads/main/extras/tmux/tokyonight_night.tmux" \
        "${TMUX_THEME_LOCAL_PATH}/tokyonight_night.tmux"

    download_file \
        "https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/heads/main/extras/tmux/tokyonight_storm.tmux" \
        "${TMUX_THEME_LOCAL_PATH}/tokyonight_storm.tmux"
}
readonly -f _setup_tmux_theme
