# MIPS Value Manipulator
This is a MIPS Assembly Program developed as a class project using MARS IDE. It takes two arguments from the command line.

The first argument is parsed to a Two's Complement integer using the "atoi" formula, breaking at any non-numerical character. The converted is then displayed in both decimal and hexadecimal.

The second argument tells the program what to do with the converted value. Here are the following options.

"1": Convert the value to its One's Complement value.

"s": Convert the argument to its Signed Magnitude value.

"g": Convert the argument to its Gray Code value.

"d": Convert the argument to its Double Dabble value.

The final value is then displayed.