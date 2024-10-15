#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_base() {
    _setup_font
    _setup_input_method
    _setup_shell
    _setup_terminal
    _setup_multiplexer
    _setup_devel
    _setup_editor
    _setup_browser
}

_setup_font() {
    log_debug "START: ${BASH_SOURCE}"

    yay -Syu --noconfirm

    # ======================================================
    # ======== normal font                                 =
    # ======================================================

    # TODO: Install normal font (何にするかまだ決めてない)
    # yay -S --needed --noconfirm noto-fonts-cjk
    yay -S --needed --noconfirm noto-fonts-cjk

    # ======================================================
    # ======== mono font                                   =
    # ======================================================

    # Ref:
    #     https://github.com/yuru7/udev-gothic
    #     https://aur.archlinux.org/packages/ttf-udev-gothic
    yay -S --needed --noconfirm ttf-udev-gothic

    # ======================================================
    # ======== extra font                                  =
    # ======================================================

    yay -S --needed --noconfirm noto-fonts-emoji

    # ======================================================
    # ======== ?                                           =
    # ======================================================

    # システムフォントの設定？
    # TODO: Link config files?
    # $XDG_CONFIG_HOME/fontconfig/fonts.conf
    # Ref: [Arch Linux インストール (7) - 各設定](https://aznote.jakou.com/archlinux/install7.html)

    # フォントキャッシュの更新（不要かも）
    fc-cache -v

    log_debug "END  : ${BASH_SOURCE}"
}

_setup_input_method() {
    # Fcitx + Mozc
    # 日本語入力環境を整える
    # sudo pacman -S --needed --noconfirm fcitx-mozc
    # TODO:
    :
}

_setup_shell() {
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

    local -r ZSH_PLUGINS_LOCAL_DIR="${ZDOTDIR}/plugins.local"

    # ======== zsh-defer
    # Ref: https://github.com/romkatv/zsh-defer/blob/master/README.md#installation
    clone_repo_shallow \
        https://github.com/romkatv/zsh-defer.git \
        "${ZSH_PLUGINS_LOCAL_DIR}/zsh-defer"

    # zsh-users/zsh-completions
    clone_repo_shallow \
        https://github.com/zsh-users/zsh-completions.git \
        "${ZSH_PLUGINS_LOCAL_DIR}/zsh-completions"

    # zsh-users/zsh-autosuggestions
    clone_repo_shallow \
        https://github.com/zsh-users/zsh-autosuggestions.git \
        "${ZSH_PLUGINS_LOCAL_DIR}/zsh-autosuggestions"

    # zsh-users/zsh-syntax-highlighting
    clone_repo_shallow \
        https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "${ZSH_PLUGINS_LOCAL_DIR}/zsh-syntax-highlighting"

    # zsh-users/zsh-history-substring-search
    clone_repo_shallow \
        https://github.com/zsh-users/zsh-history-substring-search.git \
        "${ZSH_PLUGINS_LOCAL_DIR}/zsh-history-substring-search"

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
}

_setup_terminal() {
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

}

_setup_multiplexer() {
    # ======================================================
    # ======== tmux (& plugin-manager & plugins)           =
    # ======================================================

    # ======== tmux
    sudo pacman -S --needed --noconfirm tmux
    remove_unused_config "${HOME}/.tmux.conf"
    link_file "${MYENV_ROOT}/config/home/.config/tmux/tmux.conf" "${HOME}/.config/tmux/tmux.conf"

    # ======== themes
    local -r TMUX_THEME_LOCAL_PATH="${HOME}/.config/tmux/themes.local"

    download_file \
        "https://raw.githubusercontent.com/nordtheme/tmux/refs/heads/develop/nord.tmux" \
        "${TMUX_THEME_LOCAL_PATH}/nord.tmux"

    download_file \
        "https://raw.githubusercontent.com/EdenEast/nightfox.nvim/refs/heads/main/extra/nordfox/nordfox.tmux" \
        "${TMUX_THEME_LOCAL_PATH}/nordfox.tmux"

    download_file \
        "https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/heads/main/extras/tmux/tokyonight_night.tmux" \
        "${TMUX_THEME_LOCAL_PATH}/tokyonight_night.tmux"

    download_file \
        "https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/heads/main/extras/tmux/tokyonight_storm.tmux" \
        "${TMUX_THEME_LOCAL_PATH}/tokyonight_storm.tmux"

    # # ======== tpm (plugin manager)
    # # Install tpm
    # # Ref:
    # #     https://github.com/tmux-plugins/tpm/blob/99469c4a9b1ccf77fade25842dc7bafbc8ce9946/docs/automatic_tpm_installation.md
    # #         "tpm／docs／automatic_tpm_installation.md"
    # #     https://github.com/tmux-plugins/tpm/blob/99469c4a9b1ccf77fade25842dc7bafbc8ce9946/docs/managing_plugins_via_cmd_line.md
    # #         "tpm／docs／managing_plugins_via_cmd_line.md"
    # #     https://github.com/tmux-plugins/tpm/blob/99469c4a9b1ccf77fade25842dc7bafbc8ce9946/docs/changing_plugins_install_dir.md
    # #         "tpm/docs/changing_plugins_install_dir.md"
    # #
    # local -r TMUX_PLUGIN_INSTALL_PATH="${HOME}/.config/tmux/plugins"
    # clone_repo_shallow "https://github.com/tmux-plugins/tpm" "${TMUX_PLUGIN_INSTALL_PATH}/tpm"
    #
    # # ======== plugins
    # # Install plugins with tpm via CLI
    # # Ref:
    # #       https://github.com/tmux-plugins/tpm/blob/99469c4a9b1ccf77fade25842dc7bafbc8ce9946/docs/managing_plugins_via_cmd_line.md
    # #           "tpm/docs/managing_plugins_via_cmd_line.md"
    # #
    # "${TMUX_PLUGIN_INSTALL_PATH}/tpm/bin/install_plugins"
    #
    # # update plugins with tpm via CLI
    # "${TMUX_PLUGIN_INSTALL_PATH}/tpm/bin/update_plugins" all

    log_debug "END  : ${BASH_SOURCE}"
}

