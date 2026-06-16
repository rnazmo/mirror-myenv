#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_zsh() {
    : # Phase 2: platform_install_zsh + config + completions + keybindings + plugins
}

setup_p10k() {
    : # Phase 2: platform_pre_install_p10k + platform_install_p10k
}

setup_default_shell() {
    : # Phase 2: chsh -s "$(which zsh)"
}
