#!/bin/bash

running=$(pidof netease-cloud-music)
if [ "$running" != "" ]; then
    result=""
    artist=$(playerctl metadata artist | cut -c 1-30)
    title=$(playerctl metadata title | cut -c 1-30)
    case "$1" in
        --title)
        echo "$title"
        ;;
        --all)
        echo "$artist : $title"
        ;;
    esac
fi
