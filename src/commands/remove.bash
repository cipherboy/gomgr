function ___gomgr_remove() {
    local version=""

    ___gomgr_remove_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    rm -v "$_gomgr_releases/go$version"*
}
