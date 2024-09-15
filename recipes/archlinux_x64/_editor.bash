#!/bin/bash
set -eu

source ${MYENV_ROOT}/lib/util.bash

main() {
    # =============== neovim
    sudo pacman -S --needed neovim

    # =============== astronvim (neovim framework)
    # NOTE: The framework ("astronvim") = plugin-manager ("lazy.nvim") + many plugins + configs
    # TODO: Install requirements
    local -r ASTRONVIM_DIR="${HOME}/.config/nvim" # AstroNvim のデフォルトのインストール先ディレクトリ
    if ! check_if_astronvim_is_installed "$ASTRONVIM_DIR"; then
        # Clean config files
        remove_symlink "${ASTRONVIM_DIR}"
        mv "${ASTRONVIM_DIR}" "${ASTRONVIM_DIR}.bak"

        # Clean neovim caches
        mv ~/.local/share/nvim ~/.local/share/nvim.bak
        mv ~/.local/state/nvim ~/.local/state/nvim.bak
        mv ~/.cache/nvim ~/.cache/nvim.bak

        # Install astronvim
        git clone --depth 1 https://github.com/AstroNvim/template "${ASTRONVIM_DIR}"
        # remove template's git connection to set up your own later
        rm -rf "${ASTRONVIM_DIR}/.git"
        nvim
    fi
    
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