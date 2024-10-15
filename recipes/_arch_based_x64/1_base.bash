#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

# ======================================================
# ======================================================
# ======== Pre                                         =
# ======================================================
# ======================================================

pre_setup_base() {
    _refresh_packages() {
        sudo pacman -Syu --noconfirm
        check_if_command_exists "yay" && yay -Syu --noconfirm
    }

    _refresh_packages

    unset -f _refresh_packages
}
readonly -f pre_setup_base

# ======================================================
# ======================================================
# ======== Font                                        =
# ======================================================
# ======================================================

setup_font() {
    # ======== normal font
    _install_noto_cjk

    # ======== mono font
    _install_udev_gothic

    # ======== extra font
    _install_emoji

    # ======== ?
    # システムフォントの設定？
    # TODO: Link config files?
    # $XDG_CONFIG_HOME/fontconfig/fonts.conf
    # Ref: [Arch Linux インストール (7) - 各設定](https://aznote.jakou.com/archlinux/install7.html)

    _post_setup_font
}
readonly -f setup_font

_install_noto_cjk() {
    # TODO: Install normal font (何にするかまだ決めてない)
    # yay -S --needed --noconfirm noto-fonts-cjk
    yay -S --needed --noconfirm noto-fonts-cjk
}
readonly -f _install_noto_cjk

_install_udev_gothic() {
    # Ref:
    #     https://github.com/yuru7/udev-gothic
    #     https://aur.archlinux.org/packages/ttf-udev-gothic
    yay -S --needed --noconfirm ttf-udev-gothic
}
readonly -f _install_udev_gothic

_install_emoji() {
    yay -S --needed --noconfirm noto-fonts-emoji
}
readonly -f _install_emoji

_post_setup_font() {
    # フォントキャッシュの更新（不要かも）
    fc-cache -v
}
readonly -f _post_setup_font

# ======================================================
# ======================================================
# ======== IME (Input Method Engine)                   =
# ======================================================
# ======================================================

setup_ime() {
    # Fcitx + Mozc
    # 日本語入力環境を整える
    # sudo pacman -S --needed --noconfirm fcitx-mozc
    # TODO:
    :
}
readonly -f setup_ime

# ======================================================
# ======================================================
# ======== Util                                        =
# ======================================================
# ======================================================

setup_util() {
    _install_many_util_clis
    _setup_fastfetch
    _install_proper7y
}
readonly -f setup_util

_install_many_util_clis() {
    sudo pacman -S --needed --noconfirm \
        ghq fzf tree xclip unzip \
        ripgrep bat eza fd bottom
}
readonly -f _install_many_util_clis

_setup_fastfetch() {
    sudo pacman -S --needed --noconfirm fastfetch
    remove_unused_config "${HOME}/.config/fastfetch/config.jsonc"
    link_file "${MYENV_ROOT}/config/home/.config/fastfetch/config.jsonc" "${HOME}/.config/fastfetch/config.jsonc"
}
readonly -f _setup_fastfetch

_install_proper7y() {
    if check_if_command_exists "proper7y"; then
        return 0
    fi

    local -r dest_dir="${HOME}/bin"
    cd "$(mktemp -d)"
    curl -O https://raw.githubusercontent.com/rnazmo/proper7y/main/install.bash
    chmod +x ./install.bash
    ./install.bash "$dest_dir"
}
readonly -f _install_proper7y

# ======================================================
# ======================================================
# ======== Shell                                       =
# ======================================================
# ======================================================

setup_shell() {
    _setup_zsh
    _setup_default_shell
}
readonly -f setup_shell

_setup_zsh() {
    __install_zsh
    __setup_zsh_config
    __setup_zsh_completions
    __setup_zsh_keybindings
    __setup_zsh_theme
    __setup_zsh_plugins
    __post_setup_zsh
}
readonly -f _setup_zsh

_setup_default_shell() {
    if check_if_command_exists "zsh" && [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)"
        log_info "Changed your default login shell to Zsh"
        # NOTE: Then, you must re-login (or reboot the machine) to reflect this change.
    fi
}
readonly -f _setup_default_shell

__install_zsh() {
    sudo pacman -S --needed --noconfirm zsh
}
readonly -f __install_zsh

__setup_zsh_config() {
    local -r ZDOTDIR="${HOME}/.config/zsh"
    remove_unused_config "${HOME}/.zshrc"
    remove_unused_config "${HOME}/.zshenv"
    link_file "${MYENV_ROOT}/config/home/.zshenv" "${HOME}/.zshenv"
    link_dir "${MYENV_ROOT}/config/home/.config/zsh" "$ZDOTDIR" # NOTE: the path is directory
}
readonly -f __setup_zsh_config

__setup_zsh_completions() {
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
}
readonly -f __setup_zsh_completions

