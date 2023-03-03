
#############################

# LAB 1 | PRELIMINARY PART 1
# CS224-06 Computer Architecture
# Barış Tan Ünal
# 22003617

# Shifters.

#############################


.data
	msgDecimalPrompt:	.asciiz "\nPlease enter a DECIMAL NUMBER to be shifted: "
	msgDirectionPrompt:	.asciiz "\nPlease enter the DIRECTION of shifting ( -1 to left shift, 1 to right shift ): "
	msgAmountPrompt:	.asciiz "\nPlease enter the AMOUNT of shifting: "
	msgInitialNum:		.asciiz "\n\nThe initial hex number was: "
	msgFinalNum:		.asciiz "\nThe shifted hex number is: "
	msgShAmt:		.asciiz "\nThe amount of shift was: "
	dirR:			.asciiz "\nThe direction of the shift was RIGTH."
	dirL:			.asciiz "\nThe direction of the shift was LEFT."
	

.text

main:
	# 1. Ask & get the inputs.
	
	# 1.1 Ask the user for a decimal number.
	li $v0, 4
	la $a0, msgDecimalPrompt
	syscall
	
	# 1.2 Get the decimal number.
	li $v0, 5
	syscall
	
	add $s0, $v0, $0			# $s0: decimal number 
	
	# 1.3 Ask the user for the direction of shift.
	li $v0, 4
	la $a0, msgDirectionPrompt
	syscall
	
	# 1.4 Get the direction.
	li $v0, 5
	syscall				
	
	add $s1, $v0, $0			# $s1: direction
	
	# 1.5 Ask the user for the amount of shifting.
	li $v0, 4
	la $a0, msgAmountPrompt
	syscall
	
	# 1.6 Get the amount.
	li $v0, 5
	syscall
	
	add $s2, $v0, $0			# $s2: shift amount
	

	# 2. Call the approriate method.
	slt $s3, $0, $s1			# $s3 = 1 IF $s1 = 1 (right) 
	beq $s3, $0, SLC			# go to SLC if $s3 = 0
	jal SRC					# go to SRC if not
	
	#----------------------------
	# 3. Perform the sub-program.
	#----------------------------
	
	# 4. Print the result.
Print:	
	add $s3, $v0, $0			# save the return value in $s3

	# 4.1 Print the initial number.
	li $v0, 4
	la $a0, msgInitialNum
	syscall
	
	add $a0, $s0, $0
	li  $v0, 34
	syscall
	
	# 4.2 Print the shamt and the direction.
	li $v0, 4
	la $a0, msgShAmt
	syscall
	
	add $a0, $s2, $0
	li  $v0, 1
	syscall
	
	addi $s7, $0, 1				# $s7 = 1
	
	beq  $s1, $s7, PrintRight	
	j PrintLeft
	
	
	PrintRight:
		li $v0, 4
		la $a0, dirR
		syscall
		j ContinuePrint
		
	PrintLeft:	
		li $v0, 4
		la $a0, dirL
		syscall
	
ContinuePrint:	

	# 4.3 Print the final hex number.
	li $v0, 4
	la $a0, msgFinalNum
	syscall
	
	add $a0, $s3, $0
	li  $v0, 34
	syscall
	
	j Fin
	
	#-------------------------------------
	# Method Section
	#-------------------------------------
	
SLC:
	# 3.1.1 Push $s registers to the stack.
	addi $sp, $sp, -12
	sw   $s0, 0($sp)	
	sw   $s1, 4($sp)
	sw   $s2, 8($sp)
	
	# 3.1.2 Shift left.
	j SLCTest
	
	SLCLoop:
		andi $s3, $s0, 0x80000000	# take the MSB of number
		srl  $s3, $s3, 31	
		sll  $s0, $s0, 1
		add  $s0, $s0, $s3		# new number with the first bit at the end
		addi $s2, $s2, -1
		
	SLCTest:
		bne  $s2, $0, SLCLoop		# shAmt = shAmt - 1
			
	# 3.1.3 Pop $s registers from the stack.
	add $v0, $s0, $0			# return value
	
	lw   $s0, 0($sp)	
	lw   $s1, 4($sp)
	lw   $s2, 8($sp)
	
	j Print
	
SRC:
	# 3.2.1 Push $s registers to the stack.
	addi $sp, $sp, -12
	sw   $s0, 0($sp)	
	sw   $s1, 4($sp)
	sw   $s2, 8($sp)
	
	# 3.2.2 Shift left.
	j SRCTest
	
	SRCLoop:
		andi $s3, $s0, 0x00000001	# take the LSB of number
		sll  $s3, $s3, 31
		srl  $s0, $s0, 1
		add  $s0, $s0, $s3		# new number with the first bit at the end
		addi $s2, $s2, -1
		
	SRCTest:
		bne  $s2, $0, SRCLoop		# shAmt = shAmt - 1
			
	# 3.2.3 Pop $s registers from the stack.
	add $v0, $s0, $0			# return value
	
	lw  $s0, 0($sp)	
	lw  $s1, 4($sp)
	lw  $s2, 8($sp)
	
	jr $ra
	
	#-------------------------------------
	# End of method section.
	#-------------------------------------
	
Fin:	

# END OF MAIN
	li $v0, 10
	syscall
	

