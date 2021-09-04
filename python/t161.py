#!/bin/python3

import os
import sys
import fileinput

dictfile=open(os.path.join(sys.path[0], "t161.txt"))
dict = [ line.rstrip('\n').split() for line in dictfile ]

for line in fileinput.input():
	text=line.strip()
	for kvp in dict:
		text=text.replace(kvp[0],kvp[1])
	print (text)

