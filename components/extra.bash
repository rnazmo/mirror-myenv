#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_docker() {
    platform_install_docker
}
readonly -f setup_docker

setup_virtualbox() {
    platform_install_virtualbox
}
readonly -f setup_virtualbox

setup_virtualbox_guest() {
    platform_install_virtualbox_guest
}
readonly -f setup_virtualbox_guest

setup_vscode() {
    platform_install_vscode
    _setup_vscode_config
}
readonly -f setup_vscode

_setup_vscode_config() {
    link_file "${MYENV_ROOT}/config/home/.config/Code/User/settings.json" "${HOME}/.config/Code/User/settings.json"
    link_file "${MYENV_ROOT}/config/home/.config/Code/User/keybindings.json" "${HOME}/.config/Code/User/keybindings.json"
    link_dir "${MYENV_ROOT}/config/home/.config/Code/User/snippets" "${HOME}/.config/Code/User/snippets"

    local EXTENSIONS=(
        "golang.Go"
        "editorconfig.editorconfig"
    )
    for EXT in "${EXTENSIONS[@]}"; do
        code --install-extension "$EXT"
    done
}
readonly -f _setup_vscode_config

setup_obsidian() {
    platform_install_obsidian
}
readonly -f setup_obsidian
