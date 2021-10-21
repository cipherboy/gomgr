function ___gomgr_clean() {
    local gopath="${GOPATH:-$HOME/go}"
    ___gomgr_clean_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    if [ -e "$gopath" ]; then
        sudo rm -rvf "$gopath"
    fi

    mkdir -pv "$gopath/"{bin,src}
}
