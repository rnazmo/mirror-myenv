#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

platform_pre_install_p10k() {
    local -r pkgs=("cachyos-zsh-config" "zsh-theme-powerlevel10k")
    for pkg in "${pkgs[@]}"; do
        pacman -Qi "$pkg" &>/dev/null && yay -Rns --noconfirm "$pkg" || true
    done
}
readonly -f platform_pre_install_p10k
