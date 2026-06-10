# ADR (myenv)

<!-- ADRs are listed in reverse chronological order (newest first). -->

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
