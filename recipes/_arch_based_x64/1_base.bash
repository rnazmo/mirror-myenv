#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

# ======================================================
# ======================================================
# ======== Variables                                   =
# ======================================================
# ======================================================

ZDOTDIR="${HOME}/.config/zsh"

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
    # Fcitx5 (or Fcitx4) + Mozc to Japanese Input
    # NOTE: my current desktop env is Xfce, X11
    # Fcitx5:
    #     Ref:
    #         https://fcitx-im.org/wiki/Fcitx_5
    #         https://fcitx-im.org/wiki/Install_Fcitx_5
    #         https://fcitx-im.org/wiki/Setup_Fcitx_5
    #         https://fcitx-im.org/wiki/Input_method_engines
    #         https://wiki.archlinux.jp/index.php/Fcitx5
    #         https://wiki.archlinux.org/title/Fcitx5
    #         https://archlinux.org/packages/extra/x86_64/fcitx5-configtool/
    #         https://archlinux.org/packages/extra/x86_64/fcitx5-mozc/
    #         https://aur.archlinux.org/pkgbase/manjaro-asian-input-support
    #         https://aur.archlinux.org/packages/fcitx-input-support
    #         https://aur.archlinux.org/packages/fcitx5-input-support
    #         https://gitlab.manjaro.org/packages/extra/manjaro-asian-input-support
    #     See also:
    #         https://github.com/fcitx/fcitx5
    #         https://github.com/google/mozc
    # Fcitx4:
    #     Ref:
    #         https://wiki.archlinux.org/title/Fcitx
    #         https://wiki.archlinux.jp/index.php/Fcitx
    #         https://github.com/fcitx/fcitx
    #         https://fcitx-im.org/wiki/Fcitx
    #     NOTE: fcitx (= fcitx4) is under maintainence now
    #     TODO: Migrate to fcitx5
    # NOTE:
    #     For manjaro:
    #         If "manjaro-asian-input-support-fcitx" or "manjaro-asian-input-support-fcitx5"
    #         package is installed, remove it avoid conflict.

    # NOTE: Choose fcitx5 *or* fcitx4
    _setup_fcitx5_mozc
    # _setup_fcitx4_mozc
}
readonly -f setup_ime

_setup_fcitx5_mozc() {
    __install_fcitx5_mozc
    __setup_fcitx5_config
}
readonly -f _setup_fcitx5_mozc

_setup_fcitx4_mozc() {
    __install_fcitx4_mozc
    __setup_fcitx4_config
}
readonly -f _setup_fcitx4_mozc

__install_fcitx5_mozc() {
    # Uninstall fcitx to avoid conflict
    local PKGS=("fcitx-mozc" "fcitx-configtool" "fcitx-qt5" "fcitx")
    for PKG in "${PKGS[@]}"; do
        if pacman -Qi "$PKG" &>/dev/null; then
            sudo pacman -Rns --noconfirm "$PKG"
        fi
    done
    unset PKGS

    # Install fcitx5 related packages
    # NOTE: The "fcitx5-im" include:
    #    1) fcitx5  2) fcitx5-configtool  3) fcitx5-gtk  4) fcitx5-qt
    sudo pacman -S --needed --noconfirm "fcitx5-mozc" "fcitx5-im"
}
readonly -f __install_fcitx5_mozc

__setup_fcitx5_config() {
    remove_unused_config "${HOME}/.config/fcitx5/config"
    remove_unused_config "${HOME}/.config/fcitx5/profile"
    link_file "${MYENV_ROOT}/config/home/.config/fcitx5/config" "${HOME}/.config/fcitx5/config"
    link_file "${MYENV_ROOT}/config/home/.config/fcitx5/profile" "${HOME}/.config/fcitx5/profile"
    remove_unused_config "${HOME}/.config/fcitx5/conf/xim.conf"
    remove_unused_config "${HOME}/.config/fcitx5/conf/mozc.conf"
    link_file "${MYENV_ROOT}/config/home/.config/fcitx5/conf/xim.conf" "${HOME}/.config/fcitx5/conf/xim.conf"
    link_file "${MYENV_ROOT}/config/home/.config/fcitx5/conf/mozc.conf" "${HOME}/.config/fcitx5/conf/mozc.conf"
    remove_file_as_root "/etc/profile.d/fcitx.sh"
    copy_file_as_root "${MYENV_ROOT}/config/etc/profile.d/fcitx.sh" "/etc/profile.d/fcitx.sh"
}
readonly -f __setup_fcitx5_config

__install_fcitx4_mozc() {
    # Uninstall fcitx5 to avoid conflict
    local PKGS=("fcitx5-mozc" "fcitx5-im")
    for PKG in "${PKGS[@]}"; do
        if pacman -Qi "$PKG" &>/dev/null; then
            sudo pacman -Rns --noconfirm "$PKG"
        fi
    done
    unset PKGS

    # Install fcitx related packages
    sudo pacman -S --needed --noconfirm "fcitx-mozc" "fcitx-qt5" "fcitx-configtool"
}
readonly -f __install_fcitx4_mozc

