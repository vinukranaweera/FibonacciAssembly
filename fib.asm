	.data		# data segment
nl:	.asciiz "\n"	# ASCII for a new line
	.align 2	# aligned at word boundary
intro:		.asciiz "CSC 34300: Vinuk Ranaweera 56"	# name and id number

msg1:		.asciiz "The Fibonacci Number F("	# first part of statement

msg2:		.asciiz ") is "	# second part of statement
	
	.text		# Code segment
	.globl main	# declare main to be global
main:	# $t2: F(n-2), $t1: F(n-1), $t0: F(n), $t3: counter decremented, 
	li	$t2,0		# $t2 = 0; initial value of F(n-2)
				# in this case, F(0)
	li	$t1,1		# $t1=1; initial value of F(n-1)
				# in this case, F(1)
	li	$t4,2		# $t4=2; initial value of F(n)
				# in this case, F(2)
        # ------------------
	la 	$a0, intro 	# print intro
	li 	$v0, 4 		# print string at ($a0)
	syscall			# make system call to print string
	# ------------------
	la	$a0,nl		# $a0 = address of "nl"
	li	$v0,4		# sytem call, type 4, print a string
	syscall			# print a newline
	# ------------------
 	la 	$a0, msg1 	# print msg1
	li 	$v0, 4 		# print string at ($a0)
	syscall			# make system call to print string
	# ------------------
	addiu	$t3,$t3,1	# increment index
	move 	$a0,$t3		# $a0 = $t3, which is n
	li	$v0,1		# system call, type 1, i.e. integer
	syscall			# print the value of n
	# ------------------
 	la 	$a0, msg2 	# print msg2
	li 	$v0, 4 		# print string at ($a0)
	syscall			# make system call to print string
	# ------------------
	move	$a0, $t1	# $a0 = $t1, which is F(1)
	li	$v0,1		# system call, type 1, i.e. integer
	syscall			# make system call to print the value of F(1)
	# ------------------
	la	$a0,nl		# $a0 = address of "nl"
	li	$v0,4		# sytem call, type 4, print a string
	syscall			# print a newline
	# ------------------
	li	$t3,9		# $t3 is the counter to be decremented	
print: # $t1: F(n-1), $t0: F(n), $t2 = F(n-2), $t4 = n 
	addu	$t0,$t1,$t2 	# F(n) = F(n-1) + F(n-2)
	# ------------------
 	la 	$a0, msg1 	# print msg1
	li 	$v0, 4 		# print string at ($a0)
	syscall			# make system call to print string
	# ------------------
	#addi	$t4,$t4,1	# edit
	move 	$a0,$t4		# $a0 = $t4, which is n
	li	$v0,1		# system call, type 1, i.e. integer
	syscall			# print the value of n
	# ------------------
 	la 	$a0, msg2 	# print msg2
	li 	$v0, 4 		# print string at ($a0)
	syscall			# make system call to print string
	# ------------------
	move 	$a0,$t0		# $a0 = $t0, which is F(n)
	li	$v0,1		# system call, type 1, i.e. integer
	syscall			# print the value of F(n)
	# ------------------
	la	$a0,nl		# $a0 = address of "nl"
	li	$v0,4		# sytem call, type 4, print a string
	syscall			# print a newline
	# ------------------
	addiu	$t4,$t4,1	# $t4 = $t4 + 1; increment n
	move	$t2,$t1		# $t2 = $t1; previous F(n-1) becomes F(n-2)
	move	$t1,$t0		# $t1 = $t0; previous F(n) becomes F(n-1)
	addiu	$t3,$t3,-1	# $t3 = $t3 - 1; decrement the counter
	bne	$0,$t3,print	# continue if $t3 is not 0
Exit:	# ------------------ 
	la	$a0,nl		# $a0 = address of "nl"
	li	$v0,4		# sytem call, type 4, print a string
	syscall			# print a newline
	# ------------------
	li	$v0,10		# system call, type 10, standard exit
	syscall			# ... and call the OS			


