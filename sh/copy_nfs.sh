#!/bin/bash

if [ "$#" -ne 2 ]; then
        echo "$0 <NFS Address> <Target Directory>"
	echo "Example: $0 10.10.0.10:/mnt/backup backup"
        exit
fi

mkdir xyz
mkdir $2

sudo mount -t nfs $1 `pwd`/xyz
cp -r xyz/. $2
sudo umount `pwd`/xyz
rmdir xyz
