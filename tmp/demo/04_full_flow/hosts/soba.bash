# soba: CachyOS → cachyos.bash を使用（arch の差分を継承 ＋ 上書き）
source "${DEMO_ROOT}/lib/platform.bash"
source "${DEMO_ROOT}/platforms/cachyos.bash"    # ← 内部で arch.bash を source
source "${DEMO_ROOT}/components/greet.bash"
source "${DEMO_ROOT}/components/info.bash"

# greet は呼ばず、info だけ呼ぶ例（ホストごとに取捨選択できる）
main() {
    setup_info
}
main
