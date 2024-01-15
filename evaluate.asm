# 1. Create a stack to store operands
# 2. Scan the given expression and do the following for every scanned element
	# 2.1 If the element is an operand, push it into the OperandStack.
	# 2.2 If the element is an operator, pop two elements from the OperandStack.
		# Evaluate the two operands on the scanned operator
		# Then, push the result back to the stack
# 3. When the expression is fully scanned, the number in the OperandStack is the final answer.

.text
	PostEvaluation:
	# Get the output queue array address
	move $t2, $a0
	li $s0, 0 		# Initialize OperandStack top index to 0	
	
	evaluationLoop:
	lw $t3, 0($t2)		# save the current element of output queue
	beq $t3, $zero, printResult	# if you are at the end of the output queue, go to end 
	addi $t2, $t2, 4	# increment so in next iteration, we read next element of array
		
		# If value is not a digit (value < 0)
		# because + is -57, - is -55, * is -58, / is -53
		bltz $t3, notdigit
		
		# If value is a digit
		digit:
		# then push $t3 to the OperandStack
		sw $t3, OperandStack($s0)	# store $t3 to OperatorStack
		addi $s0, $s0, 4		# increment OperatorStack top index
		j evaluationLoop
			
		# Else if value is not a digit, pop OperandStack twice and 
		#	use the operator to perform operation on the two popped elements
		notdigit:
			# num1 = $f1, num2 = $f2
			# pop off the top element of the OperandStack, and load value to a float register
			addi $s0, $s0, -4
			lwc1 $f2, OperandStack($s0)	# save OperandStack top element to $f2, then pop it
			lw $s2, OperandStack($s0)	# save OperandStack top element to $f2, then pop it
			
			# pop off the top element of the OperandStack, and load value to a float register
			addi $s0, $s0, -4
			lwc1 $f1, OperandStack($s0)	# save OperandStack top element to $f1, then pop it
			lw $s1, OperandStack($s0)
			
			# perform operation on $f1 and $f2 based on operator
			beq $t1, -57, doAdd	# if $t1 == + 	== (add_op ascii = 43) - 100 == -57
			beq $t1, -55, doSub	# if $t1 == -	== (sub_op ascii = 45) - 100 == -55
			beq $t1, -58, doMul	# if $t1 == * 	== (mul_op ascii = 42) - 100 == -58
			beq $t1, -53, doDiv	# if $t1 == /	== (div_op ascii = 47) - 100 == -53
			
			doAdd:
				add.s $f0, $f1, $f2
				j pushResultToOperandStack
				
			doSub:
				sub.s $f0, $f1, $f2
				j pushResultToOperandStack
			
			doMul:
				mul $s3, $s1, $s2
				mfhi $s4
				mtc1 $s3, $f0
				mtc1 $s4, $f3
				cvt.s.w $f3, $f3
				add.s $f0, $f0, $f3
				j pushResultToOperandStack
			
			doDiv:
				div.s $f0, $f1, $f2
				c.eq.s $f0, $f0		# this line activates printNowDontCovert at label printResult
				j pushResultToOperandStack
				
			# PUSH $f0 TO OperandStack
			pushResultToOperandStack:
				l.s $f0, OperandStack($s0)	# store $f0 to OperatorStack
				addi $s0, $s0, 4		# increment OperatorStack top index
				j evaluationLoop		# move to next element of the queue
		
	# If the end of the PostfixQueue is reached, then the result is top OperatorStack top element;
	# 	pop off the top element of the OperandStack, and load value to a float register
	printResult:
		addi $s0, $s0, -4
		l.s $f12, OperandStack($s0)	# save OperandStack top element to $f12, then pop it
		#l.s $f13, 0.0        		# set $f13 to 0.0 (least significant half)
	
		# Print result text (with $v0 = 4)
		li $v0, 4
		la $a0, result
		syscall
		
<<<<<<< Updated upstream
=======
		addi $s0, $s0, -4
		lw $t5, OperandStack($s0) 	#Save the OperandStack top element to $t5 and pop it
		mtc1 $t5, $f12 			# move $t5 to $f12
		bc1t printNowDontCovert	### If division was performed, jump to printNowDontCovert. Else, convert.
		cvt.s.w $f12, $f12 		# Convert the value of $f12 (still a word value) to a floating-point value
		
>>>>>>> Stashed changes
		# Print result float (with $v0 = 2 and $f12, $f3 loaded above)
		printNowDontCovert:
		li $v0, 2
		syscall
		
		jr $ra
			
			
.data
	.align 4
	OperandStack: .space 200	# Array to store the OperandStack elements
	result: .asciiz "The result is "
