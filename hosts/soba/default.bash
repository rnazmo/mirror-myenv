n#!/bin/bash
set -eu

main() {
    # phase 01 - Update system
    sudo pacman -Syu --noconfirm

    # phase 02 - Install dependencies
    sudo pacman -S --needed --noconfirm git base-devel
    # TODO: Install yay
    # TODO: Install mise
    # TODO: Install aqua -> Use `aqua-installer`(shell script)

    # phase 03 - Instakk packages
    # Install packages via pacman
    yay -S starship foo bar
 
    # Install packages via yay
    yay -S alacritty foo bar

    # Install packages via mise
    mise install # install all
    # or
    mise install foo
    mise install bar

    # Install packages via aqua
    # aqua install -l -a # install all

    # phase 04

    # phase 05

    # phase 06

    # phase 07

    # phase 08

    # phase 09

    # phase 10 - Setup font config

    # phase 11 - Setup terminal cofig
    link_file "../../config/home/.config/alacritty/alacritty.toml" "~/.config/alacritty/alacritty.toml"
    link_file "../../config/home/.zshrc" "~/.zshrc"
    chenge_default_shell_to_zsh
    link_file "../../config/home/.config/tmux/tmux.conf" "~/.config/tmux/tmux.conf"

    # phase 12 - Setup neovim config

    # phase 15 - Setup vscode config
    # phase 16 - Setup chrome config
    # phase 17 - Setup chromium config
    # phase 18 - Setup firefox config


# ../../modules/03_chassis/vbox_guest.arch_based.x64.bash
# ../../modules/04_os/arch.arch_based.x64.bash
# ../../modules/10_core.arch_based.x64.bash
# ../../modules/20_core.arch_based.x64.bash


# ../../modules/00_dependencies/myenv-v3/setup.arch_based.x64.bash
../../modules/00_dependencies/git/setup.arch_based.x64.bash
../../modules/00_dependencies/aqua/setup.arch_based.x64.bash
../../modules/00_dependencies/mise/setup.arch_based.x64.bash

../../modules/10_core/cli/ghq/setup.arch_based.x64.bash
../../modules/10_core/cli/fzf/setup.arch_based.x64.bash
../../modules/10_core/cli/ghq/setup.arch_based.x64.bash
../../modules/10_core/cli/ripgrep/setup.arch_based.x64.bash
# ...

}

main
