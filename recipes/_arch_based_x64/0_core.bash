#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

# ======================================================
# ======================================================
# ======== Pre                                         =
# ======================================================
# ======================================================

pre_setup_core() {
    _refresh_packages() {
        sudo pacman -Syu --noconfirm

        # NOTE: yay may not be installed yet at this point.
        # If yay is not found, skip the yay update and continue.
        # Do not stop the whole script.
        if check_if_command_exists "yay"; then
            yay -Syu --noconfirm
        fi
    }
    _install_some_dependencies() {
        sudo pacman -S --needed --noconfirm base-devel curl vim
    }

    _refresh_packages
    _install_some_dependencies

    unset -f \
        _refresh_packages \
        _install_some_dependencies
}
readonly -f pre_setup_core

# ======================================================
# ======================================================
# ======== pacman mirror                               =
# ======================================================
# ======================================================

update_pacman_mirror() {
    # Ref:
    #     https://wiki.archlinux.org/title/Mirrors
    #     https://wiki.archlinux.jp/index.php/%E3%83%9F%E3%83%A9%E3%83%BC
    #     https://archlinux.org/mirrorlist/
    #     https://ikmnjrd.github.io/blog/pacman-mirrorlist
    local -r MIRROR_URL="https://archlinux.org/mirrorlist/?country=JP&country=AU&protocol=https&use_mirror_status=on"
    local -r MIRROR_FILE="/etc/pacman.d/mirrorlist"
    local -r NUM_MIRRORS=5
    log_info "Updating pacman mirror..."
    curl -s "$MIRROR_URL" |
        sed -e 's/^#Server/Server/' -e '/^#/d' |
        rankmirrors -n "$NUM_MIRRORS" - |
        sudo tee "$MIRROR_FILE"
    log_info "pacman mirror updated"

    sudo pacman -Syu --noconfirm
}
readonly -f update_pacman_mirror

# ======================================================
# ======================================================
# ======== Git                                         =
# ======================================================
# ======================================================

setup_git() {
    # dependencies
    _install_delta # better git diff

    _install_git
    _setup_git_config
}
readonly -f setup_git

_install_git() {
    sudo pacman -S --needed --noconfirm git
}
readonly -f _install_git

_install_delta() {
    sudo pacman -S --needed --noconfirm git-delta
}
readonly -f _install_delta

_setup_git_config() {
    remove_unused_config "${HOME}/.gitconfig"
    remove_unused_config "${HOME}/.gitignore"
    remove_unused_config "${HOME}/.gitignore_global"
    link_file "${MYENV_ROOT}/config/home/.config/git/config" "${HOME}/.config/git/config"
    link_file "${MYENV_ROOT}/config/home/.config/git/ignore" "${HOME}/.config/git/ignore"
}
readonly -f _setup_git_config

# ======================================================
# ======================================================
# ======== AUR helper                                  =
# ======================================================
# ======================================================

setup_aur_helper() {
    _install_yay
}
readonly -f setup_aur_helper

_install_yay() {
    if ! check_if_command_exists "yay"; then
        # Ensure that dependencies is installed
        sudo pacman -S --needed git base-devel

        cd "$(mktemp -d)"
        # Install yay (binary)
        # Ref:
        #     https://github.com/Jguer/yay/blob/138c2dd6cdf1a3738ee18f6bf94c1e8c37e15dc4/README.md#binary
        git clone https://aur.archlinux.org/yay-bin.git
        cd yay-bin
        makepkg -si
        cd - # Go back to the previous directory, just in case
    fi
}
readonly -f _install_yay

# ======================================================
# ======================================================
# ======== Runtime version manager                     =
# ======================================================
# ======================================================

setup_runtime_version_manager() {
    _install_mise
    _setup_mise_config
}
readonly -f setup_runtime_version_manager

_install_mise() {
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

    # # Insatll mise (binary)
    # # Ref:
    # #     https://aur.archlinux.org/packages/mise-bin
    # #     https://aur.archlinux.org/packages/mise
    # #     https://mise.jdx.dev/getting-started.html#alternate-installation-methods
    # # NOTE: See following "NOTE" section
    # yay -S --needed --noconfirm mise-bin

    # Install mise
    # Ref:
    #     https://archlinux.org/packages/extra/x86_64/mise/
    #     https://mise.jdx.dev/installing-mise.html#pacman
    # NOTE: Maintenance of mise has been moved from the AUR
    #     to the official Arch package.
    log_debug "/recipes/_arch_based_x64/0_core.bash - _install_mise"
    log_debug "BEFORE yay -S --needed --noconfirm mise"
    check_if_command_exists "yay" &&  yay -S --needed --noconfirm mise
    log_debug "AFTER  yay -S --needed --noconfirm mise"
}
readonly -f _install_mise

_setup_mise_config() {
    link_file "${MYENV_ROOT}/config/home/.config/mise/config.toml" "${HOME}/.config/mise/config.toml"
}
readonly -f _setup_mise_config

# ======================================================
# ======================================================
# ======== Programming Languages                       =
# ======================================================
# ======================================================

setup_programming_languages() {
    _install_golang
    _install_nodejs
}
readonly -f setup_programming_languages

_install_golang() {
    mise use --global go@latest
}
readonly -f _install_golang

_install_nodejs() {
    mise use --global node@latest
}
readonly -f _install_nodejs

# ======================================================
# ======================================================
# ======== CLI version manager                         =
# ======================================================
# ======================================================

setup_cli_version_manager() {
    _setup_aqua
}
readonly -f setup_cli_version_manager

_setup_aqua() {
    if ! check_if_command_exists "aqua"; then
        cd "$(mktemp -d)"
        curl -sSfL -O https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.0.1/aqua-installer
        echo "fb4b3b7d026e5aba1fc478c268e8fbd653e01404c8a8c6284fdba88ae62eda6a  aqua-installer" | sha256sum -c
        chmod +x aqua-installer
        ./aqua-installer
    fi
    link_file "${MYENV_ROOT}/config/home/.config/aquaproj-aqua/aqua.yaml" "${HOME}/.config/aquaproj-aqua/aqua.yaml"
}
readonly -f _setup_aqua

# ======================================================
# ======================================================
# ======== Misc                                        =
# ======================================================
# ======================================================

setup_some_directories() {
    local -r DIRS=(
        "${HOME}/repos"
        "${HOME}/bin"
        "${HOME}/workspace"
        "${HOME}/workspace/sandboxes"
        "${HOME}/workspace/temp"
        # "${HOME}/.vscode-workspaces"
    )
    for DIR in "${DIRS[@]}"; do
        mkdir -p -v "$DIR"
    done
}
readonly -f setup_some_directories

# ======================================================
# ======================================================
# ======== Post                                        =
# ======================================================
# ======================================================

post_setup_core() {
    :
}
readonly -f post_setup_core
