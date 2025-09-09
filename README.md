Script executed on Ubuntu 22.04.5 LTS (Jammy Jellyfish)

# bash_ping1.sh - Ping Multiple Random IP Addresses
- This script pings multiple random IP addresses listed from the devices.txt file.
- If the host is up, DNS entry is also displayed.
# Output Example:
```
test-user@servervm:~$ ./bash_ping1.sh
Starting ping operations...
Host 192.168.1.150 (example1.com) is UP.
Host 192.168.1.151 (example2.com) is UP.
Host 192.168.1.152 (example3.com) is UP.
```

# bash_ping2.sh - Ping A Range Within The /24 Subnet
- This script pings continous IP addresses within a /24 subnet and does not need the devices.txt file.
- If the host is up, DNS entry is also displayed.
# Output Example:
```
testuser@vmserver:~$ ./bash_ping2.sh
Starting ping and DNS resolution. Results will be saved in output.txt.
Host 192.168.1.150 is UP. Hostname: example1.com.
Host 192.168.1.151 is DOWN.
Host 192.168.1.152 is DOWN.
```
