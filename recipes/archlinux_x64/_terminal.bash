#!/bin/bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

main() {
    log_debug "START: ${BASH_SOURCE}"

    sudo pacman -Syu --noconfirm
    yay -Syu --noconfirm

    # ======================================================
    # ======== zsh (& theme & plugin-manager & plugins)    =
    # ======================================================

    # ======== zsh
    sudo pacman -S --needed --noconfirm zsh

    local -r ZDOTDIR="${HOME}/.config/zsh"

    [ -L "${HOME}/.zshrc" ] && unlink "${HOME}/.zshrc"
    [ -L "${HOME}/.zshenv" ] && unlink "${HOME}/.zshenv"
    [ -f "${HOME}/.zshrc" ] && mv "${HOME}/.zshrc" "${HOME}/.zshrc.old"
    [ -f "${HOME}/.zshenv" ] && mv "${HOME}/.zshenv" "${HOME}/.zshenv.old"
    link_file "${MYENV_ROOT}/config/home/.zshenv" "${HOME}/.zshenv"
    link_dir "${MYENV_ROOT}/config/home/.config/zsh" "$ZDOTDIR" # NOTE: the path is directory

    # ======== powerlevel10k (= theme)
    # Ref:
    #     https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#arch-linux
    #     https://aur.archlinux.org/packages/zsh-theme-powerlevel10k-git
    yay -S --needed --noconfirm zsh-theme-powerlevel10k-git

    # ======== sheldon (= plugin manager)
    sudo pacman -S --needed --noconfirm sheldon
    link_file "${MYENV_ROOT}/config/home/.config/sheldon/plugins.toml" "${HOME}/.config/sheldon/plugins.toml"

    # ======================================================
    # ======== default shell                               =
    # ======================================================

    if check_if_command_exists "zsh" && [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)"
        log_info "Changed your default login shell to Zsh"
        # NOTE: Then, you must re-login (or reboot the machine) to reflect this change.
    fi

    # ======================================================
    # ======== alacritty (& theme)                         =
    # ======================================================

    sudo pacman -S --needed --noconfirm alacritty
    link_file "${MYENV_ROOT}/config/home/.config/alacritty/alacritty.toml" "${HOME}/.config/alacritty/alacritty.toml"
    link_file "${MYENV_ROOT}/config/home/.config/alacritty/my-theme.toml" "${HOME}/.config/alacritty/my-theme.toml"

    # ======================================================
    # ======== tmux (& plugin-manager & plugins)           =
    # ======================================================

    # ======== tmux
    sudo pacman -S --needed --noconfirm tmux
    link_file "${MYENV_ROOT}/config/home/.config/tmux/tmux.conf" "${HOME}/.config/tmux/tmux.conf"

    log_debug "END  : ${BASH_SOURCE}"
}

main
