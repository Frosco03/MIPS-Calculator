.text
	la $a0, prompt
	jal PrintString
	
	jal Exit

.data
	prompt: .asciiz "Enter a number."

.include "utils.asm"
