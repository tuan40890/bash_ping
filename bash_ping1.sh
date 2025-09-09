#!/bin/bash

IP_FILE="devices.txt"
OUTPUT_FILE="ivl_m6_rack3_ping_results.txt"

# Clear or create the output file
> "$OUTPUT_FILE"

# Check if the IP file exists
if [ ! -f "$IP_FILE" ]; then
    echo "Error: IP address file '$IP_FILE' not found." | tee -a "$OUTPUT_FILE"
    exit 1
fi

echo "Starting ping operations..." | tee -a "$OUTPUT_FILE"

# Loop through each IP address in the file
while IFS= read -r IP; do
    # Skip empty lines and comments
    [[ -z "$IP" || "$IP" =~ ^# ]] && continue

    # Resolve hostname or set placeholder
    HOSTNAME=$(host "$IP" 2>/dev/null | awk '/domain name pointer/ {print $NF}' | sed 's/\.$//')
    DISPLAY_NAME="${HOSTNAME:-[Hostname not found]}"

    # Ping the IP and check status
    ping -c 2 -W 0.1 "$IP" &> /dev/null
    if [ $? -eq 0 ]; then
        echo "Host $IP ($DISPLAY_NAME) is UP." | tee -a "$OUTPUT_FILE"
    else
        echo "Host $IP ($DISPLAY_NAME) is DOWN." | tee -a "$OUTPUT_FILE"
    fi
done < "$IP_FILE"

echo "Ping operations completed. Results saved in $OUTPUT_FILE." | tee -a "$OUTPUT_FILE"
