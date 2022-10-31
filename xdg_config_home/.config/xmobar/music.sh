#!/bin/bash

if [[ -n $(playerctl -l) ]]; then
    if ! playerctl metadata | grep artist > /dev/null; then
        artist="N/A"
    else
        artist=$(playerctl metadata artist)
    fi
    if ! playerctl metadata | grep title > /dev/null; then
        title="N/A"
    else
        title=$(playerctl metadata title)
    fi
    case "$1" in
        --artist)
        echo "$artist" > /tmp/xmobar_mpd_pipe
        ;;
        --title)
        echo "$title" > /tmp/xmobar_mpd_pipe
        ;;
        --all)
        echo "$artist : $title" > /tmp/xmobar_mpd_pipe
        ;;
    esac
fi
