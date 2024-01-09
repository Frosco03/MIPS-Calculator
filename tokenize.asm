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
  	la $s0, open_paren
  	la $s1, close_paren
  	la $s2, add_op
  	la $s3, sub_op
  	la $s4, mul_op
  	la $s5, div_op
  	
  	# numeric data
  	li $t4, 48
  	li $t5, 57
  	
  	#$a0 -> expression
  	la $a0, ex_expression
  	# load the adress of the string (at $a0) into a register
  	la $t0, ($a0)
  	
  	#iterate through the string
  	loop:
  		lb $t1, ($t0)
	  	beq $t1, $zero, end_loop
	  	
	  	#processing the character
	  	# check if the character is open_paren
	  	lb $t2, ($s0)
	  	beq $t1, $t2, found_ParenOp
	  	# check if the character is close_paren
	  	lb $t2, ($s1)
	  	beq $t1, $t2, found_ParenOp
	  	# check if equal to each operator
	  	lb $t2, ($s2)
	  	beq $t1, $t2, found_ParenOp
	  	lb $t2, ($s3)
	  	beq $t1, $t2, found_ParenOp
	  	lb $t2, ($s4)
	  	beq $t1, $t2, found_ParenOp
	  	lb $t2, ($s5)
	  	beq $t1, $t2, found_ParenOp
	  	# check if the current character is numeric
		sub $t3, $t1, $t4
		blt $t3, $t4, end_loop #if character is less than zero, it's non numeric
		bgt $t1, $t5, end_loop # if character is more than 9, it's non numeric
		# the character here is numeric
		move $a1, $a0
		addi $t7, $a1, 1
		extract_number:
			lb $t2, ($t7)
			blt $t2, $t4, end_extraction
			bgt $t2, $t5, end_extraction
			
			addi $a1, $a1, 1
			j extract_number
		end_extration:
			sub $t6, $a0, $a1
			add $t6, $a1, $t6
			sb $zero, ($t6)
			sw $a1, ($t8)
			addi $t8, $t8, 4
			add $a1, $a1, $t6
			j loop
		found_ParenOp:
			sw $t1, ($t8)
			addi $t8, $t8, 4
			
			
		end_loop:
	  		# move to the next character
	  		addi $t0, $t0, 1
	  		j loop
	  	
   
.data 
ex_expression: .asciiz "3+4*(2/3)"
open_paren: .asciiz "("
close_paren: .asciiz ")"
add_op: .asciiz "+"
sub_op: .asciiz "-"
mul_op: .asciiz "*"
div_op: .asciiz "/"

array: .space 51