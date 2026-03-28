# myenv

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

### 前提

- Bash 4.0+
- git, curl
- GitLab, (GitHub) への SSH 公開鍵の登録

### ワークフロー (例：`udon`)

#### 新規マシンのセットアップ

##### 0. Install EndeavourOS in VirtualBox

略

##### 1. Install prerequisites

```bash
sudo pacman -S --needed --noconfirm curl git xclip
```

##### 2. Setup Git

1. グローバル設定の登録

```bash
git config --global user.name "rnazmo"
git config --global user.email "rnazmo@gmail.com"
git config --list
```

2. GitLab, GitHub への SSH 接続設定

See: [Git：GitHub（または GitLab）に SSH キーを登録する手順（GitHub CLI 無し）（v2024-09](f585a709-fde5-47d8-80ab-ee079d5b99ef.md)

**手順の要点のみメモ**：

```bash
ssh-keygen -t ed25519
```

```bash
xclip -sel c < ~/.ssh/id_ed25519.pub
```

- [https://github.com/settings/ssh/new](https://github.com/settings/ssh/new)
- [https://gitlab.com/-/user_settings/ssh_keys](https://gitlab.com/-/user_settings/ssh_keys)

**接続確認**：

```bash
ssh -T git@github.com # 聞かれる
```

```bash
ssh -T git@gitlab.com # 聞かれる
```

##### 3. Run myenv

```bash
/bin/bash -c "$(curl -fsSL https://gitlab.com/rnazmo/myenv/-/raw/main/init.bash)"
```

```bash
cd ~/.myenv && ./setup.bash "udon"
```

##### 4. Reboot machine

```bash
reboot now
```

#### 日々の更新

##### リモートの更新を適用

```bash
myenv cd && myenv pull && myenv apply "$(hostname)"

```

##### 更新をリモートへプッシュ

```bash
myenv push
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
    - feat:
        - [ ] feat(myenv): Log *to file* for debug
        - [ ] feat: 前提 (Bash 4.0+ など) をチェックするようにする
    - ci:
        - [ ] ci: Add unit-test
        - [ ] ci: Add integ-test
        - [ ] ci: Add static-check (lint, format, ...)
            - ref: proper7y
    - docs:
        - [ ] docs: できること・できないことをまとめる
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
