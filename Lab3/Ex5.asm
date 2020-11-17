.data
	myArray: .word 1,3,5,7,9,11,13,15,17,19 #surely 10 elements
	out0: .asciiz "My Array: "
	out1: .asciiz "Reversed array: "
.text

main:
	#print initial array
	la $v0 4
	la $a0 out0
	syscall
	la $a0, myArray
	jal printArray
	# reverse part:
	la $s1 myArray #get first address of array
	addi $s2,$s1,36 #get last address of array
	li $t0 5 # swap 5 times
	topLoop:
	beqz $t0,endLoop
		# swap head and tail
		lw $t1,0($s1)
		lw $t2,0($s2)
		sw $t1,0($s2)
		sw $t2,0($s1)
		#done swap, iterate next elements
		addi $s1,$s1,4
		subi $s2,$s2,4
		subi $t0,$t0,1
	j topLoop
	endLoop:
	#print result
	la $v0 4
	la $a0 out1
	syscall
	la $a0, myArray
	jal printArray
	li $v0 10
	syscall
	#end program/main

printArray: #function to print array
	li $t0 0 #counter
	la $t1,($a0) #address of array
	topPrint:
	beq $t0,10,endPrint		
		#load word in to $a0 and print
		li $v0,1
		lw $a0,0($t1)
		syscall
		#print space
		la $a0,32
		li $v0 11
		syscall
		#next element
		addi $t1,$t1,4
		addi $t0,$t0,1	
	j topPrint
	endPrint:
	la $a0,10
	li $v0 11 # print an endline
	syscall
	jr $ra
	
	
	
