.data
	nums: .word 100 #size of array
	elems: .word 5, 20, 23, 42, 61, 67, 68, 72, 80, 88, 146, 149, 154, 157, 181, 200, 208, 216, 239, 245, 258, 264, 265, 272, 285, 302, 331, 333, 337, 340, 346, 347, 355, 377, 396, 411, 421, 430, 436, 438, 440, 442, 446, 448, 474, 487, 489, 494, 516, 528, 532, 546, 547, 559, 572, 573, 581, 596, 606, 624, 626, 629, 645, 652, 653, 661, 669, 670, 685, 695, 712, 713, 715, 722, 740, 748, 759, 777, 784, 791, 794, 810, 812, 816, 821, 825, 828, 833, 854, 884, 885, 905, 907, 912, 925, 930, 946, 948, 954, 982 #elements in array
	inputRequest: .asciiz "Input integer to search for: "
.text

main:
	la $s1,elems #the head address of array
	la $t2,nums
	lw $s2,0($t2) # size of array
	
	#load argument
	la $a1,($s1) #head of array
	mul $a2,$s2,4
	add $a2,$a2,$s1
	addi $a2,$a2,-4 # tail of array	
	#take value to search
	li $v0,4
	la $a0,inputRequest
	syscall
	li $v0,5
	syscall
	add $a3,$v0,$0
	#binarySearch
	jal binarySearch
	
	#print the position of found value
	li $v0,1
	add $a0,$0,$v1
	syscall
	
	
	
	#terminate
	li $v0,10
	syscall
binarySearch:
#takes in 3 values, $a1,$a2 (head,tail) and $a3(value) and serch
# return location in the array, -1 if not found
#basically it calls the search Address and then translate it into position.
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal binarySearchAdd
	beq $v1,-1, end
	sub $v1,$v1,$a1
	div $v1,$v1,4
	end:
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
binarySearchAdd: #takes in 3 values, $a1,$a2 (head,tail) and $a3(value) and serch
# return value address in the array, -1 if not found
	#save on stack
	addi $sp,$sp,-12
	sw $a1,0($sp)
	sw $a2,4($sp)
	sw $ra,8($sp)
	
	#algorithm
	add $t1,$0,$a1
	add $t2,$0,$a2
	sub $t0,$t2,$t1
	div $t0,$t0,8
	mul $t0,$t0,4
	add $t0,$t0,$t1 #middle point
	
	blt $t2,$t1,Notfound # if head tail collide, not found
		lw $t3,0($t0) #mid value
		beq $t3,$a3 found # equal means found
		bge $t3,$a3, searchLeft # if mid>val, search Left
		searchRight:
			addi $t0,$t0,4 #else search right
			add $a1,$t0,$0
			jal binarySearchAdd
			j ExitSearch
		searchLeft:
			addi $t0,$t0,-4
			add $a2,$t0,$0
			jal binarySearchAdd
			j ExitSearch
	found:
	add $v1,$t0,$0
	j ExitSearch
	Notfound:
	li $v1,-1
	j ExitSearch
	#restore stack and exit
	ExitSearch:
	lw $a1,0($sp)
	lw $a2,4($sp)
	lw $ra,8($sp)
	addi $sp,$sp,12
	jr $ra
