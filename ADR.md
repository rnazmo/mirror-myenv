# ADR (myenv)

<!-- ADRs are listed in reverse chronological order (newest first). -->

## ADR-011 真偽値関数は副作用を持たせない

- **日付**: 2026-06-26
- **ステータス**: 採用

### コンテキスト

`lib/util.bash` の `is_virtualized_environment` は、`systemd-detect-virt -q` の判定結果に加えて
日本語メッセージの `echo` を副作用として持っていた。

一方、同ファイルの `is_virtualbox_guest` は副作用を持たない静かな判定関数であり、同じレイヤで
一貫性がなかった。

### 決定

1. `is_virtualized_environment` から `echo` を削除し、副作用のない関数とする
2. 本プロジェクトで今後 `is_*` / `has_*` / `check_*` など真偽値を返す関数を書くときは、
   ログ出力・画面表示などの副作用を含めない

```bash
# is_valid_*, check_*, has_*, などの真偽値関数:
#   ✅ return 0 / 1 のみ
#   ❌ echo / log_info / log_err を中に書かない

# 呼び出し側で必要なら明示的にログを出す
if ! is_virtualized_environment; then
    log_info "Not in a VM — skipping guest setup"
fi
```

### 理由

- **Command-Query Separation (CQS)**: 問い合わせ (query) は値を返し、副作用を持たない。
  真偽値関数は問い合わせであり、`echo` や `log_info` は副作用にあたる
- **一貫性**: `is_virtualbox_guest` がすでに副作用なしで書かれている
- **構成可能性**: 副作用があると `$(is_xxx)` や `if is_xxx && is_yyy` のような
  コンテキストで予期せぬ出力が混入する

### トレードオフ

- 真偽値関数内でデバッグログを出力したい場合、呼び出し元で明示的に書く必要がある
- ただし関数が短く責務が明確になるため、むしろ可読性は向上する

## ADR-010 言語・ツール選定の理由

- **日付**: 2026-06-17（記録作成日。決定自体はプロジェクト開始時）
- **ステータス**: 記録（過去の技術選定の理由を事後的に文書化したもの）

### コンテキスト

プロジェクト myenv は Bash で書かれている。Bash は汎用プログラミング言語（Go など）や宣言的環境管理（Nix など）と比較すると、型安全性・IDE サポート・エラーハンドリング・テスタビリティの面で見劣りする。それにもかかわらずこのプロジェクトが Bash を採用しているのには、言語機能の優劣とは別の理由がある。その理由を明文化し、将来の技術選定の判断材料として記録する。

### 検討した代替案（暗黙的）

以下の選択肢はプロジェクトの歴史上、常に「ありうる選択肢」として存在していたが、これまで意識的な検討は行われてこなかった。
本 ADR はその検討を事後的に記録する。

**案A: Bash 継続（現状）**

プロジェクトを Bash で書き続ける。OS のパッケージ管理や設定ファイルの操作を、シェルスクリプトの形で直接記述する。

**案B: Go への書き換え**

バイナリ1つで動く高速なプロビジョニングツールに書き換える。型安全・クロスコンパイル・テストの書きやすさなどの恩恵が得られる。
私も Go には慣れており、書き換えの障壁は低い。
ただし「処理の記述」が Go の言語仕様（変数宣言・エラーハンドリング・ビルド手順など）のノイズを伴う。

**案C: Nix / Home Manager への移行**

宣言的な環境管理を導入する。再現性・ロールバック・依存関係管理は最も優れている。
ただし学習コストが高く、ファイル構成や記法が独特であり、プロジェクトの精神である「だいたい動けば十分」と相反する。

### 決定

案A（Bash 継続）を採る。これはプロジェクト開始時からの暗黙の選択であり、本 ADR はその理由を明文化するものである。

### 理由

Bash の最大の強みは、**「処理の記述がコマンドラインから叩く生の操作に近い」** ことにある。

```bash
# Bash: ほぼそのままコマンドラインで打つ操作
pacman -S --needed --noconfirm neovim
ln -sf "${MYENV_ROOT}/config/home/.config/nvim" "${HOME}/.config/nvim"
```

このコードを読むことは、**自分がターミナルで打つ操作をシミュレートすること**とほぼ等しい。
スクリプトの実行フローを頭で追うときに、「ああ、これは pacman で neovim を入れて、設定を symlink してるんだな」と、
コマンドの意味がそのまま理解できる。

この性質がもたらすもの:

1. **可読性 = 操作の追跡可能性**: コードを読むことが「何が起きるか」の予測と一致する。余計な抽象化レイヤを通過する必要がない
2. **デバッグの容易さ**: スクリプトが失敗したとき、問題の箇所をそのままコマンドラインにコピーして単体実行できる。「スクリプトの中のこの行がおかしい」が「このコマンドがおかしい」に直結する
3. **段階的な記述が可能**: コマンドラインで試して通った操作を、そのままスクリプトにコピー&ペーストできる。試行錯誤のサイクルが短い

Go や Nix と比較する:

- **Go**: 型安全で IDE サポートは充実しているが、`exec.Command("pacman", "-S", "--noconfirm", "neovim")` のような記述は、コマンドラインの操作との間に乖離がある。コードを読むときに「この exec は何を実行するのか」を脳内でデコードする必要が生じる
- **Nix**: 宣言的な記述は再現性に優れるが、Nix 言語の記法と実際の OS 操作の間に大きな隔たりがある。`environment.systemPackages = [ pkgs.neovim ]` が具体的にどのような OS 操作に対応するかは、Nix のビルド機構の知識なしには理解できない

### トレードオフ

- Bash の言語的限界（型安全・IDE サポート・テスト容易性など）は受け入れる。これらは Go や Nix と比較して明らかな弱点である
- 複雑なロジック（バリデーション、制御フローの深い分岐、データ変換など）が必要な処理は、Bash で書かずに外部ツール（Go 製 CLI や専門の言語）に委ねる方針と組み合わせる
- Bash の可読性が最大限発揮されるのは「コマンドライン操作の自動化」というスコープに限定される。このスコープを超えた処理ではむしろ可読性が急激に下がる

### 今後の検討事項

- **スコープの拡大**: Bash で書くのが明らかに不適切な粒度の処理（複雑なバリデーション、状態管理など）が出てきた場合、Go や Ruby など別言語での実装を一部導入する可能性を検討する
- **Nix への移行**: ADR-009 でも触れた通り、Nix/Home Manager は今後の有力な選択肢として残る。Bash の可読性のメリットより再現性・宣言性のメリットが上回ると判断した時点で、移行を改めて検討する
- **本 ADR の更新**: 言語選定の理由に変化があった場合は本 ADR を更新する

## ADR-009 3層分離アーキテクチャへの移行

- **日付**: 2026-06-12
- **更新日**: 2026-06-17
- **ステータス**: 最終決定

### コンテキスト

プロジェクト myenv は OS ごとに設定環境をプロビジョニングする Bash スクリプト群である。v4.9.x 時点のアーキテクチャには以下の問題があった。

**問題1: 環境中心の構造と人間の思考のミスマッチ**

コードの構成単位が OS（`recipes/endeavouros_x64/`）中心になっている。しかし人間は「Neovim の設定を変えたい」のように機能中心で考える。機能のコードにたどり着くには `host → recipe → 1_base → setup_editor → _setup_neovim` という階層を頭の中でトレースする必要があった。

**問題2: 1_base.bash の肥大化**

`recipes/_arch_based_x64/1_base.bash` は 881 行に達し、シェル・端末・エディタ・IME・ブラウザ・デスクトップ設定がすべて混在していた。

