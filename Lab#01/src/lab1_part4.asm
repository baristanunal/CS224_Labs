
#############################

# LAB 1 | PART 4
# CS224-06 Computer Architecture
# Barış Tan Ünal
# 22003617

# Simple menu with loops.

#############################

.data
	myArray:		.space 400
	msgGetArray:		.asciiz "Please enter the array elements (-1 to stop): \n"
	msgMenu:		.asciiz "\n\nSelect a operation to perform: \n1) Find summation array elements which are less than an input number.\n2) Find the numbers of even and odd numbers.\n3) Display the number of occurrences of the array elements NOT divisible by a certain input number.\n4) Quit.\n\nOperation: "
	msgPivotInput:		.asciiz "\nEnter the pivot input: "
	msgCountDisplay: 	.asciiz "\nSum of array elements which are less than the input number: "
	msgOdd:			.asciiz "\nNumber of ODD numbers: "
	msgEven:		.asciiz "\nNumber of EVEN numbers: "
	msgNotDivisible:	.asciiz "\nNumber of occurrences of the array elements NOT divisible by the pivot input: "
	newLine:  		.asciiz "\n"
	space: 	  		.asciiz ", "	
	
.text

main:	

	# 1.1 Ask the user for the elements of the array.
	
	li $v0, 4
	la $a0, msgGetArray
	syscall
	
	# 1.2 Get the array elements.
	
	addi $t9, $0, -1			# $t9 = -1 (sentinel value)
	
	add $t8, $0, $0				# $t8: size (= 0)
	add $t1, $0, $0				# $t1: index (= 0)

LoopG:	li $v0, 5				# get the value from user
	syscall
	
	beq $v0, $t9, Sntnel			# check if the value is sentinel		
						
	sw   $v0, myArray($t1)			# put the value in the array
	addi $t1, $t1, 4			# enlarge the array
	addi $t8, $t8, 1			# cntr = cntr + 1
	
	j LoopG


	# 2. Print the array.
	
Sntnel:	jal prntnl
	add $s0, $0, $t8			# $s0: size
	
	add $t2, $0, $0				# $t2: cntr (= 0)
	add $t1, $0, $0				# $t1: index (= 0)
	j TestP

LoopP:  lw   $t5, myArray($t1)			# $t5: current element
	li   $v0, 1
	add  $a0, $t5, $0
	syscall
	
	jal prntsp
	
	addi $t1, $t1, 4			
	addi $t2, $t2, 1

TestP:  slt $t4, $t2, $t8			# set $t4 = 1 (if) a = -1
	bne $t4, $0, LoopP
	

	# 3. Print the menu items.
Menu:
	li $v0, 4
	la $a0, msgMenu
	syscall
	
	# 4.1 Get the desired operation number.
	li $v0, 5				# get the operation number from the user
	syscall
	
	# 4.2 Initialize the possible operation numbers.
	addi $t0, $0, 1
	addi $t1, $0, 2
	addi $t2, $0, 3
	addi $t3, $0, 4
	
	# 4.3 Go to the appropriate operation branch.
	beq $v0, $t0, op1
	beq $v0, $t1, op2
	beq $v0, $t2, op3
	beq $v0, $t3, op4
	
	
	# 5. Perform the operation. 
	
	# 5.1 Find summation of array elements which are less than an input number.
	
	# 5.1.1 Get the pivot input.
op1: 	li $v0, 4
	la $a0, msgPivotInput
	syscall
	
	li $v0, 5				# get the pivot number from the user
	syscall
	
	# 5.1.2 Initiliaze registers.
	add  $t1, $v0, $0			# $t1: pivot input
	add  $t2, $0, $0			# $t2: sum
	add  $t3, $0, $0			# $t3: counter ( increases by 1 )
	add  $t4, $0, $0			# $t4: index   ( increases by 4 )	
	add  $t5, $0, $0			# $t5: set less than (0 or 1)
	addi $t6, $0, 1				# $t6 = 1
	
	# 5.1.3 Find the sum.
	j TestOp1
