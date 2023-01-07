
if [ "$#" -lt 2 ]; then
	max=100
else
	max=$2
fi

if [ "$#" -lt 1 ]; then
	min=3
else
	min=$1
fi

find . -type f -exec strings {} -n $min \; | grep -oiE "[0-9a-z_\.\-]{$min,$max}" | sort | uniq 
