#!/bin/bash
set -eu

source ${MYENV_ROOT}/lib/util.bash

main() {
    log_debug "START: ${BASH_SOURCE}"

    sudo pacman -Syu
    yay -Syu

    # ======================================================
    # ======== Chromium                                    =
    # ======================================================

    sudo pacman -S --needed chromium

    # ======== extensions
    # TODO:
    # ======== bookmarklets
    # TODO: HTML file??

    # ======================================================
    # ======== Chrome                                      =
    # ======================================================

    yay -S --needed google-chrome

    # ======== extensions
    # TODO:
    # ======== bookmarklets
    # TODO: HTML file??

    # ======================================================
    # ======== FireFox                                     =
    # ======================================================

    sudo pacman -S --needed firefox

    # ======== extensions
    sudo pacman -S --needed firefox-ublock-origin
    # TODO:
    # ======== bookmarklets
    # TODO: HTML file??

    log_debug "END  : ${BASH_SOURCE}"
}

main
