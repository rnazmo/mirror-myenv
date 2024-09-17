#!/bin/bash
set -eu

source ${MYENV_ROOT}/lib/util.bash

main() {
    log_debug "START: ${BASH_SOURCE}"

    sudo pacman -Syu

    # ======================================================
    # ======== many cli tools                              =
    # ======================================================

    sudo pacman -S --needed \
    ghq fzf tree xclip unzip neofetch lazygit \
    ripgrep bat eza fd git-delta bottom

    # ======== proper7y                          =
    if ! check_if_command_exists "proper7y"; then
        cd /tmp
        curl -O https://raw.githubusercontent.com/rnazmo/proper7y/main/install.sh
        chmod +x ./install.sh
        ./install.sh "${HOME}/bin"
    fi

    # ======================================================
    # ======== some programming languages                  =
    # ======================================================
    
    # ======== golang, nodejs
    mise install
    # mise install go
    # mise install node

    log_debug "END  : ${BASH_SOURCE}"
}

main
