#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_chromium() {
    platform_install_chromium
}
readonly -f setup_chromium

setup_chrome() {
    platform_install_chrome
}
readonly -f setup_chrome

setup_firefox() {
    platform_install_firefox
    _setup_firefox_extensions
}
readonly -f setup_firefox

_setup_firefox_extensions() {
    sudo pacman -S --needed --noconfirm firefox-ublock-origin
}
readonly -f _setup_firefox_extensions
