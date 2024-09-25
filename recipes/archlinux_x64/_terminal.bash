#!/bin/bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

main() {
    log_debug "START: ${BASH_SOURCE}"


    sudo pacman -Syu
    yay -Syu

    # ======================================================
    # ======== zsh (& plugin-manager & plugins)            =
    # ======================================================

    # ======== zsh
    sudo pacman -S --needed zsh

    local -r ZDOTDIR="${HOME}/.config/zsh"
    local -r ZSH_COMPLETION_DIR="${ZDOTDIR}/completion"

    [ -L "${HOME}/.zshrc"  ] && unlink "${HOME}/.zshrc"
    [ -L "${HOME}/.zshenv" ] && unlink "${HOME}/.zshenv"
    [ -f "${HOME}/.zshrc"  ] && mv     "${HOME}/.zshrc"  "${HOME}/.zshrc.old"
    [ -f "${HOME}/.zshenv" ] && mv     "${HOME}/.zshenv" "${HOME}/.zshenv.old"
    link_file "${MYENV_ROOT}/config/home/.zshenv"     "${HOME}/.zshenv"
    link_dir  "${MYENV_ROOT}/config/home/.config/zsh" "$ZDOTDIR" # NOTE: the path is directory

    # ======== sheldon
    # sudo pacman -S --needed sheldon
    # TODO: sheldon config???????

    # ======== zsh-syntax-highlighting, zsh-autosuggestions, zsh-history-substring-search
    sudo pacman -S --needed zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search

    # ======== git-completion
    # Ref:
    #     https://github.com/git/git/blob/ed155187b429a2a6b6475efe1767053df37ccfe1/contrib/completion/git-completion.zsh
    #     [【初級者向け】ターミナル（zsh）にgitのブランチ名表示＆補完機能を公式ドキュメントをじっくり読み解いて実装 - Qiita]
    #         (https://qiita.com/yamaday0u/items/ee8acb35709bcc8c7fc7#tab%E8%A3%9C%E5%AE%8C%E6%A9%9F%E8%83%BD%E3%82%92%E5%AE%9F%E8%A3%85git-completion)
    # TODO: Is this working???
    if [ ! -f "${ZSH_COMPLETION_DIR}/_git" ] || [ ! -f "${ZSH_COMPLETION_DIR}/git-completion.bash" ]; then
        mkdir -p "${ZSH_COMPLETION_DIR}"
        curl -o  "${ZSH_COMPLETION_DIR}/_git"                https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
        curl -o  "${ZSH_COMPLETION_DIR}/git-completion.bash" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
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

    sudo pacman -S --needed alacritty
    link_file "${MYENV_ROOT}/config/home/.config/alacritty/alacritty.toml" "${HOME}/.config/alacritty/alacritty.toml"
    link_file "${MYENV_ROOT}/config/home/.config/alacritty/my-theme.toml"  "${HOME}/.config/alacritty/my-theme.toml"

    # ======================================================
    # ======== starship (& theme)                          =
    # ======================================================

    sudo pacman -S --needed starship
    link_file "${MYENV_ROOT}/config/home/.config/starship.toml" "${HOME}/.config/starship.toml"

    # ======================================================
    # ======== tmux (& plugin-manager & plugins)           =
    # ======================================================

    # ======== tmux
    sudo pacman -S --needed tmux
    link_file "${MYENV_ROOT}/config/home/.config/tmux/.tmux.conf" "${HOME}/.config/tmux/.tmux.conf"

    # ======== tpm
    # yay -S --needed tpm

    # ======== plugins
    # TODO:

    log_debug "END  : ${BASH_SOURCE}"
}

main
