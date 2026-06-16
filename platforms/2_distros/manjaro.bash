#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

platform_pre_install_p10k() {
    local -r MANJARO_ZSH_CONFIG_PKG="manjaro-zsh-config"
    if yay -Qi "$MANJARO_ZSH_CONFIG_PKG" &>/dev/null; then
        yay -Rns --noconfirm "$MANJARO_ZSH_CONFIG_PKG"
    fi
}
readonly -f platform_pre_install_p10k
