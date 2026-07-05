# TODO (myenv)

## Milestone: v4.11.0 - 各ツールの設定を見直す

### 概要

- 各種ツールの設定を見直し、各設定ファイルに記載された TODO に対応する

### セキュリティ・バグ修正

無し。

### コード・機能

#### Alacritty

- [ ] Alacritty の設定を確認する（現状ミニマル設定で課題なし → 現状維持で問題なければ close）
    - Ref: `config/home/.config/alacritty/alacritty.toml`

#### Neovim / LazyVim

- [ ] `lua/plugins/lsp.lua` の未対応フォーマッタ・リンターを追加する
    - 不足: scss, toml, cpp, sql, jsx の formatter/linter 設定
- [ ] `lua/config/keymaps.lua` のキーバインド TODO に対応する（ペイン/タブ移動など 6件）
- [ ] `lua/plugins/editor.lua` に dial の `g<C-a>` / `g<C-x>` を追加する
- [ ] `lua/plugins/coding.lua` の nvim-cmp 残骸を掃除する（blink.cmp 移行後のクリーンアップ）
- [ ] `lua/plugins/ui.lua` のステータスライン（lualine）を改善する
- Ref:
    - `lua/plugins/lsp.lua`
    - `lua/config/keymaps.lua`
    - `lua/plugins/editor.lua`
    - `lua/plugins/coding.lua`
    - `lua/plugins/ui.lua`

#### Zsh / p10k

- [ ] `_aliases.zsh` の TODO に対応する
    - `myenv sync` サブコマンドの追加
    - 引数バリデーションの改善
    - `_bump_nvim_plugins` のロジックを適切な場所に移動
- [ ] `_completions.zsh` の TODO に対応する（補完追加、zcompdump キャッシュ）
- [ ] Zsh のエイリアスを整える
    - `l` で `ls` できない問題の解決
    - エイリアスの一覧と簡易解説のドキュメントも欲しい。 `docs/commands.md` などにまとめるのが良さそう。
