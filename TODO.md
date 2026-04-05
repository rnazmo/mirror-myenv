# TODO

## Milestone: v4.10.0 - 軽めの整備

バグ修正・誤記修正・すぐ終わる改善が中心。

### セキュリティ・バグ修正

- [ ] fix: `log_warn` のバグを修正する
    - `lib/util.bash` の `log_warn` 関数で `>&2` の位置が間違っている
    - `local -r PREFIX="WARN :" >&2` → `echo "$PREFIX $1" >&2` に修正する

### コード・機能

- [ ] chore: `run-lint` スクリプトに `nullglob` を設定する
    - `devel-tools/script/run-lint.arch_based_x64.bash` でグロブがマッチしない場合の挙動を安全にする
    - スクリプト先頭に `shopt -s nullglob` を追加する
- [ ] refactor: `setup.bash` の `HOST_NAME` 変数の宣言方法を整理する
    - `parse_args` 関数内で `readonly HOST_NAME="$1"` としているが、グローバル変数の扱いが不明瞭
    - 意図を明示するよう修正する

### テスト・CI

無し。

### ドキュメント

- [x] `TODO.md` を導入
    - [x] 雛形の作成
    - [x] タスクの洗い出し
    - [x] タスクの優先順位付け・マイルストーンの設定
- [x] docs: `ADR.md` を導入
- [ ] docs: 何かしらの ADR を書く
- [x] docs: `README.md` に、`TODO.md`, `ADR.md` への誘導を記述する
- [ ] docs: `hosts/README.md` のホスト情報の誤記を修正する
    - `soba` の記述が2回あり、片方は CachyOS のはずなのに Manjaro と誤記されている

### プロジェクト管理

無し。

---

## Backlog（いつかやる）

### セキュリティ・バグ修正

無し。

### コード・機能

- [ ] refactor: `copy_file` と `copy_file_as_root` の重複コードを解消する
    - `lib/util.bash` の2関数はほぼ同じ実装。第3引数でsudo有無を切り替える形に統合する
    - 同様に `remove_file` と `remove_file_as_root` も対象
- [ ] refactor: `link_file` と `link_dir` のバリデーション重複を解消する
    - `lib/util.bash` の2関数で共通するバリデーション処理を内部関数に切り出す
- [ ] refactor: レシピファイルの肥大化に備えてファイル分割を検討する
    - `recipes/_arch_based_x64/1_base.bash` が大きくなりつつある
    - shell / terminal / editor などの責務ごとにファイルを分割する
- [ ] feat: ErgoDox EZ の設定を追加する
- [ ] feat: 壁紙の管理を追加する (`gitlab/mywallpaper` 連携？)
- [ ] feat: Xfce の設定管理を追加する
- [ ] feat: Zsh の設定を更新・改善する
- [ ] feat: bat の設定ファイルを追加する
- [ ] feat: baobab を追加する (GUI ディスクユーザアナライザ)
    - https://archlinux.org/packages/extra/x86_64/baobab/
- [ ] feat: cspell をタイポチェックとして追加する
- [ ] feat: `myenv` コマンドに `sync` サブコマンドを追加する (`pull` + `push`)
    - `_aliases.zsh` の TODO コメントより
- [ ] feat: 前提条件（Bash 4.0+ など）をチェックする処理を追加する
- [ ] feat: デバッグ用にログをファイルへ出力する機能を追加する
- [ ] feat: ブラウザの拡張機能・ブックマークレット・ブックマークに対応を検討

### テスト・CI

- [ ] ci: ユニットテストを追加する
- [ ] ci: インテグレーションテストを追加する
- [ ] ci: 静的チェック（lint / format）を CI に追加する
    - ref: rnazmo/proper7y

### ドキュメント

- [ ] docs: README.md の TODO セクションを削除し、このファイルに一本化する
    - 移行完了後に README.md の TODO セクションを削除する
- [ ] docs: できること・できないことを README.md にまとめる
    - 時刻同期、Git の初期設定、SSH 公開鍵登録など
    - 例えば、時刻同期は GUI が楽だからそっちでやって、みたいな。
- [ ] docs: CHANGELOG.md の各バージョンセクションに内容を記入する
    - 現状 `v1.0.0` 〜 `v4.0.0` が `TODO:` のまま

### プロジェクト管理

- [ ] chore: TODO.md のタスクの優先順位付けとマイルストーンへの割り当てを行う
    - このバックログへの移動が完了したら実施する
- [ ] chore: README.md の TODO セクションをこのファイルへの誘導に差し替える
