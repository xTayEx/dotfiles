#!/bin/bash
MUTE=$(pulseaudio-ctl full-status | awk '{print $2}')
VOLUME=$(pulseaudio-ctl full-status | awk '{print $1}')

if [ "$MUTE" = "yes" ]; then
    echo "<fn=1></fn> MUTE"
elif [ "$VOLUME" -eq 0 ]; then
    echo "<fn=1></fn> $VOLUME%"
elif [ "$VOLUME" -lt 50 ]; then
    echo "<fn=1></fn> $VOLUME%"
else
    echo "<fn=1></fn> $VOLUME%"
fi