_setup_devel() {
    log_debug "START: ${BASH_SOURCE}"

    sudo pacman -Syu --noconfirm

    # ======================================================
    # ======== many cli tools                              =
    # ======================================================

    sudo pacman -S --needed --noconfirm \
        ghq fzf tree xclip unzip \
        ripgrep bat eza fd git-delta bottom \
        shellcheck shfmt

    # ======== proper7y
    if ! check_if_command_exists "proper7y"; then
        local -r dest_dir="${HOME}/bin"

        cd "$(mktemp -d)"
        curl -O https://raw.githubusercontent.com/rnazmo/proper7y/main/install.bash
        chmod +x ./install.bash
        ./install.bash "$dest_dir"
    fi

    # ======== lazygit
    sudo pacman -S --needed --noconfirm lazygit
    remove_unused_config "${HOME}/.config/lazygit/config.yml"
    link_file "${MYENV_ROOT}/config/home/.config/lazygit/config.yml" "${HOME}/.config/lazygit/config.yml"

    # ======== fastfetch
    sudo pacman -S --needed --noconfirm fastfetch
    remove_unused_config "${HOME}/.config/fastfetch/config.jsonc"
    link_file "${MYENV_ROOT}/config/home/.config/fastfetch/config.jsonc" "${HOME}/.config/fastfetch/config.jsonc"

    log_debug "END  : ${BASH_SOURCE}"
}

_setup_editor() {
    log_debug "START: ${BASH_SOURCE}"

    sudo pacman -Syu --noconfirm
    yay -Syu --noconfirm

    # ======================================================
    # ======== neovim (& plugin-manager & plugins)         =
    # ======================================================

    # ======== neovim
    sudo pacman -S --needed --noconfirm neovim
    link_dir "${MYENV_ROOT}/config/home/.config/nvim" "${HOME}/.config/nvim" # NOTE: dir

    # Sync (= install & cleanup & update) plugins
    nvim --headless "+Lazy! sync" +qa

    # # ======================================================
    # # ======== vscode (& extensions)                       =
    # # ======================================================
    #
    # yay -S --needed --noconfirm visual-studio-code-bin
    # link_file "${MYENV_ROOT}/config/home/.config/Code/User/settings.json" "${HOME}/.config/Code/User/settings.json"
    # link_file "${MYENV_ROOT}/config/home/.config/Code/User/keybindings.json" "${HOME}/.config/Code/User/keybindings.json"
    # link_dir "${MYENV_ROOT}/config/home/.config/Code/User/snippets" "${HOME}/.config/Code/User/snippets" # NOTE: dir
    #
    # # Install extensions
    # EXTENSIONS=(
    #     # TODO: Use "VSCode Neovim"
    #     "golang.Go"
    #     # "ms-azuretools.vscode-docker"
    #     # "ms-vscode-remote.remote-containers"
    #     # "GitHub.copilot"
    #     # "Codeium.codeium"
    #     "editorconfig.editorconfig"
    #     # "esbenp.prettier-vscode"
    #     # "dbaeumer.vscode-eslint"
    #     # "streetsidesoftware.code-spell-checker"
    #     # "eamodio.gitlens"
    #     # "donjayamanne.githistory"
    # )
    # for EXT in "${EXTENSIONS[@]}"; do
    #     code --install-extension "$EXT"
    # done

    # ======================================================
    # ======== obsidian                                    =
    # ======================================================

    # sudo pacman -S --needed obsidian

    # ======================================================
    # ======== misc                                        =
    # ======================================================

    # Editorconfig
    link_file "${MYENV_ROOT}/config/home/.editorconfig" "${HOME}/.editorconfig"

    log_debug "END  : ${BASH_SOURCE}"
}

_setup_browser() {
    log_debug "START: ${BASH_SOURCE}"

    sudo pacman -Syu --noconfirm
    yay -Syu --noconfirm

    # ======================================================
    # ======== Chromium                                    =
    # ======================================================

    sudo pacman -S --needed --noconfirm chromium

    # ======== extensions
    # TODO:
    # ======== bookmarklets
    # TODO: HTML file??

    # ======================================================
    # ======== Chrome                                      =
    # ======================================================

    yay -S --needed --noconfirm google-chrome

    # ======== extensions
    # TODO:
    # ======== bookmarklets
    # TODO: HTML file??

    # ======================================================
    # ======== FireFox                                     =
    # ======================================================

    sudo pacman -S --needed --noconfirm firefox

    # ======== extensions
    sudo pacman -S --needed --noconfirm firefox-ublock-origin
    # TODO:
    # ======== bookmarklets
    # TODO: HTML file??

    log_debug "END  : ${BASH_SOURCE}"
}
