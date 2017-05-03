#!/usr/bin/env bash
# https://github.com/cgerke
if [[ $(who | awk '{ print $2 }' | grep console) ]]; then
  /Applications/Utilities/Cocoadialog.app/Contents/MacOS/cocoadialog "$@"
fi
