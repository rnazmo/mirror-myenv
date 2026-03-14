#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/recipes/_arch_based_x64/1_base.bash"

___pre_setup_zsh_theme_on_cachyos() {
    log_debug "/recipes/cachyos_x64/1_base.bash > ___pre_setup_zsh_theme_on_cachyos"
    # ======== powerlevel10k (= theme)
    # (for CachyOS): Ensure that uninstall aur package "zsh-theme-powerlevel10k" to avoid conflict
    # Description:
    #     In CachyOS, package "cachyos-zsh-config" is installed by default. However,
    #     it depends on package "zsh-theme-powerlevel10k", which conflicts with package
    #     "zsh-theme-powerlevel10k-git". So, to install package "zsh-theme-powerlevel10k-git",
    #     package "cachyos-zsh-config" must be uninstalled.
    # Why use package "zsh-theme-powerlevel10k-git" instead of package "zsh-theme-powerlevel10k"?
    #     The maintainer of "zsh-theme-powerlevel10k-git" is the author of powerlevel10k.
    # Ref:
    #     https://aur.archlinux.org/packages/zsh-theme-powerlevel10k-git
    #     https://aur.archlinux.org/packages/zsh-theme-powerlevel10k
    #     https://github.com/CachyOS/cachyos-zsh-config
    local -r CACHYOS_ZSH_CONFIG_PKG="cachyos-zsh-config"
    # Uninstll the package if it is installed
    if yay -Qi "$CACHYOS_ZSH_CONFIG_PKG" &>/dev/null; then
        yay -Rns --noconfirm "$CACHYOS_ZSH_CONFIG_PKG"
    fi
    yay -Rns --noconfirm zsh-theme-powerlevel10k
}
readonly -f ___pre_setup_zsh_theme_on_cachyos

__setup_zsh_theme_on_cachyos() {
    log_debug "/recipes/cachyos_x64/1_base.bash > __setup_zsh_theme_on_cachyos"
    ___pre_setup_zsh_theme_on_cachyos
    ___install_powerlevel10k
}
readonly -f __setup_zsh_theme_on_cachyos

_setup_zsh_on_cachyos() {
    log_debug "/recipes/cachyos_x64/1_base.bash > _setup_zsh_on_cachyos"
    __install_zsh
    __setup_zsh_config
    __setup_zsh_completions
    __setup_zsh_keybindings
    __setup_zsh_theme_on_cachyos
    __setup_zsh_plugins
    __post_setup_zsh
}
readonly -f _setup_zsh_on_cachyos

setup_shell_on_cachyos() {
    log_debug "/recipes/cachyos_x64/1_base.bash > setup_shell_on_cachyos"
    _setup_zsh_on_cachyos
    _setup_default_shell
}
readonly -f setup_shell_on_cachyos
