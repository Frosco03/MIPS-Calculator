.text
	la $a0, prompt
	la $a1, buffer
	jal PromptString
	
	jal Exit

.data
	prompt: .asciiz "Input your equation here: "
	buffer: .space 100

.include "utils.asm"
