#!/bin/bash

if [ $# != 2 ]; then
	echo "USAGE: $0 imagem.jpg wordlist.txt"
else

lines=`echo \`wc -w $2\` | cut -d ' ' -f 1`
i=0

echo "Successfully loaded $lines words from word list."

for pass in $(cat $2); do
	steghide extract -sf $1 -p $pass -xf output.txt &> /dev/null
	if [ $? == 0 ]; then
		echo
		echo
		echo "SUCESS - $pass"
		echo "FILE: output.txt"
		break
	else
		((i++))
		if ! ((i % 10));
		then
			echo -n -e "\r$i / $lines pass-phrases tried =>  $((100 * i / lines))%"
		fi
	fi
done
fi

echo
echo

