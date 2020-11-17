.data
.text

main:
	li $a0 30
	mul $a0, $a0, 10
	addi $a0,$a0, 66000
	addi $a0,$a0,-6000
	addi $a0,$a0, 25
	li $v0 1
	syscall