.data
	InputRequest: .asciiz "Input an integer: "
.text
	#print request
	li $v0, 4
	la $a0, InputRequest
	syscall
	#take first number and store it
	li $v0,5
	syscall
	add  $t0,$v0,$0
	#print request
	li $v0, 4
	la $a0, InputRequest
	syscall
	#take second number and sum it with the first
	li $v0,5
	syscall
	add $t0, $t0, $v0
	#print sum
	li $v0,1
	add $a0,$t0,$0
	syscall 
	#end program
	li $v0, 10
	syscall
	
	