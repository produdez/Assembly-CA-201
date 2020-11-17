.data 
	charArray: .space 10
	mess1: .asciiz "received char array: "
	mess2: .asciiz "ascii code: "
.text

main:
	#input string one by one
	la $s1,charArray
	li $t0 10
	topInput:
	beqz $t0, endInput
		li $v0,12
		syscall
		sb $v0,0($s1)
		addi $t0,$t0,-1
		addi $s1,$s1,1 
	j topInput
	endInput:
	li $v0,11
	li $a0,10
	syscall
	#array message
	li $v0 4
	la $a0, mess1
	syscall
	#print all chars
	li $t0 10
	la $s1,charArray
	topPrint:
	beqz $t0, endPrint
		lb $t1,0($s1)
		add $a0,$0,$t1
		li $v0,11
		syscall
		addi $s1,$s1,1
		addi $t0,$t0,-1
	j topPrint
	endPrint:
	li $v0,11
	li $a0,10
	syscall
	#array message
	li $v0 4
	la $a0, mess2
	syscall
	#print ascii code of array
	li $t0 10
	la $s1,charArray
	topCode:
	beqz $t0, endCode
		li $v0 1
		lb $a0,0($s1)
		syscall
		addi $t0,$t0,-1
		addi $s1,$s1,1
	j topCode
	endCode:
	
	
	#stop program
	li $v0 10
	syscall
