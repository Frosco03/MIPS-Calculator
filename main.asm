.text
	# print prompt
	la $a0, prompt
	jal PrintString
	
	# ask for string
	li $v0, 8
	la $a0, buffer
	li $a1, 100
	syscall
	
	la $a0, buffer
	jal Tokenize
	jal Exit
	# tokenized array at $a2
	jal InPostConversion
	
	la $a0, yay
	jal PrintString
	
	jal Exit

.data
	prompt: .asciiz "Input your equation here: "
	buffer: .space 100
	yay: .asciiz "yay!"


.include "tokenize.asm"
.include "conversion.asm"

