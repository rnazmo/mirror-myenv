# TODO (myenv)

## Milestone: v4.9.2 - スクリプトのパフォーマンス改善

### 概要

- 日々使うスクリプトのパフォーマンスが悪いので，抜本的に見直す
- 主な問題点：
    - pacman のミラーリスト最適化・更新処理が重い＆毎回走っている
    - pacman -Syu が複数回呼ばれている

### セキュリティ・バグ修正

無し。

### コード・機能

- [x] Neovim プラグイン同期の毎回実行を最適化する
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

    - **対応済み（2026-06-07）**: `myenv apply` では `Lazy! sync` を実行せず、
      Neovim plugin state の fingerprint が変わった場合だけ `Lazy! restore` / `Lazy! clean` を
      実行する方針に変更した。設計判断は ADR-006 を参照。

### テスト・CI

無し。

### ドキュメント

無し。

### プロジェクト管理

- [x] `/unused_confog/` を消す
    - 消して良い設定かどうかを１つ１つ確認すること
        - 設定内容を新しい設定に移植できているか

---

## Milestone: v4.10.0 - 構成の見直し

### 概要

プロジェクト全体のアーキテクチャを抜本的に見直す。

### 設計

- [x] アーキテクチャについての検討を進める その１（構成検討その１）
    - 検討を進めた結果「3層分離設計」にたどり着いたので，その内容を書いておく
    - （下記 `構成検討その１：「3層分離設計」` セクションを参照。かなり長いので注意。）
- [ ] 検討その２：アーキテクチャについての検討をさらに進める。
    - 「3層分離設計」についての検討がほぼ最終段階に入ってから気が付いたのだが，
      **この構造だと Arch Linux 系の OS しか対応できないのでは？**
        - 例えば **macOS や Ubuntu, Kali Linux などに対応できなそう。**
        - 現状の「endeavouros, manjaro -> arch_based」，「ubuntu, kali -> debian_based」で吸収している部分。
    - また，追加の悩み（要求）も出てきた：「マシン（hosts）ごとに，各ソフトウェアのインストールする・しないを気軽にオン・オフできるようにしたい」
    - これらを踏まえて，もう一度検討し直す。
- [ ] 将来の OS 増加を踏まえた言語ランタイム導入レイヤを検討する
    - **背景**: Kali Linux, Ubuntu, macOS などを扱う場合、Go / Node.js などの導入 backend が
      mise, apt, brew などに分かれる可能性がある。
    - **検討事項**:
        - `setup_golang` / `setup_nodejs` のような言語単位の入口を持つか
        - `install_golang_with_mise` / `install_golang_with_apt` / `install_golang_with_brew` のように backend を分けるか
        - host ごとに「インストールする・しない」「バージョンを固定する・latest にする」をどう表現するか
- [ ] mise global config の責務を再検討する
    - **背景**: 現状 `~/.config/mise/config.toml` は repo 管理ファイルへの symlink であり、
      `mise use --global` が config を更新すると `config/home/.config/mise/config.toml` に差分が出る可能性がある。
    - **検討事項**:
        - `mise use --global` の実行結果として config を更新する運用を続けるか
        - host ごとに別の mise config を持たせるか
        - mise config を「install 処理の source of truth」にするか、「補助設定・結果」として扱うか
    - **注意**: これはプロジェクト全体のアーキテクチャに関わるため、v4.10.0 の構成見直しの際の検討事項の１つとする。

### 構成検討その１：「3層分離設計」

#### 現状の主な悩み

2026年6月時点の悩み：

- **「コードが追いにくい」**: `source` による暗黙的な関数継承と、600行超の巨大ファイルが組み合わさって
  全体の見通しが悪い。
- **「設定を変更するとき、どこを直せばいいかわからない」**: たとえば Neovim の設定を変えたいと思っても、
  `host → recipe → 1_base → ネストした関数呼び出し` という階層を頭の中でトレースしなければならない。

これらの根本原因は「構造が環境中心（どのOSか）になっているのに、人間は機能中心（何のセットアップか）で
考える」というミスマッチにある。解決策として「3層分離設計」を採用する方針を検討するした。

