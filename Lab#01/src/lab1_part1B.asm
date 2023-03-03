##
## Program1.asm - prints out "Hello -yourname-"
##
##	a0 - points to the string
##

#################################
#					 	#
#		text segment		#
#						#
#################################

	.text		
	.globl __start 

__start:		# execution starts here
	# la $a0,str	# put string address into a0
	# li $v0,4	# system call to print
	# syscall		#   out a string

	# 1. Ask for user's name.
	li $v0, 4
	la $a0, inputMsg
	syscall
	
	# 2. Get the user input.
	li $v0, 8
	la $a0, userInput
	li $a1, 20
	syscall

	# 3. Display hello message.
	li $v0, 4
	la $a0, str
	syscall
	
	li $v0, 4
	la $a0, userInput
	syscall
	
	
	li $v0,10  # system call to exit
	syscall	#    bye bye


#################################
#					 	#
#     	 data segment		#
#						#
#################################

	.data
str:		.asciiz "Hello, "
inputMsg:	.asciiz "Your name: "
userInput: 	.space 20
n:		.word	10

##
## end of file Program1.asm
