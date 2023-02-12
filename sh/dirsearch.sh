#!/bin/bash

if [ $# -lt 2 ]
then
	echo "Uses /opt/dirsearch/dirsearch.py with predefined parameters."
	echo "Usage: $0 <URL> <output filename> [any additional dirsearch.py params]"
	echo 'Will execute: dirsearch -u $1 -o $2 --format=plain -e html,htm,php,asp,aspx,js,txt,old,bak,cfg,conf,jsp,do,action,zip,tar,gz,pl,py,cgi,sh -f -r -R 3 -x 400 ${@:3}'
	echo "Requires sudo privileges."
	exit
fi

dirsearch -u "$1" -o "$2" --format=plain -e html,htm,php,asp,aspx,js,txt,old,bak,cfg,conf,jsp,do,action,zip,tar,gz,pl,py,cgi,sh -f -r -R 3 -x 400 ${@:3}
