# Arch Linux 共通の差分
# - pre_greet はデフォルト（no-op）のまま
# - 必要なフックだけ上書きする

platform_get_os() { echo "Arch Linux"; }
