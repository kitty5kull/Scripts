#!/bin/sh

tmpfile=`mktemp`
nasm $1.asm -f elf32 -o $tmpfile
ld -m elf_i386 $tmpfile -o $1
rm $tmpfile
