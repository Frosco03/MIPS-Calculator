.text
	queue_contstruct:
		li $t0, 100	#counter = number of members of the array
		la $t1, array
	
	enqueue:
		#store the return address 
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		beqz $t0, end_input #skip the queue if array is full
	
		#Value that will be stored in the array is at $a0
		sw $a0, 0($t1)
		addi $t1, $t1, 4
		
		addi $t0, $t0, -1 #decrement counter
		
		#Get the return address and return the memory
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		jr $ra
	
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
