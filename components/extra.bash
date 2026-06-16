#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_docker() {
    : # Phase 2: platform_install_docker
}

setup_virtualbox() {
    : # Phase 2: platform_install_virtualbox
}

setup_virtualbox_guest() {
    : # Phase 2: platform_install_virtualbox_guest
}

setup_vscode() {
    : # Phase 2: platform_install_vscode + config + extensions
}

setup_obsidian() {
    : # Phase 2: platform_install_obsidian
}
