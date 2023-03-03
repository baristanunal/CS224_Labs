.data
	msgA:	  	.asciiz "Please enter the value of a: "
	msgB:	  	.asciiz "Please enter the value of b: "
	msgC:	  	.asciiz "Please enter the value of c: "
	msgMod:		.asciiz "( A * ( B - C ) ) % 16 = "
.text 

main:
	# 1. Get the values of A, B, C from the user
	
	# 1.1.1 Ask the user for the value A
	li $v0, 4
	la $a0, msgA
	syscall
	
	# 1.1.2 Get user input for A
	li $v0, 5
	syscall
	
	# 1.1.3 Store the value
	add $s0, $v0, $0 			# $s0 = A
	
	
	# 1.2.1 Ask the user for the value B
	li $v0, 4
	la $a0, msgB
	syscall
	
	# 1.2.2 Get user input for B
	li $v0, 5
	syscall
	
	# 1.2.3 Store the value
	add $s1, $v0, $0 			# $s1 = B
	
	
	# 1.3.1 Ask the user for the value C
	li $v0, 4
	la $a0, msgC
	syscall
	
	# 1.3.2 Get user input for A
	li $v0, 5
	syscall
	
	# 1.3.3 Store the value
	add $s2, $v0, $0 			# $s2 = C
	
	
	# 2. Subtract C from B
	sub $t1, $s1, $s2			# $t1 = B - C
	
	# 3. Multiply A with (B - C)
	mul $t2, $s0, $t1			# $t2 = A * (B - C)
	
	
	# 4. Find $t2 mod 16
	addi $t3, $0, 16			# $t3 = 16 (for comparison purposes)
	
	j Test
	
Loop:	addi $t2, $t2, -16

Test:	slt $t4, $t3, $t2
	bne $t4, $0, Loop
	
	
	# 5. Print the mod value
	li $v0, 4
	la $a0, msgMod
	syscall
	
	li $v0, 1
	add $a0, $t2, $0
	syscall
	
Fin:	# END OF MAIN
	li $v0, 10
	syscall
	
	