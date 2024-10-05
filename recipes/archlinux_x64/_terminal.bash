#!/bin/bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

main() {
    log_debug "START: ${BASH_SOURCE}"

    sudo pacman -Syu --noconfirm
    yay -Syu --noconfirm

    # ======================================================
    # ======== zsh (& theme)                               =
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

    # ======================================================
    # ======== zsh plugins                                 =
    # ======================================================

    # TODO: Refactor (DRY)
    # TODO: Shallow clone for performance ?

    local -r ZSH_PLUGINS_LOCAL_DIR="${ZDOTDIR}/plugins.local"

    # ======== zsh-defer
    # Ref: https://github.com/romkatv/zsh-defer/blob/master/README.md#installation
    local -r ZSH_DEFER="${ZSH_PLUGINS_LOCAL_DIR}/zsh-defer"
    if [[ ! -d "$ZSH_DEFER" ]]; then
        git clone https://github.com/romkatv/zsh-defer.git \
            "$ZSH_DEFER"
    fi

    # zsh-users/zsh-completions
    local -r ZSH_COMPLETIONS="${ZSH_PLUGINS_LOCAL_DIR}/zsh-completions"
    if [[ ! -d "$ZSH_COMPLETIONS" ]]; then
        git clone https://github.com/zsh-users/zsh-completions.git \
            "$ZSH_COMPLETIONS"
    fi

    # zsh-users/zsh-autosuggestions
    local -r ZSH_AUTOSUGGESTIONS="${ZSH_PLUGINS_LOCAL_DIR}/zsh-autosuggestions"
    if [[ ! -d "$ZSH_AUTOSUGGESTIONS" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git \
            "$ZSH_AUTOSUGGESTIONS"
    fi

    # zsh-users/zsh-syntax-highlighting
    local -r ZSH_SYNTAX_HIGHLIGHTING="${ZSH_PLUGINS_LOCAL_DIR}/zsh-syntax-highlighting"
    if [[ ! -d "$ZSH_SYNTAX_HIGHLIGHTING" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
            "$ZSH_SYNTAX_HIGHLIGHTING"
    fi

    # zsh-users/zsh-history-substring-search
    local -r ZSH_HISTORY_SUBSTRING_SEARCH="${ZSH_PLUGINS_LOCAL_DIR}/zsh-history-substring-search"
    if [[ ! -d "$ZSH_HISTORY_SUBSTRING_SEARCH" ]]; then
        git clone https://github.com/zsh-users/zsh-history-substring-search.git \
            "$ZSH_HISTORY_SUBSTRING_SEARCH"
    fi

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
