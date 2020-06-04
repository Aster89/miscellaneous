#!/usr/bin/env bash

source "$(dirname "$0")/commons.sh" || exit 1

[[ -x "${SCRIPT:=$(dirname "$0")/make_setscreens.sh}" ]] \
  || { error 'make_setscreens.sh script not found beside setscreens.sh.' && exit 1; }
$($SCRIPT)
