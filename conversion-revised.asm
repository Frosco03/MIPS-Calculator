# 1. Read one char of infix array (from left to right)
# 2. If char is not an operand, 
#	If char is (, push char to OperatorStack
#	Else if char is ), pop OperatorStack and push to OutputQueue until ( is encountered. 
# 	Else if char is an operator, check precedence and perform operations
# 3. If char is operand, push to OutputQueue
# 4. Repeat 1-3
# 5. Pop all elements of OperatorStack and push each to OutputQueue

.text
	InPostConversion:
	# Get the tokenized infix expression address
	move $t2, $a0
	li $s0, 0 		# Initialize OperatorStack top index to 0
	li $t0, 0		# Initialize Queue Counter
	la $t1, queueArray
	
	conversionLoop:
	lw $t3, 0($t2)		# save the current element of infix expression array
	beq $t3, $zero, end	# if you are at the end of the infix expression array, go to end 
	lb $t4, 0($t2)		# else, read the first byte of current element
	addi $t2, $t2, 4	# increment so in next iteration, we read next element of array
	
		# If value is not a digit
		notdig:
		beq $t4, '(', isOpenParen	# if $t4 == (
		beq $t4, ')', isCloseParen	# if $t4 == )
		beq $t4, '+', isOperator	# if $t4 == + 
		beq $t4, '-', isOperator	# if $t4 = -
		beq $t4, '*', isOperator	# if $t4 == * 
		beq $t4, '/', isOperator	# if $t4 == /
			
		# If value is a digit
		dig:
		# push $t3 to OutputQueue
		# Value that will be stored in the queueArray is at $t3
		sw $t3, 0($t1)
		addi $t1, $t1, 4
		addi $t0, $t0, 1
		
		j conversionLoop
		
		# FUNCTIONS	
		isOpenParen:
			# push char $t3 to OperatorStack			
			sw $t3, OperatorStack($s0)	# store $t3 to OperatorStack
			addi $s0, $s0, 4		# increment OperatorStack top index
				
			j conversionLoop	# move to the next element of the array
			
		isCloseParen:
			# if OperatorStack is empty, go to next element of infix array
			beqz $s0, conversionLoop
		
			# pop $t5 from OperatorStack
			addi $s0, $s0, -4		# decrement OperatorStack top index
			lw $t5, OperatorStack($s0)	# $t5 stores OperatorStack popped element
			
			# if $t5 == (, stop and go to next element of infix array
			beq $t5, '(', conversionLoop
			
			# push char $t5 to OutputQueue
			addi $t5, $t5, -100
			# Value that will be stored in the queueArray is at $t5
			sw $t5, 0($t1)
			addi $t1, $t1, 4
			addi $t0, $t0, 1
			
			j isCloseParen
		
		isOperator:
			checkPrecedenceOfGiven:
				# $s1 = precedence value of char $t3/$t4
				li $s1, 1
				beq $t4, '+', OperatorLoop	# if $t4 == + 
				beq $t4, '-', OperatorLoop	# if $t4 = -
				li $s1, 2
				beq $t4, '*', OperatorLoop	# if $t4 == * 
				beq $t4, '/', OperatorLoop	# if $t4 == /
				
			OperatorLoop:
				# check if OperatorStack is empty before execute of code
				beqz $s0, isEmptyOperatorStack
				
				# pop $t5 from OperatorStack
				addi $s0, $s0, -4		# decrement OperatorStack_TopIndex
				lw $t5, OperatorStack($s0)	# $t5 stores OperatorStack top
				
				# if $t5 == (
				beq $t5, '(', isPoppedElementOpenParen
			
				# else check precedence of $t5
				checkPrecedenceOfPopped:
				# $s2 = precedence value of $t5
				li $s2, 1
				beq $t5, '+', comparePrecedenceValues	# if $t4 == + 
				beq $t5, '-', comparePrecedenceValues	# if $t4 = -
				li $s2, 2
				beq $t5, '*', comparePrecedenceValues	# if $t4 == * 
				beq $t5, '/', comparePrecedenceValues	# if $t4 == /
				
					comparePrecedenceValues:
					blt $s2, $s1, OpTopLessThanOpThis
						
					# push char $t5 to OutputQueue
					addi $t5, $t5, -100
					# Value that will be stored in the queueArray is at $t5
					sw $t5, 0($t1)
					addi $t1, $t1, 4
					addi $t0, $t0, 1
						
					j OperatorLoop
						
				OpTopLessThanOpThis:
					# push $t5 back to OperatorStack
					sw $t5, OperatorStack($s0)	# $t5 stores OperatorStack top
					addi $s0, $s0, 4		# increment OperatorStack Top Index

					j isEmptyOperatorStack
			
				isPoppedElementOpenParen:
					# push $t5 back to OperatorStack
					sw $t5, OperatorStack($s0)	# $t5 stores OperatorStack top
					addi $s0, $s0, 4		# increment OperatorStack Top Index
					
				isEmptyOperatorStack:
					# push char $t3 to OperatorStack
					sw $t3, OperatorStack($s0)	# $t5 stores OperatorStack top
					addi $s0, $s0, 4		# increment OperatorStack Top Index
				
					j conversionLoop	# move to the next element of the array
					
	end:
		# check if OperatorStack is empty before execute of code
		beqz $s0, returnToMainProgram
		
		# pop $t5 from OperatorStack
		addi $s0, $s0, -4		# decrement OperatorStack Top Index
		lw $t5, OperatorStack($s0)	# $t5 stores OperatorStack top
		
		# push char $t5 to OutputQueue
		addi $t5, $t5, -100
		# Value that will be stored in the queueArray is at $t5
		sw $t5, 0($t1)
		addi $t1, $t1, 4
		addi $t0, $t0, 1
		
		j end
	
	returnToMainProgram:
		la $a0, queueArray
		jr $ra
.data
	.align 4
	OperatorStack: .space 200	# Array to store the OperatorStack elements
	queueArray: .space 200 #no of members in the queueArray * 4 bytes per word
	debugging_space: .asciiz " "
