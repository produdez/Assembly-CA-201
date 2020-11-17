.data
	aString: .asciiz "Ho Chi Minh City - University of Technology"	
.text
main:
	la $s1, aString
	#print ascii
	topLoop:
	lb $a0,0($s1)
	beq $a0,0,endLoop
	li $v0,1
	syscall
	addi $s1,$s1,1
	j topLoop
	endLoop:
	#print endline
	li $v0 11
	li $a0 10
	syscall
	#print reverse
	# we have currently, $s1 at end of string
	#create $s2 to hold the beginning of string and print backward.
	la $s2, aString
	addi $s2,$s2,-1
	topLoop2:
	beq $s1,$s2,endLoop2
	lb $a0,0($s1)
	li $v0,11
	syscall
	addi $s1,$s1,-1
	j topLoop2
	endLoop2:
	#end program
	li $v0 10
	syscall