# myenv-v3

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

## ここでやること

- ツールのインストール
- ツールのバージョン管理
- ツールの設定
- OS の設定

## Tool List

- OS：
    - Manjaro Linux
    - TODO: -> EndevourOS
- AUR ヘルパー：
    - yay
- デスクトップ環境：
    - Xfce
    - TODO: -> i3wm
- ターミナルエミュレータ：
    - Alacritty
- ターミナルマルチプレクサ：
    - tmux
- シェル：
    - Zsh
- プロンプト：
    - Starship
- ランタイムバージョンマネージャー：
    - mise
- CLIバージョンマネージャー：
    - aqua
- CLI：
    - misc
        - ghq
        - fzf
        - tree
        - xclip
    - system monitor:
        - bottom
    - show system info:
        - proper7y
        - neofetch
    - git client:
        - lazygit
    - ls alt:
        - eza
    - cat alt:
        - bat
    - grep alt:
        - ripgrep
    - find alt:
        - fd
    - diff alt:
        - delta
- エディタ：
    - メイン：
        - VS Code
    - VS Code 拡張機能：
        - TODO:
    - サブ：
        - Neovim
    - Neovim プラグインマネージャー：
        - lazy.nvim (注：AstroNvim に組み込まれている)
    - Neovim フレームワーク：
        - AstroNvim

## TODO

- [ ] WIP: とりあえず作った設定ファイルを放り込んでいく
- [ ] ここで管理したいソフトウェアをリストアップする (-> [Tool List](#tool-list))
    - **まずは本当に最低限だけ！！**
        - 余分なツールを追加するのは、最低限が形になってから
