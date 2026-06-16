#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_alacritty() {
    platform_install_alacritty
    _setup_alacritty_config
    _setup_alacritty_theme
}
readonly -f setup_alacritty

_setup_alacritty_config() {
    link_file "${MYENV_ROOT}/config/home/.config/alacritty/alacritty.toml" "${HOME}/.config/alacritty/alacritty.toml"
}
readonly -f _setup_alacritty_config

_setup_alacritty_theme() {
    download_file \
        "https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/heads/main/extras/alacritty/tokyonight_night.toml" \
        "${HOME}/.config/alacritty/theme.local/tokyonight_night.toml"
}
readonly -f _setup_alacritty_theme

setup_wezterm() {
    platform_install_wezterm
    _setup_wezterm_config
}
readonly -f setup_wezterm

_setup_wezterm_config() {
    link_file "${MYENV_ROOT}/config/home/.config/wezterm/wezterm.lua" "${HOME}/.config/wezterm/wezterm.lua"
}
readonly -f _setup_wezterm_config
