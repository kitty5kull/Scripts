#!/bin/python

from pwn import *
import sys
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("libc", help="Path to libc.so")
args = parser.parse_args()

print()

f = sys.stdin.buffer
gotstring = f.read()
f.close()

if len(gotstring) % 4 > 0:
    gotstring = gotstring[:-(len(gotstring) % 4)]

got = []
print(gotstring)

for offset in range(0,len(gotstring),4):
    entry = gotstring[offset:offset+4]
    print(offset, end=":\t")
    got.append(u32(entry))
    print(hex(got[-1]))

libc = ELF(args.libc)
symbols = libc.symbols.items()
gotbase = 0x0804a000

candidates = {}

for i in range(len(got)):
    print('='*40)
    print (i, end = ' : ')
    print (4 * i, end = ' : ')
    print (hex(gotbase + 4 * i), end = ' : ')
    print(hex(got[i]))
    print('-'*40)
    for hit in (s for s in symbols if (s[1] & 0xfff) == (got[i] & 0xfff)):
        print(hit, end = ' ')
        lcbase = got[i] - hit[1]
        print(hex(lcbase))
        try:
            entry = candidates[lcbase].append((i, hit))
        except KeyError:
            candidates[lcbase] = [(i, hit)]

score = 0
load_address = 0

for cand in candidates:
    print('='*60)
    print(hex(cand))
    print('-'*60)
    candidate = candidates[cand]
    if len(candidate) > score:
        score = len(candidate)
        king = candidate
        load_address = cand
    print(candidate)

print('='*50)
print('Most likely libc load address: '+hex(load_address))
print('-'*50)

for i in range(len(got)):
    print (hex(gotbase + 4 * i), end = ' ')
    address = got[i]-load_address
    if address > 0:
        print ('<libc> + '+hex(address), end = ' ')
        for entry in (entry for entry in king if entry[0] == i):
            print (entry[1][0], end = ' ')
        print()
    else:
        print (hex(got[i]))

