#!/bin/python3

#urlencode.py: Enocde all strings from stdin as an URL parameter

import urllib
from urllib.parse import quote

from sys import stdin

for line in stdin:
	print(quote(line.strip(),safe=''))
	
