#!/bin/bash

GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"
CHECK_MARK="✅"
WARNING="⚠️"
INFO="ℹ️"

# Ensure API_KEY is set
if [ -z "$API_KEY" ]; then
    echo -e "${RED}${WARNING} Error: API_KEY environment variable is not set.${RESET}"
    exit 1
fi


source /opt/octodns-webhook/venv/bin/activate


# Check if requirements.txt is mapped and install dependencies
if [ -f /opt/octodns-webhook/requirements.txt ]; then
    echo -e "${CYAN}${INFO} Installing user-provided Python dependencies...${RESET}"
    /opt/octodns-webhook/venv/bin/pip install -r /opt/octodns-webhook/requirements.txt
else
    echo -e "${YELLOW}${INFO}No requirements.txt provided. Proceeding with base dependencies.${RESET}"
fi

echo -e "${GREEN}${CHECK_MARK} Starting application...${RESET}"
exec "$@"