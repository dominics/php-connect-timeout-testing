#!/bin/bash

if [ -z "${TEST_HOSTNAME}" ]; then
    echo "No test hostname found" >&2
    exit 2
fi

curl --version

time curl "http://${TEST_HOSTNAME}/" --connect-timeout 3 --max-time 5