__setup_fcitx4_config() {
    remove_unused_config "${HOME}/.config/fcitx/config"
    remove_unused_config "${HOME}/.config/fcitx/profile"
    link_file "${MYENV_ROOT}/config/home/.config/fcitx/config" "${HOME}/.config/fcitx/config"
    link_file "${MYENV_ROOT}/config/home/.config/fcitx/profile" "${HOME}/.config/fcitx/profile"
    remove_unused_config "${HOME}/.config/fcitx/conf/fcitx-xim.config"
    link_file "${MYENV_ROOT}/config/home/.config/fcitx/conf/fcitx-xim.config" "${HOME}/.config/fcitx/conf/fcitx-xim.config"
    remove_file_as_root "/etc/profile.d/fcitx.sh"
    copy_file_as_root "${MYENV_ROOT}/config/etc/profile.d/fcitx.sh" "/etc/profile.d/fcitx.sh"
}
readonly -f __setup_fcitx4_config

# ======================================================
# ======================================================
# ======== Util                                        =
# ======================================================
# ======================================================

setup_util() {
    _install_many_util_clis
    _setup_yazi       # cli file manager
    _setup_fastfetch  # display system info
    _install_proper7y # display system info
}
readonly -f setup_util

_install_many_util_clis() {
    local PKGS=(
        "tree"    # tree command
        "xclip"   # clipboard util
        "unzip"   # zip util
        "ghq"     # repository manager
        "fzf"     # fazzy finder
        "zoxide"  # better cd
        "eza"     # better ls
        "ripgrep" # better grep
        "bat"     # better cat
        "fd"      # better find
        "bottom"  # system monitor
        "jq"      # json util
    )
    for PKG in "${PKGS[@]}"; do
        sudo pacman -S --needed --noconfirm "$PKG"
    done
    unset PKGS
}
readonly -f _install_many_util_clis

_setup_fastfetch() {
    sudo pacman -S --needed --noconfirm fastfetch
    remove_unused_config "${HOME}/.config/fastfetch/config.jsonc"
    link_file "${MYENV_ROOT}/config/home/.config/fastfetch/config.jsonc" "${HOME}/.config/fastfetch/config.jsonc"
}
readonly -f _setup_fastfetch

_setup_yazi() {
    sudo pacman -S --needed --noconfirm yazi
    remove_unused_config "${HOME}/.config/yazi/yazi.toml"
    link_file "${MYENV_ROOT}/config/home/.config/yazi/yazi.toml" "${HOME}/.config/yazi/yazi.toml"
}
readonly -f _setup_yazi

_install_proper7y() {
    if check_if_command_exists "proper7y"; then
        return 0
    fi

    local -r ORIGINAL_DIR="$(pwd)"
    cd "$(mktemp -d)"

    local -r DEST_DIR="${HOME}/.local/bin"
    curl -O https://raw.githubusercontent.com/rnazmo/proper7y/main/install.bash
    chmod +x ./install.bash
    ./install.bash "$DEST_DIR"

    cd "$ORIGINAL_DIR"
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
    remove_unused_config "${HOME}/.zshrc"
    remove_unused_config "${HOME}/.zshenv"
    link_file "${MYENV_ROOT}/config/home/.zshenv" "${HOME}/.zshenv"
    link_file "${MYENV_ROOT}/config/home/.config/zsh/.zshrc" "${ZDOTDIR}/.zshrc"
    link_dir "${MYENV_ROOT}/config/home/.config/zsh/zshrc.d" "${ZDOTDIR}/zshrc.d" # NOTE: the path is directory
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
        download_file \
            "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh" \
            "${ZSH_COMPLETIONS_LOCAL_DIR}/_git"
    fi
    if [[ ! -f "${ZSH_COMPLETIONS_LOCAL_DIR}/git-completion.bash" ]]; then
        download_file \
            "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash" \
            "${ZSH_COMPLETIONS_LOCAL_DIR}/git-completion.bash"
    fi

    # ======== mise
    # Ref: https://mise.jdx.dev/cli/completion.html
    if [[ ! -f "${ZSH_COMPLETIONS_LOCAL_DIR}/_mise" ]]; then
        download_file \
            "https://raw.githubusercontent.com/jdx/mise/refs/heads/main/completions/_mise" \
            "${ZSH_COMPLETIONS_LOCAL_DIR}/_mise"
    fi
}
readonly -f __setup_zsh_completions

