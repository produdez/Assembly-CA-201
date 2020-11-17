.data
	myArray: .word 1,2,3,4,5,6,7,8,9,10
	Even: .asciiz "Even sum: "
	Odd: .asciiz "Odd sum: "
	endline: .byte '\n'
.text
	la $s1,myArray # $s1 store address of array 
	li $t0,0 #$t0 is our even sum
	li $t1,0 #$t1 is our odd sum
	#loop through and calculate
	li $t2 5
	topLoop:
	beqz $t2, endLoop
		#even
		lw $s2,0($s1)
		add $t0,$t0,$s2 
		addi $s1,$s1,4
		#odd
		lw $s2,0($s1)
		add $t1,$t1,$s2
		addi $s1,$s1,4
		#change loop count
		subi $t2,$t2,1
	j topLoop
	endLoop:
	
	#print the even index sum
	li $v0 4
	la $a0,Even
	syscall
	li $v0 1
	la $a0,0($t0)
	syscall
	li $v0 4
	la $a0,endline
	syscall
	#odd sum
	li $v0 4
	la $a0,Odd
	syscall
	li $v0 1
	la $a0,0($t1)
	syscall
	li $v0 4
	la $a0,endline
	syscall