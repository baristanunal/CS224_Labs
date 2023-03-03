
#############################

# LAB 3 | PRELIMINARY PART 2
# CS224-06 Computer Architecture
# Barış Tan Ünal
# 22003617

# Recursive division.

#############################


.data
	msgDividentPrompt:		.asciiz "\nPlease enter the divident: "
	msgDivisorPrompt:		.asciiz "\nPlease enter the divisor: "
	msgQuotientPrompt:		.asciiz "\nThe quotient is: "
	msgContinuePrompt:		.asciiz "\n\nDo you want to exit or continue? (0 to exit, 1 to continue.): "

.text

.globl main	
main:

Continue:
	# 1. Ask for the inputs.
	
	# 1.1.1 Ask for the divident.
	li $v0, 4
	la $a0, msgDividentPrompt
	syscall
	
	# 1.1.2 Get the divident.
	li $v0, 5
	syscall
	add $s0, $v0, $0				# $s0: divident 
		
	# 1.2.1 Ask for the divisor.
	li $v0, 4
	la $a0, msgDivisorPrompt
	syscall
	
	# 1.2.1 Get the divisor.
	li $v0, 5
	syscall
	add $s1, $v0, $0				# $s1: divisor 


	# 2. Call the recursiveDivision function.
	add $a0, $s0, $0
	add $a1, $s1, $0
			
	jal recursiveDivision
	
	#----------------------------
	# 3. Perform the sub-program.
	#----------------------------
	
	
	# 4. Display the quotient.
	add $s2, $v0, $0				# $s2: quotient
	
	li $v0, 4
	la $a0, msgQuotientPrompt
	syscall
	
	add $a0, $s2, $0
	li  $v0, 1
	syscall
	
	
	# 5. Ask the user if they want to continue with other inputs.
	li $v0, 4
	la $a0, msgContinuePrompt
	syscall
	
	li $v0, 5
	syscall
	add $t0, $v0, $0				# $t0: continue value (exit if 0, continue if 1) 
	
	bne $t0, $0, Continue
		
	li $v0, 10					# end of main
	syscall

	#------------------------------------------------------------
	
.globl recursiveDivision	
recursiveDivision:
	# 3.1.1 Push $s registers and $ra to the stack.
	addi $sp, $sp, -8
	sw   $ra, 0($sp)	
	sw   $s0, 4($sp)
	
	# 3.1.2 Base case.
	li  $v0, -1
	slt $s1, $a0, $0
	bne $s1, $0, DivisionDone
	
	# 3.1.3 Subtract the divisor from divident once.
	add $s0, $a0, $0
	sub $a0, $a0, $a1
	jal recursiveDivision
		
	# 3.1.4 Add 1 to the return value.	
	addi $v0, $v0, 1
	
	DivisionDone:
		lw   $ra, 0($sp)
		lw   $s0, 4($sp)
		addi $sp, $sp, 8  
		jr $ra	

#-------------------------------------
# End of function section.
#-------------------------------------



