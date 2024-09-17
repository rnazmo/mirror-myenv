#!/bin/bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

main() {
    log_debug "START: ${BASH_SOURCE}"

    yay -Syu

    # ======================================================
    # ======== normal font                                 =
    # ======================================================

    # TODO: Install normal font (何にするかまだ決めてない)
    # yay -S --needed --noconfirm noto-fonts-cjk
    yay -S --needed noto-fonts-cjk

    # ======================================================
    # ======== mono font                                   =
    # ======================================================

    yay -S --needed ttf-cica

    # ======================================================
    # ======== extra font                                  =
    # ======================================================

    yay -S --needed noto-fonts-emoji

    # ======================================================
    # ======== ?                                           =
    # ======================================================

    # システムフォントの設定？
    # TODO: Link config files?
    # $XDG_CONFIG_HOME/fontconfig/fonts.conf
    # Ref: [Arch Linux インストール (7) - 各設定](https://aznote.jakou.com/archlinux/install7.html)

    # フォントキャッシュの更新（不要かも）
    fc-cache -v
    
    log_debug "END  : ${BASH_SOURCE}"
}

main
