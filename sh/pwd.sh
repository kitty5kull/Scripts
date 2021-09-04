#!/bin/bash

for file in $(find /opt/BreachCompilation/data -type f)
do
	cat $file |grep $1
done

wait
