#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_xfce4() {
    _setup_panel
    _setup_keybindings
    _setup_screensaver
    _setup_thunar
}
readonly -f setup_xfce4

_setup_panel() {
    platform_install_xfce4_systemload

    remove_unused_config \
        "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
    copy_file \
        "${MYENV_ROOT}/config/home/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml" \
        "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
}
readonly -f _setup_panel

_setup_keybindings() {
    remove_unused_config \
        "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml"
    copy_file \
        "${MYENV_ROOT}/config/home/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml" \
        "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml"
}
readonly -f _setup_keybindings

_setup_screensaver() {
    remove_unused_config \
        "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml"
    copy_file \
        "${MYENV_ROOT}/config/home/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml" \
        "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml"
}
readonly -f _setup_screensaver

_setup_thunar() {
    remove_unused_config \
        "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml"
    copy_file \
        "${MYENV_ROOT}/config/home/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml" \
        "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml"
}
readonly -f _setup_thunar
