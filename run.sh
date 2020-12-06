#!/bin/bash
set -e

[[ $# -ne 2 ]] && { echo "usage: run_firecracker <image> <mem_size_mib>"; exit; }

FC=build/cargo_target/x86_64-unknown-linux-musl/debug/firecracker

# Runs a single instance of Firecracker with the given image and memory size
function run_firecracker {
	# Generate configuration file from template
	CONFIG=$(mktemp)
	trap "rm -f $CONFIG" 0 2 3 15
	IMAGE=$1 MEMSZ=$2 envsubst < config.json > "$CONFIG"

	# Piping input into firecracker stops it from attaching stdin to the serial in
	echo -e "\n" | sudo ${FC} --no-api --config-file "${CONFIG}"
}

# Forces a Firecracker run, terminating it when the "Welcome" message appears, and printing the runtime
function get_time_to_welcome {
	export TIMEFORMAT=%R
	(time cat) | \
		# Look for welcome message
		unbuffer -p grep --color=never "Welcome" | \
		# Kill the run (this signals to `time`)
		(read -n 1 && kill -9 `pidof firecracker`)
}

(run_firecracker $1 $2 | get_time_to_welcome 2>&1) 2>/dev/null