**問題3: source による暗黙の継承**

`cachyos_x64/1_base.bash` が `_arch_based_x64/1_base.bash` を `source` し、一部の関数だけを上書きする構造。何が上書きされているかを追跡するのに全ファイルを読む必要があった。

**問題4: 2軸問題の未解決**

```
         shell  editor  terminal  ime  desktop
arch       ○      ○       ○       ○      ○
cachyos    ○      ○       ○       ○      ○
manjaro    ○      ○       ○       ○      ○
```

「機能 × OS」の 2 軸があり、どちらかの軸に寄せると必ずもう一方の軸の情報が散らばる。唯一の解決は両軸を完全に分離し、間に抽象層を置く設計である。

**問題5: OS 差分の扱いがアドホック**

CachyOS では p10k インストール前に `cachyos-zsh-config` を削除する必要がある。現在は `setup_shell_on_cachyos` という特殊関数名を作り、ホスト側で `setup_shell` の代わりに呼び出すことで対応している。この方法は OS が増えるたびに特殊関数名が増殖し、スケールしない。

### 検討した代替案

**ツールレベルの代替案（不採用）:**

- **chezmoi**: dotfiles 管理に特化。独自フォーマットの習得コストと、インストール処理を多量に書く用途とのミスマッチ
- **mitamae**: Ruby 製。ドキュメント不足
- **Ansible**: 遅い
- **Nix / Home Manager**: 学習コストが高い。現在も有力な候補だが、先に Bash で設計を整理する方を選んだ

**設計レベルの代替案:**

- **機能ファイル内でOS分岐**: `if [ "$OS" = "cachyos" ]; then ...` の羅列になる。OS追加時に全ファイルを修正する必要がある（不採用）
- **現状維持**: OSファイルに機能コードが散らばったまま（不採用）

### 決定した設計: 3層分離

#### ディレクトリ構造

```
myenv/
├── lib/
│   └── util.bash               # ユーティリティ関数（変更なし）
│
├── components/                 # 「何をするか」だけを知る。OS知識ゼロ
│   ├── _init.bash              # 全 component を機械的に読み込み
│   ├── core.bash               # Git, yay, mise, aqua, ミラー更新, 各種言語
│   ├── shell.bash              # Zsh + p10k（setup_p10k は統合済み）
│   ├── terminal.bash           # Alacritty, WezTerm
│   ├── multiplexer.bash        # tmux
│   ├── editor.bash             # Neovim, editorconfig
│   ├── devel.bash              # リンター/フォーマッター, lazygit
│   ├── ime.bash                # Fcitx5 + Mozc
│   ├── desktop.bash            # Xfce4
│   ├── util.bash               # CLI ツール群, fastfetch, yazi, proper7y
│   ├── browser.bash            # Chromium, Chrome, Firefox
│   └── extra.bash              # Docker, VirtualBox, VSCode, Obsidian
│
├── platforms/                  # 「OSの差分」だけを知る。機能の中身は知らない
│   ├── 0_common/
│   │   └── default.bash        # 全フックのデフォルト実装（no-op）
│   ├── 1_families/
│   │   ├── arch_based.bash     # Arch 系共通の差分
│   │   ├── debian_based.bash   # Debian 系共通の差分
│   │   └── darwin_based.bash   # Darwin 系共通の差分
│   └── 2_distros/
│       ├── arch_linux.bash     # ディストロ固有の差分
│       ├── cachyos.bash        # cachyos-zsh-config 削除
│       ├── endeavouros.bash
│       ├── manjaro.bash        # manjaro-zsh-config 削除
│       ├── debian.bash
│       ├── ubuntu.bash
│       ├── kali.bash
│       └── macos.bash
│
├── hosts/
│   ├── udon/setup.bash         # 組み合わせを宣言するだけ
│   └── soba/setup.bash
│
├── setup.bash                  # エントリポイント
│
└── config/                     # dotfiles（変更なし）
```

#### 3層の役割と依存関係

```
setup.bash
  └── source hosts/soba/setup.bash                     # エントリポイントが host を起動
        ├── source platforms/0_common/default.bash     # デフォルト（no-op）を読み込み
        ├── source platforms/1_families/arch_based.bash# Arch 系共通フックで上書き
        ├── source platforms/2_distros/cachyos.bash    # CachyOS 固有フックで上書き
        └── source components/_init.bash               # 全 component を一括で機械的読み込み
              ├── source components/core.bash
              ├── source components/shell.bash
              ├── source components/terminal.bash
              └── ...
                    └── platform_*() を呼ぶ             # フック経由で OS に委譲
```

各層の責務:

- **`platforms/0_common/default.bash`**: 全フックのデフォルト実装（`{ :; }` = 何もしない）。「特別な処理がなければ何もしない」が保証される
- **`platforms/1_families/*.bash`**: OS ファミリ（Arch 系 / Debian 系 / Darwin 系）共通の差分だけを書く
- **`platforms/2_distros/*.bash`**: ディストロ固有の差分だけを書く。親ファイルは source せず、host 側が明示的に chain を構成する
- **`components/*.bash`**: OS を一切知らない。`platform_*` 関数を呼ぶだけで、実装はロードされた platform ファイルが決める
- **`components/_init.bash`**: `components/` 配下の全 `.bash` ファイルを機械的に読み込む。host 側の `source` はこの1行のみ
- **`hosts/*/setup.bash`**: どの platform を使うかを宣言し、`components/_init.bash` を介して chain を構成する。ソフトウェア単位の `setup_*` 関数を並べて呼ぶだけ。`core` に限り便利関数 `setup_core` も利用可能

#### フック命名規則

`platform_{タイミング}_{対象}` 形式を採用する。

| フック         | 例                           | 説明                                                                     |
| -------------- | ---------------------------- | ------------------------------------------------------------------------ |
| インストール   | `platform_install_p10k`      | 対象ソフトウェアのインストール全体                                       |
| インストール前 | `platform_pre_install_p10k`  | インストール前に必要な処理（競合パッケージ削除など）                     |
| インストール後 | `platform_post_install_p10k` | インストール後に必要な処理                                               |
| 更新           | `platform_refresh_packages`  | パッケージデータベースの更新（pacman -Syu / apt upgrade / brew upgrade） |

#### パッケージインストールの抽象化方針: A案（ソフトウェアレベルフック）

- **採用: A案（ソフトウェアレベルフック）**
- **却下・バックログ入り: C案（プリミティブ＋ソフトウェアレベルフックの併用）**

A案では、すべてのパッケージインストールに対して個別の `platform_install_{対象}` フックを定義する。これにより、OS 間でインストール手順が大きく異なるソフトウェア（p10k は Arch→AUR, Debian→git clone）にも柔軟に対応できる。

```bash
# components/shell.bash（OSを知らない）
_setup_zsh_theme() {
    platform_pre_install_p10k      # OSに「準備ある？」と委譲
    platform_install_p10k          # OSに「インストールして」と委譲
    platform_post_install_p10k     # OSに「後処理ある？」と委譲
}
```

```bash
# platforms/1_families/arch_based.bash（Arch 系の実装）
# platform_pre_install_p10k → デフォルト（no-op）のまま
platform_install_p10k() {
    yay -S --needed --noconfirm zsh-theme-powerlevel10k-git
}
# platform_post_install_p10k → デフォルト（no-op）のまま
```

