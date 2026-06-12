# udon: EndeavourOS → arch.bash を使用（差分なしなので arch で十分）
source "${DEMO_ROOT}/lib/platform.bash"
source "${DEMO_ROOT}/platforms/arch.bash"
source "${DEMO_ROOT}/components/greet.bash"
source "${DEMO_ROOT}/components/info.bash"

# ホストごとに呼ぶ関数を選択できる（呼ばなければスキップ）
main() {
    setup_greet
    setup_info
}
main
