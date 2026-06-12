setup_greet() {
    platform_pre_greet
    echo "Hello from $(platform_get_os)!"
    platform_post_greet
}