#### 根本原因の分析

**現状の構造（環境中心）:**

```
host (udon)
  └── recipe (endeavouros_x64)
        └── _arch_based_x64/1_base.bash  ← 600行超の巨大ファイル
              └── setup_editor()
                    └── _setup_neovim()
                          └── __install_neovim()
                          └── __setup_neovim_config()
```

「Neovim の設定を変えたい」という動機で作業するとき、上記の階層を手動でトレースする必要がある。
また `1_base.bash` にシェル・ターミナル・エディタ・IME・デスクトップがすべて混在しているため、
読むだけでも辛い。

**2軸問題:**

このプロジェクトには独立した2つの軸がある。

```
         shell  editor  terminal  ime  desktop
arch       ○      ○       ○       ○      ○
cachyos    ○      ○       ○       ○      ○
manjaro    ○      ○       ○       ○      ○
```

「機能 × OS」の交点をどこに書くかが設計の核心で、どちらかの軸に寄せると必ずもう一方の軸の情報が散らばる。

- **機能ファイルに書く場合**: OS固有コードが各機能ファイルに散らばる。
  「CachyOS では p10k インストール前に競合パッケージを消す必要がある」という知識が
  `shell.bash` の中に埋まることになり、OS固有コードを探すのが大変になる。
- **OSファイルに書く場合（現状）**: 機能コードがOSファイルに散らばる。
  「Neovim のセットアップ内容」を知るために OS ファイルを読まなければならない。

唯一きれいに解決できるのは「両軸を完全に分離し、間に抽象層を置く」設計。

#### 検討した代替ツール（不採用の理由とともに）

作業着手時の参考のため、過去に検討したツールの経緯を残しておく。
結論から言うと、いずれも不採用。Bash で書き続けるが、アーキテクチャを根本から見直す。

**chezmoi:**
dotfiles 管理に特化したツール。テンプレート機能でOS差分を吸収できる。
不採用の理由: 独自のファイル構成・記法への習熟コストが高く、ここで得た知識が他に活かしにくい。
「ソフトのインストールや各種スクリプトの実行」を柔軟にたくさん書こうとすると設計が歪になり、
chezmoi である利点が薄れる。複数マシン・複数アカウントの管理も辛そうだった。
実際に検討済み。

**mitamae:**
Ruby 製の軽量プロビジョニングツール。
不採用の理由: 学習コストが高い。ドキュメントが少なく、トラブル時の対応が困難。
実際に試して検討済み。

**Ansible:**
冪等性を標準で保証する、定番のプロビジョニングツール。YAML で宣言的に書く。
不採用の理由: 遅い。

**Nix / Home Manager:**
宣言的・再現性が高い・ロールバック可能。最も強力な選択肢。
不採用の理由（当時）: 学習コストの高さと普及率の低さ（数年前時点）。
現在の評価: 最近流行っている雰囲気を感じる。今なら再検討の余地あり。ただしどうせある程度の処理は
Bash スクリプトが必要になるため、純粋に Bash で設計を整理する方針を先に試みることにした。
したがって，今現在も有力な選択肢として検討中である。

#### 提案する設計: 3層分離

**ディレクトリ構造:**

```
myenv/
├── lib/
│   ├── util.bash           # 既存のユーティリティ関数（変更なし）
│   └── platform.bash       # ★新規: フックのデフォルト実装（何もしない関数群）
│
├── components/             # ★新規: 「何をするか」だけを知っている（OS知識ゼロ）
│   ├── shell.bash
│   ├── editor.bash
│   ├── terminal.bash
│   ├── ime.bash
│   ├── desktop.bash
│   ├── util.bash
│   └── devel.bash
│
├── platforms/              # ★新規: 「OSの差分だけ」を知っている（機能の中身を知らない）
│   ├── arch.bash           # Arch系共通の差分
│   ├── cachyos.bash        # CachyOS固有の差分のみ
│   ├── manjaro.bash        # Manjaro固有の差分のみ
│   └── endeavouros.bash    # EndeavourOS固有の差分のみ
│
├── hosts/
│   ├── udon/setup.bash     # 変更あり: 組み合わせを宣言するだけ
│   └── soba/setup.bash
│
└── recipes/                # 最終的には削除
```

