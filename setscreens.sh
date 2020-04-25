#!/usr/bin/bash
BLACKLISTED="VGA-1-2"
BLACKLISTED=${BLACKLISTED:+"(${BLACKLISTED//,/|})"}
THRESH=${THRESH:-.75}
POS=${POS:-"--left-of"}
command xrandr                        \
  | ./availscreens.sed                \
  | sed 's/ *+\?$//'                  \
  | awk '{ $5 = $4; $4 = $2*$3 } 1'   \
  | sort -rnk2                        \
  | awk -v T="$THRESH" -v P="$POS"    \
    'NR == 1 {
               N = P " " $1
               M = $4
               $4 = ""
               print
             }
     NR != 1 {
               if ($4 < T*M) {
                 $4 = "--off"
                 print
                 next
               } else {
                 $4 = N
                 N = P " " $1
               }
               print
             }'                       \
  | sed -E '1i\command xrandr
            /--off/!{
              s/ /x/2
              s/ / --mode /
            }
            s/^/--output /
            s/ [0-9]+ [0-9]+ / /'     \
  | sed -z 's/\n/ /g
            s/$/\n/'
