local _gomgr_version="0.1"
local _gomgr_verbose="${VERBOSE+x}"
local _gomgr_xdg_cache_home="${XDG_CACHE_HOME:-$HOME/.cache}/gomgr"
local _gomgr_cache="${GOMGR_CACHE:-$_gomgr_xdg_cache_home}"
local _gomgr_releases="$_gomgr_cache/releases"
local _gomgr_web_dl="${GO_DL_PAGE:-https://dl.google.com/go}"
