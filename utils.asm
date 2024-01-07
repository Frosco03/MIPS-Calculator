# File:
# utils.asm
# Purpose: To define utilities which will be used in MIPS programs.
# Author:
# Charles Kann
#
# Instructors are granted permission to make copies of this file
# for use by # students in their courses. Title to and ownership
# of all intellectual property rights
# in this file are the exclusive property of
# Charles W. Kann, Gettysburg, Pa.
#
# Subprograms Index:
#
# Exit -
# Call syscall with a server 10 to exit the program
#
# NewLine -
# Print a new line character (\n) to the console
#
# PrintInt - Print a string with an integer to the console
#
# PrintString -
# Print a string to the console
#
# PromptInt - Prompt the user to enter an integer, and return
#
# it to the calling program.
#
# Modification History
#
# 12/27/2014 - Initial release

.text
	PrintNewLine:
		li $v0, 4
		la $a0, __PNL_newline
		syscall
		jr $ra
.data
	__PNL_newline:
	 .asciiz "\n"
 
 .text
	PrintInt:
		# Print string. The string address is already in $a0
		li $v0, 4
		syscall
		# Print integer.
		#The integer value is in $a1, and must
		# be first moved to $a0.
		move $a0, $a1
		li $v0, 1
		syscall
		#return
		jr $ra

.text
	PromptInt:
		# Print the prompt, which is already in $a0
		li $v0, 4
		syscall
		# Read the integer value. Note that at the end of the
		# syscall the value is already in $v0, so there is no
		# need to move it anywhere.
		move $a0, $a1
		li $v0, 5
		syscall
		#return
		jr $ra
		
.text
	PrintString:
		addi $v0, $zero, 4
		syscall
		jr $ra

.text
	PromptString:
		# Print the prompt, which is already in $a0
		li $v0, 4
		syscall
		# Read the String value. Note that at the end of the
		# syscall the value is already in $v0, so there is no
		# need to move it anywhere.
		move $a0, $a1
		li $a1, 100
		li $v0, 8
		syscall
		#return
		jr $ra

.text
	Exit:
		li $v0, 10
		syscall
