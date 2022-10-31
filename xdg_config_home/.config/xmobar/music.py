#!/bin/env python

import subprocess
from subprocess import CalledProcessError
import argparse
import sys
from time import sleep

parser = argparse.ArgumentParser()
parser.add_argument('-w', '--width', type=int, help='width of marquee text')
args = parser.parse_args()

def marquee(text, width=10):
    left = 0
    right = left + width
    text = text + ' ' * width
    while True:
        to_output = ''
        for i in range(left, right):
            to_output += text[i]
            # print(text[i], end='') 
        left += 1
        right += 1
        if right >= len(text):
            left = 0
            right = left + width
        sys.stdout.flush()
        print(to_output, flush=True)
        sleep(0.1)

players = subprocess.check_output('playerctl -l 2>&-', shell=True).decode()
if len(players) != 0:
    artist = 'N/A'
    title = 'N/A'
    try:    
        artist = subprocess.check_output('playerctl metadata artist', shell=True).decode().strip('\n')
    except CalledProcessError:
        pass

    try:
        title = subprocess.check_output('playerctl metadata title', shell=True).decode().strip('\n')
    except CalledProcessError:
        pass
    
    sys.stdout.flush()
    sys.stdout.write('<fn=5></fn>')
    sys.stdout.flush()
    # print(f'<fn=5></fn>', end='')
    marquee(f' {artist} : {title}', width=5)
