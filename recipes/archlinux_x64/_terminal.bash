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

    remove_unused_config "${HOME}/.zshrc"
    remove_unused_config "${HOME}/.zshenv"
    link_file "${MYENV_ROOT}/config/home/.zshenv" "${HOME}/.zshenv"
    link_dir "${MYENV_ROOT}/config/home/.config/zsh" "$ZDOTDIR" # NOTE: the path is directory

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

    # Install powerlevel10k
    # Ref:
    #     https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#arch-linux
    #     https://aur.archlinux.org/packages/zsh-theme-powerlevel10k-git
    yay -S --needed --noconfirm zsh-theme-powerlevel10k-git

    # ======================================================
    # ======== zsh completions                             =
    # ======================================================

    local -r ZSH_COMPLETIONS_LOCAL_DIR="${ZDOTDIR}/completions.local"

    # ======== git
    # Ref:
    #     https://github.com/git/git/blob/ed155187b429a2a6b6475efe1767053df37ccfe1/contrib/completion/git-completion.zsh
    #     [【初級者向け】ターミナル（zsh）にgitのブランチ名表示＆補完機能を公式ドキュメントをじっくり読み解いて実装 - Qiita]
    #         (https://qiita.com/yamaday0u/items/ee8acb35709bcc8c7fc7#tab%E8%A3%9C%E5%AE%8C%E6%A9%9F%E8%83%BD%E3%82%92%E5%AE%9F%E8%A3%85git-completion)
    # TODO: Is this working???
    if [[ ! -f "${ZSH_COMPLETIONS_LOCAL_DIR}/_git" ]]; then
        curl -o "${ZSH_COMPLETIONS_LOCAL_DIR}/_git" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
    fi
    if [[ ! -f "${ZSH_COMPLETIONS_LOCAL_DIR}/git-completion.bash" ]]; then
        curl -o "${ZSH_COMPLETIONS_LOCAL_DIR}/git-completion.bash" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
    fi

    # ======== mise
    # Ref: https://mise.jdx.dev/cli/completion.html
    if [[ ! -f "${ZSH_COMPLETIONS_LOCAL_DIR}/_mise" ]]; then
        curl -o "${ZSH_COMPLETIONS_LOCAL_DIR}/_mise" https://raw.githubusercontent.com/jdx/mise/refs/heads/main/completions/_mise
    fi

    # ======================================================
    # ======== zsh keybindings                             =
    # ======================================================

    local -r ZSH_KEYBINDINGS_LOCAL_DIR="${ZDOTDIR}/keybindings.local"

    # ======== fzf
    if [[ ! -f "${ZSH_KEYBINDINGS_LOCAL_DIR}/key-bindings.zsh" ]]; then
        curl -o "${ZSH_KEYBINDINGS_LOCAL_DIR}/key-bindings.zsh" https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/shell/key-bindings.zsh
    fi

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
        clone_repo_shallow \
            https://github.com/romkatv/zsh-defer.git \
            "$ZSH_DEFER"
    fi

    # zsh-users/zsh-completions
    local -r ZSH_COMPLETIONS="${ZSH_PLUGINS_LOCAL_DIR}/zsh-completions"
    if [[ ! -d "$ZSH_COMPLETIONS" ]]; then
        clone_repo_shallow \
            https://github.com/zsh-users/zsh-completions.git \
            "$ZSH_COMPLETIONS"
    fi

    # zsh-users/zsh-autosuggestions
    local -r ZSH_AUTOSUGGESTIONS="${ZSH_PLUGINS_LOCAL_DIR}/zsh-autosuggestions"
    if [[ ! -d "$ZSH_AUTOSUGGESTIONS" ]]; then
        clone_repo_shallow \
            https://github.com/zsh-users/zsh-autosuggestions.git \
            "$ZSH_AUTOSUGGESTIONS"
    fi

    # zsh-users/zsh-syntax-highlighting
    local -r ZSH_SYNTAX_HIGHLIGHTING="${ZSH_PLUGINS_LOCAL_DIR}/zsh-syntax-highlighting"
    if [[ ! -d "$ZSH_SYNTAX_HIGHLIGHTING" ]]; then
        clone_repo_shallow \
            https://github.com/zsh-users/zsh-syntax-highlighting.git \
            "$ZSH_SYNTAX_HIGHLIGHTING"
    fi

    # zsh-users/zsh-history-substring-search
    local -r ZSH_HISTORY_SUBSTRING_SEARCH="${ZSH_PLUGINS_LOCAL_DIR}/zsh-history-substring-search"
    if [[ ! -d "$ZSH_HISTORY_SUBSTRING_SEARCH" ]]; then
        clone_repo_shallow \
            https://github.com/zsh-users/zsh-history-substring-search.git \
            "$ZSH_HISTORY_SUBSTRING_SEARCH"
    fi

    # ======================================================
    # ======== zsh misc                                    =
    # ======================================================

    # ======== compile
    # compile all *.zsh files under the path for performance
    find "$ZDOTDIR/" -name '*.zsh' -exec zsh -c 'zcompile "$0"' {} \;

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

    # ======== alacritty
    sudo pacman -S --needed --noconfirm alacritty
    link_file "${MYENV_ROOT}/config/home/.config/alacritty/alacritty.toml" "${HOME}/.config/alacritty/alacritty.toml"

    # ======== theme
    download_file \
        "https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/heads/main/extras/alacritty/tokyonight_night.toml" \
        "${HOME}/.config/alacritty/theme.local/tokyonight_night.toml"

    # ======================================================
    # ======== tmux (& plugin-manager & plugins)           =
    # ======================================================

    local -r TMUX_PLUGIN_INSTALL_PATH="${HOME}/.config/tmux/plugins"

    # ======== tmux
    sudo pacman -S --needed --noconfirm tmux
    remove_unused_config "${HOME}/.tmux.conf"
    link_file "${MYENV_ROOT}/config/home/.config/tmux/tmux.conf" "${HOME}/.config/tmux/tmux.conf"

    # ======== tpm (plugin manager)
    # Install tpm
    # Ref:
    #     https://github.com/tmux-plugins/tpm/blob/99469c4a9b1ccf77fade25842dc7bafbc8ce9946/docs/automatic_tpm_installation.md
    #         "tpm／docs／automatic_tpm_installation.md"
    #     https://github.com/tmux-plugins/tpm/blob/99469c4a9b1ccf77fade25842dc7bafbc8ce9946/docs/managing_plugins_via_cmd_line.md
    #         "tpm／docs／managing_plugins_via_cmd_line.md"
    #     https://github.com/tmux-plugins/tpm/blob/99469c4a9b1ccf77fade25842dc7bafbc8ce9946/docs/changing_plugins_install_dir.md
    #         "tpm/docs/changing_plugins_install_dir.md"
    #
    if [[ ! -d "${TMUX_PLUGIN_INSTALL_PATH}/tpm" ]]; then
        clone_repo_shallow "https://github.com/tmux-plugins/tpm" "${TMUX_PLUGIN_INSTALL_PATH}/tpm"
    fi

    # ======== plugins
    # Install plugins with tpm via CLI
    # Ref:
    #       https://github.com/tmux-plugins/tpm/blob/99469c4a9b1ccf77fade25842dc7bafbc8ce9946/docs/managing_plugins_via_cmd_line.md
    #           "tpm/docs/managing_plugins_via_cmd_line.md"
    #
    "${TMUX_PLUGIN_INSTALL_PATH}/tpm/bin/install_plugins"

    # update plugins with tpm via CLI
    "${TMUX_PLUGIN_INSTALL_PATH}/tpm/bin/update_plugins" all

    log_debug "END  : ${BASH_SOURCE}"
}

main
