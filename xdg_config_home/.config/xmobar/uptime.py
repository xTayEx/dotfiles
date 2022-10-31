#!/bin/env python
import subprocess
from loguru import logger

logger.add('./uptime.log')

uptime_result = subprocess.check_output(['uptime', '-p']).decode().strip().split(' ')
uptime_str = ''
for idx, item in enumerate(uptime_result):
    if item.isdigit():
        uptime_str += item
        try:
            uptime_str += uptime_result[idx + 1][0]
        except IndexError as e:
            logger.warning(f'{e}')

# uptime_str = ':'.join([x.zfill(2) for x in uptime if x.isdigit()])
print(f'<fn=1></fn> {uptime_str}')
