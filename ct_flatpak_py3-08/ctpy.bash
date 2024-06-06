#!/bin/bash
# wrapper for python
if [[ -z ${1:-} ]]; then
  echo "----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- "
  echo "CTPY: No script specified."
  /app/bin/python3 --version
  echo "----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- "
  exit 0
fi

if [[ -f /app/venv3-08/bin/activate ]]; then
   echo "CTPY: Activating venv3-08..."
   . /app/venv3-08/bin/activate
fi
echo "CTPY: Running: $@"
/app/bin/python3 $@
