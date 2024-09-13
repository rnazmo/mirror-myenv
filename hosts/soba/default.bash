#!/bin/bash
set -eu

# ../../modules/03_chassis/vbox_guest.arch_based.x64.bash
# ../../modules/04_os/arch.arch_based.x64.bash
# ../../modules/10_core.arch_based.x64.bash
# ../../modules/20_core.arch_based.x64.bash


# ../../modules/00_dependencies/myenv-v3/setup.arch_based.x64.bash
../../modules/00_dependencies/git/setup.arch_based.x64.bash
../../modules/00_dependencies/aqua/setup.arch_based.x64.bash
../../modules/00_dependencies/mise/setup.arch_based.x64.bash

../../modules/10_core/cli/ghq/setup.arch_based.x64.bash
../../modules/10_core/cli/fzf/setup.arch_based.x64.bash
../../modules/10_core/cli/ghq/setup.arch_based.x64.bash
../../modules/10_core/cli/ripgrep/setup.arch_based.x64.bash
# ...