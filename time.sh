#!/bin/bash
set -e

(time unbuffer ./start.sh 2>&1) | unbuffer -p grep --color=never Welcome 2>&1 | (read -n 1 && kill -9 `pidof firecracker`)

