function ___gomgr_disable() {
    ___gomgr_disable_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    if [ -e "$_gomgr_install_root/go" ]; then
        echo "Removing existing installation root: $_gomgr_install_root/go"
        sudo rm -rf "$_gomgr_install_root/go"
    fi
}
