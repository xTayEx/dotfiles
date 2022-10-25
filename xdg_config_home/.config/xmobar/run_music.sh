#!/bin/bash

pre_title="N/A"
pre_artist="N/A"
if [ ! -p /tmp/xmobar_mpd_pipe ]; then
    echo "no pipe"
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
        echo "pre_title: $pre_title"
        echo "pre_artist: $pre_artist"
        echo "title: $title"
        echo "artist: $artist"
        if [ "$title" != "$pre_title" ] || [ "$artist" != "$pre_artist" ]; then
            echo "not equal"
            . "$HOME"/.config/xmobar/music.sh --all
            pre_title=$title
            pre_artist=$artist
        fi
        echo "----------------------------------------------"
        sleep 5
    done
fi