```bash
# platforms/2_distros/cachyos.bash（cachyos の差分）
# 親（arch_based.bash）は source しない → host 側で明示的に読み込む

platform_pre_install_p10k() {
    local -r pkgs=("cachyos-zsh-config" "zsh-theme-powerlevel10k")
    for pkg in "${pkgs[@]}"; do
        pacman -Qi "$pkg" &>/dev/null && yay -Rns --noconfirm "$pkg" || true
    done
}
# platform_install_p10k → arch_based.bash の実装が使われる（host が先に source している）
# platform_post_install_p10k → デフォルト（no-op）のまま
```

```bash
# platforms/2_distros/debian.bash（将来の Debian 対応）
platform_install_zsh() { sudo apt install -y zsh; }
platform_install_p10k() {
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${HOME}/.config/zsh/plugins.local/powerlevel10k"
}
# platform_pre_install_p10k, platform_post_install_p10k → デフォルト（no-op）のまま
```

**A案を選んだ理由:**

1. シンプルなメンタルモデル: すべてのインストールが `platform_install_xxx` で統一される
2. 移行の容易さ: 現状のインストール関数（`__install_zsh` など）をそのまま `platform_install_zsh` にリネームするだけで移行できる
3. OS 間のインストール手順の差異（パッケージ名の不一致、パッケージマネージャーの違い、ビルド手順の有無）を個別に吸収できる
4. `platform_install_pkg` のようなプリミティブと個別フックの併用（C案）は「なぜこれは個別フックなのか」という認知負荷が常に伴うため、メンテナンスに不向き

**C案を却下した理由（バックログに保持）:**

- platform ファイルの記述量削減というメリットはあるが、新規 OS 追加時に関数が2〜3個で済むか30個になるかの差でしかなく、絶対的な作業量の差は小さい
- A案から C案への移行（単純ラッパーの削除）は機械的に可能だが、C案から A案への移行は困難。リスクの低い A案を先に選ぶ

#### platforms/ 内の階層構造

`platforms/` は 3 階層のディレクトリ構成を持つ。各階層間の継承は自動解決せず、host ファイルが明示的な source 順で chain を構成する。

```
0_common/default.bash（デフォルト no-op）
  └── 1_families/arch_based.bash（Arch 系共通）
        └── 2_distros/arch_linux.bash
        └── 2_distros/cachyos.bash
        └── 2_distros/endeavouros.bash
        └── 2_distros/manjaro.bash
  └── 1_families/debian_based.bash（Debian 系共通）
        └── 2_distros/debian.bash
        └── 2_distros/ubuntu.bash
        └── 2_distros/kali.bash
  └── 1_families/darwin_based.bash（Darwin 系共通）
        └── 2_distros/macos.bash
```

各階層の意味:

| 階層       | ディレクトリ  | 役割                                                                               |
| ---------- | ------------- | ---------------------------------------------------------------------------------- |
| 共通       | `0_common/`   | 全プラットフォームの共通デフォルト。`default.bash` のみ配置                        |
| ファミリ   | `1_families/` | 同一パッケージマネージャ系統の OS で共通する差分（例: Arch 系の `pacman` + `yay`） |
| ディストロ | `2_distros/`  | 単一ディストリビューション固有の差分（例: CachyOS の `cachyos-zsh-config` 削除）   |

各ファイルは自分の親を source しない。host ファイルが source 順を明示的に制御する。

#### ホストごとのオン・オフ

ホストごとに「どの機能をセットアップするか」の選択は、`hosts/*/setup.bash` 内で呼ぶ関数を取捨選択することで実現する。変数による制御や関数の動的上書きは採用しない（暗黙の依存が増え、読みにくくなるため）。

```bash
# hosts/soba/setup.bash
main() {
    setup_core           # 便利関数: git + aur + mise + aqua + languages + directories

    setup_zsh            # 内部で p10k もセットアップ（setup_p10k は統合済み）
    setup_default_shell  # chsh

    setup_alacritty      # 呼ぶ
    # setup_wezterm     ← コメントアウト = このホストではスキップ
    setup_tmux           # 呼ぶ

    setup_neovim         # 呼ぶ

    # setup_fcitx5_mozc ← コメントアウト = このホストではスキップ
    # setup_xfce4       ← コメントアウト = このホストではスキップ
}
```

#### エントリポイントと readonly のルール

プロジェクト内の Bash ファイルは、その使われ方に応じて以下の3種類に分類する。

| カテゴリ                            | 例                                              | `main` を持つか | `readonly -f` すべきか                                                                                                 |
| ----------------------------------- | ----------------------------------------------- | --------------- | ---------------------------------------------------------------------------------------------------------------------- |
| **純ライブラリ**                    | `lib/`, `components/*.bash`, `platforms/*.bash` | 持たない        | 全関数を readonly（誤上書き防止）                                                                                      |
| **スタンドアロンスクリプト**        | `init.bash`, `devel-tools/script/*.bash`        | 持つ            | `main` を readonly にしてもよい（誰も source しないため）                                                              |
| **source 連鎖するエントリポイント** | `setup.bash` → `hosts/*/setup.bash`             | 両方とも持つ    | `main` は readonly にしない（source 先でも同名関数を定義するため）。host 側では `readonly HOST_LABEL` でホスト名を宣言 |

`main` はプロジェクト全体で統一されたエントリポイント名とする。ただし source 連鎖が発生するファイル間では `readonly -f main` を付与しない。これにより「ファイルの実行は必ず `main` で行われる」という命名規則と「base 実装は readonly で保護する」というルールの両立を図る。

`readonly -f` は純ライブラリカテゴリのファイルで積極的に使い、定義した関数が利用側で誤って上書きされるのを防ぐ。エントリポイントカテゴリでも `main` 以外の内部関数（`parse_args`, `check_prerequisites` など）は readonly にしてよい。

#### core 相当の処理

現状の `0_core.bash`（ミラー更新、Git、AUR helper、mise、言語インストールなど）は `components/core.bash` として独立させる。OS 固有部分（ミラー更新・AUR helper）はフック機構で吸収し、OS 横断の処理（Git・mise・言語インストールなど）は `components/core.bash` に直接書く。

#### 複数 OS 対応の射程

v4.10.0 のアーキテクチャ見直しは以下を想定範囲とする:

- **Arch 系**: Arch Linux, EndeavourOS, CachyOS, Manjaro
- **Debian 系**: Kali Linux, Ubuntu
- **Darwin 系**: macOS

言語ランタイム（Go, Node.js など）の導入は `_install_golang` などの言語単位の入口を維持し、backend は mise に一本化する。mise 自体のインストール方法の OS 差分はフック（`platform_install_mise` など）で吸収する。

#### 移行戦略

**一括置き換え**を採用する。`recipes/` と `components/` + `platforms/` を別エントリポイントとして共存させ、全機能の移行完了後に `recipes/` を削除する。

コミットは機能単位に細かく切りながら進める。全機能の移行完了後に `recipes/` を削除し、`setup_new.bash` を `setup.bash` にリネームする。

#### コンポーネント分割

既存の `recipes/_arch_based_x64/{0_core,1_base,2_extra}.bash` を以下のコンポーネントに分割する。
各コンポーネントはソフトウェア単位の公開関数（`setup_<software>`）を提供し、ホスト側でそれらを明示的に組み合わせる。
`core` に限りソフトウェア単位の関数に加えて `setup_core` を便利関数として提供する（依存関係が強く順序ミスを防ぐため）。

