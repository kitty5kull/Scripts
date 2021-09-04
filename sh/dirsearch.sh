#!/bin/bash

if [ $# -lt 2 ]
then
	echo "Uses /opt/dirsearch/dirsearch.py with predefined parameters."
	echo "Usage: $0 <URL> <output filename> [any additional dirsearch.py params]"
	echo "Requires sudo privileges."
	exit
fi

sudo dirsearch -u "$1" -o "$2" --format=simple --wordlist=/usr/share/wordlists/dirb/common.txt -e html,htm,php,asp,aspx,js,txt,old,bak,cfg,conf,jsp,do,action,zip,tar,gz -f -r -R 3 "{$*:3}"
