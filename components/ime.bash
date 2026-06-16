#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_fcitx5_mozc() {
    platform_install_fcitx5_mozc
    _setup_fcitx5_config
}
readonly -f setup_fcitx5_mozc

_setup_fcitx5_config() {
    remove_unused_config "${HOME}/.config/fcitx5/config"
    remove_unused_config "${HOME}/.config/fcitx5/profile"
    link_file "${MYENV_ROOT}/config/home/.config/fcitx5/config" "${HOME}/.config/fcitx5/config"
    link_file "${MYENV_ROOT}/config/home/.config/fcitx5/profile" "${HOME}/.config/fcitx5/profile"
    remove_unused_config "${HOME}/.config/fcitx5/conf/xim.conf"
    remove_unused_config "${HOME}/.config/fcitx5/conf/mozc.conf"
    link_file "${MYENV_ROOT}/config/home/.config/fcitx5/conf/xim.conf" "${HOME}/.config/fcitx5/conf/xim.conf"
    link_file "${MYENV_ROOT}/config/home/.config/fcitx5/conf/mozc.conf" "${HOME}/.config/fcitx5/conf/mozc.conf"
    remove_file_as_root "/etc/profile.d/fcitx.sh"
    copy_file_as_root "${MYENV_ROOT}/config/etc/profile.d/fcitx.sh" "/etc/profile.d/fcitx.sh"
}
readonly -f _setup_fcitx5_config
