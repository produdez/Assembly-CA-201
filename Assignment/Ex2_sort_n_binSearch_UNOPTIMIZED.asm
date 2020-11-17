.data
	nums: .word 20 #size of array
	elems: .word 10, 5, 1, 3, 10, 7, 1, 3, 1, 2, 3, 7, 7, 1, 8, 10, 3, 2, 1, 10
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
	#print initial array
	jal printArray
	#sortArray
	jal quickSort
	#print array after sort
	jal printArray
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
quickSort: # takes $a1 as array head address,$a2 as array tail index
# sort the array, no return value
	addi $sp,$sp,-24
	sw $a1,0($sp)
	sw $a2,4($sp)
	sw $t1,8($sp)
	sw $t2,12($sp)
	sw $t3,16($sp)
	sw $ra,20($sp)
	sortAlgorithm:
	#$a1 and $s2 are head and tail
	bge $a1,$a2,stopSort # if head touch tail means done
		jal partition #partition using the current head and tail
		add $t1,$0,$v1 #get corrent address of pivot after partition
		sortLeft:
		addi $t2,$t1,-4 # tail of left array
		add $t3,$a2,$0 #save the current tail before changing it
		add $a2,$0,$t2 # new tail use for calling left sort
		jal quickSort
		sortRight:
		add $a2,$0,$t3 # restore tail
		addi $t3,$t1,4 # head of right array
		add $a1,$0,$t3
		jal quickSort
	stopSort:
	lw $a1,0($sp)
	lw $a2,4($sp)
	lw $t1,8($sp)
	lw $t2,12($sp)
	lw $t3,16($sp)
	lw $ra,20($sp)
	addi $sp,$sp,24
	jr $ra

partition: # takes $a1 as array head address,$a2 as array tail index
#put the pivot at the right index and return address of pivot at $v1
#our pivot is last element 
	addi $sp,$sp,-24
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $t4,16($sp)
	sw $ra,20($sp)
	partitionAlgorithm:
	add $t1,$0,$a1 #left most address
	addi $t2,$a2,-4 #right most address that's not pivot
	lw $t0,0($a2) #pivot value
		infLoop:
			L1:
			lw $t3,0($t1) # if left is less than pivot
			bge $t3,$t0, eL1 
				addi $t1,$t1,4 #next left
			j L1
			eL1:
			
			L2:
			lw $t4,0($t2)
			sgt $t5,$t4,$t0 # if right is larger than pivot
			sgt $t6,$t2,$a1 # and right is not moved to head
			and $t5,$t6,$t5
			beqz $t5,eL2 
				addi $t2,$t2,-4 #then next right
			j L2
			eL2:
			
			bge $t1,$t2,noSwap #if collided, end inf loop
				#if left and right not collided, swap them
				sw $t3,0($t2)
				sw $t4,0($t1)
		j infLoop
			noSwap: 			
		#after arranging the left and right, put the pivot in middle and return it's address
		sw $t3,0($a2) #swap pivot(at end) with first value greater than pivot
		sw $t0,0($t1)
		add $v1,$0,$t1 #return corrected address of pivot
	exitPartition:
	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $t4,16($sp)
	lw $ra,20($sp)
	addi $sp,$sp,24
	jr $ra
	
printArray: #takes $a1 as array head and $a2 as array size to print
	addi $sp,$sp,-8
	lw $a0,0($sp)
	lw $t0,4($sp)
	add $t0,$a1,$0 # head address
	topPrint:
	bgt $t0,$a2, endPrint
		li $v0,1
		lw $a0,0($t0)
		syscall
		li $v0,11
		addi $a0,$0,32
		syscall
		addi $t0,$t0,4
	j topPrint
	endPrint:
	li $v0,11
	addi $a0,$0,10
	syscall
	#end
	sw $a0,0($sp)
	sw $t0,4($sp)
	addi $sp,$sp,8
	jr $ra
