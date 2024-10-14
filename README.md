# myenv-v3

my provisioning scripts.

## Documentation for users

### このリポジトリは何か

- 個人用開発環境のプロビジョニングスクリプト
- このリポジトリでやること：
    - ツールのインストール
    - ツールのバージョン管理
    - ツールの設定
    - OS の設定

### このリポジトリの目的

- 自分で使うため

### 対応環境リスト

- List (2024-09-25 時点)
    - `soba`
        - OS: Manjaro
        - Chassis: VM

### 前提

- Bash 4.0+
- git, curl
- GitLab, (GitHub) への SSH 公開鍵の登録

### ワークフロー (例：`soba`)

#### 新規マシンのセットアップ

```bash
/bin/bash -c "$(curl -fsSL https://gitlab.com/rnazmo/myenv-v3/-/raw/main/init.bash)"

cd ~/.myenv-v3 && ./setup.bash "soba"

```

#### 日々の更新

##### リモートの更新を適用

```bash
# Apply changes
cd ~/.myenv-v3 && git pull && ./setup.bash "soba"

```

##### 更新をリモートへプッシュ

```bash
# Push changes
cd ~/.myenv-v3 && git add -i && git commit -m "update" && git push

```

## Documentation for developers

### 方針

- 管理するツールをなるべく増やさない：
    - 何でもかんでもここで管理しようとしない。管理するツールは絞る
    - そのツール、本当にここで管理する必要ありますか？
- 管理する設定を増やさない：
    - 各種設定やツールのバージョンを、完璧に復元しようとしない
    - だいたい動けば十分。そも厳密な環境が環境が必要なら Docker 使え
- その他：
    - メンテナンスコストを下げる
    - Bash でコードをたくさん書くな。巨大な Bash スクリプトはメンテナンス性が低い
    - Bash のテストをちゃんと書く
    - Windows 対応は原則諦める
        - 開発環境として WLS を使うことはあっても Windows を使うことはないでしょ
    - CI でテストさせる
    - テスト駆動開発
    - このリポジトリの管理にあまり労力を割かない
        - このリポジトリはあくまで道具。これを使って何を作るかが重要
            - いや、「斧を研ぐ」ことは重要では？
    - ちょこちょこタグを付ける
        - `v2024-XX-XX` みたいな日付形式が良さそう

### TODO

- myenv:
    - all:
        - [ ] Restructure `/recipes/*`, `/hosts/*`
        - [ ] Rename project to `myenv`
        - [ ] Publish `v4`
        - [ ] Use semantic versioning
    - feat:
        - [ ] feat(myenv): Log *to file* for debug
        - [ ] feat: 前提 (Bash 4.0+ など) をチェックするようにする
        - [ ] feat: Add command (`sync`, `apply`, `dry-run`, `test`)
    - ci:
        - [ ] ci: Add unit-test
        - [ ] ci: Add integ-test
        - [ ] ci: Add static-check (lint, format, ...)
            - ref: proper7y
    - docs:
        - [ ] docs: できること・できないことをまとめる
            - `init.bash`：
            - `setup.bash`：
                - `soba`：
                    - できること：
                    - できないこと：
                        - 日本語入力の設定（GUI でやって）
                        - 時刻同期 (Manjaro は GUI が楽)
                        - Git の初期設定。GitHub, GitLab への SSH 公開鍵の登録
        - [ ] docs: Add dicision-redords
- keyboard:
    - [ ] feat: Add ErgoDox EZ config
- os:
    - [ ] feat: Support wallpaper (`gitlab/mywallpaper`)
    - [ ] feat: Support Xfce config?
- browser:
    - [ ] feat: Support browser bookmarklet
    - [ ] feat: Support browser extension
- ime:
    - [ ] feat: Migrate { fcitx-mozc => fcitx5-mozc }
        - [Arch Linux - fcitx5-mozc 2.26.4632.102.g4d2e3bd-2 (x86_64)](https://archlinux.org/packages/extra/x86_64/fcitx5-mozc/)
    - [ ] feat: Support config file of fcitx5-mozc
- shell:
    - [ ] feat: Update Zsh config
- bat:
    - [ ] feat: Support config file of bat
- baobab:
    - [ ] feat: Add baobab
        - GUI disk usage analyzer
        - [Arch Linux - baobab 47.0-1 (x86_64)](https://archlinux.org/packages/extra/x86_64/baobab/)
- Xfce:
    - [ ] feat: Support panel config file
    - [ ] feat: Support desktop config file
- thunar:
    - [ ] feat: Support config file of thunar
- ?:
    - [ ] feat: Add cspell for typo check
