# myenv-v3

my provisioning scripts.

## 方針

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

## ここでやること

- ツールのインストール
- ツールのバージョン管理
- ツールの設定
- OS の設定

## TODO

- [ ] refactor: Remove `/modules_old1/`
- [ ] refactor: Remove `/modules_old2/`
- [ ] ci: Migrate GitLab -> GitHub
- [ ] feat: Support ErgoDox EZ config
- [ ] ci: Add test for 
- [ ] Add Makefile (`pull`, `push`, `update`, `lint`, `format`)
- [ ] feat: Support browser bookmarklet
- [ ] feat: Support browser extension
- [ ] feat: Support wallpaper (`gitlab/mywallpaper`)
- [ ] feat: Update VS Code config
- [ ] feat: Update VS Code keybindigs
- [ ] feat: Update VS Code extensions
- [ ] feat: Support Zsh plugin-manager
- [ ] feat: Update Zsh plugins
- [ ] feat: Support tmux plugin-manager
- [ ] feat: Update tmux plugins
- [ ] feat: Support AstroNvim
- [ ] feat: Update AstroNvim config

- [ ] doc: できること・できないことをまとめる
    - `init.bash`：
        - できること：
        - できないこと：
    - `setup.bash`：
        - `soba`：
            - できること：
            - できないこと：
                - 日本語入力の設定（GUI でやって）
                - 時刻同期
