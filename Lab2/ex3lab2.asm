.data
	exp1: .asciiz "f = (a + b) - (c - d - 2)\n"
	exp2: .asciiz "g = (a + b) * 3 - (c + d) * 2\n"
	a: .asciiz "a: "
	b: .asciiz "b: "
	c: .asciiz "c: "
	d: .asciiz "d: "
	f: .asciiz "f = "
	g: .asciiz "g = "
	endline: .byte '\n'
.text
	#print expresion 1 and 2 
	li $v0, 4
	la $a0, exp1
	syscall
	la $a0, exp2
	syscall
	#get input for a,b,c,d
	li $v0,4
	la $a0,a
	syscall
	li $v0,5
	syscall
	add $t1,$v0,$0
	
	li $v0,4
	la $a0,b
	syscall
	li $v0,5
	syscall
	add $t2,$v0,$0
	
	li $v0,4
	la $a0,c
	syscall
	li $v0,5
	syscall
	add $t3,$v0,$0
	
	li $v0,4
	la $a0,d
	syscall
	li $v0,5
	syscall
	add $t4,$v0,$0
	
	#calculate and print f
	li $v0, 4
	la $a0,f
	syscall
	add $a0,$t1,$t2
	add $a0,$a0,$t3
	add $a0,$a0,$t4
	addi $a0,$a0,2
	li $v0, 1
	syscall
	#endline
	li $v0,12
	la $a0, endline
	#calculate and print g
	li $v0, 4
	la $a0,g
	syscall
	add $t5,$t1,$t2
	add $t5,$t5,$t5
	add $t5,$t5,$t5
	add $t6,$t3,$t4
	add $t6,$t6,$t6
	sub $a0,$t5,$t6
	li $v0, 1
	syscall
#end program
li $v0,10
syscall