.data

	deck: .asciiz         "AAAA222233334444555566667777888899991111JJJJQQQQKKKK"
	shuffledDeck: .asciiz "----------------------------------------------------"
	discardPile:  .asciiz "----------------------------------------------------"
	cardsLeft: .word 52
	cardLine1: .asciiz "===== "
	cardLine2: .asciiz"|   | "
	cardLine3: .asciiz "|"
	cardLine4: .asciiz "|   | "
	cardLine5: .asciiz "===== "
	newLine: .asciiz "\n"
	tenText: .asciiz "10 | "
	

.text

.globl shuffle	
shuffle:
	li $a1,52
	li $t3,0
	addi $sp,$sp,-4
	sw $ra,($sp)
	for1:
		li $a0,0
		li $v0,42
		syscall
		la $a0,deck($a0)
		lb $t2,($a0)
		sb $t2,shuffledDeck($t3)
		addi $a1,$a1,-1
		addi $t3,$t3,1
		jal shiftAllLeft
		bnez $a1,for1
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra
		
shiftAllLeft: #$a0 is position to start at
	while1:
		lb $t1,1($a0)
		sb $t1,($a0)
		addi $a0,$a0,1
		bnez $t1,while1
	jr $ra
	
.globl draw
draw: # $a0 contains the address of the hand where cards will be placed, $a1 contains the # of cards to draw
	addi $sp,$sp,-4
	sw $ra,($sp)
	la $t0,shuffledDeck
	lw $t2,cardsLeft
	#blt $t2,$a1,error1
	for2:
		beqz $a1,endfor2 #check condition
		lb $t1,($t0)
		sb $t1,($a0)
		addi $t0,$t0,1
		addi $a0,$a0,1
		addi $a1,$a1,-1
		j for2
	endfor2:
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra

shuffleDiscards:
	li $t5,0
	la $t6,discardPile
	counter:
		lb $t7,($t6)
		beq $t7,'-',endcount
	endcount:
	li $a1,52
	li $t3,0
	addi $sp,$sp,-4
	sw $ra,($sp)
	for4:

	for3:
	
		li $a0,0
		li $v0,42
		syscall
		la $a0,deck($a0)
		lb $t2,($a0)
		sb $t2,shuffledDeck($t3)
		addi $a1,$a1,-1
		addi $t3,$t3,1
		jal shiftAllLeft
		bnez $a1,for4
		bnez $a1,for3
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra
	
.globl printCards
printCards: # $a0 contains the address of a string containing chars A 2 3 4 5 6 7 8 9 1 J Q or K
	move $t0,$a0
	move $s3,$a0
	li $t2,0 # t2 contains total cards after count2
	count2:
		lb $t1,($t0)
		beqz $t1,endcount2
		addi $t2,$t2,1
		addi $t0,$t0,1
		b count2
	endcount2:
	move $t3,$t2
	li $v0,4
	la $a0,cardLine1
	la $s0,endLoop5_1
	la $t7,cardLine3
	for5:
		beqz $t3,jumptos0
		syscall
		addi $t3,$t3,-1
		
		beq $a0,$t7,printVal
		b for5
		printVal:
			lb $t6,($s3)
			addi $s3,$s3,1
			bne $t6,'1',endif5
			if5:
				la $a0,tenText
				syscall
				move $a0,$t7
				b for5
			endif5:
			li $v0,11
			li $a0,' '
			syscall
			move $a0,$t6
			syscall
			li $a0,' '
			syscall
			li $v0,4
			la $a0,cardLine3
			syscall
			li $v0,11
			li $a0,' '
			syscall
			li $v0,4
			move $a0,$t7
			b for5
		jumptos0:
			jr $s0
	endLoop5_1:
	move $t3,$t2
	la $a0,newLine
	syscall
	la $a0,cardLine2
	la $s0,endLoop5_2
	b for5
	endLoop5_2:
	move $t3,$t2
	la $a0,newLine
	syscall
	la $a0,cardLine3
	la $s0,endLoop5_3
	b for5
	endLoop5_3:
	move $t3,$t2
	la $a0,newLine
	syscall
	la $a0,cardLine4
	la $s0,endLoop5_4
	b for5
	endLoop5_4:
	move $t3,$t2
	la $a0,newLine
	syscall
	la $a0,cardLine5
	la $s0,endLoop5_5
	b for5
	endLoop5_5:
	la $a0,newLine
	syscall
	jr $ra
.globl remainingCards
remainingCards: # Number of remaining cards in $s0

.globl discard
discard: # $a0 contains address of first index of discards $a1 contains the # of cards to discard
