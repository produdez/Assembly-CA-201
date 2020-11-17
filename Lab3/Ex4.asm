.data
	myArray: .word 1,2,3,4,5,6,7,8,9,10
	ReqIndex: .asciiz "Choose an index from 0 to 9: "
.text
	#ask for input
	li $v0 4
	la $a0, ReqIndex
	syscall
	li $v0 5
	syscall
	add $t0,$0,$v0
	#get array address
	la $s1, myArray
	#loop and find the number
	li $t1 0
	topLoop:
	beq $t1,$t0 endLoop
		addi $s1,$s1,4
		addi $t1,$t1,1
	j topLoop
	endLoop:
	
	lw $s2,0($s1)
	la $a0, 0($s2)
	li $v0 1
	syscall
	