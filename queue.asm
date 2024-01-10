.text
	queue_contstruct:
		###Set the number of members of the queueArray to the number of characters parsed by copying a counter from main to a specific register here
		li $t0, 100	#counter = number of members of the queueArray
		la $t1, queueArray
	
	enqueue:
		#store the return address 
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		beqz $t0, end_input #skip the queue if queueArray is full
	
		#Value that will be stored in the queueArray is at $a0
		sw $a0, 0($t1)
		addi $t1, $t1, 4
		
		addi $t0, $t0, -1 #decrement counter
		
		#Get the return address and return the memory
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		jr $ra
	
	end_input:
		li $t0, 100	#counter
		la $t1, queueArray
		
	output_loop:
		beqz $t0, exit
	
		lw $a1, 0($t1)
		addi $t1, $t1, 4
		la $a0, answer
		jal PrintInt
		
		addi $t0, $t0, -1
		b output_loop
		
	getNext:
		beqz $t0, exit
		
		lw $t9, 0($t1) #Store the next element in $t9
		addi $t1, $t1, 4 #go to the next element
		
		exit:
			#Get the return address and return the memory
			lw $ra, 0($sp)
			addi $sp, $sp, 4
		
			jr $ra
		
	resetIndex:
		#store the return address 
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		li $t0, 100	#counter
		la $t1, queueArray
		
		#Get the return address and return the memory
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		jr $ra

.data
	.align 4
	queuePrompt: .asciiz "Please enter a number: "
	queueArray: .space 20 #no of members in the queueArray * 4 bytes per word
	answer: .asciiz " "
