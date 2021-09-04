#!/bin/bash

echo "=== Erethron HTB Starting point VPN script ==="
echo

sudo /usr/sbin/openvpn /home/kitty/ctf/htb/solved/starting/kitty5kull-startingpoint.ovpn
echo

read -p "Press ENTER to close shell"
