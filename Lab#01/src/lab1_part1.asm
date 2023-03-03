
#############################

# CS224-06 Computer Architecture
# Barış Tan Ünal
# 22003617

# Calculates (a * b) / (a + b) & prints it.

#############################

.data 
	promptA:	.asciiz "Please enter the value for A: "
	promptB:	.asciiz "Please enter the value for B: "
	printValue:	.asciiz "(a * b) / (a + b) = "

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
	add $t1, $v0, $0		# $t1 = A
	
	# 1.2.1 Ask for the value of B to the user.
	li $v0, 4
	la $a0, promptB
	syscall
	
	# 1.2.2 Get the B value.
	li $v0, 5
	syscall
	
	# 1.2.3 Store the B value.
	add $t2, $v0, $0		# $t2 = B

	
	# 2.1 Multiply a * b.
	mul $t3, $t1, $t2		# $t3 = a * b
	
	# 2.2 Add a + b.
	add $t4, $t1, $t2		# $t4 = a + b
	
	# 2.3 Divide (a * b) / (a + b).
	div $t5, $t3, $t4 		# $t5 = (a * b) / (a + b)
					
	
	# 3. Print the value.
	li $v0, 4
	la $a0, printValue
	syscall
	
	li $v0, 1
	add $a0, $t5, $0
	syscall

# END OF MAIN
	li $v0, 10
	syscall

