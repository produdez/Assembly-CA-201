.data
	InputRequest: .asciiz "Please input an integer number! \n"
.text
	#print input request
	li $v0, 4
	la $a0, InputRequest
	syscall
	#take in an integer
	li $v0, 5
	syscall
	#increase it by one, save and print
	addi $a0, $v0, 1
	li $v0, 1
	syscall