#!/bin/bash

rpm=$(sensors | grep 'fan' | awk '{print $2}')
echo "$rpm RPM"