| コンポーネント | 公開関数                                                                                                                                   | 元のファイル                    | 概算行数 |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------- | -------- |
| `core`         | `setup_git`, `setup_aur_helper`, `setup_mise`, `setup_aqua`, `setup_golang`, `setup_nodejs`, `setup_directories`, `setup_core`（便利関数） | `0_core.bash`                   | ~400     |
| `shell`        | `setup_zsh`（p10k含む）, `setup_default_shell`                                                                                             | `1_base.bash` の Shell 節       | ~130     |
| `terminal`     | `setup_alacritty`, `setup_wezterm`                                                                                                         | `1_base.bash` の Terminal 節    | ~50      |
| `multiplexer`  | `setup_tmux`                                                                                                                               | `1_base.bash` の Multiplexer 節 | ~75      |
| `editor`       | `setup_neovim`, `setup_editorconfig`                                                                                                       | `1_base.bash` の Editor 節      | ~90      |
| `devel`        | `setup_devel_tools`, `setup_lazygit`                                                                                                       | `1_base.bash` の Devel 節       | ~50      |
| `ime`          | `setup_fcitx5_mozc`                                                                                                                        | `1_base.bash` の IME 節         | ~110     |
| `util`         | `setup_util_clis`, `setup_fastfetch`, `setup_yazi`, `setup_proper7y`                                                                       | `1_base.bash` の Util 節        | ~60      |
| `desktop`      | `setup_xfce4`                                                                                                                              | `1_base.bash` の Desktop 節     | ~80      |
| `browser`      | `setup_chromium`, `setup_chrome`, `setup_firefox`                                                                                          | `1_base.bash` の Browser 節     | ~80      |
| `extra`        | `setup_docker`, `setup_virtualbox`, `setup_virtualbox_guest`, `setup_vscode`, `setup_obsidian`                                             | `2_extra.bash`                  | ~90      |

#### platform hook 一覧

`platforms/0_common/default.bash` に定義する全フック関数。各 platform ファイルが必要に応じて上書きする。

```bash
# ===== core コンポーネント用 =====
platform_refresh_packages()    # pacman -Syu / apt upgrade / brew upgrade
platform_update_mirrorlist()   # ミラーリスト更新（Arch 系のみ実装）
platform_ensure_build_deps()   # base-devel, curl, vim 等のビルド依存
platform_install_git()         # git
platform_install_delta()       # git-delta
platform_install_yay()         # AUR helper（Arch 系のみ）
platform_install_mise()        # ランタイムバージョン管理

# ===== util コンポーネント用 =====
platform_install_tree()
platform_install_xclip()
platform_install_unzip()
platform_install_ghq()
platform_install_fzf()
platform_install_zoxide()
platform_install_eza()
platform_install_ripgrep()
platform_install_bat()
platform_install_fd()
platform_install_bottom()
platform_install_jq()
platform_install_fastfetch()
platform_install_yazi()

# ===== shell コンポーネント用 =====
platform_install_zsh()
platform_install_p10k()
platform_pre_install_p10k()    # 競合パッケージ削除（CachyOS/Manjaro 用）

# ===== terminal コンポーネント用 =====
platform_install_alacritty()
platform_install_wezterm()

# ===== multiplexer コンポーネント用 =====
platform_install_tmux()

# ===== devel コンポーネント用 =====
platform_install_shellcheck()
platform_install_shfmt()
platform_install_selene()
platform_install_stylua()
platform_install_staticcheck()
platform_install_eslint_d()
platform_install_prettier()
platform_install_markdownlint_cli2()
platform_install_actionlint()
platform_install_typos()
platform_install_lazygit()

# ===== editor コンポーネント用 =====
platform_install_neovim()

# ===== ime コンポーネント用 =====
platform_install_fcitx5_mozc()

# ===== desktop コンポーネント用 =====
platform_install_xfce4_systemload()

# ===== browser コンポーネント用 =====
platform_install_chromium()
platform_install_chrome()
platform_install_firefox()

# ===== extra コンポーネント用 =====
platform_install_docker()
platform_install_virtualbox()
platform_install_virtualbox_guest()
platform_install_vscode()
platform_install_obsidian()
```

#### 実行された移行フェーズ

ブランチ `feat/3-layer-architecture` で全作業を行い、完了後に `main` にマージした。

1. **Phase 1（骨格）**: `platforms/` と `components/` の空実装を作成。`setup_new.bash` のエントリポイントを用意。Phase 3 で `setup.bash` にリネーム
2. **Phase 2（肉付け）**: 全 10 コンポーネント（`core`, `shell`, `util`, `devel`, `terminal`, `multiplexer`, `editor`, `ime`, `desktop`, `browser`, `extra`）を実装。各コミットで関数存在確認 + `bash -n` を検証
3. **Phase 3（後始末）**: `recipes/` 削除、旧 `hosts/*/setup.bash` 削除、`setup_new.bash` → `setup.bash` リネーム

新旧のコードが同時にアクティブになることはない。作業中は旧システム（`setup.bash` → `recipes/`）と新システム（`setup_new.bash` → `components/`）が別ファイルとして共存するが、呼び出し側（`setup.bash` vs `setup_new.bash`）で完全に分離されていた。

- **Bash の限界**: 型安全でない、IDEサポートが貧弱、などの Bash 自体の制約は解消されない
- **platform ファイルの単調さ**: A案では単純な `pacman -S` ラッパーが多数含まれる。ただし各関数の実装は1行で自明
- **新規 OS 追加時のコスト**: A案では各パッケージに対応する `platform_install_xxx` をすべて実装する必要がある。大半は単純なラッパーだが、数は増える
- **Nix への移行可能性**: 今後の有力な選択肢として残る。本設計は Bash の整理に留まっており、Nix への置き換えを妨げない

### 今後の検討事項

- **C案への移行**: platform ファイルの単調さが許容できなくなった場合、単純ラッパーを削除し `platform_install_pkg` プリミティブに統合する C案への移行を検討する（A→Cは機械的に可能）
- **システム更新プリミティブ**: `platform_refresh_packages`（pacman -Syu / apt upgrade / brew upgrade）のような OS 横断のシステム更新フックの追加
- **mise global config の責務**: 現在は現状維持。v4.10.0 の移行完了後に改めて検討
- **mise 管理ツールのバージョン固定方針**: 現在は `latest` を使用。固定する場合は config.toml の管理方法と合わせて検討
- **myenv コマンド再設計**: `myenv apply` / `myenv bump` の責務整理（v4.X.0 別マイルストーン）
- **テストの導入**: `lib/util.bash` のユニットテストから段階的に導入

### 実装決定の補足（v4.10.0 完了時点）

- **aqua インストール方式**: 当初は `aqua-installer` スクリプトを使用する予定だったが、`./aqua update-aqua` の SLSA 検証がネットワーク環境によってリトライループに陥る問題が判明。直接 GitHub Releases からバイナリをダウンロードする方式に変更した。`setup_aqua` の API は変わらない
- **`setup_p10k` の統合**: 当初の設計では `setup_zsh` と `setup_p10k` は別関数だったが、Powerlevel10k は Zsh のテーマに過ぎず単独で呼び出すユースケースが存在しないため、`setup_zsh` に統合した。hook の呼び出し構造（`platform_pre_install_p10k` → `platform_install_p10k`）は `_setup_zsh_theme` 内部で維持されている
- **`HOST_LABEL`**: host ファイルで `readonly HOST_LABEL="udon"` のように宣言することで、platform ファイル内の `$HOST_LABEL` から参照可能。新 host 追加時のコピーが1行の修正で済む

## ADR-008 `copy_file` / `copy_file_as_root` / `remove_file` / `remove_file_as_root` の重複を許容する

