n#!/bin/bash
set -eu

# ===========================================================
# - dependencies:
#     - Install via git-clone:
#         - [ ] myenv-v3
#                 - `~/.myenv-v3`
#     - Install via pacman:
#         - [ ] git
#             - Link config files
#                 - `~/.config/git/config`
#                 - `~/.config/git/ignore`
#         - [ ] yay
#     - Install via shell-script?:
#         - [ ] mise
#             - Link config files
#                 - `~/.config/mise/config.toml`
#         - [ ] aqua
#             - Link config files
#                 - `~/.config/aquaproj-aqua/aqua.yaml`
# - core/system:
#     - Misc:
#         - [ ] Update system
#                 - `pacman -Syu`
# - core/terminal:
#     - Misc:
#         - [ ] Setup default-shell
#     - Install via pacman:
#         - [ ] zsh
#             - Link config files
#                 - `~/.zshrc`
#         - [ ] alacritty
#                 - import `~/.config/alacritty/theme-foo.yaml`
#         - [ ] starship
#             - Link config files
#                 - `~/.config/starship.toml`
#         - [ ] tmux
#             - Link config files
#                 - `~/.config/tmux/tmux.conf`
#     - Install via git-clone:
#         - [ ] tmux-plugin-manager (tpm) ?
#     - ?
#         - [ ] zsh-plugin-manager (sheldon) ?
#         - [ ] zsh-plugin-zsh-syntax-highlighting
#         - [ ] zsh-plugin-zsh-autosuggestions
#         - [ ] zsh-plugin-zsh-zsh-history-substring-search
# - core/font:
#     - Misc:
#         - [ ] Setup normal-font
#         - [ ] Setup mono-font
#     - Install via yay:
#         - [ ] cica
#     - ?:
#         - [ ] 何かノーマルフォント ？
# - core/cli:
#     - Install via pacman:
#         - [ ] ghq
#         - [ ] fzf
#         - [ ] tree
#         - [ ] xclip
#         - [ ] neofetch
#         - [ ] lazygit
#         - [ ] ripgrep
#         - [ ] bat
#         - [ ] eza
#         - [ ] fd
#         - [ ] delta
#         - [ ] bottom
#     - Install via shell-script:
#         - [ ] proper7y
# - core/programming-language:
#     - Install via mise:
#         - [ ] golang
#         - [ ] nodejs
#         - [ ] python
#         - [ ] ruby
# - core/editor:
#     - Install via pacman:
#         - [ ] neovim
#             - Link config files
#                 - `~/.config/zsh/.zshrc`
#                 - `~/.config/zsh/.zsh_aliases`
#                 - `~/.config/zsh/.zsh_path`
#                 - `~/.config/zsh/.zshenv`
#         - [ ] vscode
#             - Link config files
#                 - `~/.config/Code/User`
#         - [ ] obsidian
#     - Misc:
#         - [ ] editorconfig
#             - Link config files
#                 - `~/.editorconfig`
#     - ?:
#         - [ ] neovim-plugin
#         - [ ] neovim-framework-astronvim
#             - astronvim は plugin というよりもはや framework
# - core/browser:
#     - Install via pacman:
#         - [ ] chromium
#         - [ ] firefox
#     - ?:
#         - [ ] chrome
#         - [ ] browser-extension
#         - [ ] browser-bookmarklet
# ===========================================================

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