LoopOp1:
	lw  $t7, myArray($t4)			# $t7: current element
	
	slt $t5, $t7, $t1			# set $t5 = 1 (if) cur < pivot		
	bne $t5, $t6, AddOp1
	
	add  $t2, $t2, $t7
	
AddOp1:
	addi $t4, $t4, 4			# index = index + 4
	addi $t3, $t3, 1			# cntr  = cntr + 1

TestOp1:
	slt $t5, $t3, $s0			# set $t5 = 1 (if) counter => size
	beq $t5, $t6, LoopOp1			# go to loop or exit
	
	# 5.1.4 Display the sum.
	li $v0, 4
	la $a0, msgCountDisplay
	syscall
	
	add $a0, $t2, $0
	li $v0, 1
	syscall
	
	j Menu
	
	
	# 5.2 Find the numbers of even and odd numbers.
	
op2: 	li $v0, 4
	la $a0, msgOdd
	syscall
	
	# 5.2.1 Initiliaze registers.
	add  $t1, $0, $0			# $t1: mod ( odd if =1 )
	addi $t2, $0, 2				# $t2 = 2
	add  $t3, $0, $0			# $t3: counter ( increases by 1 )
	add  $t4, $0, $0			# $t4: index   ( increases by 4 )	
	add  $t5, $0, $0			# $t5: set less than (0 or 1)
	add  $t6, $0, $0			# $t6: number of odd numbers
	add  $t7, $0, $0			# $t7: number of even numbers
	addi $t8, $0, 1				# $t8 = 1
	
	
LoopOp2: 
	lw   $t9, myArray($t4)			# $t9: current element
	div  $t9, $t2
	mfhi $t1
	beq  $t1, $0, Even
	
	addi $t6, $t6, 1
	j IncrementOp2
	
Even:	
	addi $t7, $t7, 1
	
IncrementOp2:	
	addi $t4, $t4, 4			
	addi $t3, $t3, 1

TestOp2:  
	slt $t5, $t3, $s0			# set $t5 = 1 (if) counter => size
	beq $t5, $t8, LoopOp2			# go to loop or exit
	
	# 5.2.3 Print the numbers
	li $v0, 4
	la $a0, msgOdd
	
	li $v0, 1
	add $a0, $t6, $0
	syscall
	
	li $v0, 4
	la $a0, msgEven
	syscall
	
	li $v0, 1
	add $a0, $t7, $0
	syscall
	
	j Menu
	
	
	# 5.3 Display the number of occurrences of the array elements NOT divisible by a certain input number.
	
	# 5.3.1 Get the pivot input.
op3: 	li $v0, 4
	la $a0, msgPivotInput
	syscall
	
	li $v0, 5				# get the pivot number from the user
	syscall
	
	# 5.3.2 Initiliaze registers.
	add  $t1, $v0, $0			# $t1: pivot input
	add  $t2, $0, $0			# $t2: sum
	add  $t3, $0, $0			# $t3: counter ( increases by 1 )
	add  $t4, $0, $0			# $t4: index   ( increases by 4 )	
	add  $t5, $0, $0			# $t5: set less than (0 or 1)
	addi $t6, $0, 1				# $t6 = 1
	add  $t9, $0, $0			# $t9: number of occurences
	
	# 5.3.3 Find the number of occurences.
	j TestOp3
LoopOp3:
	lw  $t7, myArray($t4)			# $t7: current element
	
	div  $t7, $t1
	mfhi $t8				# $t8 = (cur) mod (pivot)
	
	beq $t8, $0, SkipOp3			# if it is divisible, skip addition
	
	addi $t9, $t9, 1
	
SkipOp3:
	addi $t4, $t4, 4			# index = index + 4
	addi $t3, $t3, 1			# cntr  = cntr + 1

TestOp3:
	slt $t5, $t3, $s0			# set $t5 = 1 (if) counter => size
	beq $t5, $t6, LoopOp3			# go to loop or exit

	# 5.3.4 Print the number of occurences.
	li $v0, 4
	la $a0, msgNotDivisible
	syscall
	
	li $v0, 1
	add $a0, $t9, $0
	syscall
	
	j Menu


op4:	# nothing


# END OF MAIN
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
		
	
