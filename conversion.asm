.text
	InPostConversion:
	# Tokens: 
	li $s0, '(' 	# open_paren
	li $s1, ')'	# close_paren
	li $s2, '+' 	# add_op
	li $s3, '-' 	# sub_op
	li $s4, '*' 	# mul_op
	li $s5, '/' 	# div_op
	
	# Get the tokenized infix expression 
	move $t2, $a2
	
	conversionLoop:
		lw $s7, 0($t2)		# save the current element of infix expression array
		addi $t2, $t2, 4	# increment so in next iteration, we read next element of $a2 array
		beq $s7, $zero, end	# if you are at the end of the infix expression array, go to end 
		lb $t3, 0($s7)		# else, read the first byte of one word
		
		#Check if the current array value is a number
		#Assume that $t3 = member of the array
		li  $t4, '0'
		bltu $t3, $t4, notdig        # Jump if char < '0'

		li $t4,'9'
		bltu $t4, $t3, notdig       # Jump if '9' < char
		
		#Value is a digit
		dig:
			# PUSH $S7 TO OutputQueue; $s7 first byte is a digit, so push the whole word and not juist 1 byte or $t3
			move $a0, $s7 #move $s7 to $a0 as it will be used by the subprogram
			jal enqueue
			
			b conversionLoop
			
		#Value is not a digit
		notdig:
			beq $s2, $t3, isAddOrSub	# if $t3 == + 
			beq $s3, $t3, isAddOrSub	# if $t3 = -
			beq $s4, $t3, isMulOrDiv	# if $t3 == * 
			beq $s5, $t3, isMulOrDiv	# if $t3 == /
			beq $s0, $t3, isOpenParen	# if $t3 == (
			beq $s1, $t3, isCloseParen	# if $t3 == )
			
			isAddOrSub:
				# if OperatorStack is empty, go to pushInputToOperatorStack
				lw $s6, OperatorStack_TopIndex
				beq $s6, $zero, pushInputToOperatorStack
				
				# else if the OperatorStack is NOT empty, execute the following:
				
				# pop off the top element $s7 of the OperatorStack
				lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
				lw $s7, OperatorStack($t7)	# save OperatorStack top element to $s7, then pop it off
				addi $t7, $t7, -4
				sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
					
					# if $s7 == (
					beq $s0, $s7, pushPoppedElementBackToOperatorStack # then pushInputToOperatorStack
					# else if $s7 == *  /
					beq $s4, $s7, pushInputToOperatorStack	
					beq $s5, $s7, pushInputToOperatorStack
					
					# PUSH $S7 TO OutputQueue 
					addi $s7, $s7, -100	# deduct 100 from operator since it will be pushed to OutputQueue as a number
					move $a0, $s7 #move $s7 to $a0 as it will be used by the subprogram
					jal enqueue
					
					b isAddOrSub
				
				pushPoppedElementBackToOperatorStack:
					# push $s7 back to OperatorStack
					lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
					addi $t7, $t7, 4		
					sw $s7, OperatorStack($t7)
					sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
			
				pushInputToOperatorStack:
					# push $t3 to OperatorStack
					lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
					addi $t7, $t7, 4
					sw $t3, OperatorStack($t7)
					sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
					
					b conversionLoop	# move to the next element of the array
			
			isMulOrDiv:
				# if OperatorStack is empty, go to pushInputToOperatorStack
				lw $s6, OperatorStack_TopIndex			
				beq $s6, $zero, pushInputToOperatorStack_duplicate
				
				# else if the OperatorStack is NOT empty, execute the following:
				
				# pop off the top element $s7 of the OperatorStack
				lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
				lw $s7, OperatorStack($t7)	# save OperatorStack top element to $s7, then pop it off
				addi $t7, $t7, -4
				sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
					
					# if $s7 == ( 
					beq $s0, $s7, pushPoppedElementBackToOperatorStack_duplicate # then pushInputToOperatorStack_duplicate
					
					#PUSH $S7 TO OutputQueue
					addi $s7, $s7, -100	# deduct 100 from operator since it will be pushed to OutputQueue as a number
					move $a0, $s7 #move $s7 to $a0 as it will be used by the subprogram
					jal enqueue
					
					b isMulOrDiv
					
				pushPoppedElementBackToOperatorStack_duplicate:
					lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
					addi $t7, $t7, 4
					sw $s7, OperatorStack($t7)
					sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
						
				pushInputToOperatorStack_duplicate:
					# push $t3 to OperatorStack
					lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
					addi $t7, $t7, 4
					sw $t3, OperatorStack($t7)
					sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
					
					b conversionLoop	# move to the next element of the array

			isOpenParen: 
				# push $t3 to OperatorStack
				lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
				addi $t7, $t7, 4
				sw $t3, OperatorStack($t7)
				sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
				
				b conversionLoop	# move to the next element of the array
			
			isCloseParen: 
				# if OperatorStack is empty, go to popOperatorStack
				lw $s6, OperatorStack_TopIndex			
				beq $s6, $zero, popOperatorStack
				
				# else if the OperatorStack is NOT empty
				
				# pop off the top element $s7 of the OperatorStack
				lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
				lw $s7, OperatorStack($t7)	# save OperatorStack top element to $s7, then pop it off
				addi $t7, $t7, -4
				sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
					
					# if $s7 == (
					beq $s0, $s7, popOperatorStack
					
					# PUSH $S7 TO OutputQueue
					addi $s7, $s7, -100	# deduct 100 from operator since it will be pushed to OutputQueue as a number
					move $a0, $s7 #move $s7 to $a0 as it will be used by the subprogram
					jal enqueue
					
					b isCloseParen
			
				popOperatorStack:
					# pop off the top element $s7 of the OperatorStack
					lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
					lw $s7, OperatorStack($t7)
					addi $t7, $t7, -4
					sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
					
					b conversionLoop	# move to the next element of the array

		end:
			# if OperatorStack is empty, go to endProgram
			lw $s6, OperatorStack_TopIndex
			beq $s6, $zero, endProgram
			
			# else if the OperatorStack is NOT empty, execute the following:
			
			# pop off the top element $s7 of the OperatorStack
			lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
			lw $s7, OperatorStack($t7)	# save OperatorStack top element to $s7, then pop it off
			addi $t7, $t7, -4
			sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
			
			# PUSH $S7 TO OutputQueue 
			addi $s7, $s7, -100	# deduct 100 from operator since it will be pushed to OutputQueue as a number
			move $a0, $s7		# move $s7 to $a0 as it will be used by the subprogram
			jal enqueue
			
			j end
		
		endProgram:
			jr $ra		#### To debug, copy the popOperatorStack code here
    
.data
	.align 4
	OperatorStack: .space 200	# Array to store the OperatorStack elements
	OperatorStack_TopIndex: .word 0	# Initialize TopIndex to 0
	InfixExpression: .space 20

.include "queue.asm"
	
