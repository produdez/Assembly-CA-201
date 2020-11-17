.data
	nums: .word 100 #size of array
	elems: .word 91, 95, 18, 91, 50, 7, 84, 33, 32, 32, 97, 20, 29, 92, 36, 39, 4, 77, 52, 8, 64, 18, 61, 82, 74, 55, 59, 64, 91, 69, 24, 33, 74, 17, 75, 63, 99, 32, 27, 67, 21, 15, 100, 83, 82, 18, 77, 48, 57, 70, 73, 59, 100, 8, 81, 58, 1, 50, 18, 8, 5, 32, 91, 25, 4, 1, 87, 50, 32, 68, 73, 1, 46, 65, 86, 40, 48, 89, 98, 33, 84, 85, 74, 19, 57, 19, 47, 21, 62, 70, 26, 23, 35, 7, 15, 36, 73, 34, 36, 69
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
	#print array
	jal printArray
	#sort
	jal quickSort
	#print array sorted
	jal printArray
	#take value to search
	li $v0,4
	la $a0,inputRequest
	syscall
	li $v0,5
	syscall
	add $a3,$v0,$0
	#binarySearch
	jal binSearchPrint
	li $v0,10
	syscall
	#terminate

binSearchPrint:
# print all the indexes that has the value searching for
# Input: $a1,$a2 as head and tail of array, $a3 as value to search for
# Output: print -1 if not found, else all found indexes, raging from the first found to the last found address
	#stack
	addi $sp,$sp,-12
	sw $ra,0($sp)
	sw $s1,4($sp)
	sw $s2,8($sp)
	#algo
	jal binSearchFirst
	add $s1,$0,$v1 #first found address
	beq $s1,0x00000000,notFound #if not found, exit
	
	jal binSearchLast #else get the last address 
	add $s2,$0,$v1 
	#And print all of indexes
	topPr:
	bgt $s1,$s2,exit
		li $v0,1
		sub $a0,$s1,$a1
		div $a0,$a0,4 #get index 
		syscall
		li $v0,11
		addi $a0,$0,32
		syscall
		addi $s1,$s1,4
	j topPr
	
	notFound:
	li $v0,1
	li $a0,-1 
	syscall
	exit:
	#stack
	lw $ra,0($sp)
	lw $s1,4($sp)
	lw $s2,8($sp)
	addi $sp,$sp,12
	jr $ra		
binSearchFirst:
# return the first address of search value
# input: head tail, value as $a1,$a2,$a3
# output: first found address at $a1, NULL(0x0) if not found
	#stack

	#algo
	add $v1,$0,$0 #found address initialy NULL
	add $t1,$0,$a1 #head
	add $t2,$0,$a2 #tail
	top1:
	bgt $t1,$t2, end1
		sub $t0,$t2,$t1
		div $t0,$t0,8
		mul $t0,$t0,4
		add $t0,$t0,$t1 #middle address
		lw $t3,0($t0) # middle value
		
		bne $t3,$a3, notEq1
			#if value found
			add $v1,$0,$t0 # set the found address for return
			addi $t2,$t0,-4 # and search left for the first one
			j top1
		notEq1:
		bge $a3,$t3, right1
			#if smaller, search left
			addi $t2,$t0,-4
			j top1
		right1:
			#else search right
			addi $t1,$t0,4
			j top1
	end1:
	#stack

	jr $ra
binSearchLast:
	#stack

	#algo
	add $v1,$0,$0 #found address initialy NULL
	add $t1,$0,$a1 #head
	add $t2,$0,$a2 #tail
	top2:
	bgt $t1,$t2, end2
		sub $t0,$t2,$t1
		div $t0,$t0,8
		mul $t0,$t0,4
		add $t0,$t0,$t1 #middle address
		lw $t3,0($t0) # middle value
		
		bne $t3,$a3, notEq2
			#if value found
			add $v1,$0,$t0 # set the found address for return
			addi $t1,$t0,4 # and search right for the last one
			j top2
		notEq2:
		bge $a3,$t3, right2
			#if smaller, search left
			addi $t2,$t0,-4
			j top2
		right2:
			#else search right
			addi $t1,$t0,4
			j top2
	end2:
	#stack

	jr $ra
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
