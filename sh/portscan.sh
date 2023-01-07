#!/bin/bash

if [ "$2" == "" ]
then

 echo "Usage: $0 <path-to-nc> <IP-Address>"

else

 for port in `seq 1 254`; do
  echo -n "$port "
  $1 -w 1 $2 $port
 done

fi

wait
