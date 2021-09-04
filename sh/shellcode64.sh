#!/bin/sh

tmpfile=`mktemp`
nasm $1 -f elf64 -o $tmpfile
objdump -d $tmpfile | grep -ioE "\:\s{1,99}([a-f0-9]{2}\s)+" | grep -ioE "[a-f0-9]{2}" | tr '\n' ' ' | sed 's/ /\\x/g' | sed 's/\\x$/\n/g' | sed 's/^/\\x/g'
rm $tmpfile

