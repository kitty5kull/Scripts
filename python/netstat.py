#!/usr/bin/env python3

import argparse
import re

parser = argparse.ArgumentParser("netstat.py", "Usage: netstat.py filename")
parser.add_argument("filename")

args = parser.parse_args()

f = open(args.filename, "r")

def print_result(result):

    for address in result:

        spl = address.split(':')
        port = int(spl[1].strip(),16)

        for index in range(6,-1,-2):
            print(int(spl[0][index:index+2],16), end="" if index==0 else ".")

        print(f":{port}", end='\t')

    print()

for line in f.readlines():

    if line.find("local_address") > 0:
        print("\nlocal_address\tremote address")

    result = re.findall("[0-9a-f]{8}:[0-9a-f]{4} ", line, flags = re.IGNORECASE)

    if len(result) == 2:
        print_result(result)

print()