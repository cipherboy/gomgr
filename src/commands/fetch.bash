function ___gomgr_fetch() {
    local version=""
    local host="$(uname -s | tr '[:upper:]' '[:lower:]')"
    local arch="amd64"
    local fips="false"

    ___gomgr_fetch_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    if [ ! -e "$_gomgr_releases" ]; then
        mkdir -p "$_gomgr_releases"
    fi

    local identifier="go$version.$host-$arch"
    if [ "$fips" == "false" ]; then
        echo "Fetching Go version $version/$host@$arch..."

        __gomgr_fetch_nonfips "$identifier"
    else
        echo "Fetching FIPS Go version $version/$host@$arch..."

        __gomgr_fetch_fips "$version" "$identifier"
    fi
}

function __gomgr_fetch_nonfips() {
    local identifier="$1"
    local found="false"

    for ext in "tar.xz" "tar.bz2" "tar.gz" "zip"; do
        local file="$identifier.$ext"
        local file_path="$_gomgr_releases/$file"

        local wget_output="$(wget --no-verbose --output-document="$file_path" "$_gomgr_web_dl/$file" 2>&1)"
        ret=$?

        if (( ret != 0 )); then
            rm -f "$file_path"
            continue
        fi

        if [ ! -s "$file_path" ]; then
            rm -f "$file_path"
            continue
        fi

        echo "$wget_output"
        found="true"

        local remote_sha256="$(wget --no-verbose --output-document=- "$_gomgr_web_dl/$file.sha256")"
        local local_sha256="$(sha256sum "$file_path" | awk '{ print $1 }')"

        if [ "$remote_sha256" != "$local_sha256" ]; then
            rm -f "$file_path"
            echo "SHA256 checksum mismatch for $file" 1>&2
            echo "remote: $remote_sha256"
            echo "local: $local_sha256"
            exit 1
        fi

        echo "Checksum: OK"
        break
    done

    if [ "$found" = "false" ]; then
        return 1
    fi
}

function __gomgr_fetch_fips() {
    local version="$1"
    local identifier="$2"
    local found="false"

    for ext in "tar.xz" "tar.bz2" "tar.gz" "zip"; do
        local file="$identifier.$ext"
        local file_path="$_gomgr_releases/$file"

        local wget_output="$(wget --no-verbose --output-document="$file_path" "$_gomgr_fips_dl/$file" 2>&1)"
        ret=$?

        if (( ret != 0 )); then
            rm -f "$file_path"
            continue
        fi

        if [ ! -s "$file_path" ]; then
            rm -f "$file_path"
            continue
        fi

        echo "$wget_output"
        found="true"

        if [ -z "$_gomgr_fips_checksums" ]; then
            echo "Checksum: skipped"
            break
        fi

        local remote_sha256="$(wget --no-verbose --output-document=- "$_gomgr_fips_checksums" | grep "^go$version " | grep 'linux-amd64' | awk '{print $5}')"
        local local_sha256="$(sha256sum "$file_path" | awk '{ print $1 }')"

        if [ "$remote_sha256" != "$local_sha256" ]; then
            rm -f "$file_path"
            echo "SHA256 checksum mismatch for $file" 1>&2
            echo "remote: $remote_sha256"
            echo "local: $local_sha256"
            exit 1
        fi

        echo "Checksum: OK"
        break
    done

    if [ "$found" = "false" ]; then
        return 1
    fi
}
