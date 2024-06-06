#!/bin/bash
# wrapper for python
if [[ -z ${1:-} ]]; then
  echo "----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- "
  echo "CTPY: No script specified."
  /app/bin/python3 --version
  echo "----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- "
  exit 0
fi

echo "CTPY: Activating venv3-10..."
. /app/venv3-10/bin/activate
echo "CTPY: Running: $@"
/app/bin/python3 $@