- **日付**: 2026-06-11
- **ステータス**: 採用

### コンテキスト

`lib/util.bash` には以下の4関数があり、copy 系2関数、remove 系2関数の間で validation ロジックが重複している。

- `copy_file`: source の存在・symlink・regular file 確認 + 宛先の非存在確認 + `mkdir` + `cp`
- `copy_file_as_root`: 同上 + `sudo`
- `remove_file`: ファイル存在確認 → `rm`
- `remove_file_as_root`: 同上 + `sudo`

また、`copy_file_as_root` と `remove_file_as_root` にはそれぞれ `# TODO: Refactor!!!` のコメントが付いている。

### 検討した案

**案A: 4関数を1つの内部 helper に統合する**

`_copy_with_sudo_if_needed` と `_remove_with_sudo_if_needed` の2つではなく、1つの helper で copy/remove の両方を扱う。

- Pros: 重複の完全排除
- Cons: helper 内で copy/remove の分岐が混在し、可読性が低下する。節約できるコード量は約10%と小さく、抽象化のコストに見合わない

**案B: copy 系 / remove 系をそれぞれ共通化する**

`_copy_with_sudo_if_needed` と `_remove_with_sudo_if_needed` の2つの内部 helper に抽出する。

- Pros: 責務が明確に分離され、全4関数の重複が排除できる
- Cons: `"true"` / `"false"` のマジックワードが呼び出し側に出現する。節約できるコード量が限られており、抽象化のコストに見合わない

**案C: リファクタリングせず、`# TODO: Refactor!!!` のみ削除する**

コードは変更しない。

- Pros: コード変更が最小限
- Cons: 重複したまま。ただしコード量が少なく、メンテナンス負荷は低い

### 決定

案Cを採用する。`# TODO: Refactor!!!` コメントを削除し、代わりに ADR-008 への参照コメントを残す。

### 理由

- 重複量が小さく（関数あたり ~15行）、抽象化のコストに比べてメリットが薄い
- 当該 validation ロジックは安定しており、今後も頻繁に変更される見込みが低い
- README や TODO.md で計画されている将来のアーキテクチャ見直しの中で、必要なら改めてリファクタリングすればよい

### トレードオフ

- 重複コードは残る。将来 validation ロジックに変更が入った場合、同一の修正を4関数に反映する必要がある
- ただし同種の変更が入る頻度は低く、変更時も grep で漏れなく検出できる範囲の規模である

## ADR-007 `remove_unused_config` のバックアップ方式を維持する

- **日付**: 2026-06-11
- **ステータス**: 採用

### コンテキスト

`remove_unused_config` は、既存の設定ファイルやディレクトリを `mv <path> <path>.old` で退避してから、
後続の `link_file` / `copy_file` で myenv 管理の設定に置き換える。`.old` ファイルは同名の既存ファイル
が存在すると上書きされる。

コードレビューにおいて、この `.old` 上書きはデータ喪失リスクではないかという指摘があった。

### 検討した案

**案C（現状維持 + コメント）**: コードは変更せず、リスクについて説明を追加する。
`.old` 上書きは「2回目の myenv apply」でのみ発生し、2回目の時点ではすでに myenv の symlink が配置されているため、
このケースで `.old` が作成されることはない。

**案E（バックアップ廃止）**: `remove_unused_config` でバックアップを取らず、実ファイルを直接削除する。
シンプルだが、初回 `myenv apply` 実行時にユーザーが元々持っていた設定が跡形なく消える。

### 動作解析

現状の `remove_unused_config` の呼び出しパターンを分析した。28 箇所すべて以下のパターンである。

```bash
remove_unused_config "${HOME}/.config/something"
link_file "${MYENV_ROOT}/config/home/.config/something" "${HOME}/.config/something"
```

各実行回での動作は以下の通り。

| 状況                                     | `TARGET_PATH` の状態                | 該当ブランチ | 動作                                             |
| ---------------------------------------- | ----------------------------------- | ------------ | ------------------------------------------------ |
| 初回 `myenv apply`                       | ユーザーの実ファイル / ディレクトリ | `-f` or `-d` | `.old` に退避（`.old` は未存在なので上書き不可） |
| 2回目以降                                | myenv への symlink                  | `-L`         | `unlink` のみ、`.old` 非生成                     |
| レアケース（同名の未管理ファイルが出現） | symlink でない実ファイル            | `-f` or `-d` | 既存 `.old` が存在すれば上書きされる。確率は低い |

重要なのは、**.old 上書きは「2回目の apply で既存 .old を上書きする」という形でしか発生しない**ことである。
しかし2回目以降の apply では、すでに myenv の symlink になっているため `-L` ブランチに入り、`.old` は生成されない。
したがって現実的には上書きは発生しない。

`.old` が最も価値を発揮するのは**初回適用時**であり、これは `.old` の上書きリスクが存在しない唯一のタイミングでもある。

### 決定

案C（現状維持）を採用する。コード変更は行わない。

### 理由

- 初回適用時のデータ喪失防止という `.old` の目的と、`.old` 上書きリスクは両立できない問題ではない
- 案Eはアーキテクチャ的に一貫しているが、初回適用時の心理的安全を損なう
- コードがすでに意図した通りに動作している

### トレードオフ

- 同名パスに myenv 未管理のファイルが出現した場合、既存 `.old` が上書きされる理論上のリスクは残る
- バックアップファイルがユーザーのホームディレクトリに残り続ける（ユーザーが明示的に削除するまで消えない）

### 今後の検討事項

- `myenv doctor` や `myenv cleanup` のようなコマンドを導入する場合、古い `.old` ファイルを一覧・削除する機能を追加してもよい

## ADR-006 `myenv apply` では Neovim プラグインを更新せず、必要時だけ lockfile に復元する

- **日付**: 2026-06-08
- **ステータス**: 採用

### コンテキスト

`myenv apply` は日々の設定適用で頻繁に実行するコマンドである。README の日常フローでも
`myenv cd && myenv pull && myenv apply "$(hostname)"` を案内しており、
「たまに実行する重い更新コマンド」ではなく、普段使いの収束コマンドとして扱っている。

一方、従来の `_setup_neovim` は Neovim のインストールと設定リンクに続いて、毎回以下を実行していた。

```bash
nvim --headless "+Lazy! sync" +qa
```

`Lazy sync` は install / clean / update をまとめて行うため、Neovim 起動とリモート確認により
数秒〜十数秒かかることがある。また、upstream の新しい commit を取り込んで
`lazy-lock.json` を更新しうるため、`apply` が「repo に書かれた desired state を適用する」だけでなく
「desired state 自体を更新する」責務まで持ってしまっていた。

### コマンド設計の方針

今後の `myenv` コマンドは、少なくとも以下の責務を分けて考える。

1. **apply / ensure 系**
    - repo に記録された状態へローカル環境を収束させる
    - 日常的に何度も実行する
    - 速く、冪等で、予期せず repo 管理ファイルに差分を作らないことを重視する

2. **update / refresh 系**
    - upstream を見に行き、repo に記録する desired state を更新する
    - ネットワークアクセスや時間のかかる処理を許容する
    - 実行後に lockfile や設定ファイルの差分が出ることを前提にする

この整理に従うと、Neovim プラグインについて `myenv apply` が担うべきなのは
「lockfile に書かれた状態へ復元すること」であり、upstream への更新確認と
`lazy-lock.json` の更新ではない。

### 検討した案

**案A: `lazy-lock.json` の変化だけを見て `Lazy sync` をスキップする**