__setup_zsh_keybindings() {
    local -r ZSH_KEYBINDINGS_LOCAL_DIR="${ZDOTDIR}/keybindings.local"

    # ======== fzf
    if [[ ! -f "${ZSH_KEYBINDINGS_LOCAL_DIR}/key-bindings.zsh" ]]; then
        curl -o "${ZSH_KEYBINDINGS_LOCAL_DIR}/key-bindings.zsh" https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/shell/key-bindings.zsh
    fi
}
readonly -f __setup_zsh_keybindings

__setup_zsh_theme() {
    ___install_powerlevel10k
}
readonly -f __setup_zsh_theme

__setup_zsh_plugins() {
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
}
readonly -f __setup_zsh_plugins

__post_setup_zsh() {
    # ======== compile
    # compile all *.zsh files under the path for performance
    find "$ZDOTDIR/" -name '*.zsh' -exec zsh -c 'zcompile "$0"' {} \;
}
readonly -f __post_setup_zsh

___install_powerlevel10k() {
    # Install powerlevel10k
    # Ref:
    #     https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#arch-linux
    #     https://aur.archlinux.org/packages/zsh-theme-powerlevel10k-git
    yay -S --needed --noconfirm zsh-theme-powerlevel10k-git
}
readonly -f ___install_powerlevel10k

# ======================================================
# ======================================================
# ======== Shell                                       =
# ======================================================
# ======================================================

setup_terminal() {
    _setup_alacritty
}
readonly -f setup_terminal

_setup_alacritty() {
    __install_alacritty
    __setup_alacritty_config
    __setup_alacritty_theme
}
readonly -f _setup_alacritty

__install_alacritty() {
    sudo pacman -S --needed --noconfirm alacritty
}
readonly -f __install_alacritty

__setup_alacritty_config() {
    link_file "${MYENV_ROOT}/config/home/.config/alacritty/alacritty.toml" "${HOME}/.config/alacritty/alacritty.toml"

}
readonly -f __setup_alacritty_config

__setup_alacritty_theme() {
    download_file \
        "https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/heads/main/extras/alacritty/tokyonight_night.toml" \
        "${HOME}/.config/alacritty/theme.local/tokyonight_night.toml"
}
readonly -f __setup_alacritty_theme

# ======================================================
# ======================================================
# ======== Multiplexer                                 =
# ======================================================
# ======================================================

setup_multiplexer() {
    _setup_tmux
}
readonly -f setup_multiplexer

_setup_tmux() {
    __install_tmux
    __setup_tmux_config
    __setup_tmux_theme
    # __install_tpm
    # __refresh_tmux_plugins
}
readonly -f _setup_tmux

__install_tmux() {
    sudo pacman -S --needed --noconfirm tmux
}
readonly -f __install_tmux

__setup_tmux_config() {
    remove_unused_config "${HOME}/.tmux.conf"
    link_file "${MYENV_ROOT}/config/home/.config/tmux/tmux.conf" "${HOME}/.config/tmux/tmux.conf"
}
readonly -f __setup_tmux_config

__setup_tmux_theme() {
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
}
readonly -f __setup_tmux_theme

__install_tpm() {
    # Install tpm (plugin manager)
    # Ref:
    #     https://github.com/tmux-plugins/tpm/blob/99469c4a9b1ccf77fade25842dc7bafbc8ce9946/docs/automatic_tpm_installation.md
    #         "tpm／docs／automatic_tpm_installation.md"
    #     https://github.com/tmux-plugins/tpm/blob/99469c4a9b1ccf77fade25842dc7bafbc8ce9946/docs/managing_plugins_via_cmd_line.md
    #         "tpm／docs／managing_plugins_via_cmd_line.md"
    #     https://github.com/tmux-plugins/tpm/blob/99469c4a9b1ccf77fade25842dc7bafbc8ce9946/docs/changing_plugins_install_dir.md
    #         "tpm/docs/changing_plugins_install_dir.md"
    #
    local -r TMUX_PLUGIN_INSTALL_PATH="${HOME}/.config/tmux/plugins"
    clone_repo_shallow "https://github.com/tmux-plugins/tpm" "${TMUX_PLUGIN_INSTALL_PATH}/tpm"
}
readonly -f __install_tpm

__refresh_tmux_plugins() {
    # Install plugins with tpm via CLI
    # Ref:
    #       https://github.com/tmux-plugins/tpm/blob/99469c4a9b1ccf77fade25842dc7bafbc8ce9946/docs/managing_plugins_via_cmd_line.md
    #           "tpm/docs/managing_plugins_via_cmd_line.md"
    #
    "${TMUX_PLUGIN_INSTALL_PATH}/tpm/bin/install_plugins"

    # update plugins with tpm via CLI
    "${TMUX_PLUGIN_INSTALL_PATH}/tpm/bin/update_plugins" all
}
readonly -f __refresh_tmux_plugins

