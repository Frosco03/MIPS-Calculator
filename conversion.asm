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
				# if OperatorStack is empty, go to pushInputToOperatorStack
				lw $s6, OperatorStack_TopIndex
				beq $s6, $zero, pushInputToOperatorStack
				
				# else if the OperatorStack is NOT empty, execute the following:
				
				# pop off the top element $s7 of the OperatorStack
				lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
				lw $s7, OperatorStack($t7)	# save OperatorStack top element to $s7, then pop it off
				addi $t7, $t7, -4
				sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
					
					# check if $s7 is ( * / 
					# if $s7 == (
					beq $s0, $s7, pushPoppedElementBackToOperatorStack # then pushInputToOperatorStack
					# else if $s7 == *  /
					beq $s4, $s7, pushInputToOperatorStack	
					beq $s5, $s7, pushInputToOperatorStack
					
					##### PUSH $S7 TO OutputQueue; ADD CODE HERE
					
					b isAddOrSub
				
				pushPoppedElementBackToOperatorStack:
					# push $s7 back to OperatorStack
					lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
					addi $t7, $t7, 4		
					sw $s7, OperatorStack($t7)
					sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
			
				pushInputToOperatorStack:
					# push $t1 to OperatorStack
					lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
					addi $t7, $t7, 4
					sw $t1, OperatorStack($t7)
					sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
					
					##### b InPostConversion	# move to the next element of the array
			
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
					
					# check if $s7 is (
					# if $s7 == ( 
					beq $s0, $s7, pushPoppedElementBackToOperatorStack_duplicate # then pushInputToOperatorStack_duplicate
					
					##### PUSH $S7 TO OutputQueue; ADD CODE HERE
					
					b isMulOrDiv
					
				pushPoppedElementBackToOperatorStack_duplicate:
					lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
					addi $t7, $t7, 4
					sw $s7, OperatorStack($t7)
					sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
						
				pushInputToOperatorStack_duplicate:
					# push $t1 to OperatorStack
					lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
					addi $t7, $t7, 4
					sw $t1, OperatorStack($t7)
					sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
					
					##### b InPostConversion	# move to the next element of the array

			isOpenParen: 
				# push $t1 to OperatorStack
				lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
				addi $t7, $t7, 4
				sw $t1, OperatorStack($t7)
				sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
				
				##### b InPostConversion	# move to the next element of the array
			
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
					
					# check if $s7 is ( 
					# if $s7 == (
					beq $s0, $s7, popOperatorStack
					
					##### PUSH $S7 TO OutputQueue; ADD CODE HERE
					
					b isCloseParen
			
				popOperatorStack:
					# pop off the top element $s7 of the OperatorStack
					lw $t7, OperatorStack_TopIndex	# load current OperatorStack_TopIndex
					lw $s7, OperatorStack($t7)
					addi $t7, $t7, -4
					sw $t7, OperatorStack_TopIndex	# update OperatorStack_TopIndex
					
					##### b InPostConversion	# move to the next element of the array

		end:
			#### To debug, copy the popOperatorStack code here
			jal Exit
    

.data
OperatorStack: .space 200	# Array to store the OperatorStack elements
OperatorStack_TopIndex: .word 0	# Initialize TopIndex to 0

.include "utils.asm"
	
