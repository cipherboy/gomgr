function ___gomgr_enable() {
    local version=""
    local host="$(uname -s | tr '[:upper:]' '[:lower:]')"
    local arch="amd64"

    ___gomgr_enable_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    local identifier="go$version.$host-$arch"
    local num_releases="$(ls -alh "$_gomgr_releases/$identifier".* | wc -l)"
    if (( num_releases < 0 )); then
        echo "This release is not present in cache; must fetch it first." 1>&2
        exit 1
    fi

    if (( num_releases > 1 )); then
        echo "Failure to fetch release: found $num_releases release files (expected 1)" 1>&2
        exit 1
    fi

    local release_path=""
    for only_file in "$_gomgr_releases/$identifier".*; do
        release_path="$only_file"
    done

    if [ -z "$release_path" ]; then
        echo "PANIC: release_path is empty!"
        exit 1
    fi

    if [ -e "$__gomgr_install_root/go" ]; then
        echo "Removing existing installation root: $_gomgr_install_root/go"
        sudo rm -rf "$_gomgr_install_root/go"
    fi

    echo "Installing new Go version $version"
    sudo tar -C "$_gomgr_install_root" -xf "$release_path"

    "$_gomgr_install_root/go/bin/go" version
}
