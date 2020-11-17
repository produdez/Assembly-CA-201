.data
	nums: .word 20 #size of array
	elems: .word 10, 5, 1, 3, 10, 7, 1, 3, 1, 2, 3, 7, 7, 1, 8, 10, 3, 2, 1, 10
.text

main:
	la $s1,elems #the head address of array
	la $t2,nums
	lw $s2,0($t2) # size of array
	#load arguments and run quick sort
	la $a1,($s1) #head of array
	mul $a2,$s2,4
	add $a2,$a2,$s1
	addi $a2,$a2,-4 # tail of array	
	#print array
	jal printArray
	#quickSort
	jal quickSort
	#print array
	jal printArray
	#terminate
	li $v0,10
	syscall
	##end of main##

quickSort: # takes $a1 as array head address,$a2 as array tail index
# sort the array, no return value
	addi $sp,$sp,-24
	sw $a1,0($sp)
	sw $a2,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $ra,20($sp)
	sortAlgorithm:
	#$a1 and $s2 are head and tail
	bge $a1,$a2,stopSort # if head touch tail means done
		jal partition #partition using the current head and tail
		add $s1,$0,$v1 #get corrent address of pivot after partition
		sortLeft:
		addi $s2,$s1,-4 # tail of left array
		add $s3,$a2,$0 #save the current tail before changing it
		add $a2,$0,$s2 # new tail use for calling left sort
		jal quickSort
		sortRight:
		add $a2,$0,$s3 # restore tail
		addi $s3,$s1,4 # head of right array
		add $a1,$0,$s3
		jal quickSort
	stopSort:
	lw $a1,0($sp)
	lw $a2,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $ra,20($sp)
	addi $sp,$sp,24
	jr $ra


partition: # takes $a1 as array head address,$a2 as array tail index
#put the pivot at the right index and return address of pivot at $v1
#our pivot is last element 
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
			sge $t5,$t4,$t0 # if right is larger than pivot
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
	jr $ra
	
printArray: #takes $a1 as array head and $a2 as array size to print
	addi $sp,$sp,-4
	lw $s1,0($sp)
	add $s1,$a1,$0 # head address
	topPrint:
	bgt $s1,$a2, endPrint
		li $v0,1
		lw $a0,0($s1)
		syscall
		li $v0,11
		addi $a0,$0,32
		syscall
		addi $s1,$s1,4
	j topPrint
	endPrint:
	li $v0,11
	addi $a0,$0,10
	syscall
	#end
	sw $s1,0($sp)
	addi $sp,$sp,4
	jr $ra
