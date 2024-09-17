#!/bin/bash
set -eu

source ${MYENV_ROOT}/lib/util.bash

main() {
    source ${MYENV_ROOT}/recipes/archlinux_x64/setup.bash
}

main
