.text
	# Tokens: 
	li $s0, '(' 	# open_paren
	li $s1, ')'	# close_paren
	li $s2, '+' 	# add_op
	li $s3, '-' 	# sub_op
	li $s4, '*' 	# mul_op
	li $s5, '/' 	# div_op
	
	InPostConversion:
		#Joenne: Check if the value of array is an operator and add to stack accordingly 
		#James: Check if the value of array is a number and add to queue accordingly
		
		#Check if the current array value is a number
		#Assume that $t1 = member of the array
		li  $t0, '0'
		bltu   $t1,$t0, notdig        # Jump if char < '0'

		li $t0,'9'
		bltu   $t0,$t1, notdig       # Jump if '9' < char
		
		#Value is a digit
		dig:
			
			b end
			
		#Value is not a digit
		notdig:
			beq $s2, $t1, isAddOrSub	# if $t1 == + 
			beq $s3, $t1, isAddOrSub	# if $t1 = -
			beq $s4, $t1, isMulOrDiv	# if $t1 == * 
			beq $s5, $t1, isMulOrDiv	# if $t1 == /
			beq $s0, $t1, isOpenParen	# if $t1 == (
			beq $s1, $t1, isCloseParen	# if $t1 == )
			
			isAddOrSub:
				# $s6 is OperatorStack
				# if OperatorStack is empty, go to pushInputToOperatorStack
				lw $s6, 0($sp)		
				beq $s6, $zero, pushInputToOperatorStack
				
				# else if the OperatorStack is NOT empty
					# pop off the top element $s7 of the OperatorStack
					lw $s7, 0($sp)	
					addi $sp, $sp, 4
					
					# if $s7 is ( * / 
					# if $s7 == ( then push $s7 back to OperatorStack
					beq $s0, $s7, pushS7BackToOperatorStack
						pushS7BackToOperatorStack:
							addi $sp, $sp, -4
							sw $s7, 0($sp)
							b pushInputToOperatorStack
					beq $s4, $s7, pushInputToOperatorStack	# if $s7 == * 
					beq $s5, $s7, pushInputToOperatorStack	# if $s7 == /
					
					# PUSH $S7 TO OutputQueue
					
					b isAddOrSub
			
				pushInputToOperatorStack:
					# push $t1 to OperatorStack
					addi $sp, $sp, -4
					sw $t1, 0($sp)
					
					b InPostConversion	# move to the next element of the array
			
			isMulOrDiv:
				# $s6 is OPERATOR STACK 
				# if OperatorStack is empty, go to pushInputToOperatorStack
				lw $s6, 0($sp)		
				beq $s6, $zero, pushInputToOperatorStack
				
				# else if the OperatorStack is NOT empty
					# pop off the top element $s7 of the OperatorStack
					lw $s7, 0($sp)	
					addi $sp, $sp, 4
					
					# if $s7 is (
					# if $s7 == ( then push $s7 back to OperatorStack
					beq $s0, $s7, pushS7BackToOperatorStack
						pushS7BackToOperatorStack:
							addi $sp, $sp, -4
							sw $s7, 0($sp)
							b pushInputToOperatorStack
					
					# PUSH $S7 TO OutputQueue
					
					b isMulOrDiv
			
				pushInputToOperatorStack:
					# push $t1 to OperatorStack
					addi $sp, $sp, -4
					sw $t1, 0($sp)
					
					b InPostConversion	# move to the next element of the array

			isOpenParen: 
					# push $t1 to OperatorStack
					addi $sp, $sp, -4
					sw $t1, 0($sp)
					
					b InPostConversion	# move to the next element of the array
			
			isCloseParen: 
				# $s6 is OPERATOR STACK 
				# if OperatorStack is empty, go to pushInputToOperatorStack
				lw $s6, 0($sp)		
				beq $s6, $zero, popOffOperatorStack
				
				# else if the OperatorStack is NOT empty
					# pop off the top element $s7 of the OperatorStack
					lw $s7, 0($sp)	
					addi $sp, $sp, 4
					
					# if $s7 == (, then pop $s7 from the OperatorStack
					beq $s0, $s7, popOffOperatorStack # if $s7 == (
					
					# PUSH $S7 TO OutputQueue
					
					b isMulOrDiv
			
				popOffOperatorStack:
					# pop off the top element $s7 of the OperatorStack
					lw $s7, 0($sp)	
					addi $sp, $sp, 4
					
					b InPostConversion	# move to the next element of the array

		end:

.data
	