**3層の役割と依存関係:**

```
hosts/setup.bash
  ├── source lib/platform.bash      # デフォルトフック読み込み
  ├── source platforms/cachyos.bash # OS固有フックで上書き
  └── source components/*.bash      # 機能を読み込む
        └── platform_*() を呼ぶ     # フック経由でOSに委譲
```

各層の責務:

- `lib/platform.bash`: 全フックのデフォルト実装（`{ :; }` = 何もしない）。
  どのOSでも「特別な処理がなければ何もしない」が保証される。
- `platforms/cachyos.bash`: CachyOS固有の差分だけを書く。
  `arch.bash` を source したうえで、異なる部分だけフック関数をオーバーライドする。
- `components/shell.bash`: OSを一切知らない。
  `platform_*` という名前の関数を呼ぶだけで、その実装はロードされたプラットフォームファイルが決める。
- `hosts/udon/setup.bash`: どのプラットフォームを使うかを宣言し、コンポーネントを並べて呼ぶだけ。

**各ファイルの具体的なコードイメージ:**

`lib/platform.bash`（デフォルト実装）:

```bash
# すべてのフックのデフォルト。
# 何も特別なことがないOSはこれが使われる。
# 今後OS差分が見つかるたびに、ここにデフォルト定義を追加していく。
platform_pre_install_p10k() { :; }
```

`platforms/cachyos.bash`（差分だけ書く）:

```bash
source "${MYENV_ROOT}/platforms/arch.bash"

# CachyOS だけ: 競合パッケージを先に消す必要がある
platform_pre_install_p10k() {
    local -r pkgs=("cachyos-zsh-config" "zsh-theme-powerlevel10k")
    for pkg in "${pkgs[@]}"; do
        pacman -Qi "$pkg" &>/dev/null && yay -Rns --noconfirm "$pkg" || true
    done
}
```

`components/shell.bash`（OSを一切知らない）:

```bash
setup_shell() {
    _install_zsh
    _setup_zsh_config
    _setup_zsh_theme
    _setup_zsh_plugins
    _setup_default_shell
}

_setup_zsh_theme() {
    platform_pre_install_p10k  # OSに「何か準備ある?」と委譲するだけ
    yay -S --needed --noconfirm zsh-theme-powerlevel10k-git
}
```

`hosts/udon/setup.bash`（組み合わせを宣言するだけ）:

```bash
source "${MYENV_ROOT}/lib/util.bash"
source "${MYENV_ROOT}/lib/platform.bash"           # デフォルト読み込み
source "${MYENV_ROOT}/platforms/endeavouros.bash"  # OS固有で上書き

source "${MYENV_ROOT}/components/shell.bash"
source "${MYENV_ROOT}/components/editor.bash"
source "${MYENV_ROOT}/components/terminal.bash"
source "${MYENV_ROOT}/components/ime.bash"
source "${MYENV_ROOT}/components/desktop.bash"
source "${MYENV_ROOT}/components/util.bash"
source "${MYENV_ROOT}/components/devel.bash"

main() {
    setup_shell
    setup_editor
    setup_terminal
    setup_ime
    setup_desktop
    setup_util
    setup_devel
}

main
```

#### 着手前に決めておくべき設計上の問題

以下は実装に入る前に方針を決定し、ADR に記録すること。

**①フック名の命名規則:**
現在の案は `platform_{タイミング}_{対象}` 形式（例: `platform_pre_install_p10k`）。
別の候補として `platform_hook_{component}_{event}` 形式もある（例: `platform_hook_shell_pre_p10k`）。
後者の方がどのコンポーネントのフックかが明確だが、冗長になりやすい。
着手時に一方に統一してから実装を始めること。

**②`platforms/` 内の継承構造:**
現状の `recipes/` では `cachyos_x64/1_base.bash` が `_arch_based_x64/1_base.bash` を source している。
新設計の `platforms/` でも同様に `cachyos.bash` が `arch.bash` を source する形にするか、
それとも完全に独立させて `lib/platform.bash` のデフォルトだけを頼りにするかを決める。
差分が少ないうちは後者の方がシンプルかもしれない。
前者の場合、`arch.bash` に「Arch系共通だがデフォルトと違う処理」を書くことになる。

