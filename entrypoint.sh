#!/bin/bash

check_required_env() {
    VAR_NAME=$1
    if [ -z "${!VAR_NAME}" ]; then
        echo "Error: Environment variable $VAR_NAME is required but not set."
        exit 1
    else
        echo "Environment variable $VAR_NAME is set to: ${!VAR_NAME}"
    fi
}

# Check each required environment variable
check_required_env "ALGO"
check_required_env "POOL"
check_required_env "WALLET"


./lolMiner --algo "${ALGO}" --pool "${POOL}" --user "${WALLET}" "${EXTRA}"
while [ $? -eq 42 ]; do
    sleep 15s
    ./lolMiner --algo "${ALGO}" --pool "${POOL}" --user "${WALLET}" "${EXTRA}"
done
