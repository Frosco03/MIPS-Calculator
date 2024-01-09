# 1. Create a stack to store operands
# 2. Scan the given expression and do the following for every scanned element
	# 2.1 If the element is an operand, push it into the OperandStack.
	# 2.2 If the element is an operator, pop two elements from the OperandStack.
		# Evaluate the two operands on the scanned operator
		# Then, push the result back to the stack
# 3. When the expression is fully scanned, the number in the OperandStack is the final answer.

.text
	# Tokens: 
	li $s0, '+' 	# add_op
	li $s1, '-' 	# sub_op
	li $s2, '*' 	# mul_op
	li $s3, '/' 	# div_op
	
	PostEvaluation:
		# If the element is an operand, push it into the OperandStack.
		# If the element is an operator, pop two elements from the OperandStack.
		
		# Check if the current array value is a number
		# Assume that $t1 = member of the array
		li  $t0, '0'
		bltu   $t1,$t0, notdig        # Jump if char < '0'

		li $t0,'9'
		bltu   $t0,$t1, notdig       # Jump if '9' < char
		
		# If value is a digit, then push it to the OperandStack
		dig:
			#### PUSH IT TO OperandStack; ADD CODE HERE
			
			b end
			
		# Else if value is not a digit, pop OperandStack twice and 
		#	use the operator to perform operation on the two popped elements
		notdig:
			# num1 = $s6, num2 = $s7
			# pop off the top element $s7 of the OperandStack
			lw $t7, OperatorStack_TopIndex	# load current OperandStack_TopIndex
			lw $s7, OperatorStack($t7)	# save OperandStack top element to $s7, then pop it off
			addi $t7, $t7, -4
			sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
			
			# pop off the top element $s6 of the OperandStack
			lw $t7, OperatorStack_TopIndex	# load current OperandStack_TopIndex
			lw $s6, OperatorStack($t7)	# save OperandStack top element to $s6, then pop it off
			addi $t7, $t7, -4
			sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
			
			##### Convert $s6 and $s7 to floating type
			
			# perform operation on $s6 and $s7 based on operator
			beq $s0, $t1, doAdd	# if $t1 == + 
			beq $s1, $t1, doSub	# if $t1 = -
			beq $s2, $t1, doMul	# if $t1 == * 
			beq $s3, $t1, doDiv	# if $t1 == /
			
			##### CODE BELOW IS THE GIST OF THE IMPLEMENTATION; REPLACE TO cater to floating type
			
			doAdd:
				add $t2, $s6, $s7
				##### PUSH $t2 TO OperandStack; ADD CODE HERE
			
			doSub:
				sub $t2, $s6, $s7
				##### PUSH $t2 TO OperandStack; ADD CODE HERE
			
			doMul:
				mul $t2, $s6, $s7
				##### PUSH $t2 TO OperandStack; ADD CODE HERE
			
			doDiv:
				div $t2, $s6, $s7
				##### PUSH $t2 TO OperandStack; ADD CODE HERE
			
		end:
			jal Exit
			
			
.data
PostfixQueue: .space 200	# TEMPORARY Array to store the postfix expression
OperandStack: .space 200	# Array to store the OperandStack elements
OperandStack_TopIndex: .word 0	# Initialize TopIndex to 0

.include "utils.asm"
.include "queue.asm"