毎回実行よりは速くなる。ただし plugin spec や `lua/config/lazy.lua` の変更を検出できない。
また、実行される処理が `sync` のままだと、必要時に `apply` が upstream 更新を行う問題は残る。

**案B: Neovim プラグイン処理を `myenv apply` から完全に外す**

`apply` は速くなるが、新規セットアップや `myenv pull` 後に Neovim が lockfile の状態へ
自動で揃わなくなる。`apply` の ALL IN ONE 的な便利さが下がるため採用しない。

**案C: タイムスタンプで週1程度に制限する**

最小変更としては有効だが、Neovim プラグインの復元が必要になる主な理由は
「時間が経ったこと」ではなく「lockfile / plugin spec が変わったこと」や
「プラグイン実体が存在しないこと」である。したがって状態ベースの制御を優先する。

**案D: fingerprint で必要時だけ `Lazy restore` / `Lazy clean` を実行する**

`lazy-lock.json` だけでなく、Neovim の plugin state に影響する設定ファイル群の fingerprint を計算し、
前回成功時と同じであれば復元をスキップする。fingerprint が変わった場合や
`lazy.nvim` が存在しない場合は、upstream 更新ではなく lockfile への復元を行う。

### 決定

案Dを採用する。

- `_setup_neovim` からは `__ensure_neovim_plugins` を呼ぶ
- `myenv apply` では `Lazy sync` を実行しない
- fingerprint が変わった場合、fingerprint が未作成の場合、または `lazy.nvim` が存在しない場合だけ
  `nvim --headless "+Lazy! restore" "+Lazy! clean" +qa` を実行する
- fingerprint は `~/.cache/myenv/nvim/plugins_fingerprint` に保存する
- fingerprint 更新は Neovim の復元処理が成功した後に行う
- fingerprint ファイルを削除すれば、次回 `myenv apply` で強制復元できる

fingerprint の対象は以下とする。

- `config/home/.config/nvim/init.lua`
- `config/home/.config/nvim/lazy-lock.json`
- `config/home/.config/nvim/lazyvim.json`
- `config/home/.config/nvim/lua/config/lazy.lua`
- `config/home/.config/nvim/lua/plugins/` 配下のファイル

### 変更後の呼び出し構造

```bash
setup_editor
  _setup_neovim
    __install_neovim
    __setup_neovim_config
    __ensure_neovim_plugins
      __calculate_neovim_plugins_fingerprint
      __should_skip_neovim_plugins_restore
      # 必要時のみ Lazy restore / Lazy clean
```

### `apply` から追い出した更新処理の扱い

upstream を見に行って Neovim プラグインを更新し、`lazy-lock.json` を commit / push する処理は
`apply` ではなく update / refresh 系コマンドの責務とする。

ただしコマンド体系全体の見直しは別途検討が必要である。今回の変更では、既存の
`myenv bump` を暫定的な互換入口として残し、`myenv bump` 実行時に `Lazy sync` を行ってから
`lazy-lock.json` の差分を commit / push する。将来的には、Neovim に限らず pacman / mise / aqua などの
「upstream を見に行く重い更新処理」をどのコマンドに集約するかを設計し直す。

### トレードオフ

- `myenv apply` を実行しても Neovim プラグインは upstream 最新にはならない。
  最新化したい場合は update / refresh 系の明示コマンドを使う。
- fingerprint が同じでも、プラグイン実体が部分的に壊れているケースは検出できない可能性がある。
  その場合は `~/.cache/myenv/nvim/plugins_fingerprint` を削除して `myenv apply` を再実行する。
- `Lazy restore` / `Lazy clean` は `Lazy sync` より `apply` の責務に近いが、Neovim 起動は依然として必要である。
  そのため fingerprint が変わらない日常実行ではスキップする。

### 今後の検討事項

- `myenv bump` という名前を維持するか、`myenv update` / `myenv refresh` などに再設計するか
- Neovim 以外の upstream 更新処理（pacman, mise, aqua など）をどの単位で明示コマンド化するか
- `apply` / `update` / `doctor` / `repair` のような責務分割を myenv 全体に適用するか
- force option を導入するか、stamp / fingerprint ファイル削除の運用で十分とするか

## ADR-005 `mise use --global` の毎回実行をツール単位のタイムスタンプ制御で抑制する

- **日付**: 2026-06-06
- **ステータス**: 採用

### コンテキスト

`setup_programming_languages` では Go と Node.js を mise 経由で導入している。

```bash
_install_golang() {
    mise use --global go@latest
}

_install_nodejs() {
    mise use --global node@latest
}
```

この実装は各 install 関数を読めば「何を入れるか」が分かるという利点がある。
一方で、`myenv apply` を実行するたびに `mise use --global` が走るため、mise がリモートの
バージョン情報を確認し、すでに最新がインストール済みでもネットワークアクセスが発生しうる。

### 検討した案

**案A: `mise use --global` を維持し、ツール単位でタイムスタンプ制御する**

Go なら `go@latest`、Node.js なら `node@latest` という指定を各 install 関数に残したまま、
実行頻度だけを `~/.cache/myenv/mise/<tool>_last_updated` で抑制する。

**案B: `mise install` に寄せる**

`config/home/.config/mise/config.toml` の `[tools]` を source of truth とし、
`setup_programming_languages` からは `mise install` を呼ぶ。

これは mise の config 駆動の使い方として自然な面がある。しかし、Go をインストールする処理が
`config/home/.config/mise/config.toml` に暗黙依存し、`_install_golang` のような関数だけでは
「何を入れるか」を読めなくなる。今後 host ごとのインストール有無やバージョン差分が増えると、
依存関係が追いにくくなるため今回は見送る。

**案C: `mise outdated` で更新が必要な場合のみ `mise use` を実行する**

`latest` を本当に最新に保つには、結局リモートのバージョン情報を確認する必要がある。
今回の主目的は「毎回のリモート確認を避ける」ことなので、相性が悪い。

**案D: `latest` ではなくバージョンを固定する**

再現性の観点では有力だが、今回のパフォーマンス改善とは別論点である。
バージョン固定方針は別タスクとして検討する。

### 決定

案Aを採用する。

- 各 install 関数は `go@latest` / `node@latest` のように「何を入れるか」を明示する
- `mise use --global <tool>@<version>` の呼び出し自体は維持する
- 共通 helper でツール単位のタイムスタンプ制御を行う
- スタンプファイルは `~/.cache/myenv/mise/<tool>_last_updated` とする
- 前回実行から24時間以内ならスキップする
- スタンプファイルが存在しない場合（初回・強制リセット時）は必ず実行する
- スタンプファイルを手動削除することでツール単位または mise 管理ツール全体を強制実行できる

### 変更後の呼び出し構造

```bash
setup_programming_languages:
    _install_golang
        _mise_use_global_if_needed "go" "latest"
            # 24時間以内ならスキップ
            # 期限切れなら mise use --global go@latest

    _install_nodejs
        _mise_use_global_if_needed "node" "latest"
            # 24時間以内ならスキップ
            # 期限切れなら mise use --global node@latest
```

### トレードオフ

- 24時間以内に `myenv apply` を複数回走らせた場合、2回目以降は `mise use --global` がスキップされる。
  その間に upstream の最新バージョンが更新されても即時には反映されない。
- ツールを手動削除したがスタンプファイルが残っている場合、次回 `myenv apply` では再インストールされない。
  その場合は該当ツールのスタンプファイルを削除して再実行する。
