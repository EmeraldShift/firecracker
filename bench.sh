#!/bin/bash
set -e

[[ $# -ne 1 ]] && { echo "usage: bench.sh <config> "; exit; }

CONFIG=$1
source ${CONFIG} # Read environment vars from config file (e.g. image, policy, ...)

# Validate arguments
[[ -z "${IMAGE}" ]] && { echo "Undefined variable 'IMAGE'"; exit; }
[[ -z "${POLICY}" ]] && { echo "Undefined variable 'POLICY'"; exit; }
[[ -z "${MEMSZS}" ]] && { echo "Undefined variable 'MEMSZS'"; exit; }

base=$(basename -- ${CONFIG})
RUN=${base%.*}
mkdir -p "out/${RUN}"
for i in ${MEMSZS}; do
	echo -n "${RUN}/$i ... "
	(timeout 10 ./run.sh ${IMAGE} $i || echo "timeout") | tee -a "out/${RUN}/$i"
done
