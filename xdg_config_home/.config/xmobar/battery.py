#!/bin/env python

import subprocess

CHARGING_ICON = ''
BATTERY_FULL = ''
BATTERY_THREE_QUARTER = ''
BATTERY_HALF = ''
BATTERY_QUARTER = ''
BATTERY_EMPTY = ''

GREEN = '#A3BE8C'
YELLOW = '#EBCB8B'
RED = '#BF616A'

acpi_output = subprocess.check_output(['acpi'])
acpi_output_list = acpi_output.splitlines()
acpi_output_list = [x.decode() for x in acpi_output_list]

percents = [float(item.strip(' ').strip(',')[:-1]) for single_acpi_info in acpi_output_list for item in single_acpi_info.split(' ') if '%' in item]
avg_percent = int(sum(percents) / len(percents))
is_charging = True if len([x for x in acpi_output_list if 'Charging' in x]) else False

bat_xmobar_output = ''
icon = ''
color = '#FFFFFF'


if 90 < avg_percent <= 100:
    icon = BATTERY_FULL
    color = GREEN
elif 50 < avg_percent <= 90:
    icon = BATTERY_THREE_QUARTER
    color = GREEN
elif 20 < avg_percent <= 50:
    icon = BATTERY_HALF
    color = YELLOW
elif 10 < avg_percent <= 20:
    icon = BATTERY_HALF
    color = RED
elif avg_percent <= 10:
    icon = BATTERY_QUARTER
    color = RED

if is_charging:
    icon = CHARGING_ICON

if avg_percent < 10:
    avg_percent = '0' + str(avg_percent)

bat_xmobar_output = f'<action=`kitty --title yacpi -e yacpi`><fc={color}><fn=1>{icon}</fn> {avg_percent}%</fc></action>'

print(bat_xmobar_output)