- `mise use --global` は `~/.config/mise/config.toml` を更新する可能性がある。
  現状このファイルは repo 管理ファイルへの symlink であり、差分が出る可能性がある。
  ただしこれは既存実装でも発生しうる挙動であり、今回は実行頻度を下げるに留める。
  mise global config の責務は、今後のアーキテクチャ見直しで再検討する。

### 今後の検討事項

- host ごとに別の mise config を持たせるか
- mise config を install 処理の source of truth にするか、補助設定・実行結果として扱うか
- `latest` を維持するか、バージョンを固定して再現性を高めるか
- Kali Linux, Ubuntu, macOS などで mise, apt, brew などの backend をどう切り替えるか

## ADR-004 `pacman -Syu` の重複呼び出しをタイムスタンプ制御で解消する

- **日付**: 2026-06-06
- **ステータス**: 採用

### コンテキスト

`myenv apply` を1回実行するたびに `pacman -Syu` が4回呼ばれていた。

```
1. pre_setup_core > _refresh_packages  （ミラー更新前）
2. pre_setup_core > _refresh_packages  （update_pacman_mirror の直後）
3. pre_setup_base > _refresh_packages
4. pre_setup_extra > _refresh_packages
```

1日に複数回 `myenv apply` を走らせる運用では、そのたびに無駄なネットワークI/Oが
発生していた。ログでも `there is nothing to do` で終わる呼び出しが複数回確認されている。

### `pacman -Syu` の挙動と「複数回呼ぶ」の是非

`pacman -Syu` は `-Sy`（リモートからパッケージDBをダウンロード）と
`-u`（ローカルの古いパッケージを更新）の2フェーズからなる。

Arch Linux はローリングリリースのため、パッケージのインストール前に DB を最新化して
おかないと部分アップグレードによる依存関係の不整合が起きうる（公式 wiki でも
`pacman -S パッケージ名` 単体での使用は非推奨とされている）。
この理由から、インストール処理の前に1回 `-Syu` するのは正当である。

一方、`core → base → extra` の各フェーズ冒頭で毎回呼ぶことは過剰である。
フェーズ間の数十分でミラー側の依存関係が変わる確率は現実的にゼロに近く、
2回目以降は「更新するものはない」で終わるだけのネットワークI/Oになっている。

### 決定

以下の3点を組み合わせて対応する。

**① `pre_setup_core` 内の1回目の `_refresh_packages` を削除する**

現状は「古いミラーで `-Syu`」→「ミラー更新」→「新しいミラーで `-Syu`」の順になっている。
1回目は古いミラーで実行するため実益が薄い。また `_install_some_dependencies` で
`curl` 等の前提パッケージは確保済みなので、依存上の問題もない。

**② `pre_setup_base` と `pre_setup_extra` の `_refresh_packages` を削除し、
`pre_setup_core` に集約する**

`core → base → extra` の順に実行される設計上、`core` の末尾で1回更新すれば
後続フェーズのインストール処理に対して整合性は保たれる。

**③ `_refresh_packages` にタイムスタンプ制御を導入する（間隔: 24時間）**

- スタンプファイル: `~/.cache/myenv/pacman_last_updated`
- 前回実行から24時間以上経過していれば実行する
- スタンプファイルが存在しない場合（初回・強制リセット時）は必ず実行する
- スタンプファイルを手動削除することで強制実行できる

間隔を24時間とする理由: 同日に複数回 `myenv apply` を走らせる運用では2回目以降を
スキップできる。数ヶ月ぶりの実行時は必ず1回実行される。
週1のミラー更新（ADR-003）と独立したタイムスタンプで管理することで関心事を分離する。

### 変更後の呼び出し構造

```
pre_setup_core:
    # _refresh_packages ← 削除（①）
    update_pacman_mirror     # タイムスタンプで週1制御（ADR-003）
    _refresh_packages        # タイムスタンプで24時間制御（③）← ここだけ残る

pre_setup_base:
    # _refresh_packages ← 削除（②）

pre_setup_extra:
    # _refresh_packages ← 削除（②）
```

### トレードオフ

- 24時間以内に `myenv apply` を複数回走らせた場合、2回目以降は `pacman -Syu` がスキップされる。
  この間に新たなパッケージをインストールする処理が走っても、部分アップグレード問題が起きる確率は
  現実的にゼロに近い。問題が起きた場合はスタンプファイルを削除して再実行することで対処できる。
- `pacman -Syu` のスキップを強制したい場合（例: セキュリティアップデートをすぐ当てたい）は
  スタンプファイルを削除する必要があり、自動ではない。ただしこのユースケースは
  `myenv apply` とは別に `sudo pacman -Syu` を手動実行する方が自然であり、実害は低い。

## ADR-003 pacman ミラー更新処理をホワイトリスト＋タイムスタンプ方式に刷新

- **日付**: 2026-06-05
- **ステータス**: 採用

### コンテキスト

`update_pacman_mirror` 関数は以下の実装だった。

1. Arch Linux 公式から JP・AU のミラー一覧を取得
2. `rankmirrors` で速度計測
3. 上位5件を `/etc/pacman.d/mirrorlist` に書き込み
4. `pacman -Syu` を実行

以下の問題があった。

- `myenv apply` を1日に数回走らせるのだが、そのたびにこの処理が実行され、
  `rankmirrors` の速度計測がスクリプト全体のボトルネックになっていた
- たまに不安定なミラーに当たる、という問題があった
  （接続が不安定なだけではなく運営主体も不明で、信頼性に懸念がある）

### 決定

以下の方針で実装を刷新する。

- **ミラー選定**：信頼済みホワイトリストを `0_core.bash` に定数として静的管理する。
  採用基準は後述
- **頻度制御**：タイムスタンプファイル（`~/.cache/myenv/mirror_last_updated`）で
  7日以内の再実行をスキップする
- **廃止検知**：更新実行時に公式ミラーリストと突合し、ホワイトリストにある URL が
  消えていれば警告を出す（処理は止めない）
- **関心事の分離**：`pacman -Syu` を `update_pacman_mirror` から切り出し、
  呼び出し側の `_refresh_packages` に任せる

### ホワイトリストの選定基準

以下の条件をすべて満たすものを採用する。

1. 法人・研究機関・公式コミュニティによる運営
   （個人運営は廃止リスクが高いため除外）
2. Arch Linux 公式ミラーリストに掲載されている
3. HTTPS を提供している

参考:

- <https://archlinux.org/mirrors/status/>
- <https://archlinux.org/mirrors/>

### ホワイトリスト選定の調査過程

2026-06-05 時点で公式リストに掲載されている日本の HTTPS ミラーは以下の8件だった。

| ミラー URL                                             | 運営主体                            | 採否 | 理由                                      |
| ------------------------------------------------------ | ----------------------------------- | ---- | ----------------------------------------- |
| `https://ftp.jaist.ac.jp/pub/Linux/ArchLinux/`         | JAIST（国立大）                     | ✅   | 長年の実績、完了率100%、エラーなし        |
| `https://mirrors.cat.net/archlinux/`                   | Cat Networks K.K.（大阪・商用法人） | ✅   | 商用法人、完了率100%、エラーなし          |
| `https://ftp.yz.yamagata-u.ac.jp/pub/linux/archlinux/` | 山形大学（国立大）                  | ✅   | 国立大学、HTTPS側は完了率100%・エラーなし |
| `https://ftp.tsukuba.wide.ad.jp/Linux/archlinux/`      | WIDEプロジェクト（研究機関）        | ❌   | 公式ステータス上 HTTPS を提供していない   |
| `https://mirror.aria-on-the-planet.es/archlinux/`      | 不明                                | ❌   | 運営主体が不明                            |
| `https://jp.mirrors.cicku.me/archlinux/`               | 不明                                | ❌   | 運営主体が不明                            |
| `https://mirror.hashy0917.net/archlinux/`              | 個人運営                            | ❌   | 個人運営                                  |
| `https://www.miraa.jp/archlinux/`                      | 個人運営（sakura.ne.jp ホスト）     | ❌   | 個人運営                                  |

