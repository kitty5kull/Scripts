#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 hostname ip [additional arguments for Docker]"
    echo "Example: $0 machine.loc 10.1.1.1 --option value"
    exit 1
fi

hostname="$1"
ip="$2"

echo "Mounted pwd -> /wpscan/pwd and /home/kitty/wordlists -> /wpscan/wordlists"

if [ "$#" -gt 2 ]; then

	shift 2  # Remove the first two arguments
	echo "wpscan parameters detected - running wpscan --disable-tls-checks --url "http://$hostname" $@"

	sudo docker run -it --add-host "$hostname":"$ip" \
		-v "$(pwd)":/wpscan/pwd \
		-v /home/kitty/wordlists:/wpscan/wordlists \
		--rm wpscanteam/wpscan --disable-tls-checks --url "http://$hostname" "$@"

else

	echo "No wpscan parameters given - running wpscan --disable-tls-checks --url "http://$hostname" --plugins-detection mixed -e vp,vt,tt,cb,dbe,u,m"
	
	sudo docker run -it --add-host "$hostname":"$ip" \
		-v "$(pwd)":/wpscan/pwd \
		-v /home/kitty/wordlists:/wpscan/wordlists \
		--rm wpscanteam/wpscan --disable-tls-checks --url "http://$hostname" --plugins-detection mixed -e vp,vt,tt,cb,dbe,u,m

fi

