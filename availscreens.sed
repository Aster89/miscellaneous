#!/usr/bin/env -S sed -Ef
# Fed with xrandr's output, this script reports the list of connected monitors
# together with the resolution of their preferred mode followed by + or, if
# there is no preferred mode, the maximum resolution.
#
# Example output (first and third screens have a preferred mode):
# LVDS-1 1366 768 +
# HDMI-1 1920 1080
# VGA-1-2 800 600 +
:t
/^[A-Z0-9-]+ connected (primary )?/I!d
s/ .*//
:w
N
/.*\n[^ ][^\n]+$/{
  h
  s/^([A-Z0-9-]+)\n +([0-9]+)x([0-9]+)\>.*/\1 \2 \3/p
  x
  s/.*\n//
  bt
}
s/^([A-Z0-9-]+).*\n +([0-9]+)x([0-9]+)\>[^\n]*\+[^\n]*$/\1 \2 \3 +/I
t
bw
