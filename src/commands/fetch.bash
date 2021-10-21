function ___gomgr_fetch() {
    local version=""
    local host="$(uname -s | tr '[:upper:]' '[:lower:]')"
    local arch="amd64"

    ___gomgr_fetch_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    echo "Fetching Go version $version/$host@$arch..."

    if [ ! -e "$_gomgr_releases" ]; then
        mkdir -p "$_gomgr_releases"
    fi

    local identifier="go$version.$host-$arch"

    for ext in "tar.xz" "tar.bz2" "tar.gz" "zip"; do
        local file="$identifier.$ext"
        local file_path="$_gomgr_releases/$file"

        wget --no-verbose --output-document="$file_path" "$_gomgr_web_dl/$file"
        ret=$?

        if (( ret != 0 )); then
            rm -f "$file_path"
            continue
        fi

        if [ ! -s "$file_path" ]; then
            rm -f "$file_path"
            continue
        fi

        local remote_sha256="$(curl -sSL "$_gomgr_web_dl/$file.sha256")"
        local local_sha256="$(sha256sum "$file_path" | awk '{ print $1 }')"

        if [ "$remote_sha256" != "$local_sha256" ]; then
            rm -f "$file_path"
            echo "SHA256 checksum mismatch for $file" 1>&2
            echo "remote: $remote_sha256"
            echo "local: $local_sha256"
            exit 1
        fi

        break
    done
}
