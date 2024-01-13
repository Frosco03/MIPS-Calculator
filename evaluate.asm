# 1. Create a stack to store operands
# 2. Scan the given expression and do the following for every scanned element
	# 2.1 If the element is an operand, push it into the OperandStack.
	# 2.2 If the element is an operator, pop two elements from the OperandStack.
		# Evaluate the two operands on the scanned operator
		# Then, push the result back to the stack
# 3. When the expression is fully scanned, the number in the OperandStack is the final answer.

.text
	PostEvaluation:
		# If the element is an operand, push it into the OperandStack.
		# If the element is an operator, pop two elements from the OperandStack.
		
		# Check if the current array value is a number
		# Assume that $t1 = member of the array
		li  $t0, '0'
		blt $t1, $zero, notdig        # Jump if number < 0, because (+ is -57, - is -55, * is -58, / is -53)
		
		# If value is a digit, then push it to the OperandStack
		dig:
			#### PUSH IT TO OperandStack; ADD CODE HERE
			
			j end
			
		# Else if value is not a digit, pop OperandStack twice and 
		#	use the operator to perform operation on the two popped elements
		notdig:
			# num1 = $f1, num2 = $f2
			# pop off the top element of the OperandStack, and load value to a float register
			lw $t7, OperandStack_TopIndex	# load current OperandStack_TopIndex
			l.s $f2, OperandStack($t7)	# save OperandStack top element to $s7, then pop it off
			addi $t7, $t7, -4
			sw $t7, OperandStack_TopIndex	# update OperatorStack_TopIndex
			
			# pop off the top element of the OperandStack, and load value to a float register
			lw $t7, OperandStack_TopIndex	# load current OperandStack_TopIndex
			l.s $f1, OperandStack($t7)	# save OperandStack top element to $s6, then pop it off
			addi $t7, $t7, -4
			sw $t7, OperandStack_TopIndex	# update OperatorStack_TopIndex
			
			# perform operation on $f1 and $f2 based on operator
			beq $t1, -57, doAdd	# if $t1 == + 	== (add_op ascii = 43) - 100
			beq $t1, -55, doSub	# if $t1 == -	== (sub_op ascii = 45) - 100
			beq $t1, -58, doMul	# if $t1 == * 	== (mul_op ascii = 42) - 100
			beq $t1, -53, doDiv	# if $t1 == /	== (div_op ascii = 47) - 100
			
			doAdd:
				add.s $f0, $f1, $f2
				j pushResultToOperandStack
				
			doSub:
				sub.s $f0, $f1, $f2
				j pushResultToOperandStack
			
			doMul:
				mul.s $f0, $f1, $f2
				j pushResultToOperandStack
			
			doDiv:
				div.s $f0, $f1, $f2
				j pushResultToOperandStack
				
			# PUSH $f0 TO OperandStack
			pushResultToOperandStack:
				lw $t7, OperandStack_TopIndex	# load current OperatorStack_TopIndex
				addi $t7, $t7, 4
				swc1 $f0, OperandStack($t7)
				sw $t7, OperandStack_TopIndex	# update OperatorStack_TopIndex
				
				#####b PostEvaluation	# move to next element of the queue
				
		end:
		
		
	printResult:
	# If the end of the PostfixQueue is reached, then the result is top OperatorStack top element;
	# 	pop off the top element of the OperandStack, and load value to a float register
		lw $t7, OperandStack_TopIndex	# load current OperandStack_TopIndex
		l.s $f12, OperandStack($t7)	# save OperandStack top element to $f12, then pop
		li.s $f13, 0.0        		# set $f13 to 0.0 (least significant half)
		addi $t7, $t7, -4
		sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
	
		# Print result text (with $v0 = 4)
		li $v0, 4
		la $a0, result
		syscall
		
		# Print result float (with $v0 = 2 and $f12, $f3 loaded above)
		li $v0, 2
		syscall
		
		jal Exit
			
			
.data
	.align 4
	PostfixQueue: .space 200	# TEMPORARY Array to store the postfix expression
	OperandStack: .space 200	# Array to store the OperandStack elements
	OperandStack_TopIndex: .word 0	# Initialize TopIndex to 0
	result: .asciiz "The result is "

.include "utils.asm"
.include "queue.asm"
