# TODO (myenv)

## Milestone: v4.9.2 - スクリプトのパフォーマンス改善

### 概要

- 日々使うスクリプトのパフォーマンスが悪いので，抜本的に見直す
- pacman のミラーリスト最適化・更新処理の改善がメイン
- 主な問題点：
    - pacman のミラーリスト最適化・更新処理が重い＆毎回走っている
    - pacman -Syu が複数回呼ばれている

### セキュリティ・バグ修正

無し。

### コード・機能

- [x] pacman のミラーリスト最適化・更新処理の改善
    - ホワイトリスト＋タイムスタンプ方式に刷新（ADR-003 参照）
- [ ] `myenv apply` コマンド（スクリプト）のボトルネックを分析する
    - pacman -Syu が複数回呼ばれている？
    - Neovim 周りも結構重そう？
    - など
- [ ] `myenv apply` の中で複数回呼ばれている `pacman -Syu` への対応を検討

### テスト・CI

無し。

### ドキュメント

無し。

### プロジェクト管理

- [ ] `/unused_confog/` を消す
    - 消して良い設定かどうかを１つ１つ確認すること
        - 設定内容を新しい設定に移植できているか

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

- テストに関する今後の方針としては、段階的に進めることを検討中
    - フェーズ1（今すぐできる）: lib/util.bash のユニットテスト
    - フェーズ2（後で考える）: インテグレーションテスト
- このマイルストーンでやることは？
    - proper7y で導入した bats-core の仕組みをそのまま流用し、
      `lib/util.bash` のユニットテストを小さく始める。
    - インテグレーションテスト（`myenv apply` を実際に実行して検証する）は、
      副作用が大きく難易度が高いため、このマイルストーンでは対象外とする。
      後続のマイルストーンで改めて検討する（後述のバックログ参照）。

### セキュリティ・バグ修正

無し。

### コード・機能

無し。

### テスト・CI

- [ ] `lib/util.bash` のユニットテストを導入する
    - **背景:** `lib/util.bash` の各関数（`link_file`、`link_dir`、`remove_unused_config` 等）は
      条件分岐が複数あり、バグが潜みやすい。一時ディレクトリを使えば副作用を閉じ込めて
      テストできるため、費用対効果が高い。
    - **方針:** proper7y と同じ構成を採用する
        - テストフレームワーク: bats-core（proper7y の `devel-tools/bin/bats` を流用）
        - テストファイルの配置: `test/unit/`
        - テストの実行: `make unit-tests` などの make ターゲットを追加
    - **実装手順（案）:**
        1. bats-core のインストール方法を決める
            - 案A: proper7y の `devel-tools/bin/bats` を参照するだけにする（バイナリを共有）
            - 案B: myenv の `devel-tools/bin/` にも同じ仕組みで管理する
            - **この選択は着手時に判断する**
        2. `test/unit/` ディレクトリを作成する
        3. `link_file` のテストを1本書いて動作確認する（小さく試す）
        4. 結果を踏まえて継続するか判断し、他の関数のテストも追加する
    - **テスト対象の優先候補:**
        - `link_file`（条件分岐が多く価値が高い）
        - `link_dir`（同上）
        - `remove_unused_config`（シンボリックリンク・通常ファイル・ディレクトリで挙動が異なる）
        - `copy_file`、`remove_file`（比較的シンプルだが念のため）
    - **対象外とする関数:**
        - `log_info` 等のログ関数（ロジックが単純すぎてテストの価値が低い）
        - `download_file`、`clone_repo_shallow`（ネットワークアクセスが必要でユニットテストに不向き）
        - `copy_file_as_root`、`remove_file_as_root`（sudo が必要）

### ドキュメント

- [ ] テストの実行方法を README.md に追記する（ユニットテスト導入後）

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

- [ ] インテグレーションテストの導入を検討する
    - **背景:** `myenv apply` は `pacman -S` や `link_file` など副作用の塊であり、
      通常の方法ではテストできない。現実的な選択肢は以下。
    - **案A:** Docker コンテナ（`archlinux:latest`）の中で `setup.bash` を実行する
        - proper7y の CI に Arch Linux を追加したのと同じ手法（ADR-033 参照）
        - パッケージの大量インストールが走るためテスト時間がかかる
    - **案B:** インストール処理は諦め、「設定ファイルの配置だけ」を検証する
        - `link_file` / `copy_file` を呼ぶ設定配置関数を一時ディレクトリで確認する
        - ユニットテストとの境界が曖昧になるが、導入コストは低い
    - **案C:** インテグレーションテストは見送り、ユニットテストだけに絞る
    - **この検討は ADR で行うべき**
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