# ======================================================
# ======================================================
# ======== Devel                                       =
# ======================================================
# ======================================================

setup_devel() {
    _install_many_devel_tools
    _setup_lazygit
}
readonly -f setup_devel

_install_many_devel_tools() {
    local -r PKGS=(
        "git-delta"         # better git diff
        "shellcheck"        # bash linter
        "shfmt"             # bash formatter
        "selene"            # lua linter
        "stylua"            # lua formatter
        "staticcheck"       # golang linter
        "eslint_d"          # js/ts/jsx/tsx/json/yaml linter
        "prettier"          # js/ts/jsx/css/scss/html/markdown/json/yaml linter
        "stylelint"         # css linter
        "markdownlint-cli2" # markdown linter
        "actionlint"        # github actions linter
        "typos"             # spell checker
        # "cspell"            # spell checker
        # "editorconfig-checker"
        # "editorconfig-checker"
    )
    for PKG in "${PKGS[@]}"; do
        sudo pacman -S --needed --noconfirm "$PKG"
    done

    # TODO: Instll goimports (go formatter) via go install
    # TODO: Install hadolint-bin (dockerfile linter) via aur
}
readonly -f _install_many_devel_tools

_setup_lazygit() {
    __install_lazygit
    __setup_lazygit_config
}
readonly -f _setup_lazygit

__install_lazygit() {
    sudo pacman -S --needed --noconfirm lazygit
}
readonly -f __install_lazygit

__setup_lazygit_config() {
    remove_unused_config "${HOME}/.config/lazygit/config.yml"
    link_file "${MYENV_ROOT}/config/home/.config/lazygit/config.yml" "${HOME}/.config/lazygit/config.yml"
}
readonly -f __setup_lazygit_config

# ======================================================
# ======================================================
# ======== Editor                                      =
# ======================================================
# ======================================================

setup_editor() {
    _setup_neovim
    _setup_editorconfig
}
readonly -f setup_editor

_setup_neovim() {
    __install_neovim
    __setup_neovim_config
    __refresh_neovim_plugins
}
readonly -f _setup_neovim

_setup_editorconfig() {
    link_file "${MYENV_ROOT}/config/home/.editorconfig" "${HOME}/.editorconfig"
}
readonly -f _setup_editorconfig

__install_neovim() {
    sudo pacman -S --needed --noconfirm neovim
}
readonly -f __install_neovim

__setup_neovim_config() {
    link_dir "${MYENV_ROOT}/config/home/.config/nvim" "${HOME}/.config/nvim" # NOTE: dir
}
readonly -f __setup_neovim_config

__refresh_neovim_plugins() {
    # Sync (= install & cleanup & update) plugins
    nvim --headless "+Lazy! sync" +qa
}
readonly -f __refresh_neovim_plugins

# ======================================================
# ======================================================
# ======== Browser                                     =
# ======================================================
# ======================================================

setup_browser() {
    _setup_chromium
    _setup_chrome
    _setup_firefox
}
readonly -f setup_browser

_setup_chromium() {
    __install_chromium
    __setup_chromium_extensions
    __setup_chromium_bookmarklet
}
readonly -f _setup_chromium

_setup_chrome() {
    __install_chrome
    __setup_chrome_extensions
    __setup_chrome_bookmarklet
}
readonly -f _setup_chrome

_setup_firefox() {
    __install_firefox
    __setup_firefox_extensions
    __setup_firefox_bookmarklet
}
readonly -f _setup_firefox

__install_chromium() {
    sudo pacman -S --needed --noconfirm chromium
}
readonly -f __install_chromium

__setup_chromium_extensions() {
    # TODO:
    :
}
readonly -f __setup_chromium_extensions

__setup_chromium_bookmarklet() {
    # TODO:
    # TODO: HTML file??
    :
}
readonly -f __setup_chromium_bookmarklet

__install_chrome() {
    yay -S --needed --noconfirm google-chrome
}
readonly -f __install_chrome

__setup_chrome_extensions() {
    # TODO:
    :
}
readonly -f __setup_chrome_extensions

__setup_chrome_bookmarklet() {
    # TODO:
    # TODO: HTML file??
    :
}
readonly -f __setup_chrome_bookmarklet

__install_firefox() {
    sudo pacman -S --needed --noconfirm firefox
}
readonly -f __install_firefox

__setup_firefox_extensions() {
    # TODO:
    :
    sudo pacman -S --needed --noconfirm firefox-ublock-origin
}
readonly -f __setup_firefox_extensions

__setup_firefox_bookmarklet() {
    # TODO:
    # TODO: HTML file??
    :
}
readonly -f __setup_firefox_bookmarklet

# ======================================================
# ======================================================
# ======== Post                                        =
# ======================================================
# ======================================================

post_setup_base() {
    :
}
readonly -f post_setup_base
