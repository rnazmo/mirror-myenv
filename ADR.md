# ADR (myenv)

<!-- ADRs are listed in reverse chronological order (newest first). -->

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
