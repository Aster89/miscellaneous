#!/usr/bin/env bash

### exit if playerctl and pactl are not available ###
which playerctl 2> /dev/null 1>&2 && which pactl 2> /dev/null 1>&2 || exit 1

### functions ###
# check if Spotify is playing ads
shouldMute() {
  [[ $(playerctl --player=spotify metadata 2> /dev/null \
    | sed 's/^.*:title *//p;d') =~ 'Advertisement' ]]
}

# retrieve the sink Spotify is using
getCurrentSink() {
  pactl list \
    | sed -E '/^Sink Input #/,/^$/{/^\s*Sink:\s*/{s///;h};/application\.name.*Spotify/{x;p}};d'
}

# mute/unmute
setMute() {
  # fallback on old sink if new one is empty
  # (this happens when terminating Spotify)
  sinkNew="$(getCurrentSink)"
  [[ -n "$sinkNew" ]] && sink="$sinkNew"
  pactl set-sink-mute "$sink" "$1" 2> /dev/null && pkill -RTMIN+1 i3blocks
}

### unmute upon termination ###
trap 'setMute 0; exit' SIGINT SIGTERM EXIT

### main loop ###
while true; do
  sleep 1
  # shellcheck disable=SC2015
  shouldMute && setMute true || setMute false
done
