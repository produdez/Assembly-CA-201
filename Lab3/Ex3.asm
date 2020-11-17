.data
	emptyArray: .space 40
	Sum: .asciiz "Sum: "
	inputRequest: .asciiz "Next integer: "
.text
	la $s1,emptyArray #$s1 holds adress of array
	li $t1 0 # our sum
	
	li $v0 5 # integer input mode
	li $t0 10 #loop counter
	topLoop:
	beqz $t0 endLoop
		li $v0 4
		la $a0, inputRequest
		syscall
		li $v0 5 # integer input mode
		syscall #get integer
		sw $v0, 0($s1) #store into array
		lw $s2,0($s1) #load value to $s2
		add $t1,$t1,$s2 #sum in
		  
		addi $s1,$s1,4
		subi $t0,$t0,1	
	j topLoop
	endLoop:
	
	#print sum
	li $v0 4
	la $a0, Sum
	syscall
	li $v0 1
	la $a0,0($t1)
	syscall
