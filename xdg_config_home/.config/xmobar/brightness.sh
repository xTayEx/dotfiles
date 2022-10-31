#!/bin/bash
brightness=$(lux -G | awk -F% '{print $1}')

if [[ $brightness -lt 10 ]]; then
    echo "<fn=1></fn> $brightness%"
elif [[ $brightness -lt 50 ]]; then
    echo "<fn=1></fn> $brightness%"
else
    echo "<fn=1></fn> $brightness%"
fi
