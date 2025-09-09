#!/bin/bash

# Define the list of IP addresses to ping
IP_ADDRESSES=(
    "10.0.0.72" "172.30.0.75" "172.21.24.42" "192.168.0.23")

# Define the output file
OUTPUT_FILE="output.txt"

# Empty or create the output file
> "$OUTPUT_FILE"

# Loop through each IP address in the array
for IP_ADDRESS in "${IP_ADDRESSES[@]}"; do
    # Attempt to resolve the hostname from the IP address
    # host command output format: IP_ADDRESS.in-addr.arpa domain name pointer HOSTNAME.
    # We want to extract HOSTNAME.
    HOSTNAME=$(host "$IP_ADDRESS" | awk '/domain name pointer/ {print $NF}' | sed 's/\.$//')

    # If hostname resolution fails, set a placeholder
    if [ -z "$HOSTNAME" ]; then
        DISPLAY_NAME="[Hostname not found]"
    else
        DISPLAY_NAME="$HOSTNAME"
    fi

    # Ping the host with 2 packets and a timeout of 0.1 second
    ping -c 2 -W 0.1 "$IP_ADDRESS" &> /dev/null

    # Check the result of the ping command
    if [ $? -eq 0 ]; then
        echo "Host $IP_ADDRESS $DISPLAY_NAME is UP." | tee -a "$OUTPUT_FILE"
    else
        echo "Host $IP_ADDRESS $DISPLAY_NAME is DOWN." | tee -a "$OUTPUT_FILE"
    fi
done

echo "Ping operations have completed. Results are saved in $OUTPUT_FILE."
