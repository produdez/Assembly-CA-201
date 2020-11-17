.data
	nums: .word 13 #size of array
	elems: .word 1,2,3,4,4,4,4,5,6,7,8,9,10
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
	addi $sp,$sp,-16
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
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
	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	addi $sp,$sp,16
	jr $ra
binSearchLast:
	#stack
	addi $sp,$sp,-16
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
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
	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	addi $sp,$sp,16
	jr $ra