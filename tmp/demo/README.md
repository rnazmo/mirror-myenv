# 3層分離アーキテクチャ デモ

4ステップで構成。それぞれ `bash <dir>/main.bash` で実行できる。

| #   | ディレクトリ               | 内容                                                     |
| --- | -------------------------- | -------------------------------------------------------- |
| 01  | `01_source_and_override/`  | Bashの `source` と関数の上書きの基本                     |
| 02  | `02_default_and_platform/` | デフォルトno-op → platformが上書き → componentが呼び出し |
| 03  | `03_inheritance/`          | platform同士の継承（`arch` → `cachyos`）                 |
| 04  | `04_full_flow/`            | 3層完全版。複数component × 複数hostを引数で切り替え      |
