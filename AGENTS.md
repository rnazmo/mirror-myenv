# AGENTS.md — myenv

## アーキテクチャ

- **3層構成**: `setup.bash` → `hosts/<host>/setup.bash` → `platforms/` + `components/`
- **source 順**（`hosts/*/setup.bash` でこの順に source すること）:
  1. `platforms/0_common/default.bash`（全フックの no-op デフォルト）
  2. `platforms/1_families/<family>.bash`（OS ファミリ共通の差分）
  3. `platforms/2_distros/<distro>.bash`（ディストロ固有の差分）
  4. `components/_init.bash`（全 component を機械的読み込み）
- **ホスト**: `udon`（EndeavourOS, Xfce4）, `soba`（CachyOS, headless）。`hosts/README.md` は古い情報を含むため実コードを優先すること
- **命名規則**: `_` prefix の数 = 呼び出し階層の深さ。`_` はファイル private、`__` は `_` からのみ呼ばれる
- **`readonly -f`**: `lib/`, `components/`, `platforms/` の全関数に必須。`main` には付けない（source chain で再定義される可能性があるため）
- **真偽値関数**: 副作用禁止（`return 0/1` のみ、`echo`/`log_*` を書かない）。ADR-011
- **フック機構**: component は `platform_*` 関数を呼ぶだけで OS 知識を持たない。platform ファイルで上書きする
- **メンテナンス機構**: `setup_core()` 末尾で `setup_maintenance()` を自動実行。ホスト側で個別の `maintain_*` 関数を呼び分けることでメンテナンス範囲を選択可能
- **メンテナンス用 platform hook**（4 つ）: `platform_clean_package_cache`, `platform_clean_yay_cache`, `platform_clean_system_logs`, `platform_remove_orphan_packages`

## コマンド

```bash
# プロビジョニング実行（日々の適用）
./setup.bash "<hostname>"

# lint 実行（shellcheck）
./devel-tools/script/run-lint.arch_based_x64.bash

# lint ツールのインストール（初回のみ）
./devel-tools/script/install_devel_tools.arch_based_x64.bash

# 強制再実行（cache stamp を削除してから setup を再実行）
rm ~/.cache/myenv/<stamp_file>         # pacman / mirror / mise 等
rm ~/.cache/myenv/maintenance/<stamp>  # メンテナンスタスク
./setup.bash "$(hostname)"
```

lint バイナリは `devel-tools/bin/` に配置される（gitignore 対象）。初回は `install_devel_tools` を実行すること。

CI 未導入。テスト未実装（bats-core 計画中）。

## 規約

- **コミットメッセージ**: Conventional Commits。`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`
- **ブランチ**: `main` に直接コミット。PR なし
- **バージョニング**: semver（タグ: `vMAJOR.MINOR.PATCH`）
- **ドキュメント言語**: 日本語（コミットメッセージのみ英語）
- **コード**: `set -eu` 必須。変数は常にダブルクォート。`[[ ]]` で条件分岐。`$(...)` でコマンド置換
- **エラーハンドリング**: トップレベルスクリプトは `exit 1` と末尾 `exit 0`、ライブラリ関数は `return 1` を使う

## 運用上の注意点

- 新しい component を追加するときは `components/_init.bash` の source 行を依存順に挿入すること（glob 未使用）
- pacman / mise / Neovim プラグインの更新は cache stamp で制御されている。強制実行するには `~/.cache/myenv/` 配下の該当 stamp を削除する
- メンテナンスタスク一覧（詳細は `components/maintenance.bash`）:
  - 週1回: pacman cache（`paccache -rk 2`）, yay cache
  - 月1回: journald vacuum, npm cache, Go build cache, mise prune, browser caches
  - 未実装（hook のみ）: 孤児パッケージ削除
- Git remote: `git@gitlab.com:rnazmo/myenv.git`
- `config/home/.bin/` は自作スクリプト（Git 管理）、`~/.local/bin/` は外部バイナリ（Git 管理外）
