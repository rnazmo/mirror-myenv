#!/usr/bin/env bash
set -eu

source ${MYENV_ROOT}/lib/util.bash

setup_browser() {
    log_debug "START: ${BASH_SOURCE}"

    sudo pacman -Syu --noconfirm
    yay -Syu --noconfirm

    # ======================================================
    # ======== Chromium                                    =
    # ======================================================

    sudo pacman -S --needed --noconfirm chromium

    # ======== extensions
    # TODO:
    # ======== bookmarklets
    # TODO: HTML file??

    # ======================================================
    # ======== Chrome                                      =
    # ======================================================

    yay -S --needed --noconfirm google-chrome

    # ======== extensions
    # TODO:
    # ======== bookmarklets
    # TODO: HTML file??

    # ======================================================
    # ======== FireFox                                     =
    # ======================================================

    sudo pacman -S --needed --noconfirm firefox

    # ======== extensions
    sudo pacman -S --needed --noconfirm firefox-ublock-origin
    # TODO:
    # ======== bookmarklets
    # TODO: HTML file??

    log_debug "END  : ${BASH_SOURCE}"
}
