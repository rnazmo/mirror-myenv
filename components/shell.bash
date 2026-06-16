#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_zsh() {
    : # Phase 2: platform_install_zsh + config + completions + keybindings + plugins + p10k
}

setup_default_shell() {
    : # Phase 2: chsh -s "$(which zsh)"
}
