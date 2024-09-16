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
        # TODO: Install astronvim
        # git clone --depth 1 https://github.com/AstroNvim/template "${ASTRONVIM_DIR}"
        # # remove template's git connection to set up your own later
        # rm -rf "${ASTRONVIM_DIR}/.git"
        # nvim
        # TODO: Link neovim, astrovim config files
    fi

    # ======================================================
    # ======== vscode (& extensions)                       =
    # ======================================================

    sudo pacman -S --needed code
    link_file "${MYENV_ROOT}/config/home/.config/Code/User/settings.json" "${HOME}/.config/Code/User/settings.json"
    link_file "${MYENV_ROOT}/config/home/.config/Code/User/keybindings.json" "${HOME}/.config/Code/User/keybindings.json"
    link_file "${MYENV_ROOT}/config/home/.config/Code/User/snippets" "${HOME}/.config/Code/User/snippets" # NOTE: dir

    # Install extensions
    EXTENSIONS=(
        "golang.Go"
        # "ms-azuretools.vscode-docker"
        # "ms-vscode-remote.remote-containers"
        # "GitHub.copilot"
        # "Codeium.codeium"
        "editorconfig.editorconfig"
        # "esbenp.prettier-vscode"
        # "dbaeumer.vscode-eslint"
        # "streetsidesoftware.code-spell-checker"
        # "eamodio.gitlens"
        # "donjayamanne.githistory"
    )
    for EXT in "${EXTENSIONS[@]}"; do
        code --install-extension "$EXT"
    done

    # ======================================================
    # ======== obsidian                                    =
    # ======================================================

    sudo pacman -S --needed obsidian


    # ======================================================
    # ======== misc                                        =
    # ======================================================

    # Editorconfig
    link_file "${MYENV_ROOT}/config/home/.editorconfig" "${HOME}/.editorconfig"
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
