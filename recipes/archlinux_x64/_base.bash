#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_base() {
    log_debug "START: ${BASH_SOURCE}"

    # ======================================================
    # ======== system update                               =
    # ======================================================

    sudo pacman -Syu --noconfirm

    # ======================================================
    # ======== some dependencies                           =
    # ======================================================

    sudo pacman -S --needed --noconfirm base-devel curl vim

    # ======================================================
    # ======== git                                         =
    # ======================================================

    sudo pacman -S --needed --noconfirm git

    remove_unused_config "${HOME}/.gitconfig"
    remove_unused_config "${HOME}/.gitignore"
    remove_unused_config "${HOME}/.gitignore_global"
    link_file "${MYENV_ROOT}/config/home/.config/git/config" "${HOME}/.config/git/config"
    link_file "${MYENV_ROOT}/config/home/.config/git/ignore" "${HOME}/.config/git/ignore"

    # ======================================================
    # ======== yay                                         =
    # ======================================================

    if ! check_if_command_exists "yay"; then
        # Ensure that dependencies is installed
        sudo pacman -S --needed git base-devel

        # Install yay (binary)
        # Ref:
        #     https://github.com/Jguer/yay/blob/138c2dd6cdf1a3738ee18f6bf94c1e8c37e15dc4/README.md#binary
        git clone https://aur.archlinux.org/yay-bin.git
        cd yay-bin
        makepkg -si
    fi

    # ======================================================
    # ======== mise                                        =
    # ======================================================

    # if ! check_if_command_exists "mise"; then
    #     # Install mise under `~/.local/bin/mise` with the script
    #     # Ref:
    #     #     https://mise.jdx.dev/getting-started.html#alternate-installation-methods
    #     #     https://github.com/jdx/mise/blob/4ac34dac72144f9084b49359dc0181e8f762f0bf/docs/getting-started.md#alternate-installation-methods
    #     cd "$(mktemp -d)"
    #     export MISE_INSTALL_PATH="${HOME}/.local/bin/mise"
    #     curl -fsSL https://mise.jdx.dev/install.sh -o install.sh
    #     chmod +x ./install.sh
    #     ./install.sh
    # fi

    # Insatll mise (binary)
    # Ref:
    #     https://aur.archlinux.org/packages/mise-bin
    #     https://aur.archlinux.org/packages/mise
    #     https://mise.jdx.dev/getting-started.html#alternate-installation-methods
    yay -S --needed --noconfirm mise-bin

    link_file "${MYENV_ROOT}/config/home/.config/mise/config.toml" "${HOME}/.config/mise/config.toml"

    # ======================================================
    # ======== Programming Languages                       =
    # ======================================================

    # mise install

    # ======== golang
    mise use --global go@latest

    # ======== nodejs
    mise use --global node@latest

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
