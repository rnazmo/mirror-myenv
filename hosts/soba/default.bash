#!/bin/bash
set -eu

# TODO: Load ../../lib/util.bash

main() {
    install_packages
    twea_configs
}

install_packages() {
    # パッケージマネージャの更新
    sudo pacman -Syu --noconfirm

    # yay のインストール
    sudo pacman -S --needed --noconfirm git base-devel
    # TODO: Install yay

    # mise のインストール
    curl https://mise.run | sh

    # aqua のインストール
    curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v2.1.1/aqua-installer | bash

    # pacman でインストール可能なパッケージのインストール
    sudo pacman -S --needed --noconfirm \
    bat delta eza fzf ripgrep tree xclip neovim alacritty tmux zsh \
    go nodejs python ruby neofetch chromium firefox

    # yay でインストール可能な AUR パッケージのインストール
    yay -S --needed --noconfirm \
    ghq lazygit cica-git starship bottom obsidian visual-studio-code-bin google-chrome

    # miseを使用して言語バージョンをインストール
    mise use -g go@latest
    mise use -g node@lts
    mise use -g python@latest
    mise use -g ruby@latest

    # aquaを使用してツールをインストール
    aqua i -l

    # その他：
    # AstroNvimのインストール
    # git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
}

tweak_configs() {
    # phase 10 - Setup font config
    # TODO:

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
}

main
