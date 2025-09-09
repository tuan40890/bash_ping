Script executed on Ubuntu 22.04.5 LTS (Jammy Jellyfish)
# bash_ping.sh - Ping Multiple Random IP Addresses
- This script pings multiple random IP addresses listed explicitly within the script.
- If the host is up, DNS entry is also displayed.
# Output Example:
```
testuser@vmserver:~$ ./bash_ping.sh
Host 10.0.0.72 example1.com is UP.
Host 172.30.0.75 example2.com is UP.
Host 172.21.24.42 example3.com is UP.
Host 192.168.0.23 example41.com is UP.
```

# bash_ping2.sh - Ping A Range Within The /24 Subnet
- This script pings continous IP addresses within a /24 subnet.
- If the host is up, DNS entry is also displayed.
# Output Example:
```
testuser@vmserver:~$ ./bash_ping2.sh
Starting ping and DNS resolution. Results will be saved in output.txt.
Host 192.168.1.150 is UP. Hostname: example1.com.
Host 192.168.1.151 is DOWN.
Host 192.168.1.152 is DOWN.
```
