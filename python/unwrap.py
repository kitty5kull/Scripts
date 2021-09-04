#!/bin/python3

import re
import sys
import html
import argparse


def unwrap(input, lookBehind, lookAhead):

    match = re.search('(?<=({0})).*(?=({1}))'.format(lookBehind, lookAhead), input)

    if match is None:
        return ""

    output = html.unescape(match.group(0))
    return re.sub("<\s*br\s*\/>", "\n", output)


def main():

    parser = argparse.ArgumentParser("Unwraps HTML-wrapped text files")
    parser.add_argument("lookbehind", metavar="look-behind", help="The last string before the wrapped text. This is basicalla a regex look-behind.")
    parser.add_argument("lookahead", metavar="look-ahead", help="The last string after the wrapped text. This is basically a regex look-ahead.")
    args = parser.parse_args()

    lines = sys.stdin.read()
    text = "".join(lines).replace("\n", "");

    output = unwrap(text.replace("\n",""), args.lookbehind, args.lookahead)
    print(output)


if __name__ == '__main__':
    main()