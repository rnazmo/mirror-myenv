#!/bin/bash
set -eu

source ${MYENV_DIR}/lib/util.bash

main() {
    # =============== default shell
    sudo chsh -s $(which zsh)

    # =============== zsh (zsh & plugin-manager & plugins)
    sudo pacman -S --needed zsh sheldon zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search
    link_file "${MYENV_ROOT}/config/home/.zshenv" "${HOME}/.zshenv"
    link_file "${MYENV_ROOT}/config/home/.config/zsh" "${HOME}/.config/zsh" # NOTE: the path is directory
    # TODO: setup sheldon????

    # =============== alacritty
    # Install alacritty & theme
    sudo pacman -S --needed alacritty
    link_file "${MYENV_ROOT}/config/home/.config/alacritty/alacritty.toml" "${HOME}/.config/alacritty/alacritty.toml"
    link_file "${MYENV_ROOT}/config/home/.config/alacritty/alacritty.toml" "${HOME}/.config/alacritty/theme-zenburn.toml"

    # =============== starship
    sudo pacman -S --needed starship
    link_file "${MYENV_ROOT}/config/home/.config/starship.toml" "${HOME}/.config/starship.toml"

    # =============== tmux (tmux & plugin-manager & plugins)
    sudo pacman -S --needed tmux
    yay -S --needed tpm
    link_file "${MYENV_ROOT}/config/home/.config/tmux/tmux.conf" "${HOME}/.config/tmux/tmux.conf"
}

main
