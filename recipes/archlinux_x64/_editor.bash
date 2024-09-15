#!/bin/bash
set -eu

source ${MYENV_ROOT}/lib/util.bash

main() {
    # ======================================================
    # ======== neovim (& plugin-manager & plugins)         =
    # ======================================================

    # ======== neovim
    sudo pacman -S --needed neovim

    # ======== astronvim (= framework)
    # NOTE: The framework ("astronvim") = plugin-manager ("lazy.nvim") + many plugins + configs
    # TODO: Install requirements
    local -r ASTRONVIM_DIR="${HOME}/.config/nvim" # AstroNvim のデフォルトのインストール先ディレクトリ
    # TODO: astronvim のインストール方法どうしよう？？？？？？？？？？？？？
    # TODO: あとどうやって設定ファイルをカスタムしよう？？？？？？？？？？？？？
    # TODO: そしてそれをどうやって dotfiles として管理しよう？？？？？？？？？
    # TODO: さらに astronvim に更新があったときの更新をどうやろう？？？？？？
    if ! check_if_astronvim_is_installed "$ASTRONVIM_DIR"; then
        # Clean config files
        remove_symlink "${ASTRONVIM_DIR}"
        mv "${ASTRONVIM_DIR}" "${ASTRONVIM_DIR}.bak"

        # Clean neovim caches
        mv ~/.local/share/nvim ~/.local/share/nvim.bak
        mv ~/.local/state/nvim ~/.local/state/nvim.bak
        mv ~/.cache/nvim ~/.cache/nvim.bak

        # Install astronvim
        # TODO:
        git clone --depth 1 https://github.com/AstroNvim/template "${ASTRONVIM_DIR}"
        # remove template's git connection to set up your own later
        rm -rf "${ASTRONVIM_DIR}/.git"
        nvim
    fi

    # ======================================================
    # ======== vscode (& extensions)                       =
    # ======================================================

    sudo pacman -S --needed code
    link_file "${MYENV_ROOT}/config/home/.config/Code/User/settings.json" "${HOME}/.config/Code/User/settings.json"
    link_file "${MYENV_ROOT}/config/home/.config/Code/User/keybindings.json" "${HOME}/.config/Code/User/keybindings.json"
    link_file "${MYENV_ROOT}/config/home/.config/Code/User/snippets" "${HOME}/.config/Code/User/snippets" # NOTE: dir

    # TODO: install extensions
    # TODO: ~~indent-rainbow~~
    # TODO: ~~zenkaku~~
    # TODO: ~~Trailing Spaces~~
    # TODO: EditorConfig
    # ======== prettier
    ext install esbenp.prettier-vscode
    # TODO: githHub copilot
    # TODO: codeium
    # TODO: Code Spell Checker
    # TODO: Git History # 必要なときだけ有効にする
    # TODO: GitLens # 重め。必要なときだけ有効にする
    # TODO: Dev Containers
    # 言語系はどうする？
    # TODO: golang
    # TODO: html
    # TODO: css
    # TODO: markdown
    # TODO: javascript
    # TODO: typescript
    # TODO: etc...

}

# この関数は次のリポジトリ構成に基づいて判別しています：
#     https://github.com/AstroNvim/template/tree/20450d8a65a74be39d2c92bc8689b1acccf2cffe
check_if_astronvim_is_installed() {
    local -r ASTRONVIM_DIR="${HOME}/.config/nvim"
    if [ -d "$ASTRONVIM_DIR" ] && [ -f "$ASTRONVIM_DIR/README.md" ] && [ -f "$ASTRONVIM_DIR/lua/plugins/astrocore.lua" ]; then
        return 0 # AstroNvim is installed
    else
        return 1 # AstroNvim is not installed
    fi
}

main


# - core/editor:
#     - Install via pacman:
#         - [ ] neovim
#             - Link config files

#         - [ ] vscode
#             - Link config files
#                 - `~/.config/Code/User`
#         - [ ] obsidian
#     - Misc:
#         - [ ] editorconfig
#             - Link config files
#                 - `~/.editorconfig`
#     - ?:
#         - [ ] neovim-plugin
#         - [ ] neovim-framework-astronvim
#             - astronvim は plugin というよりもはや framework