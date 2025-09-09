#!/bin/bash

IP_FILE="devices.txt"
OUTPUT_FILE="output.txt"
MAX_PARALLEL_PINGS=20 # Adjust this number based on your system's capabilities and network conditions

# Clear or create the output file
> "$OUTPUT_FILE"

# Check if the IP file exists
if [ ! -f "$IP_FILE" ]; then
    echo "Error: IP address file '$IP_FILE' not found." | tee -a "$OUTPUT_FILE"
    exit 1
fi

echo "Pinging..." | tee -a "$OUTPUT_FILE"

# Define a function to process each IP address
# This function will be called in parallel by xargs
process_ip() {
    IP="$1"
    # Skip empty lines and comments within the function as well,
    # although xargs will typically filter empty lines from input.
    [[ -z "$IP" || "$IP" =~ ^# ]] && return

    # Resolve hostname or set placeholder
    # Note: The 'host' command can sometimes be slow. If hostname resolution is not critical
    # for every ping, or if speed is paramount, this step could be optimized or removed.
    HOSTNAME=$(host "$IP" 2>/dev/null | awk '/domain name pointer/ {print $NF}' | sed 's/\.$//')
    DISPLAY_NAME="${HOSTNAME:-[Hostname not found]}"

    # Ping the IP and check status
    # -c 2: send 2 packets
    # -W 0.1: wait 0.1 seconds for a response (timeout)
    # IMPORTANT: A timeout of 0.1 seconds (-W 0.1) is very aggressive.
    # If the network has even slight latency, or if devices are slow to respond,
    # they might be incorrectly reported as "DOWN". Consider increasing this value
    # (e.g., -W 1 for 1 second) if you experience false negatives.
    ping -c 2 -W 0.1 "$IP" &> /dev/null
    if [ $? -eq 0 ]; then
        echo "$IP ($DISPLAY_NAME) is UP"
    else
        echo "$IP ($DISPLAY_NAME) is DOWN"
    fi
}

# Export the function so that `bash -c` (which xargs uses) can access it
export -f process_ip

# Use xargs to run the process_ip function in parallel
# -P "$MAX_PARALLEL_PINGS": Run up to MAX_PARALLEL_PINGS processes at a time.
# -I {}: Replace {} with each line read from stdin.
# bash -c 'process_ip "$@"' _ {}: Executes the process_ip function with the IP as an argument.
# The '_' is a placeholder for $0 in the bash -c script, and '{}' becomes $1.
# The entire output of the parallel operations is then piped to tee.
cat "$IP_FILE" | grep -vE '^\s*($|#)' | xargs -P "$MAX_PARALLEL_PINGS" -I {} bash -c 'process_ip "$@"' _ {} | tee -a "$OUTPUT_FILE"

echo "Ping completed. Output is saved in $OUTPUT_FILE" | tee -a "$OUTPUT_FILE"
