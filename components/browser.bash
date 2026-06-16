#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_chromium() {
    : # Phase 2: platform_install_chromium
}

setup_chrome() {
    : # Phase 2: yay -S google-chrome
}

setup_firefox() {
    : # Phase 2: platform_install_firefox
}
