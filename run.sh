#!/bin/bash
set -e

./time.sh 2>&1 | grep --color=never real | awk '{print $2}'
