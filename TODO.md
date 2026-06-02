# TODO (myenv)

## Milestone: v4.9.2 - スクリプトのパフォーマンス改善

### 概要

- 日々使うスクリプトのパフォーマンスが悪いので，抜本的に見直す
- pacman のミラーリスト最適化・更新処理の改善がメイン

### セキュリティ・バグ修正

無し。

### コード・機能

無し。

### テスト・CI

無し。

### ドキュメント

無し。

### プロジェクト管理

無し。

---

## Milestone: v4.10.0 - 構成の見直し

### 概要

- 構成を抜本的に見直す。
- ディレクトリ構成だけでなく，リポジトリ構成，技術構成から見直す
    - nix, chezmoi など

### セキュリティ・バグ修正

無し。

### コード・機能

無し。

### テスト・CI

無し。

### ドキュメント

無し。

### プロジェクト管理

無し。

---

## Milestone: v4.X.0 - テストの導入

### 概要

- ユニットテスト，インテグレーションテスト
- 別プロジェクトである proper7y で使った bats をそのまま使えそう

### セキュリティ・バグ修正

無し。

### コード・機能

無し。

### テスト・CI

無し。

### ドキュメント

無し。

### プロジェクト管理

無し。

---

## Milestone: v4.X.0 - CI の導入

### 概要

- 自動テスト
- README にバッジ付ける

### セキュリティ・バグ修正

無し。

### コード・機能

無し。

### テスト・CI

無し。

### ドキュメント

無し。

### プロジェクト管理

無し。

---

## Backlog（いつかやる）

### セキュリティ・バグ修正

- [ ] 自作の applypatch スクリプトが全然まともに使えないので deprecated とする，または削除する

### コード・機能

- [ ] applypatch スクリプトに以下の機能を追加することを検討する
    - 安全・ミス予防のための機能
        - クリップボードの中身の確認
        - 作業場所・対象ファイルの確認
        - 最初に上記の確認をして、ダメそうなら警告を出して中断したい。
- [ ] feat/fix: `recipes/_common/setup_git.bash` と `recipes/_common/setup_myenv.bash` が未実装
    - どちらも `# TODO:` のみで実質機能していない
    - 必要な処理を実装するか、不要なら削除することを検討する
- [ ] feat: `lib/util_test.bash` にユニットテストを書く
    - 現状 `# TODO:` のみで空ファイルになっている
    - `lib/util.bash` の各関数に対するテストを追加する
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
    - <https://archlinux.org/packages/extra/x86_64/baobab/>
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

- [ ] docs: `hosts/README.md` のホスト情報の誤記を修正する
    - `soba` の記述が2回あり、片方は CachyOS のはずなのに Manjaro と誤記されている
    - soba は manjaro にして，別のやつを新規で cachy 用にしよう
- [ ] README.md の骨組みを完成させる
    - 他のプロジェクトで使った骨組みをそのまま持ってくれば良い
- [ ] README.md に，TODO.md, ADR.md に関する Conventions を書く
- [ ] README.md に，このプロジェクトの目的や方針を書く

- [ ] docs: README.md の TODO セクションを削除し、このファイルに一本化する
    - 移行完了後に README.md の TODO セクションを削除する
- [ ] docs: できること・できないことを README.md にまとめる
    - 時刻同期、Git の初期設定、SSH 公開鍵登録など
    - 例えば、時刻同期は GUI が楽だからそっちでやって、みたいな。
- [ ] docs: CHANGELOG.md の各バージョンセクションに内容を記入する
    - 現状 `v1.0.0` 〜 `v4.0.0` が `TODO:` のまま
- [ ] keybindings.md に、LazyVim のデフォルトのキーバインドについてまとめたものを追記することを検討する
    - [⌨️ Keymaps | LazyVim](https://www.lazyvim.org/keymaps)
        - [lazyvim.github.io／docs／keymaps.md at main · LazyVim／lazyvim.github.io](https://github.com/LazyVim/lazyvim.github.io/blob/main/docs/keymaps.md)
        - <https://raw.githubusercontent.com/LazyVim/lazyvim.github.io/refs/heads/main/docs/keymaps.md>
    - 分量が多すぎなので、別のファイルとしたほうが良いのでは？
- [ ] 自作スクリプト・コマンド（~/.bin の Bash ファイルや Zsh の関数として実装）の簡易まとめを作りたい

### プロジェクト管理

- [ ] chore: TODO.md のタスクの優先順位付けとマイルストーンへの割り当てを行う
    - このバックログへの移動が完了したら実施する
- [ ] chore: README.md の TODO セクションをこのファイルへの誘導に差し替える
