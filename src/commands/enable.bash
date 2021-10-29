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
    local num_releases="$(ls -alh "$_gomgr_releases/$identifier".* 2>/dev/null | wc -l)"
    if (( num_releases < 1 )); then
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

    if [ -e "$_gomgr_install_root/go" ]; then
        echo "Removing existing installation root: $_gomgr_install_root/go"
        sudo rm -rf "$_gomgr_install_root/go"
        ret=$?
        if (( ret != 0 )); then
            echo "Unable to remove existing Go version" 1>&2
            return $ret
        fi
    fi

    echo "Installing new Go version $version"
    sudo tar -C "$_gomgr_install_root" -xf "$release_path"
    ret=$?
    if (( ret != 0 )); then
        echo "Unable to unpack Go release" 1>&2
        return $ret
    fi

    "$_gomgr_install_root/go/bin/go" version

    # Launch another shell to refresh $PATH cache...
    if [ "$(bash -c 'command -v go')" != "$_gomgr_install_root/go/bin/go" ]; then
        echo "Please add $_gomgr_install_root/go/bin to \$PATH ahead of /usr/bin." 1>&2
        exit 1
    fi
}
