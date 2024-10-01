#!/bin/bash
set -eu

source ${MYENV_ROOT}/lib/util.bash

main() {
    log_debug "START: ${BASH_SOURCE}"

    sudo pacman -Syu
    yay -Syu

    # ======================================================
    # ======== neovim (& plugin-manager & plugins)         =
    # ======================================================

    # ======== neovim
    sudo pacman -S --needed neovim
    link_dir "${MYENV_ROOT}/config/home/.config/nvim" "${HOME}/.config/nvim" # NOTE: dir

    # TODO: setup neovim...


    # ======================================================
    # ======== vscode (& extensions)                       =
    # ======================================================

    yay -S --needed visual-studio-code-bin
    link_file "${MYENV_ROOT}/config/home/.config/Code/User/settings.json" "${HOME}/.config/Code/User/settings.json"
    link_file "${MYENV_ROOT}/config/home/.config/Code/User/keybindings.json" "${HOME}/.config/Code/User/keybindings.json"
    link_dir "${MYENV_ROOT}/config/home/.config/Code/User/snippets" "${HOME}/.config/Code/User/snippets" # NOTE: dir

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

    # sudo pacman -S --needed obsidian

    # ======================================================
    # ======== misc                                        =
    # ======================================================

    # Editorconfig
    link_file "${MYENV_ROOT}/config/home/.editorconfig" "${HOME}/.editorconfig"

    log_debug "END  : ${BASH_SOURCE}"
}

main
