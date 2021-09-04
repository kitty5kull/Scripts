#!/bin/python3

#Print string
print("Strings and things");
print('Hello world');
print("""Hello,
this is a multiline
string.""");

print ("This" + " is " + " easy");
print('\n') #new line



#Math
print("Math time:");
print(5+3);

print(5/3);

print(5//3);


#Variables & Methods
print("Variables and Stuff");
quote = "So this is implicitly defined";
print(str(len(quote))+" -> this si easy" + quote.upper());
print(quote.title());


print("Conversion");
fl = 29.9;
print(int(fl)) # rounds down
print(round(fl)) # rounds up

#functions
print("Now some funcs");

def who_am_i():
	name="HEath"
	age = 29
	print("y name is " + name + " and I am " + str(age) + " years old");


who_am_i();



