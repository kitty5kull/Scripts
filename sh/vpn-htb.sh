#!/bin/bash

echo "=== Kitty5kull HTB Regular Lab VPN script ==="
echo

sudo /usr/sbin/openvpn /home/kitty/ctf/htb/kitty5kull.ovpn
echo

read -p "Press ENTER to close shell"
