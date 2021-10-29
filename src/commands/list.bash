function ___gomgr_list() {
    local go_version="$(go version 2>/dev/null | awk '{ print $3 }' | sed 's/^go//g')"
    local go_path="$(command -v go)"
    local go_installed_path="/usr/local/go/bin/go"

    if [ "$go_path" != "$go_installed_path" ]; then
        echo "go$go_version (system) (enabled)"
        echo "---"
    elif [ -e /usr/bin/go ]; then
        local system_go_version="$(/usr/bin/go version 2>/dev/null | awk '{ print $3 }' | sed 's/^go//g')"
        echo "go$system_go_version (system)"
        echo "---"
    fi

    for _entry in "$_gomgr_releases/"*; do
        local entry="$(basename "$_entry")"
        echo -n "$entry (cache)"
        if [ "$go_path" = "$go_installed_path" ] && [[ "$entry" = *"$go_version"* ]]; then
            echo -n " (enabled)"
        fi
        echo
    done
}
