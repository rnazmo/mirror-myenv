#!/bin/bash
set -eu

# TODO: Import `../lib/util.bash`

main() {
    # system
    setup_bottom
    setup_neofetch

    # devel
    setup_lazygit
    setup_lazydelta
    setup_gpg # -> credential?
    setup_golang
    setup_nodejs
    setup_deno
    setup_bun
    setup_python
    setup_ruby
}

setup_bottom() {
    # TODO:
}

setup_neofetch() {
    # TODO:
}

main