__setup_zsh_keybindings() {
    local -r ZSH_KEYBINDINGS_LOCAL_DIR="${ZDOTDIR}/keybindings.local"

    # ======== fzf
    if [[ ! -f "${ZSH_KEYBINDINGS_LOCAL_DIR}/fzf.zsh" ]]; then
        download_file \
            "https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/shell/key-bindings.zsh" \
            "${ZSH_KEYBINDINGS_LOCAL_DIR}/fzf.zsh"
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
    log_debug "START /recipes/_arch_based_x64/1_base.bash > ___install_powerlevel10k"
    # Install powerlevel10k
    # Ref:
    #     https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#arch-linux
    #     https://aur.archlinux.org/packages/zsh-theme-powerlevel10k-git

    # Skip if the package is already installed
    if pacman -Qi zsh-theme-powerlevel10k-git &>/dev/null; then
        log_info "powerlevel10k is already installed. Skipping."
        return 0
    fi

    yay -S --needed --noconfirm zsh-theme-powerlevel10k-git
    log_debug "END /recipes/_arch_based_x64/1_base.bash > ___install_powerlevel10k"
}
readonly -f ___install_powerlevel10k

# ======================================================
# ======================================================
# ======== Shell                                       =
# ======================================================
# ======================================================

setup_terminal() {
    _setup_alacritty
    _setup_wezterm
}
readonly -f setup_terminal

_setup_alacritty() {
    __install_alacritty
    __setup_alacritty_config
    __setup_alacritty_theme
}
readonly -f _setup_alacritty

_setup_wezterm() {
    __install_wezterm
    ___setup_wezterm_config
}
readonly -f _setup_wezterm

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

__install_wezterm() {
    sudo pacman -S --needed --noconfirm wezterm
}
readonly -f __install_wezterm

___setup_wezterm_config() {
    link_file "${MYENV_ROOT}/config/home/.config/wezterm/wezterm.lua" "${HOME}/.config/wezterm/wezterm.lua"
}

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
    local PKGS=(
        "shellcheck"  # bash linter
        "shfmt"       # bash formatter
        "selene"      # lua linter
        "stylua"      # lua formatter
        "staticcheck" # golang linter
        "eslint_d"    # js/ts/jsx/tsx/json/yaml linter
        "prettier"    # js/ts/jsx/css/scss/html/markdown/json/yaml linter
        # "stylelint"         # css linter (npm package; will be set up when starting frontend development)
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
    unset PKGS

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
# ======== Desktop                                     =
# ======================================================
# ======================================================

setup_desktop() {
    _setup_xfce4
}
readonly -f setup_desktop

_setup_xfce4() {
    # Ref:
    #     https://wiki.archlinux.org/title/Xfce#Configuration
    #     https://github.com/endeavouros-team/endeavouros-xfce4-theming/tree/master

    # TODO: These may cause error
    # rm -r "${HOME}/.config/xfce4"
    # rm -r "${HOME}/.cache/sessions"

    __setup_panel
    __setup_keybindings
    # __setup_window_manager # This config isn't worth syncing.
    # __setup_wallpaper # This config isn't worth syncing.
    __setup_screensaver
    __setup_thunar

    # NOTE: Reboot required
    # sudo reboot
}
readonly -f _setup_xfce4

__setup_panel() {
    # Install dependencies
    sudo pacman -S --needed --noconfirm xfce4-systemload-plugin

    # dependencies configs
    remove_unused_config \
        "${HOME}/.config/xfce4/panel/datetime-18.rc"
    copy_file \
        "${MYENV_ROOT}/config/home/.config/xfce4/panel/datetime-18.rc" \
        "${HOME}/.config/xfce4/panel/datetime-18.rc"

    remove_unused_config \
        "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
    copy_file \
        "${MYENV_ROOT}/config/home/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml" \
        "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
}
readonly -f __setup_panel

__setup_keybindings() {
    remove_unused_config \
        "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml"
    copy_file \
        "${MYENV_ROOT}/config/home/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml" \
        "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml"
}
readonly -f __setup_keybindings

# __setup_window_manager() {
#     remove_unused_config \
#         "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml"
#     copy_file \
#         "${MYENV_ROOT}/config/home/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml" \
#         "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml"
# }
# readonly -f __setup_window_manager
#
# __setup_wallpaper() {
#     remove_unused_config \
#         "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
#     copy_file \
#         "${MYENV_ROOT}/config/home/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml" \
#         "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
# }
# readonly -f __setup_wallpaper

__setup_screensaver() {
    remove_unused_config \
        "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml"
    copy_file \
        "${MYENV_ROOT}/config/home/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml" \
        "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml"
}
readonly -f __setup_screensaver

__setup_thunar() {
    remove_unused_config \
        "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml"
    copy_file \
        "${MYENV_ROOT}/config/home/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml" \
        "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml"
}
readonly -f __setup_thunar

# ======================================================
# ======================================================
# ======== Post                                        =
# ======================================================
# ======================================================

post_setup_base() {
    :
}
readonly -f post_setup_base