**③`0_core.bash` 相当の処理をどのコンポーネントに対応させるか:**
現状の `0_core.bash`（pacman ミラー更新、Git、AUR helper、mise、言語インストールなど）は
「機能のセットアップ」というよりも「セットアップ全体の前提条件」に近い。
`components/core.bash` として独立させるか、`hosts/udon/setup.bash` 内に直接書くかを決める。

**④移行戦略（段階的 vs 一括置き換え）:**
`recipes/` を残したまま `components/` と `platforms/` を新規作成して段階的に移行するか、
一気に置き換えるかを決める。
段階的移行は安全だが、移行期間中に新旧が混在して逆に混乱しやすい。
コミットを機能ごとに細かく切りながら一括で置き換える方が、最終的にはシンプルかもしれない。

**⑤`components/` 内のパッケージマネージャー抽象化をどこまでやるか:**
現状はすべての対象OSが Arch 系のため `pacman`/`yay` が直書きされている。
将来 Debian 系に対応する可能性があるなら、パッケージマネージャーの呼び出しも
`platform_install_pkg()` のような形で抽象化すべきだが、
対応する予定がないなら過剰設計になる。
当面は Arch 系のみ前提で進め、必要になったときに抽象化する方針で良いと思われる。

#### 実装の進め方（案）

このタスクは影響範囲が広いため、**実装前に必ず ADR-004 を書いて承認を得ること**。
ADR に書くべき内容:

- 根本原因の分析（2軸問題）
- 検討した代替案（ツール変更、機能ファイル内でのOS分岐など）
- 決定した設計（3層分離）
- 着手前に決めておくべき設計問題（上記4点）の最終決定
- トレードオフ（移行コスト、Bash の限界、今後の拡張性）

### セキュリティ・バグ修正

無し。

### コード・機能

未定。

### テスト・CI

未定。

### ドキュメント

未定。

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

## Milestone: v4.X.0 - 各ツールの設定を見直す

### 概要

- 各種ツールの設定を見直す

### セキュリティ・バグ修正

無し。

### コード・機能

- [ ] tmux の設定の改善点を洗い出し，`TODO.md` に記載する
- [ ] Alacritty の設定の改善点を洗い出し，`TODO.md` に記載する
- [ ] Neovim, LazyVim の設定の改善点を洗い出し，`TODO.md` に記載する
- [ ] Zsh, p10k の設定の改善点を洗い出し，`TODO.md` に記載する
- [ ] Git, LazyGit の設定の改善点を洗い出し，`TODO.md` に記載する
- [ ] Zsh のエイリアスを整えたい
    - `l` で `ls` できないのが不便なので、それっぽいコマンドを l に割り振る
    - エイリアスの一覧と簡易解説のドキュメントも欲しい。 `docs/commands.md` などにまとめるのが良さそう。

### テスト・CI

無し。

### ドキュメント

- [ ] Neovim(LazyNvim) のメンテナンスとして日々行うべきことをドキュメント化する
    - README.md のワークフローに追加する
    - プラグインの更新とかそういったこと
    - どのタイミング、どの頻度で？
    - LazyVim の管理画面から行える操作で大体簡潔するようだ
        - 管理画面の開き方は、Neovim を起動して、 :Lazy コマンドを入力するまたは`Space -> L`
    - Ref: [🚀 Usage | lazy.nvim](https://lazy.folke.io/usage)

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

- [ ] mise 管理ツールのバージョン固定方針を検討する
    - **背景**: `go = "latest"` や `node = "latest"` は便利だが、日々の更新でランタイムが変わりうる。
    - **検討事項**:
        - `latest` を維持するか
        - `go = "1.22.0"` のように固定するか
        - host ごと・用途ごとにバージョン固定方針を変えるか
    - **注意**: これは再現性の改善であり、v4.9.2 内で行った「`mise use --global` 毎回実行のパフォーマンス改善」とは別論点として扱う。
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
