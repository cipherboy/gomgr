#!/bin/bash

# gomgr is a binary Go Toolchain version manager
# See: https://github.com/cipherboy/gomgr for more information

function gomgr() {
  # [ stage: variables ] #
  . utils/globals.bash

  # [ stage: functions ] #
  . utils/args.bash

  # [ stage: commands ] #
  . commands/clean.bash
  . commands/enable.bash
  . commands/fetch.bash
  . commands/list.bash
  . commands/upgrade.bash

  # [ stage: core ] #

  _gomgr_parse_args "$@"
  ret=$?

  if (( ret != 0 )); then
    return $ret
  fi

  _gomgr_dispatch_subparser
}

gomgr "$@"
