#!/bin/bash
set -eu

# TODO: Import `../lib/util.bash`

main() {
    # # dependencies
    # setup_git
    # setup_myenv_v3
    # setup_mise
    # setup_aqua

    # credential
    # TODO: # ?

    # system
    setup_locale
    # TODO:

    # # cli
    # setup_ghq
    # setup_fzf
    # setup_xclip
    # setup_tree
    # setup_ripgrep
    setup_exa___or_lsd # ?
    # setup_bat
    # setup_proper7y

    # font
    setup__normal_font # ?
    # setup__cica

    # terminal
    # setup_alacritty
    # setup_starship
    # setup_zsh
    setup_sheldon # ?
    setup_zsh_plugins # ?
    # setup_tmux
    setup_tpm # ?
    setup_tmux_plugins # ?

    # editor
    # setup_neovim
    setup_neovim_plugins # ?
    setup_astronvim # ?
    # setup_editorconfig
}

setup_myenv_v3() {
    clone_git_repo
}

setup_locale() {
    # TODO:
}

main
