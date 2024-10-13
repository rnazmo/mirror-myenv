#!/bin/bash
set -eu

source ${MYENV_ROOT}/lib/util.bash

main() {
    log_debug "START: ${BASH_SOURCE}"

    sudo pacman -Syu --noconfirm

    # ======================================================
    # ======== many cli tools                              =
    # ======================================================

    sudo pacman -S --needed --noconfirm \
        ghq fzf tree xclip unzip fastfetch \
        ripgrep bat eza fd git-delta bottom

    # ======== proper7y
    if ! check_if_command_exists "proper7y"; then
        local -r dest_dir="${HOME}/bin"

        cd "$(mktemp -d)"
        curl -O https://raw.githubusercontent.com/rnazmo/proper7y/main/install.bash
        chmod +x ./install.bash
        ./install.bash "$dest_dir"
    fi

    # ======== lazygit
    sudo pacman -S --needed --noconfirm lazygit
    link_file "${MYENV_ROOT}/config/home/.config/lazygit/config.yml" "${HOME}/.config/lazygit/config.yml"

    log_debug "END  : ${BASH_SOURCE}"
}

main
