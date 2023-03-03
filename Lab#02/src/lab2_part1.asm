
#############################

# LAB 2 | LAB WORK 1
# CS224-06 Computer Architecture
# Barış Tan Ünal
# 22003617

# Bubble sort.

#############################

.data
	commaSpace:		.asciiz ", "
	msgArraySize:		.asciiz "\nPlease enter the size of the array: "
	msgArrayElements:	.asciiz "\nPlease enter the elements of the array:\n"
	msgPrintArray:		.asciiz "\nYour array is:\n"
	msgSortedPrompt:	.asciiz "\nSorted array:\n"

.text

main:
	# 1. Call createArray.
	jal createArray
	
	# 2. Get the arrayAddress and arraySize values.
	add $a0, $v0, $0				# $a0: arraySize
	add $a1, $v1, $0				# $a1: arrayAddress

	# 3. Call bubbleSort
	jal bubbleSort

	li $v0, 10				# end of main
	syscall

	#----------------------------------
	
bubbleSort:

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
	
	# 2. Get the arguments.	
	add  $s0, $a0, $0				# $s0: arraySize		
	add  $s1, $a1, $0				# $s1: arrayAddress
		
				
	# 3. Bubble sort the array.
	
	# 3.1 Initiliaze the registers.
	SortLoop:
		
		add  $s3, $0, $0				# $s3: isChanged
		add  $s2, $0, $s1				# $s2: current element index
		addi $s4, $0, 1					# $s4: counter - increases by 1 (= 1)
		
		beq $s0, $s4, PrintSortedArray	
		
		TraverseLoop:
			
			lw $s5, 0($s2)				# $s5: current element
			lw $s6, 4($s2)				# $s6: next element
			
			beq $s5, $s6, SkipSwap
		
			add $s7, $0, $0				# slt
			slt $s7, $s5, $s6
			bne $s7, $0, SkipSwap
		
			add  $s7, $s5, $0			# temp = cur
			add  $s5, $s6, $0			# cur = next
			add  $s6, $s7, $0			# next = temp
			addi $s3, $0, 1				# $s3 = 1 (isChanged)
			
			sw $s5, 0($s2)				# $s5: current element
			sw $s6, 4($s2)				# $s6: next element
		
		SkipSwap:
			addi $s4, $s4, 1
			addi $s2, $s2, 4
		
		TraverseTest:
			bne $s4, $s0, TraverseLoop
	
	SortTest:
		bne $s3, $0, SortLoop
	
	
	PrintSortedArray:
		# 4. Print the array elements.
		add  $s2, $s1, $0					# $s2: arrayAddress / index - increases by 4
		add  $s3, $0, $0					# $s3: counter - increases by 1 (= 0)
	
		# 4.1 Print the print array prompt.
		li $v0, 4
		la $a0, msgSortedPrompt
		syscall
	
		j PrintSortedArrayTest
	
	PrintSortedArrayLoop:
		lw   $s4, 0($s2)				# $s4: current element
		li   $v0, 1	
		add  $a0, $s4, $0
		syscall
	
		li $v0, 4
		la $a0, commaSpace
		syscall
	
		addi $s2, $s2, 4			
		addi $s3, $s3, 1

	PrintSortedArrayTest:  
		bne $s3, $s0, PrintSortedArrayLoop
		
		

	# 5. Pop $s registers from the stack.
	sw   $s0, 0($sp)	
	sw   $s1, 4($sp)
	sw   $s2, 8($sp)
	sw   $s3, 12($sp)
	sw   $s4, 16($sp)
	sw   $s5, 20($sp)
	sw   $s6, 24($sp)
	sw   $s7, 28($sp)
	addi $sp, $sp, 32				
																							
	jr $ra
	
	#----------------------------------
	# end of bubbleSort subprogram
	#----------------------------------
	
		
createArray:

	# 1. Push $s registers to the stack.
	addi $sp, $sp, -16
	sw   $s0, 0($sp)	
	sw   $s1, 4($sp)
	sw   $s2, 8($sp)
	sw   $s3, 12($sp)

	# 2.1 Ask the user for the array size.
	li $v0, 4
	la $a0, msgArraySize
	syscall
	
	# 2.2 Get the array size
	li $v0, 5
	syscall
	
	add $s0, $v0, $0				# $s0: arraySize
	
	# 2.3 Allocate the appropriate space for the array.
	sll $s1, $s0, 2
	li  $v0, 9
	add $a0, $s1, $0
	syscall
	
	add $s1, $v0, $0				# $s1: arrayAddress
	
	
	# 3. Get the array elements.
	add $s2, $s1, $0				# $s2: arrayAddress / index - increases by 4
	add $s3, $0, $0					# $s3: counter - increases by 1 (= 0)
	
	# 3.1 Ask the user for the array elements.
	li $v0, 4
	la $a0, msgArrayElements
	syscall
	
	j GetArrayTest
	
	GetArrayLoop:
		# 3.2 Get the element.
		li $v0, 5					# get the value from user
		syscall
					
		# 3.3 Save the element.												
		sw   $v0, 0($s2)				# put the value in the array 
		addi $s3, $s3, 1				# cntr = cntr + 1
		addi $s2, $s2, 4				# index = index + 4
	
	GetArrayTest:	
		bne $s3, $s0, GetArrayLoop
	
	
		# 4. Print the array elements.
		add  $s2, $s1, $0				# $s2: arrayAddress / index - increases by 4
		add  $s3, $0, $0				# $s3: counter - increases by 1 (= 0)
	
		# 4.1 Print the print array prompt.
		li $v0, 4
		la $a0, msgPrintArray
		syscall
	
		j PrintArrayTest

	PrintArrayLoop:
		lw   $s4, 0($s2)				# $s4: current element
		li   $v0, 1	
		add  $a0, $s4, $0
		syscall
	
		li $v0, 4
		la $a0, commaSpace
		syscall
	
		addi $s2, $s2, 4			
		addi $s3, $s3, 1
	
	PrintArrayTest:  
		bne $s3, $s0, PrintArrayLoop
		
		
		# 4. Save the return values.
		add $v0, $s0, $0
		add $v1, $s1, $0	
	
		# 5. Pop $s registers from the stack.
		lw  $s0, 0($sp)	
		lw  $s1, 4($sp)
		lw  $s2, 8($sp)
		lw  $s3, 12($sp)
		addi $sp, $sp, 16
	
		jr $ra
	
	#----------------------------------
	# end of createArray subprogram
	#----------------------------------

