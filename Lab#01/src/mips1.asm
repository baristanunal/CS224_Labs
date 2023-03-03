.data
	ogArray:  .space 80
	revArray: .space 80
	newLine:  .asciiz "\n"
	space: 	  .asciiz ", "	
	msg1:	  .asciiz "Please enter the size of the array: "
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


LoopP:  lw   $t5, ogArray($t1)			# $t5 = current element
	li   $v0, 1
	add  $a0, $t5, $0
	syscall
	
	jal prntsp
	
	addi $t1, $t1, 4			
	addi $t2, $t2, 1

TestP:  slt $t4, $t2, $s0			# set $t4 = 1 (if) i < arraySize
	bne $t4, $0, LoopP
			
	
	# 4. Reverse the array
	
	jal prntnl	
		
	# 4.1.1 Take the middle + 1 index
	addi $t7, $s0, 1			
	sra  $t7, $t7, 1			# $t7 = mid + 1 index (starts at 1, increases by 1)
	
	add  $t8, $t7, $0
	sll  $t8, $t8, 2			# $t8 = mid + 1 index (starts at 0, increases by 4)
	
	#addi $t7, $t7, 1
	add  $s1, $t7, $0			# $s1 = mid + 1 index (saved index - same as $t7)
	
		
	# 4.1.2 Set the counter and index for revArray
	add $t2, $0, $0				# $t2 = cntr (= 0)
	add $t1, $0, $0				# $t1 = index (= 0)
	j TestR1
		
LoopR1:	# 4.1.3 Get the proper element from the second half of ogArray
	lw $t5, ogArray($t8)
	
	# 4.1.4 Store that element to the revArray
	#sw   $t5, revArray($t1)
	#addi $t1, $t1, 4
	
	addi $t8, $t8, 4			
	addi $t7, $t7, 1
	
	# 4.1.5 Print the element
	li  $v0, 1
	add $a0, $t5, $0
	syscall
	jal prntsp
	
	
TestR1: slt $t4, $t7, $s0			# set $t4 = 1 (if) i < arraySize
	bne $t4, $0, LoopR1	
		
	
	
	# 4.2.1 Initialize counter and index
	addi $s2, $s1, -1 			# $s2 = mid - 1	
	add $t7, $0, $0
	add $t8, $0, $0
	
	# 4.2.2 Determine if the arraySize is odd
	addi $t1, $t1, 2
	div  $s0, $t1 
	mfhi $t9
	beq  $t9, $0, TestEv
					
	# 4.2.3 Print the middle element if the arraySize is odd
	li  $v0, 1
	add $a0, $s1, $0
	syscall
	jal prntsp			
			
	j TestOd		
											
	# 4.3 Print the first half (EVEN)
	
LoopEv: # 4.3.1 Get the proper element from the second half of ogArray
	lw $t5, ogArray($t8)
	
	# 4.3.2 Store that element to the revArray
	#sw   $t5, revArray($t1)
	#addi $t1, $t1, 4

	# 4.3.3 Increment the index and counter
	addi $t8, $t8, 4			
	addi $t7, $t7, 1
	
	# 4.3.4 Print the element
	li  $v0, 1
	add $a0, $t5, $0
	syscall
	jal prntsp
			
TestEv:	slt $t4, $t7, $s1			# set $t4 = 1 (if) i < mid + 1
	bne $t4, $0, LoopEv			
	
	j Exit
	
	
	# 4.3 Print the first half (ODD)	
																																
LoopOd: # 4.3.1 Get the proper element from the second half of ogArray
	lw $t5, ogArray($t8)
	
	# 4.3.2 Store that element to the revArray
	#sw   $t5, revArray($t1)
	#addi $t1, $t1, 4

	# 4.3.3 Increment the index and counter
	addi $t8, $t8, 4			
	addi $t7, $t7, 1
	
	# 4.3.4 Print the element
	li  $v0, 1
	add $a0, $t5, $0
	syscall
	jal prntsp
			
TestOd:	slt $t4, $t7, $s2			# set $t4 = 1 (if) i < mid + 1
	bne $t4, $0, LoopOd			
																		
																																	
	
Exit:	# END OF MAIN
	li $v0, 10
	syscall
	
	
	# Print new line
prntnl: li $v0, 4
	la $a0, newLine
	syscall
	jr $ra
	
	# Print space & comma
prntsp: li $v0, 4
	la $a0, space
	syscall
	jr $ra
	
	
	
	
	