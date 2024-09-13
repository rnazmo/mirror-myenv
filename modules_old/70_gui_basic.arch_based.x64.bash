#!/bin/bash
set -eu

# TODO: Import `../lib/util.bash`

main() {
    # editor
    setup_vscode
    setup_vscode_extension
    setup_obsidian

    # browser
    setup_chrome
    setup_chromium
    setup_firefox
    setup_browser_extension
    setup_browser_bookmarklet

    # system
    bleachbit

    # 日本語入力
}

setup_vscode() {
    # TODO:
}

setup_vscode_extension() {
    # TODO:
}

main
