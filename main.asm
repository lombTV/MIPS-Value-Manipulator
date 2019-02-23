#	Project 1
#	Name: Matthew Lombardo
#	SCCC ID: 01177432
.data
	argOne: .byte '1'
	argSign: .byte 's'
	argGray: .byte 'g'
	negative: .byte '-'
	
	.align 2
	arg1: .word 0
	arg2: .word 0
	sum: .word 0
	isNegative: .word 0
	increment: .word 0
	size: .word 0
	
	error: .asciiz "Incorrect argument provided.\n"
	sm: .asciiz "Signed Magnitude: "
	one: .asciiz "One's Complement: "
	gray: .asciiz "Gray Code: "
	dbl: .asciiz "Double Dabble: "
	msg1: .asciiz "You entered "
	msg2: .asciiz " which parsed to "
	msg3: .asciiz "In hex it looks like "
	
	
	
# Helper macro for grabbing command line arguments
.macro load_args
	 lw $t0, 0($a1)
	 sw $t0, arg1
	 lw $t0, 4($a1)
	 sw $t0, arg2
.end_macro

# Macro for ending the program
.macro exit_program
	li $v0, 10
	syscall
.end_macro

# Macro for printing an integer
.macro print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
.end_macro

# Macro for printing a String Argument
.macro print_str (%str)
	li $v0, 4
	la $a0, %str
	syscall
.end_macro

.macro print_strarg (%str)
	.data
myLabel: .asciiz %str
	.text
	li $v0, 4
	la $a0, myLabel
	syscall
.end_macro
	
	print_str ("test1")	#"test1" will be labeled with name "myLabel_M0"


.text
main:
	load_args() # Arguments are stored into arg1 and arg2 respectively
part1:
	# Take the string arg1 and convert it to an integer in Two's Complement.
	# sum = 0
	lw $t0, sum
	li $t1, 0		
	sw $t1, sum
	# isNegative = false
	lw $t0, isNegative
	li $t1, 0		
	sw $t1, isNegative
	# increment = 0
	lw $t0, increment
	li $t1, 0
	sw $t1, increment
	## Check to see if there's a negative sign
	lw $t0, increment
	
	# if input[0] = '-'
	lw $a0, arg1
	lw $a1, increment
	add $a2, $a0, $a1
	lb $t1, 0($a2) 		#t1 is the first character of the string
	lb $t2, negative	#t2 is the character '-'
	# Branch to negativeTrue if the first character is '-'
	beq $t1,$t2, negativeTrue

	jal getArgSize
negativeTrue:
	# isNegative = true
	lw $t0, isNegative
	li $t1, 1	
	sw $t1, isNegative
	#  Increment the address of input by 1
	lw $a0, increment
	addi $a1, $a0, 1
	sw $a1, increment
	lw $t0, increment
	jal getArgSize
	
convert:
	# If increment is 1, jump the loop ahead 1 automatically. If it's not, go directly to the loop.
	lw $t3, arg1
	lw $t0, increment
	li $t1, 1
	beq $t0, $t1, addOne
	bne $t0, $t1, convertLoop
addOne:
	addi $t3, $t3, 1
convertLoop:
# NOTE: $t0 is the increment of the loop. $t1 is the size of the argument.
	lw $t0, increment
	lw $t1, size
	# Add 1 to size.
	addi $t1, $t1, 1
	# $t2 = The current character value of arg1
	lb $t2, 0($t3)
	
	# Branch off if we've hit the end of the loop.
	beq $t0, $t1, itsNegative
	# NOTE: $t2 contains the current character. $t3 contains the argument.
	# NOTE: '0' = byte 48, and '9' = byte 57
	# If the character is less than '0' or greater than '9', end the loop.
	li $t4, 48
	blt $t2, $t4, itsNegative
	li $t4, 57
	bgt $t2, $t4, itsNegative
	## sum = (sum * 10) + (char - '0')
	# $s0 = sum * 10
	lw $a0, sum
	sll $a1, $a0, 1
	sll $a2, $a0, 3
	add $s0, $a1, $a2
	#  $s1 = (char - '0')
	subi $s1, $t2, 48
	# sum = $s0 + $s1
	add $s2, $s0, $s1
	sw $s2, sum
	# Add 1 to the counter and increment the argument up by 1.
	addi $t0 $t0 1
	addi $t3 $t3 1
	# Save the increment and jump back to the beginning.
	sw $t0, increment
	
	j convertLoop
itsNegative:
	# If isNegative isn't true, jump directly to next part.
	lw $s5, isNegative
	li $s6, 1
	bne $s5, $s6, nextPart
	# sum = 0 - sum
	lw $t0, sum
	li $t1, 0
	sub $t2, $t1, $t0
	sw $t2, sum
nextPart:
	# Print out the ending of Part1
	li $v0, 4
	la $a0, msg1
	syscall
	
	li $v0, 4
	lw $a0, arg1
	syscall
	
	li $v0, 4
	la $a0, msg2
	syscall
	
	li $v0, 1
	lw $a0, sum
	syscall
	
	print_strarg("\n")
	li $v0, 4
	la $a0, msg3
	syscall
	
	li $v0, 34
	lw $a0, sum
	syscall
part2:
	print_strarg("\n")
# INSERT PART 2 HERE!
	lw $a0, arg2
	lb $a1, 0($a0)
	# If arg2 is 1, jump to One's Complement
	lb $a2, argOne
	beq $a1, $a2, onesComplement
	# If arg2 is s, jump to signed magnitude.
	lb $a2, argSign
	beq $a1, $a2, signedMagnitude
	# If arg2 is g, jump to Gray's Code.
	lb $a2, argGray
	beq $a1, $a2, graysCode
	# Else, jump to error.
	jal argError
onesComplement:
	print_strarg("Jumped to One's Complement!")
	jal exit
signedMagnitude:
	print_strarg("Jumped to Signed Magnitude!")
	jal exit
graysCode:
	print_strarg("Jumped to Gray's Code!")
	jal exit
argError:
	li $v0, 4
	la $a0, error
	syscall
	
	
	
	
	

exit:
	exit_program ()
getArgSize:
	# Load arg1 to $t0
	lw $t0, arg1
sizeLoop:
	# Increment up if the current character isn't a null value
	lb   $t1, 0($t0)
	beq  $t1, $zero sizeEnd
	addi $t0 $t0 1
	j sizeLoop
sizeEnd:
	# Save the size of the character to the variable "size"
	lw $t1, arg1
	sub $t3, $t0, $t1 #$t3 now contains the length of the string
	subi $t3, $t3, 1
	sw $t3, size
	jal convert