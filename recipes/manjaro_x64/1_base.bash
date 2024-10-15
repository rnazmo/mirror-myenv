#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/recipes/_arch_based_x64/1_base.bash"

___pre_setup_zsh_theme() {
    # ======== powerlevel10k (= theme)
    # (for Manjaro): Ensure that uninstall aur package "zsh-theme-powerlevel10k" to avoid conflict
    # Description:
    #     In Manjaro, package "manjaro-zsh-config" is installed by default. However,
    #     it depends on package "zsh-theme-powerlevel10k", which conflicts with package
    #     "zsh-theme-powerlevel10k-git". So, to install package "zsh-theme-powerlevel10k-git",
    #     package "manjaro-zsh-config" must be uninstalled.
    # Why use package "zsh-theme-powerlevel10k-git" instead of package "zsh-theme-powerlevel10k"?
    #     The maintainer of "zsh-theme-powerlevel10k-git" is the author of powerlevel10k.
    # Ref:
    #     https://aur.archlinux.org/packages/zsh-theme-powerlevel10k-git
    #     https://aur.archlinux.org/packages/zsh-theme-powerlevel10k
    #     https://github.com/Chrysostomus/manjaro-zsh-config
    local -r MANJARO_ZSH_CONFIG_PKG="manjaro-zsh-config"
    # Uninstll the package if it is installed
    if yay -Qi "$MANJARO_ZSH_CONFIG_PKG" &>/dev/null; then
        yay -Rns --noconfirm "$MANJARO_ZSH_CONFIG_PKG"
    fi
}

__setup_zsh_theme() {
    ___pre_setup_zsh_theme
    ___install_powerlevel10k
}

_setup_zsh() {
    __install_zsh
    __setup_zsh_config
    __setup_zsh_completions
    __setup_zsh_keybindings
    __setup_zsh_theme
    __setup_zsh_plugins
    __post_setup_zsh
}

setup_shell() {
    _setup_zsh
    _setup_default_shell
}
