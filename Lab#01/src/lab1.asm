.data
	ogArray: .space 80
	newLine: .asciiz "\n"
	space: 	 .asciiz ", "	
	msg1:	 .asciiz "Please enter the size of the array: "
	msgtmp:  .asciiz "The size is "
.text 
	
main:
	# 1.1 Ask the user for the size of the array
	li $v0, 4
	la $a0, msg1
	syscall
	
	
	# 1.2 Get user input for length of the array
	li $v0, 5
	syscall
	
	# 1.3 Store the size value
	add $s0, $v0, $0 			# $s0 = arraySize
	
	
	
	# 2. Get the array elements
	
	add $t2, $0, $0				# $t2 = cntr (= 0)
	add $t1, $0, $0				# $t1 = index (= 0)
	j TestG
	
LoopG:	li $v0, 5				# get the value from user
	syscall
	
				
	sw   $v0, ogArray($t1)			# put the value in the array
	addi $t1, $t1, 4			# enlarge the array
	addi $t2, $t2, 1			# cntr = cntr + 1
	
TestG:	slt $t4, $t2, $s0			# set $t4 = 1 (if) i < arraySize
	bne $t4, $0, LoopG
	
	
	
	# 3. Print the original array
				
	jal prntnl
	
	add $t2, $0, $0				# $t2 = cntr (= 0)
	add $t1, $0, $0				# $t1 = index (= 0)
	j TestP
	
LoopP: 	lw  $t5, ogArray($0)
	li  $v0, 1
	add $a0, $t5, $0
	syscall
	
	jal prntsp
	
	
TestP:	slt $t4, $t2, $s0			# set $t4 = 1 (if) i < arraySize
	bne $t4, $0, LoopP			


	# END OF MAIN
	li $v0, 10
	syscall
	
	
	# Print new line
prntnl:	li $v0, 4
	la $a0, newLine
	syscall
	jr $ra
	
	# Print space & comma
prntsp: li $v0, 4
	la $a0, space
	syscall
	jr $ra 	
	
	
	
	
