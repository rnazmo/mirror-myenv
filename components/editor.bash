#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_neovim() {
    : # Phase 2: platform_install_neovim + config + plugins restore
}

setup_editorconfig() {
    : # Phase 2: link .editorconfig
}
