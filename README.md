# myenv

個人用開発環境のプロビジョニングスクリプト

---

## About

### Overview

実行するとツールのインストール・設定ファイルの配置・OS設定を自動で行う、Bash 製のプロビジョニングスクリプト。
いわゆる dotfiles を拡張したもので、新規マシンのセットアップから日々の設定変更の適用まで一括して管理する。

### Purpose

- 新しいマシンをセットアップするとき、手順を再現できるようにするため
- ツールのバージョンや設定を一元管理するため
- 自分のため

---

## For Users

### Requirements

- Bash 4.0+
- `git`
- `curl`
- GitLab・GitHub への SSH 公開鍵の登録

### Supported Environments

実際に動作確認済みの環境のみ記載する。

| ホスト名 | OS          | DE    | 仮想化            |
| -------- | ----------- | ----- | ----------------- |
| `udon`   | EndeavourOS | Xfce4 | VirtualBox ゲスト |

### Installation

> **NOTE:** 現在、開発者（SSH アクセス権のある利用者）向けの手順のみ整備されている。
> SSH 鍵なしで利用する手順は未実装。

詳細は [For Developers > Setup](#setup) を参照。

### Usage

セットアップ・更新の手順は [Workflows](#workflows) を参照。

`myenv` コマンド（`~/.config/zsh/zshrc.d/_aliases.zsh` で定義）を使って日常操作を行う。

```bash
# myenv ディレクトリへ移動
myenv cd

# セットアップを実行（ホスト名を指定）
myenv apply "udon"

# リモートから最新の設定を取得
myenv pull

# 変更をリモートへ反映
myenv push

# 静的チェック（lint）を実行
myenv test

# Neovim プラグインを更新し、バージョンをコミット＆プッシュ
myenv bump
```

---

## For Developers

### Policy

- **管理するツールを増やさない。** 何でもここで管理しようとしない。本当に必要なものに絞る。
- **設定の完全再現を目指さない。** だいたい動けば十分。厳密な環境が必要なら Docker を使う。
- **Bash のコード量を抑える。** 巨大な Bash スクリプトはメンテナンス性が低い。
- **Windows 対応は原則諦める。** WSL を使うことはあっても、Windows ネイティブ環境は対象外。
- **このリポジトリの管理に過剰な労力を割かない。** あくまで道具。これを使って何を作るかが重要。
- **ちょこちょこタグを付ける。**

### Tech Stack

| 分類                     | ツール                                       |
| ------------------------ | -------------------------------------------- |
| スクリプト               | Bash / Zsh                                   |
| パッケージ管理           | pacman / yay (AUR)                           |
| ランタイムバージョン管理 | [mise](https://mise.jdx.dev/)                |
| CLI バージョン管理       | [aqua](https://aquaproj.github.io/)          |
| エディタ                 | Neovim + [LazyVim](https://www.lazyvim.org/) |
| ターミナル               | Alacritty / WezTerm                          |
| マルチプレクサ           | tmux                                         |

### Directory Structure

```
myenv/
├── config/             # 設定ファイル群
│   ├── home/           # ホームディレクトリ以下に配置するファイル
│   │   ├── .bin/       # 自作スクリプト（PATH に追加される）
│   │   ├── .config/    # 各種ツールの設定ファイル（XDG 準拠）
│   │   └── .zshenv     # Zsh 環境変数（ZDOTDIR の設定など）
│   └── etc/            # /etc 以下に配置するファイル
├── hosts/              # ホストごとのセットアップエントリーポイント
│   └── <hostname>/
│       └── setup.bash
├── recipes/            # OS ごとのセットアップ関数群
│   ├── _arch_based_x64/    # Arch 系共通
│   ├── cachyos_x64/
│   ├── endeavouros_x64/
│   └── ...
├── lib/
│   └── util.bash       # 共通ユーティリティ関数
├── devel-tools/        # 開発用ツール（lint 等）
├── docs/               # ドキュメント類
├── setup.bash          # メインエントリーポイント
├── init.bash           # リポジトリの初期クローン用スクリプト
├── ADR.md
├── CHANGELOG.md
└── TODO.md
```

**`config/home/.bin/` と `~/.local/bin/` の使い分け**（ADR-001 参照）:

- `config/home/.bin/` — 自作スクリプトを置く。Git 管理対象。ディレクトリごとシンボリックリンクで `~/.bin/` に繋ぐ。
- `~/.local/bin/` — 外部バイナリ（proper7y など）を置く。Git 管理外。

### Setup

#### 1. 前提パッケージのインストール

```bash
sudo pacman -S --needed --noconfirm curl git xclip
```

#### 2. Git のグローバル設定

```bash
git config --global user.name "rnazmo"
git config --global user.email "rnazmo@gmail.com"
git config --list
```

#### 3. SSH 鍵の作成と GitLab・GitHub への登録

```bash
ssh-keygen -t ed25519
xclip -sel c < ~/.ssh/id_ed25519.pub
```

- GitHub: <https://github.com/settings/ssh/new>
- GitLab: <https://gitlab.com/-/user_settings/ssh_keys>

**接続確認:**

```bash
ssh -T git@github.com
ssh -T git@gitlab.com
```

#### 4. myenv のクローン

```bash
/bin/bash -c "$(curl -fsSL https://gitlab.com/rnazmo/myenv/-/raw/main/init.bash)"
```

#### 5. 開発用ツールのインストール

```bash
cd ~/.myenv
./devel-tools/script/install_devel_tools.arch_based_x64.bash
```

### Conventions

#### バージョニング

セマンティックバージョニング（`MAJOR.MINOR.PATCH`）を使う。

- `MAJOR`: 破壊的変更（既存環境との互換性がなくなる変更）
- `MINOR`: 後方互換のある機能追加（ホスト追加、新ツール追加など）
- `PATCH`: 後方互換のあるバグ修正・小改善

#### コミットメッセージ

[Conventional Commits](https://www.conventionalcommits.org/) 形式を使う。

```
<type>(<scope>): <subject>
```

よく使う `type`:

| type       | 用途                                       |
| ---------- | ------------------------------------------ |
| `feat`     | 新機能・新ホスト追加など                   |
| `fix`      | バグ修正                                   |
| `chore`    | ビルド・ツール・設定の更新（機能変更なし） |
| `docs`     | ドキュメントのみの変更                     |
| `refactor` | リファクタリング                           |
| `test`     | テストの追加・修正                         |

#### ブランチ戦略

現状は `main` ブランチに直接コミットする運用。規模が大きくなったタイミングで見直す。

#### TODO.md・ADR.md の運用ルール

**TODO.md:**

- タスクはマイルストーン単位でまとめ、バックログは末尾に列挙する。
- 完了したタスクは `[x]` にチェックを入れ、マイルストーン単位でアーカイブする。

**ADR.md:**

- 以下の場合に ADR を追記する:
    - 複数の実装方針を比較検討して一方を選んだとき
    - 既存設計を変更するとき
    - 明確なトレードオフが存在する設計判断をしたとき
- typo 修正・コメント追加など自明な変更では ADR は不要。
- ADR は逆時系列順（新しいものが上）に並べる。

#### ドキュメント

英語と日本語が混在していても構わない。（SHOULD）
（このドキュメントの主な読者は将来の自分であるため。）

**ドキュメント種別ごとの言語方針:**

| ドキュメント種別   | 言語   | 理由                                                                   |
| ------------------ | ------ | ---------------------------------------------------------------------- |
| コード内コメント   | 日本語 | このプロジェクトの主な読者は自分のみであり、日本語の方が速く書けるため |
| コミットメッセージ | 英語   | Conventional Commits の標準に合わせるため                              |
| README.md          | 日本語 | 主な読者は自分であり、日本語の方が速く書けるため                       |
| ADR.md             | 日本語 | 内部の意思決定記録であり、日本語の方が速く書けるため                   |
| TODO.md            | 日本語 | 内部のタスク管理であり、日本語の方が速く書けるため                     |
| CHANGELOG.md       | 日本語 | 内部のリリースノートであり、日本語の方が速く書けるため                 |

#### コードスタイル（Bash）

shellcheck・shfmt のルールに従う。（SHALL）

また、それらでカバーされないルールについては
[Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html) に従う。
以下はこのプロジェクトで特に重要なルールを抜粋・補足したものである。

**命名規則**

- 関数名: `lowercase_with_underscores`（SHALL）
- 定数・読み取り専用グローバル変数: `UPPER_SNAKE_CASE` + `readonly`（SHALL）
- ミュータブルなグローバル変数: `UPPER_SNAKE_CASE`（readonly なし）（SHALL）
- ローカル変数: `lowercase_with_underscores` + `local` または `local -r`（SHALL）

**関数のプレフィックスルール（myenv 固有）**

プレフィックスの数は、その関数の呼び出し階層の深さを表す。

| プレフィックス | 意味                                         | 例                         |
| -------------- | -------------------------------------------- | -------------------------- |
| なし           | 外部（他ファイル）から呼ばれるパブリック関数 | `setup_shell`              |
| `_`            | 同一ファイル内からのみ呼ばれる               | `_setup_zsh`               |
| `__`           | `_` プレフィックスの関数からのみ呼ばれる     | `__install_zsh`            |
| `___`          | `__` プレフィックスの関数からのみ呼ばれる    | `___install_powerlevel10k` |

`_` プレフィックスの関数を別ファイルから `source` 経由で呼び出すことは禁止する。（SHALL）

**`readonly -f` の使用方針（myenv 固有）**

`source` で読み込まれる可能性があるファイル（`lib/`・`recipes/` 配下など）の関数には、
定義直後に `readonly -f` をつける。（SHALL）

`source` されず直接実行されるだけのファイル（`hosts/*/setup.bash` など）の
内部関数には不要。

```bash
# 良い例（recipes/ 配下）
_setup_zsh() {
    # ...
}
readonly -f _setup_zsh

# 良い例（hosts/ 配下・直接実行のみ）
call_func_in_1_base() {
    # readonly -f は不要
}
```

**関数**

- 関数スコープの変数は必ず `local` または `local -r` で宣言する。（SHALL）
- 自明でない関数には定義の直前にドキュメントコメントを書く。（SHOULD）
  フォーマットは以下の通り。

```bash
# TL;DR (What is this?):
#   この関数が何をするかの一行説明。
#
# Usage:
#   function_name <arg1> <arg2>
#
# Example:
#   function_name "foo" "bar"
#
# NOTE:
#   重要な注意事項・制約があれば書く。
```

**ファイルヘッダー**

各スクリプトファイルの先頭にはヘッダーコメントを書く。（SHOULD）
フォーマットは以下の通り。

```bash
# TL;DR (What is this?):
#   このスクリプトが何をするかの一行説明。
#
# Usage:
#   ./script-name.bash <args>
#
# NOTE:
#   前提条件や制約があれば書く。
```

**エラーハンドリング**

- 全スクリプトの先頭に必ず `set -eu` を書く。（SHALL）
- トップレベルスクリプト（直接実行するファイル）では `exit 1` を使う。（SHALL）
- ライブラリ関数（`lib/util.bash` など、`source` で読み込まれるファイルの関数）では
  `return 1` を使う。（SHALL）
  （`exit 1` を使うと、呼び出し元のシェルごと終了してしまうため。）
- 全トップレベルスクリプトの末尾に `exit 0` を書く。（SHALL）
  （`set -e` 環境下での予期しない非ゼロ終了を防ぐため。）

**クォーティング**

- 変数は必ずダブルクォートで囲む: `"$VAR"`（`$VAR` は不可）（SHALL）
- 例外: `[[ ]]` の内側はクォートなしも許容するが、つけることを推奨する。（SHOULD）

**その他**

- 条件式には `[ ]` ではなく `[[ ]]` を使う。（SHALL）
- コマンド置換にはバッククォートではなく `$(...)` を使う。（SHALL）

**参考**

- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck](https://github.com/koalaman/shellcheck)
- [shfmt](https://github.com/mvdan/sh)

### Workflows

#### 新規マシンのセットアップ

##### 0. OS のインストール

VirtualBox に EndeavourOS をインストールする（手順略）。

##### 1. 前提パッケージのインストール

```bash
sudo pacman -S --needed --noconfirm curl git xclip
```

##### 2. Git のセットアップ

グローバル設定を登録する。

```bash
git config --global user.name "rnazmo"
git config --global user.email "rnazmo@gmail.com"
git config --list
```

GitLab・GitHub への SSH 接続を設定する（詳細は [Setup](#setup) 参照）。

##### 3. myenv の実行

```bash
/bin/bash -c "$(curl -fsSL https://gitlab.com/rnazmo/myenv/-/raw/main/init.bash)"
```

```bash
cd ~/.myenv && ./setup.bash "udon"
```

##### 4. 再起動

```bash
reboot now
```

#### 日々の更新

**リモートの変更を取り込む:**

```bash
myenv cd && myenv pull && myenv apply "$(hostname)"
```

**ローカルの変更をリモートへ反映する:**

```bash
myenv push
```

**静的チェック（lint）を実行する:**

```bash
myenv test
```

**Neovim プラグインを更新し、バージョンをコミット＆プッシュする:**

```bash
myenv bump
```

#### Neovim プラグイン復元の強制実行

fingerprint 制御により Neovim プラグイン復元がスキップされている場合でも、
以下の手順で `lazy-lock.json` に基づく復元を強制実行できる。

```bash
rm ~/.cache/myenv/nvim/plugins_fingerprint
myenv apply "$(hostname)"
```

#### pacman アップデートの強制実行

タイムスタンプ制御により `pacman -Syu` がスキップされている場合でも、
以下の手順で強制実行できる。

```bash
rm ~/.cache/myenv/pacman_last_updated
myenv apply "$(hostname)"
```

#### mise ツール更新の強制実行

タイムスタンプ制御により `mise use --global` がスキップされている場合でも、
以下の手順で強制実行できる。

特定のツールだけ強制更新する場合：

```bash
rm ~/.cache/myenv/mise/go_last_updated
myenv apply "$(hostname)"
```

mise 管理ツールをまとめて強制更新する場合：

```bash
rm -rf ~/.cache/myenv/mise
myenv apply "$(hostname)"
```

#### pacman ミラーのトラブル対応

pacman ミラーに関するトラブルが発生した場合の対応手順。
設計の背景は [ADR-003](./ADR.md#adr-003-pacman-ミラー更新処理をホワイトリストタイムスタンプ方式に刷新) を参照。

##### ケース1：廃止ミラーの警告が出たとき

`myenv apply` の実行ログに以下のような警告が出た場合：

```
WARN : Mirror 'https://ftp.example.ac.jp/' is not in the official mirror list. Consider removing it from PACMAN_MIRROR_WHITELIST.
```

対応手順：

1. `recipes/_arch_based_x64/0_core.bash` を開く
2. `PACMAN_MIRROR_WHITELIST` から該当 URL の行を削除する
3. コミットする

##### ケース2：`pacman -Syu` が遅い・失敗するなど、ミラーの品質劣化に気づいたとき

対応手順：

1. `recipes/_arch_based_x64/0_core.bash` を開く
2. `PACMAN_MIRROR_WHITELIST` から該当 URL の行を削除する（または別のミラーに差し替える）
3. タイムスタンプファイルを削除して、次回 `myenv apply` 時に強制再実行させる

```bash
rm ~/.cache/myenv/mirror_last_updated
myenv apply "$(hostname)"
```

1. コミットする

### References

- [TODO.md](./TODO.md)
- [ADR.md](./ADR.md)
- [CHANGELOG.md](./CHANGELOG.md)
- [docs/keybindings.md](./docs/keybindings.md)
