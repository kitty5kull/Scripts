#!/bin/python3

for i in range(1,31):
	print ("So easy")
	if i%5==0 and i%3==0:
		print ("Fizz Buzz");
	elif i%3==0:
		print ("Fizz");
	elif i%5==0:
		print ("Buzz");
	else:
		print (i);

