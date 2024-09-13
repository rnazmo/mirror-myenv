#!/bin/bash
set -eu

../../modules/03_chassis/vbox_guest.arch_based.x64.bash

../../modules/04_os/arch.arch_based.x64.bash

../../modules/10_core.arch_based.x64.bash

../../modules/20_core.arch_based.x64.bash
