.data
	myArray: .word 2,4,6,8,10,12,14,16,18,20
	sum: .asciiz "Sum: "
.text
	la $s1,myArray # $s1 store address of array 
	li $t0,0 #$t0 is our sum
	#loop take value and increase sum, then move to next address 10 times
	li $t1 10
	topLoop:
	beqz $t1 endLoop
		lw $s2, 0($s1)
		add $t0,$t0,$s2
		addi $s1,$s1,4
		subi $t1,$t1,1
	j topLoop
	endLoop:
	#print the sum
	li $v0 4
	la $a0,sum
	syscall
	li $v0 1
	la $a0,0($t0)
	syscall
	
