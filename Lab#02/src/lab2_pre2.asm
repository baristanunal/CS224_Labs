
#############################

# LAB 2 | PRELIMINARY PART 2
# CS224-06 Computer Architecture
# Barış Tan Ünal
# 22003617

# Array operations.

#############################


.data
	commaSpace:		.asciiz ", "
	msgArraySize:		.asciiz "\nPlease enter the size of the array: "
	msgArrayElements:	.asciiz "\nPlease enter the elements of the array:\n"
	msgPrintArray:		.asciiz "\nYour array is:\n"
	msgMenu:		.asciiz "\n\nSelect a operation to perform: \n1) Find the minimum value stored in the array. \n2) Find the maximum value stored in the array. \n3) Find the summation of array elements. \n4) Check if array contents defines a palindrome. \n5) Quit program. \n\nYour operation: "
	msgMinPrompt:		.asciiz "\nThe minimum element is: "
	msgMaxPrompt:		.asciiz "\nThe maximum element is: "
	msgSumPrompt:		.asciiz "\nThe sum of all elements is: "
	msgIsPalPrompt:		.asciiz "\nThe array IS palindrome."
	msgNotPalPrompt:	.asciiz "\nThe array IS NOT palindrome."
	
.text

main:
	# 1. Call createArray.
	jal createArray
	
	# 2. Get the arrayAddress and arraySize values.
	add $a0, $v0, $0				# $a0: arraySize
	add $a1, $v1, $0				# $a1: arrayAddress

	# 3. Call arrayOperations.
	jal arrayOperations
	
	li $v0, 10				# end of main
	syscall
	
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

arrayOperations:
				
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
	add $s0, $a0, $0				# $s0: arraySize		
	add $s1, $a1, $0				# $s1: arrayAddress
						
	# 3. Print the menu items.
Menu:
	li $v0, 4
	la $a0, msgMenu
	syscall
	
	# 3.1 Get the desired operation number.
	li $v0, 5				
	syscall
	
	# 3.2 Initialize the possible operation numbers.
	addi $s4, $0, 1
	addi $s5, $0, 2
	addi $s6, $0, 3
	addi $s7, $0, 4
	addi $s3, $0, 5
	
	# 3.3 Go to the appropriate operation branch.
	beq $v0, $s4, min
	beq $v0, $s5, max
	beq $v0, $s6, sum
	beq $v0, $s7, palindrome
	beq $v0, $s3, quit
	
	# 4. Perform the appropriate operation branch.
	
		# 4.MIN Ge the  minimum element.	
	min:
		# 4.MIN.1 Initiliaze values.
		add  $s2, $s1, $0			# $s2: index1   - increases by 4 (= arrayAddress)
		addi $s3, $0, 1				# $s3: counter1 - increases by 1 (= 1)
		
		# 4.MIN.2 Find the min element.
		lw   $s4, 0($s2)			# $s4: min element
		addi $s2, $s2, 4
		
		beq $s3, $s0, MinPrint

	MinLoop:
		lw  $s5, 0($s2)				# $s5: current element
		
		add $s6, $0, $0
		slt $s6, $s5, $s4
		beq $s6, $0, SkipSetMin			# skip set new element if current is not less than min
		
		add $s4, $s5, $0			# set new min element
		
	SkipSetMin:
		addi $s2, $s2, 4			
		addi $s3, $s3, 1

	MinTest:  
		bne $s3, $s0, MinLoop
	
	MinPrint:		
		# 4.MIN.3 Print the minimum element.
		li $v0, 4
		la $a0, msgMinPrompt
		syscall
		
		li  $v0, 1
		add $a0, $s4, $0
		syscall
		
		j Menu
	
		# 4.MAX Get the maximum element.
	max:
		# 4.MAX.1 Initiliaze values.
		add  $s2, $s1, $0			# $s2: index1   - increases by 4 (= arrayAddress)
		addi $s3, $0, 1				# $s3: counter1 - increases by 1 (= 1)
		
		# 4.MAX.2 Find the max element.
		lw   $s4, 0($s2)			# $s4: max element
		addi $s2, $s2, 4
	
		beq $s3, $s0, MaxPrint

	MaxLoop:
		lw  $s5, 0($s2)				# $s5: current element
		
		add $s6, $0, $0
		slt $s6, $s4, $s5
		beq $s6, $0, SkipSetMax			# skip set new element if current is not greater than max
		
		add $s4, $s5, $0			# set new max element
		
	SkipSetMax:
		addi $s2, $s2, 4			
		addi $s3, $s3, 1

	MaxTest:  
		bne $s3, $s0, MaxLoop
		
	MaxPrint:	
		# 4.MAX.3 Print the maximum element.
		li $v0, 4
		la $a0, msgMaxPrompt
		syscall
		
		li  $v0, 1
		add $a0, $s4, $0
		syscall
		
		j Menu
	
	
		# 4.SUM Get the sum of the elements.
	sum:
		# 4.MAX.1 Initiliaze values.
		add  $s2, $s1, $0			# $s2: index1   - increases by 4 (= arrayAddress)
		add  $s3, $0, $0			# $s3: counter1 - increases by 1 (= 0)
		
		# 4.MAX.2 Find the max element.
		add  $s4, $0, $0			# $s4: sum

	SumLoop:
		lw  $s5, 0($s2)				# $s5: current element
		
		add $s4, $s4, $s5
		
		addi $s2, $s2, 4			
		addi $s3, $s3, 1
	
	SumTest:  
		bne $s3, $s0, SumLoop
		
		# 4.MAX.3 Print the sum.
		li $v0, 4
		la $a0, msgSumPrompt
		syscall
		
		li  $v0, 1
		add $a0, $s4, $0
		syscall
		
		j Menu


		# 4.PAL Check if the array is a palindrome.
	palindrome:
	
		# 4.PAL.1 Initiliaze values.
		add  $s3, $0, $0				# slt value (= 0)
		add  $s2, $s1, $0			# $s2: index1  - increases by 4 (= arrayAddress)
		sll  $s4, $s0, 2
		add  $s5, $s1, $s4			
		addi $s5, $s5, -4			# $s5: index2 - decreases by 4 (= last element)

		# 4.PAL.2 Traverse the array from both sides and check if palindrome.
	PalindromeLoop:
		lw $s6, 0($s2)				# $s6: element from first half
		lw $s7, 0($s5)				# $s7: element from last half
		
		addi $s2, $s2, 4
		addi $s5, $s5, -4
			
		slt $s3, $s5, $s2
		bne $s3, $0, IsPalindrome	
		
	PalindromeTest: 
		bne $s6, $s7, NotPalindrome
		j PalindromeLoop
		
		# 4.PAL.3.F Print notPalindrome prompt.
	NotPalindrome:	
		add $v0, $0, $0	
		li  $v0, 4
		la  $a0, msgNotPalPrompt
		syscall
		
		j Menu
		
		# 4.PAL.3.T Print isPalindrome prompt.
	IsPalindrome:
		addi $v0, $0, 1	
		li   $v0, 4
		la   $a0, msgIsPalPrompt
		syscall
		
		j Menu
		
	quit:																									
		# 5. Pop $s registers from the stack.
		lw   $s0, 0($sp)	
		lw   $s1, 4($sp)
		lw   $s2, 8($sp)
		lw   $s3, 12($sp)
		lw   $s4, 16($sp)
		lw   $s5, 20($sp)
		lw   $s6, 24($sp)
		lw   $s7, 28($sp)
		addi $sp, $sp, 32				
																							
		jr $ra
	
	#----------------------------------
	# end of arrayOperations subprogram
	#----------------------------------

	
	
	
