
#############################

# LAB 3 | PRELIMINARY PART 1
# CS224-06 Computer Architecture
# Barış Tan Ünal
# 22003617

# Counting instructions.

#############################

 
.data
	msgMainAddCountPrompt:		.asciiz "\nThe number ADD instructions in MAIN: "
	msgMainOriCountPrompt:		.asciiz "\nThe number ORI instructions in MAIN: "
	msgMainLwCountPrompt:		.asciiz "\nThe number LW instructions in MAIN: "
	msgFuncAddCountPrompt:		.asciiz "\n\nThe number ADD instructions in FUNCTION: "
	msgFuncOriCountPrompt:		.asciiz "\nThe number ORI instructions in FUNCTION: "
	msgFuncLwCountPrompt:		.asciiz "\nThe number LW instructions in FUNCTION: "

.text

.globl main
main:	

		# 1. Call the function for main.
	BeginL:
		la $a0, BeginL				# ori inside the la instruction!
		la $a1, EndL				
		
		jal instructionCount
		
		add $s0, $v0, $0			# $s0: MAIN ADD count
		add $s1, $v1, $0			# $s1: MAIN ORI count
		add $s2, $a0, $0			# $s2: MAIN LW count
		
		
		# 2. Call the function for the function itself.
		la $a0, instructionCount
		la $a1, EndOfInstCount
		
		jal instructionCount
		
		add $s3, $v0, $0			# $s3: FUNC ADD count
		add $s4, $v1, $0			# $s4: FUNC ORI count
		add $s5, $a0, $0			# $s5: FUNC LW count
		
		
		# 3. Print the results.
		
		# 3.1.1
		li $v0, 4
		la $a0, msgMainAddCountPrompt
		syscall
		
		add $a0, $s0, $0
		li  $v0, 1
		syscall
		
		# 3.1.2
		li $v0, 4
		la $a0, msgMainOriCountPrompt
		syscall
		
		add $a0, $s1, $0
		li  $v0, 1
		syscall
		
		# 3.1.3
		li $v0, 4
		la $a0, msgMainLwCountPrompt
		syscall
		
		add $a0, $s2, $0
		li  $v0, 1
		syscall
		
		# 3.2.1
		li $v0, 4
		la $a0, msgFuncAddCountPrompt
		syscall
		
		add $a0, $s3, $0
		li  $v0, 1
		syscall
		
		# 3.2.2
		li $v0, 4
		la $a0, msgFuncOriCountPrompt
		syscall
		
		add $a0, $s4, $0
		li  $v0, 1
		syscall
		
		# 3.2.3
		li $v0, 4
		la $a0, msgFuncLwCountPrompt
		syscall
		
		add $a0, $s5, $0
		li  $v0, 1
		syscall
				
	EndL:		
		li $v0, 10					# end of main
		syscall
	#------------------------------------------------------------
	
.globl instructionCount
instructionCount:
	# 1. Push $s registers to the stack.
	addi $sp, $sp, -32
	sw   $s0, 0($sp)	
	sw   $s1, 4($sp)
	sw   $s2, 8($sp)
	sw   $s3, 12($sp)
	sw   $s4, 16($sp)	
	sw   $s5, 20($sp)
	sw   $s6, 24($sp)
	sw   $s7, 28($sp)
	
	add $s0, $0, $0					# $s0: add
	add $s1, $0, $0					# $s1: ori
	add $s2, $0, $0					# $s2: lw
	add $s3, $0, $0					# $s3: temp inst
	
	addi $s5, $0, 0x00000020			# $s5: add funct
	addi $s6, $0, 0x0000000d			# $s6: ori opcode
	addi $s7, $0, 0x00000023			# $s7: lw  opcode
	
	# 2. Traverse over the addresses between given labels.
	FuncLoop:
		lw   $s3, 0($a0)
		andi $s4, $s3, 0x0000003f		# $s4: function field
		srl  $s3, $s3, 26			# $s3: opcode field
		
		# 2.1 Add instruction.
		bne  $s3, $0, SkipAdd
		bne  $s4, $s5, SkipAdd
		addi $s0, $s0, 1
		j FuncTest
					
	SkipAdd:	
		# 2.2 Ori instruction.
		bne  $s3, $s6, SkipOri
		addi $s1, $s1, 1
		j FuncTest
		
	SkipOri:		
		# 2.3 Lw instruction.							
		bne  $s3, $s7, FuncTest
		addi $s2, $s2, 1
		j FuncTest
		
	FuncTest:
		addi $a0, $a0, 4
		bne  $a0, $a1, FuncLoop
		
		add $v0, $s0, $0			# $v0: add count
		add $v1, $s1, $0			# $v1: ori count
		add $a0, $s2, $0			# $a0: lw count
	
	# 3. Pop $s registers from the stack.
	lw   $s0, 0($sp)	
	lw   $s1, 4($sp)
	lw   $s2, 8($sp)
	lw   $s3, 12($sp)
	lw   $s4, 16($sp)	
	lw   $s5, 20($sp)
	lw   $s6, 24($sp)
	lw   $s7, 28($sp)
	addi $sp, $sp, 32
	
EndOfInstCount:
	jr $ra

#-------------------------------------
# End of function section.
#-------------------------------------

