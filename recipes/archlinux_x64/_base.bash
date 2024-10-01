#!/bin/bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

main() {
    log_debug "START: ${BASH_SOURCE}"

    # ======================================================
    # ======== system update                               =
    # ======================================================

    sudo pacman -Syu

    # ======================================================
    # ======== some dependencies                           =
    # ======================================================

    sudo pacman -S --needed base-devel curl vim

    # ======================================================
    # ======== git                                         =
    # ======================================================

    sudo pacman -S --needed git

    [ -f "${HOME}/.gitconfig" ]        && mv     "${HOME}/.gitconfig"        "${HOME}/.gitconfig.old"
    [ -f "${HOME}/.gitignore" ]        && mv     "${HOME}/.gitignore"        "${HOME}/.gitignore.old"
    [ -f "${HOME}/.gitignore_global" ] && mv     "${HOME}/.gitignore_global" "${HOME}/.gitignore_global.old"
    [ -L "${HOME}/.gitconfig" ]        && unlink "${HOME}/.gitconfig"
    [ -L "${HOME}/.gitignore" ]        && unlink "${HOME}/.gitignore"
    [ -L "${HOME}/.gitignore_global" ] && unlink "${HOME}/.gitignore_global"
    link_file "${MYENV_ROOT}/config/home/.config/git/config" "${HOME}/.config/git/config"
    link_file "${MYENV_ROOT}/config/home/.config/git/ignore" "${HOME}/.config/git/ignore"

    # ======================================================
    # ======== yay                                         =
    # ======================================================

    if ! check_if_command_exists "yay"; then
        cd "$(mktemp -d)"
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
    fi

    # ======================================================
    # ======== mise                                        =
    # ======================================================

    if ! check_if_command_exists "mise"; then
        # Ref:
        #     https://mise.jdx.dev/getting-started.html#alternate-installation-methods
        #     https://github.com/jdx/mise/blob/4ac34dac72144f9084b49359dc0181e8f762f0bf/docs/getting-started.md#alternate-installation-methods
        curl https://mise.jdx.dev/mise-latest-linux-x64 > ~/.local/bin/mise
        chmod +x ~/.local/bin/mise
    fi
    link_file "${MYENV_ROOT}/config/home/.config/mise/config.toml" "${HOME}/.config/mise/config.toml"

    # ======================================================
    # ======== aqua                                        =
    # ======================================================

    if ! check_if_command_exists "aqua"; then
        cd "$(mktemp -d)"
        curl -sSfL -O https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.0.1/aqua-installer
        echo "fb4b3b7d026e5aba1fc478c268e8fbd653e01404c8a8c6284fdba88ae62eda6a  aqua-installer" | sha256sum -c
        chmod +x aqua-installer
        ./aqua-installer
    fi
    link_file "${MYENV_ROOT}/config/home/.config/aquaproj-aqua/aqua.yaml" "${HOME}/.config/aquaproj-aqua/aqua.yaml"

    # ======================================================
    # ======== misc                                        =
    # ======================================================


    local -r DIRS=(
        "${HOME}/repos"
        "${HOME}/bin"
        "${HOME}/workspace"
        "${HOME}/workspace/sandboxes"
        "${HOME}/workspace/temp"
        "${HOME}/.vscode-workspaces"
    )
    for DIR in "${DIRS[@]}"; do
        mkdir -p -v "$DIR"
    done

    log_debug "END  : ${BASH_SOURCE}"
}

main
