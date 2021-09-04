#!/bin/bash

echo "=== Kitty5kull TryHackMe Lab VPN script ==="
echo

sudo /usr/sbin/openvpn /home/kitty/ctf/tryhackme/kitty5kull.ovpn
echo

read -p "Press ENTER to close shell"
