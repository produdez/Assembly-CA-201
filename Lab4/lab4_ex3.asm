.data
	equation: .asciiz "f = a*x^3 + b*x^2 + c*x + d"
	inputRequest: .asciiz "Input number "
.text


main:
	#input a
	li $v0,4
	la $a0, inputRequest
	syscall
	li $v0,11
	li $a0, 97
	syscall
	li $a0, 32
	syscall
	li $v0,5
	syscall
	la $s1,($v0)
	#input b
	li $v0,4
	la $a0, inputRequest
	syscall
	li $v0,11
	li $a0, 98
	syscall
	li $a0, 32
	syscall
	li $v0,5
	syscall
	la $s2,($v0)
	#input c
	li $v0,4
	la $a0, inputRequest
	syscall
	li $v0,11
	li $a0, 99
	syscall
	li $a0, 32
	syscall
	li $v0,5
	syscall
	la $s3,($v0)
	#input d
	li $v0,4
	la $a0, inputRequest
	syscall
	li $v0,11
	li $a0, 100
	syscall
	li $a0, 32
	syscall
	li $v0,5
	syscall
	la $s4,($v0)
	#input x
	li $v0,4
	la $a0, inputRequest
	syscall
	li $v0,11
	li $a0, 120
	syscall
	li $a0, 32
	syscall
	li $v0,5
	syscall
	la $s0,($v0)
	#print equation
	li $v0,4
	la $a0,equation
	syscall
	li $v0,11
	li $a0,32
	syscall
	li $a0,61
	syscall
	li $a0,32
	syscall
	#calculate f
	la $t0,($s0)
	mul $s3,$s3,$s0
	mul $t0,$t0,$s0
	mul $s2,$s2,$t0
	mul $t0,$t0,$s0
	mul $s1,$s1,$t0
	#
	add $t1,$s4,$s3
	add $t2,$s2,$s1
	add $a0,$t1,$t2
	li $v0,1
	syscall
	
	li $v0,10
	syscall