.text
	li $t0, 5	#counter = number of members of the array
	la $t1, array
	
	input_loop:
		beqz $t0, end_input
	
		la $a0, prompt
		jal PromptInt
		
		sw $v0, 0($t1)
		addi $t1, $t1, 4
		
		addi $t0, $t0, -1
		b input_loop
	
	end_input:
		li $t0, 5	#counter
		la $t1, array
		
	output_loop:
		beqz $t0, exit
	
		lw $a1, 0($t1)
		addi $t1, $t1, 4
		la $a0, answer
		jal PrintInt
		
		addi $t0, $t0, -1
		b output_loop
	
	exit:
		jal Exit

.data
	.align 4
	prompt: .asciiz "Please enter a number: "
	array: .space 20 #no of members in the array * 4 bytes per word
	answer: .asciiz " "

.include "utils.asm"
