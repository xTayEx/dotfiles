#!/bin/bash

pre_title="N/A"
pre_artist="N/A"
if [ ! -p /tmp/xmobar_mpd_pipe ]; then
    mknod /tmp/xmobar_mpd_pipe p
fi
if [[ -n $(playerctl -l) ]]; then
    while true
    do
        if playerctl metadata 2>&- | grep title > /dev/null; then
            title=$(playerctl metadata title)
        fi
        if playerctl metadata 2>&- | grep artist > /dev/null; then
            artist=$(playerctl metadata artist)
        fi
        if [[ $title != $pre_title && $artist != $pre_artist ]]; then
            . $HOME/.config/xmobar/music.sh --all
            pre_title=$title
            pre_artist=$artist
        fi
        sleep 5
    done
fi
