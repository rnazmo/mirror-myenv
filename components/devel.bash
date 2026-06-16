#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_devel_tools() {
    : # Phase 2: platform_install_{shellcheck,shfmt,selene,stylua,...}
}

setup_lazygit() {
    : # Phase 2: platform_install_lazygit + config
}