なお WIDEプロジェクトのミラーは `https://ftp.tsukuba.wide.ad.jp/Linux/archlinux/` で
HTTPS アクセス自体は通る（おそらくリダイレクト）が、公式ミラーステータスには
HTTPS URL として登録されていない。廃止チェックの仕組みが機能しなくなるリスクがあるため、
採用しないことにした。

### 変更後の運用フロー

**日常（変更なし）**

毎日 `myenv apply` を実行する。タイムスタンプが7日以内であればミラー更新処理は
自動的にスキップされる。

**週1程度（自動・意識不要）**

`myenv apply` の中でミラー更新処理が自動的に走る。具体的には以下が実行される。

1. ホワイトリストの各 URL が公式ミラーリストに存在するか確認（廃止チェック）
2. ホワイトリストから `/etc/pacman.d/mirrorlist` を生成・書き込み
3. タイムスタンプを更新

**トラブル時（年0〜2回程度・手動対応）**

具体的な対応手順は README の「ワークフロー」セクションを参照。

### 理由

- `rankmirrors` による速度計測は毎回実行する必要がなく、週1程度で十分
- ホワイトリストは「問題ミラーに当たったら1行削除する」だけでメンテナンスできる
- 廃止検知を自動化することで、手動での公式リスト確認が不要になる
- `pacman -Syu` を分離することで `update_pacman_mirror` の責務が明確になる

### トレードオフ

- reflector のような動的選定と比べ、新しい優良ミラーは自動的に採用されない。
  ただし既存ミラーの品質が十分であれば実害はない
- 採用ミラーが3件と少ない。これは2026-06-05 時点での日本国内 HTTPS ミラーの
  選択肢が限られているためであり、やむを得ない。3つのミラーが同時にダウンする
  可能性は十分に低く、仮にダウンしたらもうそれは仕方無いと判断した
- また、ホワイトリストのミラーが一斉に劣化した場合（運営主体がミラーから撤退した場合など）
  にも手動対応が必要になる。ただしこちらについても、一斉劣化の可能性は十分に低いと判断した

## ADR-002 xfce4-datetime-plugin を Xfce 組み込み clock プラグインへ移行

- **日付**: 2026-05-12
- **ステータス**: 採用

### コンテキスト

Xfce パネルの日時表示に AUR パッケージ `xfce4-datetime-plugin` を使用していた。
2026-05-12 に実施した `myenv apply` において、このパッケージのビルドが
`./configure: No such file or directory` エラーで失敗した。

調査の結果、以下のことが判明した。

- **EOL の確認**: AUR パッケージのコメント（jujudusud, 2026-04-11）に
  "As of the 4.18 release, this plugin is considered End-of-Life(EOL).
  For similar functionality, consider using the built-in Clock plugin." との記載がある
- **ビルド失敗の原因**: バージョン 0.8.3-4 の PKGBUILD にソースの tarball URL が
  含まれておらず、ビルドに必要なソースコードが取得できない状態になっている

参考：

- [AUR (en) - xfce4-datetime-plugin](https://aur.archlinux.org/packages/xfce4-datetime-plugin)
- [xfce:xfce4-panel:clock [Xfce Docs]](https://docs.xfce.org/xfce/xfce4-panel/clock)
- [plugins／clock · master · Xfce ／ xfce4-panel · GitLab](https://gitlab.xfce.org/xfce/xfce4-panel/-/tree/master/plugins/clock?ref_type=heads)

### 決定

`xfce4-datetime-plugin` の使用を止め、`xfce4-panel` 組み込みの
`clock` プラグインへ移行する。

`clock` プラグインの時刻フォーマット等の細かい設定は、当面デフォルトのまま使用する。
実際に触ってみて使い勝手が固まり次第、設定の myenv 管理を検討する。

### 理由

- EOL となったパッケージを使い続けることはセキュリティ・安定性の観点から望ましくない
- 公式が推奨する代替手段（`xfce4-panel` 組み込みの `clock` プラグイン）が存在する
- 組み込みプラグインであれば AUR 経由のビルドが不要で、パッケージ管理の複雑さが下がる

### トレードオフ

- `clock` プラグインの設定フォーマットが異なるため、既存の `datetime-18.rc`
  による設定管理ができなくなる。当面はデフォルト設定で運用し、
  必要に応じて xfconf XML による管理を追加する
- 外見・機能が多少変わる可能性があるが、EOL パッケージへの依存を解消する
  メリットの方が大きいと判断した

## ADR-001 「自作スクリプト」と「自作CLI（外部）」の置き場所を決める

- **日付**: 2026-04-29
- **ステータス**: 採用

### コンテキスト

- 以下の 2 つを管理するためのディレクトリが必要になった。
    1. 自作のユーティリティスクリプト（主にBash 製で、コマンドみたいに使えるようにしてある）
    2. 外部のCLIツール・バイナリ（例えば proper7y）
- 現時点での proper7y のインストール先は `~/.bin` である（ただしこれは気軽に変えて良い）
- 自作スクリプトは1つ1つを明示的に管理したくない。ディレクトリごとシンボリックリンクを貼って、
  配下のスクリプトファイルを全部PATHに含めるような運用にしたい。
- `~/.bin/` に両方とも置く運用を考えていたが、そうなると上記の「ディレクトリごとシンボリックリンクを貼る」
  を実現できない（そこにインストールした外部バイナリも Git 管理の対象となってしまう）。
  よって、自作スクリプトと外部バイナリの配置場所は分ける必要がある。
- 主な候補：
    - `~/bin`: ls で見える
    - `~/.bin`: ls で見えない
    - `~/.local/bin/`: XDG準拠の標準的な自作スクリプト配置場所
      実体は `myenv` リポジトリ内に置き、ホームディレクトリからはディレクトリごとシンボリックリンクを張る構成とする。

### 決定

- 自作スクリプト → `~/.bin/` に置かれる（実態は myenv 下）
    - `config/home/.bin/` へのシンボリックリンク（ディレクトリごと）
    - Git管理
- 外部バイナリ → `~/.local/bin/` に置かれる
    - 外部バイナリはここへ直接インストール
    - Git管理外
- 自作スクリプトを作成した際は `config/home/.bin` へ配置する
- 外部バイナリをインストールする際は `~/.local/bin` へ配置する

### 理由

- 自作スクリプトはディレクトリごとリンクで管理でき、追加時に設定変更が不要
- 両者を混在させないことでGit管理の範囲が明確になる
- ホームディレクトリを `ls` したときにノイズが増えるのを避けたい
- 外部バイナリはXDG準拠の標準的な場所に置ける

### トレードオフ

- PATHに2つのディレクトリを追加する必要がある
- 「スクリプトはここ、バイナリはここ」というルールを開発者が意識する必要がある
- `~/bin` の方が一部の環境で `$PATH` に自動追加されやすく、`~/.bin` は自分でパスを追加する必要があるが、
  どうせ `myenv` で明示管理するので問題無い
- ドットディレクトリは `ls` でデフォルト非表示なので、存在を忘れないよう注意する