- Ref:
    - `zshrc.d/_aliases.zsh`
    - `zshrc.d/_completions.zsh`
    - [あなたのzshは何ms？zsh-benchで測ってから起動高速化 | eiji.page](https://eiji.page/blog/zsh-fast-start/)

#### Git / LazyGit

- [ ] Git 設定を見直す（discard alias の動作確認・修正など）
- [ ] LazyGit の設定を確認する（現状課題なし → 現状維持で問題なければ close）
- Ref:
    - `config/home/.config/git/config`
    - `config/home/.config/lazygit/config.yml`

#### tmux

- [ ] tmux の設定を見直し、`tmux.conf` の TODO に対応する
    - コピーモード設定（クリップボード周りと統合）
    - セッション番号の振り直し設定
    - キーバインドの TODO（フォーカス移動、swap など）
    - tpm プラグインの導入を検討
- Ref:
    - `config/home/.config/tmux/tmux.conf`
    - [tmuxのPane/Window移動を少し便利にする – Portablecode.info](https://portablecode.info/2026/02/14/tmux-pane-window-move/)
    - [tmuxのコピーモードを解説！チュートリアルとおすすめ設定 | eiji.page](https://eiji.page/blog/tmux-conf-copy-mode/)
    - [Clipboard · tmux／tmux Wiki](https://github.com/tmux/tmux/wiki/Clipboard)

#### Browser

- [ ] Chrome のインストール方法を調査・実装する
    - `components/browser.bash` の `setup_chrome` → `platform_install_chrome` が未実装
    - `platforms/0_common/default.bash` に no-op のデフォルトが必要
    - `platforms/1_families/arch_based.bash` に AUR/google-chrome 経由の実装が必要

#### ツール追加・設定拡充

- [ ] bat の設定ファイルを追加する（Backlog #241 から昇格）
- [ ] yazi の設定を充実させる（カスタマイズ TODO 対応）
    - Ref: `config/home/.config/yazi/yazi.toml`
- [ ] VS Code の設定を全面的に見直す（settings.json, keybindings.json）
    - Ref: `config/home/.config/Code/User/settings.json`
    - Ref: `config/home/.config/Code/User/keybindings.json`
- [ ] aqua のインストーラがアーキテクチャ/バージョンをハードコードしているのを直す
    - `components/core.bash` の `_install_aqua`: `AQUA_VERSION`, `OS`, `ARCH`, `CHECKSUMS` がすべて固定値
    - ARM 環境で動かす際に `uname -s`/`uname -m` の動的取得とチェックサムの分岐が必要
    - 現状 aqua は使っていないため優先度低
- [ ] aqua に管理対象パッケージを追加する（現状 packages が空）
    - Ref: `config/home/.config/aquaproj-aqua/aqua.yaml`

#### 開発ワークフロー

- [ ] 開発ワークフロー自体の見直し
    - Ref:
        - [tmuxマルチセッション運用——AI時代を1キーバインドで乗り切る | eiji.page](https://eiji.page/blog/tmux-multi-sessions/)
        - [AI時代のブランチ操作を最適化した――2026年5月 | eiji.page](https://eiji.page/blog/git-my-flow-2026-05/)

### テスト・CI

無し。

### ドキュメント

- [ ] Neovim（LazyVim）のメンテナンスとして日々行うべきことをドキュメント化する
    - README.md のワークフローに追加する
    - プラグインの更新とかそういったこと
    - どのタイミング、どの頻度で？
    - LazyVim の管理画面から行える操作で大体完結するようだ
        - 管理画面の開き方は、Neovim を起動して、`:Lazy` コマンドを入力するまたは `<Space>l`
    - Ref: [🚀 Usage | lazy.nvim](https://lazy.folke.io/usage)

### プロジェクト管理

無し。

## Milestone: v4.12.0 - 設計の文書化と暗黙的依存の解消

### 概要

ADR だけではプロジェクト全体像を掴むのが難しくなってきた。
アーキテクチャ概説書 (ARCHITECTURE.md) を作成し、各層の責務・制御フロー・
依存関係・よくある変更パターンを明示する。

### セキュリティ・バグ修正

無し。

### コード・機能

#### アーキテクチャ文書

- [ ] ARCHITECTURE.md を作成する
    - ディレクトリ構成の意味 (components / platforms / hosts の責務)
    - 制御フロー: setup.bash → host → platform → component のつながり
    - 命名規則: setup*\*, platform*\*, \_private のルール
    - 読み込み順の依存: source chain の仕組みと制約
    - スタンプファイルによる実行制御
    - よくある変更パターン: 「新しいツールを追加する」「新OSに対応する」手順

### プロジェクト管理

無し。

---

## Milestone: v4.X.0 - `myenv` コマンドの再設計

### 概要

- ADR-006 で整理した `myenv apply` を日常コマンドとして位置付ける方針を踏まえ、コマンド全体の設計を見直す
- 特に、ADR-006 では暫定的な対処をした `myenv bump` を含む update / refresh 系コマンドの設計については、
  抜本的に見直す必要がある

### セキュリティ・バグ修正

無し。

### コード・機能

- [ ] `myenv` コマンドのサブコマンド全体の設計を見直す
    - ADR-006 も参照。
    - 各コマンドの責務とか使い分けは？
- [ ] `myenv bump` を含む update / refresh 系コマンド全体の再設計
    - **背景**: ADR-006 にて、`myenv apply` は repo に記録された状態へ収束させる日常コマンドとして整理した。
      一方、upstream を見に行く重い更新処理をどこへ集約するかは未整理。
    - **検討事項**:
        - `myenv bump` という名前を維持するか、`myenv update` / `myenv refresh` などに変えるか
        - Neovim に限らず pacman / mise / aqua などの更新処理をどう分けるか
        - commit / push まで自動化する処理と、更新だけ行う処理を分けるか
        - 実装方法をどうするか。Zsh の関数には、スクリプトの呼び出し（や、例外的に Git の操作）などの
          薄い操作しか書きたくない。一方で現状において、コマンドの１つ下のレイヤにおいて、このプロジェクト
          の主たる処理のエントリーポイントとなっていたのは `/setup.bash` だけであった。これを崩すことになる？
          その場合、`/myenv/cmd/apply.bash` のような感じに再構成した方が良いのか？

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
- [ ] `zsh-theme-powerlevel10k-git` の Flagged Out Of Date 警告への対応を検討する
    - **問題**: `myenv apply` を実行するたびに `yay -Syu` が4回走り、その都度
      `-> Flagged Out Of Date AUR Packages: zsh-theme-powerlevel10k-git` という警告が出る。
      ログで確認済み（2026-06-05）。
    - **背景**: `zsh-theme-powerlevel10k` は開発が停滞気味で、AUR パッケージが
      Flagged Out Of Date になっている。実害（動作不良）は現時点では確認されていない。
    - **対応方針の候補**:
        - 案A: 警告を無視して使い続ける（現状維持）。動作している間は問題ない。
        - 案B: 代替テーマへの移行を検討する（例: starship, oh-my-posh）。
          移行コストは高いが、長期的にはメンテナンスが楽になる可能性がある。
          ただし，パフォーマンスは大幅に下がる可能性が高い。
        - 案C: `yay -Syu` の重複呼び出し解消（上のタスク）で警告の表示回数は
          自然に4回→1回に減る。まずそちらを先に対応し、残り1回の警告は許容する。
    - **優先度**: 低。動作には影響しないため、`pacman -Syu` 重複解消タスクより後でよい。
    - Zsh (シェル) のテーマ自体を再選定（技術選定）し，その ADR を書くべき
    - Ref:
        - [AUR (en) - zsh-theme-powerlevel10k-git](https://aur.archlinux.org/packages/zsh-theme-powerlevel10k-git)
        - [romkatv／powerlevel10k: A Zsh theme](https://github.com/romkatv/powerlevel10k#arch-linux)

### コード・機能

- [ ] ログをファイルに出力する機能を追加する
    - **背景:** `myenv apply` の実行ログは標準出力にしか出ないため、後から確認できない。
      ログをファイルに出力する仕組みがあると便利。
    - **検討事項:**
        - 何をどの程度の粒度でログに出力するべきか
        - ログの保存先ディレクトリはどこにするか（`~/.cache/myenv/logs/` など）
        - ログのローテーション・古いログの削除はどうするか
        - 標準出力とログファイルの両方に出すか、ログファイルだけにするか
    - ログ周りの設計の勉強にもなりそう
- [ ] udon, soba でインストールしているソフトウェアの構成を見直す
- [ ] コマンド（スクリプト）の書くコマンドのパフォーマンスを計測し、改善する
    - 計測手法はどうする？
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
- [ ] fix: `___install_powerlevel10k` の関数プレフィックス規約違反を修正する
    - `___install_powerlevel10k` は `cachyos_x64/1_base.bash` と
      `_arch_based_x64/1_base.bash` の両方から呼ばれており、
      「`__` プレフィックスの関数からのみ呼ばれる」という規約に違反している
    - 関数の配置・命名を見直して規約に沿った構造に修正すること
- [ ] feat/docs: `link_file` と `copy_file` の使い分け基準を決めて明文化・適用する
    - 現状、どちらを使うかの判断基準が暗黙的で曖昧な状態
    - 基準を決めたうえで README.md の Conventions に追記し、
      既存コードが基準に沿っているか確認・修正すること
- [ ] feat: `platforms/_init.bash` の導入を検討する
    - **背景**: 現在は host 側が platform ファイルを直接 source しているが、OS 追加時に host ファイルの修正が増える。
      `components/_init.bash` と同様の仕組みを `platforms/` にも導入すれば、host 側の記述を1行に減らせる。
    - **課題**: platform は階層構造（common → families → distros）があり、単純な機械的読み込みでは source 順が制御できない。
      明示的な順序制御の仕組みと組み合わせる必要がある。
    - **検討事項**:
        - host 側で source 順を宣言し、`platforms/_init.bash` がその順に従って読み込む方式
        - または host は相変わらず明示的に source し、`platforms/_init.bash` は作らない（現状維持）
    - Ref: ADR-009 のディレクトリ構造・依存関係図

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
- [ ] README.md を英語で書き直すことを検討する
- [ ] コメントの言語を日本語か英語で統一する
    - `lib/util.bash` に日本語コメントが残っている
    - 現状「英語に統一する」というルールは明文化されていないため、ADR の要不要も合わせて検討
    - 優先度: 低

### プロジェクト管理

- [ ] chore: TODO.md のタスクの優先順位付けとマイルストーンへの割り当てを行う
    - このバックログへの移動が完了したら実施する
- [ ] chore: README.md の TODO セクションをこのファイルへの誘導に差し替える
- [ ] `.markdownlint-cli2.yaml` は不要では？
- [ ] `.shellcheckrc` は不要では？
