#!/bin/bash

# Colors and Icons
GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"
CHECK_MARK="✅"
WARNING="⚠️"
INFO="ℹ️"


# Replace placeholders in config.yaml and domain YAML files with environment variables
echo -e "${CYAN}${INFO} Replacing placeholders in config.yaml and domain YAML files...${RESET}"

sed -i "s|\${DO_TOKEN}|$DO_TOKEN|g" /opt/octodns-webhook/config/config.yaml
sed -i "s|\${NETBOX_HOST}|$NETBOX_HOST|g" /opt/octodns-webhook/config/config.yaml
sed -i "s|\${NETBOX_TOKEN}|$NETBOX_TOKEN|g" /opt/octodns-webhook/config/config.yaml
sed -i "s|\${MY_DOMAIN}|$MY_DOMAIN|g" /opt/octodns-webhook/config/config.yaml


# Execute the CMD passed to the container
exec "$@"