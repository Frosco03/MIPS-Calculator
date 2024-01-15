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
	# tokenized array at $a0
	
	jal InPostConversion
	
	jal PostEvaluation
	
	jal Exit


.data
	prompt: .asciiz "Input your equation here: "
	buffer: .space 100

.include "tokenize.asm"
.include "conversion-revised.asm"
.include "evaluate.asm"
.include "utils.asm"