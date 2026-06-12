# デフォルト実装：すべてのフックは何もしない（no-op）
platform_pre_greet()  { :; }
platform_post_greet() { :; }
platform_get_os()     { echo "unknown"; }
