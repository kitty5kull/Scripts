#!/bin/python

import argparse
import os
import re
import sys


parser = argparse.ArgumentParser(
                    prog = 'wordcarve',
                    description = 'Extracts all printable words of the given directory and all subdirectories')

parser.add_argument('directory')           # positional argument
parser.add_argument('-n', '--min', type=int, help = 'Minimum number of characters by word. Default: 3', required=False, default=3)
parser.add_argument('-m', '--max', type=int, help = 'Maximum number of characters by word. Default: 256', required=False, default=256)
parser.add_argument('-v', '--verbose', action='store_true', help='Verbose output', default=False)

args = parser.parse_args()
pattern = "\w{" + str(args.min) + ",}"
words = {}

basedir = args.directory
#basedir = '.'

def print_verbose(msg):
    if args.verbose:
        print(msg,file=sys.stderr)

def parsefile(file):

    print_verbose(f"Parsing file '{file}' ...")

    try:
        f = open(file, "r")
        for line in f.readlines():
            for word in re.findall(pattern, line):
                if len(word)<=args.max and word not in words:
                    words[word] = None
    except BaseException as error:
        print(f"Error reading file {file}: {error}",file=sys.stderr)
    finally:
        f.close()

def scandir(dir):

    print_verbose(f"Looking in '{dir}' ...")

    for ent in os.scandir(dir):

        if ent.is_file():
            parsefile(ent.path)

        elif ent.is_dir():
            scandir(ent.path)


print_verbose(f"Carving from directory '{basedir}', looking for strings with length between {args.min} and {args.max} characters ...")
scandir(basedir)

for word in words:
    print(word)