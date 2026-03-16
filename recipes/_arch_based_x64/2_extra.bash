#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

# ======================================================
# ======================================================
# ======== Pre                                         =
# ======================================================
# ======================================================

pre_setup_extra() {
    _refresh_packages() {
        sudo pacman -Syu --noconfirm
        check_if_command_exists "yay" && yay -Syu --noconfirm
    }

    _refresh_packages

    unset -f _refresh_packages
}
readonly -f pre_setup_extra

# ======================================================
# ======================================================
# ======== Virtualization                              =
# ======================================================
# ======================================================

setup_docker() {
    sudo pacman -S docker docker-compose
}
readonly -f setup_docker

setup_virtualbox() {
    sudo pacman -S --needed virtualbox virtualbox-host-modules-arch virtualbox-guest-iso
    sudo gpasswd -a "$USER" vboxusers
    sudo modprobe vboxdrv
}
readonly -f setup_virtualbox

setup_virtualbox_guest() {
    # Ref:
    #     https://wiki.archlinux.org/title/VirtualBox/Install_Arch_Linux_as_a_guest
    #     https://archlinux.org/packages/extra/x86_64/virtualbox-guest-utils/
    sudo pacman -S --needed virtualbox-guest-utils
}
readonly -f setup_virtualbox_guest

# ======================================================
# ======================================================
# ======== Editor                                      =
# ======================================================
# ======================================================

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
readonly -f setup_vscode

setup_obsidian() {
    sudo pacman -S --needed obsidian
}
readonly -f setup_obsidian

# ======================================================
# ======================================================
# ======== Post                                        =
# ======================================================
# ======================================================

post_setup_extra() {
    :
}
readonly -f post_setup_extra
