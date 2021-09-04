#!/bin/python3

#Imports
print("Importing stuff");

import sys #system functions
from datetime import datetime
print(datetime.now())

from datetime import datetime as dt
print (dt.now());

def new_line():
	print ('\n');

#Advanced strings
print("Advanced strings");

name = "Billy";
print (name[0]);
print (name[-1]);

sentence  ="This is a sentence.";
print(sentence[:4]);
print(sentence[-9:-1]);

print (sentence.split())

splitted = sentence.split();
joined = ' '.join(splitted);
print(joined);

print('\n'.join(splitted));

print ("A" in "Apple");
print ("B" in "Apple");

print ("a" in "Apple");

movie = "E.T."
print("Fav mov: {}!",format(movie))

def fav_book(title, author):
	fav = "My fav book is \"{}\" by {}.".format(title,author);
	return fav;

print(fav_book("Hexen", "Pratchett"));

#Dicts
print("Dictionaries:");
drinks = {"WR":5,"Old":4, "Lem":7}
print(drinks);

empl = {"Finance": ["Bob","Linda","Jeff"], "IT" : ["Ross", "Jebediah"]}
print(empl);


