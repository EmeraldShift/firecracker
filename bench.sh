#!/bin/bash
set -e

for i in {64..32}; do
	sed -i'' "s/.*mem_size.*/    \"mem_size_mib\": $i,/" hello-config.json
	echo -n "$i ... "
	timeout 10 ./run.sh | tee -a "times/${i}"
done
