#!/bin/bash

# Define subnet base here (e.g., "192.168.1")
SUBNET_BASE="192.168.1"

# Define the output file
OUTPUT_FILE="output.txt"

# Empty or create the output file
> "$OUTPUT_FILE"

echo "Starting ping and DNS resolution. Results will be saved in $OUTPUT_FILE." | tee -a "$OUTPUT_FILE"

# Ping hosts from 4th octet range
for i in {150..152}; do
    HOST="$SUBNET_BASE.$i"
    HOSTNAME="" # Initialize hostname variable

    # Ping the host with a timeout of 0.1 second
    # -c 1 for a single ping to speed up, -W 0.1 for quick timeout
    ping -c 1 -W 0.1 "$HOST" &> /dev/null

    # Check the result of the ping command
    if [ $? -eq 0 ]; then
        # Host is up, attempt reverse DNS lookup
        # +short option returns only the answer
        HOSTNAME=$(dig -x "$HOST" +short)

        if [ -n "$HOSTNAME" ]; then
            echo "Host $HOST is UP. Hostname: $HOSTNAME" | tee -a "$OUTPUT_FILE"
        else
            echo "Host $HOST is UP. No DNS record found." | tee -a "$OUTPUT_FILE"
        fi
    else
        echo "Host $HOST is DOWN." | tee -a "$OUTPUT_FILE"
    fi
done

echo "Ping and DNS operations have completed. Results are saved in $OUTPUT_FILE." | tee -a "$OUTPUT_FILE"
