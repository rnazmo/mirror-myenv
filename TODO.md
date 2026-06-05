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
- [x] `myenv apply` コマンド（スクリプト）のボトルネックを分析する
    - 分析結果は以下の各タスクにまとめた
- [ ] 🔴【重大】`pacman -Syu` の重複呼び出しを解消する
    - **問題**: `myenv apply` を1回実行するたびに `pacman -Syu` が最低4回呼ばれている
    - **ログで確認済み（2026-06-05）**: 実際のログで `pacman -Syu` が4回、`yay -Syu` も4回走っていることを確認した。
      いずれも `there is nothing to do` で終わっているため、この日は実害はなかったが、
      パッケージ更新がある日はその分だけ時間が伸びる。また `yay` は AUR の `zsh-theme-powerlevel10k-git`
      が Flagged Out Of Date であるという警告も毎回4回出ている。
    - **呼ばれる箇所**（`_arch_based_x64/0_core.bash` と `1_base.bash` と `2_extra.bash` を読むと確認できる）:
        1. `pre_setup_core > _refresh_packages`（ミラー更新前）
        2. `pre_setup_core > _refresh_packages`（`update_pacman_mirror` の直後）
        3. `pre_setup_base > _refresh_packages`
        4. `pre_setup_extra > _refresh_packages`
    - **なぜ重いか**: pacman はリモートのパッケージDBを毎回ダウンロードして差分チェックするため、
      ネットワークI/Oが必ず発生する。1回あたり数秒〜数十秒かかる。
    - **改善方針の候補**:
        - 案A: `pacman -Syu` にもタイムスタンプ制御を入れ、1日1回までに制限する
            - `update_pacman_mirror` の `_should_update_mirror` と同じ仕組みで実現できる
            - スタンプファイル例: `~/.cache/myenv/pacman_last_updated`
            - メリット: 毎日 `myenv apply` を複数回実行しても1日1回しか走らない
            - デメリット: 「今すぐ最新にしたい」場合はスタンプファイルを手動削除する必要がある
        - 案B: `pre_setup_core` の1回目の `_refresh_packages`（ミラー更新前）を削除する
            - ミラー更新前に走る意味が薄い（古いミラーで更新しても無駄になる可能性がある）
            - ただしこれだけでは3回→3回（タイムスタンプスキップ時は2回）にしか減らない
        - 案C: `pre_setup_base` と `pre_setup_extra` の `_refresh_packages` を削除し、
          `pre_setup_core` の末尾の1回に集約する
            - 「core → base → extra の順に実行するので core で更新すれば十分」という考え方
            - メリット: シンプルに重複が消える
            - デメリット: base や extra の処理が長時間かかる場合、その間にパッケージが
              古くなる可能性がある（現実的には問題にならないと思われる）
        - 案A + 案B + 案C の組み合わせが最も効果が高いと思われる
    - 要調査：
        - そもそも，`pacman -Syu` は何を行っているのか。また，`pacman -Syu` はどのタイミングで（・どの頻度で）行うべきなのか
    - **実装の注意点**:
        - `update_pacman_mirror` の設計方針（ADR-003）と一貫性を持たせること
        - タイムスタンプを強制リセットする手順を README.md の「ワークフロー」に追記すること
- [ ] 🟡【中程度】`pre_setup_core` 内の二重 `_refresh_packages` を整理する
    - **問題**: `pre_setup_core` の中で `_refresh_packages` が連続して2回呼ばれている
        ```
        _refresh_packages      # 1回目（ミラー更新前）
        update_pacman_mirror
        _refresh_packages      # 2回目（ミラー更新後）
        ```
    - **経緯**: 「新しいミラーで改めて更新する」意図で2回呼ぶ設計になっている
    - **問題点**: `update_pacman_mirror` がタイムスタンプでスキップされる日（7日以内）でも
      1回目は必ず走る。ミラーが変わっていない日に1回目を実行する意味はない。
    - **改善方針**: 上の「`pacman -Syu` の重複解消」タスクと合わせて対応するのが自然。
      単体で対応するなら「1回目を削除して2回目だけ残す」のが最もシンプル。
    - このタスクは上の「`pacman -Syu` の重複解消」タスクを対応する際に合わせて潰すこと
- [ ] 🟡【中程度】`mise use --global` の毎回実行を最適化する
    - **問題**: `setup_programming_languages` 内の以下が毎回実行される
        ```bash
        mise use --global go@latest
        mise use --global node@latest
        ```
    - **なぜ遅い可能性があるか**: `mise` はリモートのバージョン情報を確認しにいく場合があり、
      すでに最新がインストール済みでもネットワークアクセスが発生しうる
    - **改善方針の候補**:
        - 案A: `mise` にもタイムスタンプ制御を入れる（`pacman -Syu` と同じ方針）
        - 案B: `mise outdated` で更新が必要な場合のみ `mise use` を実行する
            - `mise outdated` の終了コードや出力で判定できるか要確認
        - 案C: `latest` ではなくバージョンを固定する
            - `config/home/.config/mise/config.toml` で `go = "1.22.0"` のように固定すれば
              ネットワークアクセスが減る可能性がある
            - デメリット: バージョンの手動更新が必要になる
     - **ログで確認済み（2026-06-05）**: ログ上ではスピナー（`◜`）が回っており、処理に時間がかかっている
       ことは確認できたが、所要時間は出力されていない。実際の時間は以下で計測すること:
       ```bash
       time mise use --global go@latest
       time mise use --global node@latest
       ```
       計測結果をこのタスクに追記してから、対応方針を決定すること。
- [ ] 🟢【軽微】Neovim プラグイン同期の毎回実行を最適化する
    - **問題**: `__refresh_neovim_plugins` 内の以下が毎回実行される
        ```bash
        nvim --headless "+Lazy! sync" +qa
        ```
    - **なぜ遅いか**: Neovim の起動 + lazy.nvim の同期チェック（リモート確認を含む）で
      数秒〜十数秒かかる
    - **改善方針の候補**:
        - 案A: `lazy-lock.json` のハッシュをタイムスタンプ代わりに使い、
          ファイルに変化がない場合はスキップする
            - `git diff --quiet lazy-lock.json` で変化を検出できる
            - ただし「lock ファイルは変わっていないがプラグインが壊れている」ケースは検出できない
        - 案B: `myenv apply` からは除外し、`myenv bump` 実行時のみ同期する
            - デメリット: 新規セットアップ時に手動で同期が必要になる
        - 案C: タイムスタンプで週1程度に制限する（`pacman -Syu` と同じ方針）
    - **ログで確認済み（2026-06-05）**: fetch タスクが最長約11秒（`neotest-golang` の fetch が 10897ms）かかっており、
    全体で約11秒の同期処理が発生していた。この日は実際に複数プラグインの更新（checkout）が走っており、
    `there is nothing to do` の日より長くなっている可能性がある。
    更新がない日の時間も計測しておくこと:
    ```bash
    time nvim --headless "+Lazy! sync" +qa
    ```

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

### プロジェクト管理

- [ ] chore: TODO.md のタスクの優先順位付けとマイルストーンへの割り当てを行う
    - このバックログへの移動が完了したら実施する
- [ ] chore: README.md の TODO セクションをこのファイルへの誘導に差し替える
- [ ] `.markdownlint-cli2.yaml` は不要では？
- [ ] `.shellcheckrc` は不要では？
