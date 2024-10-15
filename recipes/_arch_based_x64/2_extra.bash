#!/usr/bin/env bash
set -eu

# virtualized environment guest

source "${MYENV_ROOT}/lib/util.bash"

setup_docker() {
    sudo pacman -S docker docker-compose
}

setup_virtualbox() {
    sudo pacman -S --needed virtualbox virtualbox-host-modules-arch virtualbox-guest-iso
    sudo gpasswd -a $USER vboxusers
    sudo modprobe vboxdrv
}

setup_virtualbox_guest() {
    # Ref: https://wiki.archlinux.org/title/VirtualBox/Install_Arch_Linux_as_a_guest
    sudo pacman -S --needed virtualbox-guest-utils
}

setup_vscode() {
    yay -S --needed --noconfirm visual-studio-code-bin
    link_file "${MYENV_ROOT}/config/home/.config/Code/User/settings.json" "${HOME}/.config/Code/User/settings.json"
    link_file "${MYENV_ROOT}/config/home/.config/Code/User/keybindings.json" "${HOME}/.config/Code/User/keybindings.json"
    link_dir "${MYENV_ROOT}/config/home/.config/Code/User/snippets" "${HOME}/.config/Code/User/snippets" # NOTE: dir

    # Install extensions
    EXTENSIONS=(
        # TODO: Use "VSCode Neovim"
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
}

setup_obsidian() {
    sudo pacman -S --needed obsidian
}
