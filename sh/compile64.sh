#!/bin/sh

tmpfile=`mktemp`
nasm $1.asm -f elf64 -o $tmpfile && ld -m elf_x86_64 $tmpfile -o $1
rm $tmpfile
