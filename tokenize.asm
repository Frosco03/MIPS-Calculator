.text
	# register conventions
	# $s0 -> open_paren
	# $s1 -> close_paren
	# $s2 -> add
	# $s3 -> sub
	# $s4 -> mul
	# $s5 -> div
  Tokenize:
  	# load tokens
  	lb $s0, open_paren
  	lb $s1, close_paren
  	lb $s2, add_op
  	lb $s3, sub_op
  	lb $s4, mul_op
  	lb $s5, div_op
  	# token_array
    	#$a0 -> expression

  	move $a1, $a0 # from $a0 (string input to $a1)
  	move $a0, $zero

  	la $a2, array
  	
  	# numeric data
  	li $t1, 48
  	li $t2, 9
  	

  	# each character is in $t3
  	
  	loop: 
  		lb $t3, ($a1) # comparing the current character
  		beq $t3, $zero, end_loop
  		beq $t3, $s0, parenOp_found
   		beq $t3, $s1, parenOp_found
  		beq $t3, $s2, parenOp_found
  		beq $t3, $s3, parenOp_found
  		beq $t3, $s4, parenOp_found
  		beq $t3, $s5, parenOp_found
  		# if it's not  paren or Op, then I need to check if it's a number
  		 
  		sub $t4, $t3, $t1
  		bltz $t4, not_valid
		bgt $t4, $t2, not_valid
  		# it's a number
  		# make BUFFER
  		move $t5, $zero
  		number_loop:
  			lb $t3, ($a1)
  		  	sub $t4, $t3, $t1

  			bltz $t4, not_numeric
  			bgt $t4, $t2, not_numeric

  			mul $t5, $t5, 10
  			add $t5, $t5, $t4

  			addi $a1, $a1, 1
  			
  			j number_loop
  			
  		not_numeric:
  			sw $t5, ($a2)
  			addi $a2, $a2, 4
  			j loop
  		not_valid:
  			la $a0, notvalid
  			jal PrintString
  			jal Exit

  	
  	parenOp_found:
		# push to stack
		sb $t3, ($a2)
  		addi $a2, $a2, 4
  		addi $a1, $a1, 1

		j loop

  	end_loop:
  		la $a2, array # tokenized array
  		jr $ra

  		
.data 
	open_paren: .ascii "("
	close_paren: .ascii ")"
	add_op: .ascii "+"
	sub_op: .ascii "-"
	mul_op: .ascii "*"
	div_op: .ascii "/"
	parenOp: .asciiz "ParenOp, "
	numeric: .asciiz "a number, "
	debugger: .asciiz "hakhak"
	notvalid: .asciiz "syntax error"

	yay: .asciiz "yay!"
	.align 4
	array: .space 20
	.include "utils.asm"
