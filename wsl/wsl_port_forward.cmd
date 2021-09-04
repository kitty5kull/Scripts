@ECHO OFF
SET LXDISTRO=kittyb0x & SET WSL2PORT=9090 & SET HOSTPORT=9090
NETSH INTERFACE PORTPROXY RESET & NETSH AdvFirewall Firewall delete rule name="%LXDISTRO% Port Forward" > NUL
WSL -d %LXDISTRO% -- ip addr show eth0 ^| grep -oP '(?^<=inet\s)\d+(\.\d+){3}' > IP.TMP
SET /p IP=<IP.TMP
NETSH INTERFACE PORTPROXY ADD v4tov4 listenport=%HOSTPORT% listenaddress=0.0.0.0 connectport=%WSL2PORT% connectaddress=%IP% 
NETSH AdvFirewall Firewall add rule name="%LXDISTRO% Port Forward" dir=in action=allow protocol=TCP localport=%HOSTPORT% > NUL
ECHO WSL2 Virtual Machine %IP%:%WSL2PORT%now accepting traffic on %COMPUTERNAME%:%HOSTPORT%
