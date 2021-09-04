#!/bin/python3

import sys
import socket
from datetime import datetime


#Define target

if len(sys.argv)==2:
	target = socket.gethostbyname(sys.argv[1])
else:
	print("Invalid amount of arguments");
	print("Usage: portscan.py <host>");
	sys.exit()
	

try:
	for port in range(1,1000):
		s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		socket.setdefaulttimeout(1)
		result = s.connect_ex((target,port))
		if result==0:
			print ("{}:{}".format(target,port))
		s.close()
except KeyboardInterrupt:
	print("\nExiting program");
	sys.exit();
	
except socket.gaierror:
	print("Hostname could not be resolved");
	sys.exit();
	
except socket.error:
	print("Unable to connect")
	sys.exit();
