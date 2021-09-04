#!/bin/bash

while :
do
	nc -lvnp $2 -s 127.0.0.1 -e $1
	status=$?
	if [ $status -ne 0 ]; then
		exit
	fi
done
