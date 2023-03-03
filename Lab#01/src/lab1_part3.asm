
#############################

# LAB 1 | PART 3
# CS224-06 Computer Architecture
# Barış Tan Ünal
# 22003617

# Calculates (a - b) / ( (ab - b) % a ) & prints it.

#############################

.data 
	promptA:	.asciiz "Please enter the value for A: "
	promptB:	.asciiz "Please enter the value for B: "
	printValue:	.asciiz "(a - b) / ( (ab - b) % a ) = "
	divideZero:	.asciiz "Illegal operation: divide by zero"

.text

main:
	# 1.1.1 Ask for the value of A to the user.
	li $v0, 4
	la $a0, promptA
	syscall
	
	# 1.1.2 Get the A value.
	li $v0, 5
	syscall
	
	# 1.1.3 Store the A value.
	add $t0, $v0, $0		# $t0 = A
	
	# 1.2.1 Ask for the value of B to the user.
	li $v0, 4
	la $a0, promptB
	syscall
	
	# 1.2.2 Get the A value.
	li $v0, 5
	syscall
	
	# 1.2.3 Store the A value.
	add $t1, $v0, $0		# $t1 = B
	
	# 1.2.3.1 Branch if divide by zero.
	beq $t1, $0, DivideByZero
	
	
	# 2.1 Multiply a * b.
	mult $t0, $t1
	mflo $t2			# $t2 = a * b
	
	# 2.2 Add a - b.
	sub $t3, $t0, $t1		# $t3 = a - b
	
	# 2.3 Subtract ( (a * b) - b ).
	sub $t4, $t2, $t1		# $t4 = (a * b) - b
	
	# 2.4 Find ((a * b) - b) mod a
	div $t4, $t0			
	mfhi $t5			# $t5 = ((a * b) - b) mod a
	
	# 2.4.1 Branch if 0
	beq $t5, $0, DivideByZero
	
	# 2.5 Find (a - b) / (((a * b) - b) mod a)
	div  $t3, $t5
	mflo $t6			# $t6 = result	
	
	
	# 3. Print values.
	li $v0, 4
	la $a0, printValue
	syscall
	
	li $v0, 1
	la $a0, 0($t6)
	syscall
	
	j fin

DivideByZero:
	li $v0, 4
	la $a0, divideZero
	syscall

# END OF MAIN
fin:
	li $v0, 10
	syscall
