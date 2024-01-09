.text
	InPostConversion:
		#Joenne: Check if the value of array is an operator and add to stack accordingly 
		#James: Check if the value of array is a number and add to queue accordingly
		
		#Check if the current array value is a number
		#Assume that $t1 = member of the array
		li  $t0, '0'
		bltu   $t1,$t0, notdig        # Jump if char < '0'

		li $t0,'9'
		bltu   $t0,$t1, notdig       # Jump if '9' < char
		
		#Value is a digit
		dig:
			
			b end
			
		#Value is not a digit
		notdig:
		
		end:

.data