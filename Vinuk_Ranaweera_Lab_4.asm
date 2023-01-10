	.data
intro: 	.asciiz "\nCSC 34300: Vinuk Ranaweera 56"	# name and id number
msg: 	.asciiz "Please enter a Fibonacci index number (0 will stop the program): "
msg1: 	.asciiz "F("
msg2: 	.asciiz ") = "
msg3: 	.asciiz "Bye!"
msg4: 	.asciiz "The number is too large"
endl: 	.asciiz "\n"

	.text
main: # registers: a0 = intro, newline
	# ------------------
	la 	$a0, intro 	# print intro
	li 	$v0, 4 		# print string at ($a0)
	syscall			# make system call to print string
	# ------------------
	la	$a0,endl	# $a0 = address of "nl"
	li	$v0,4		# sytem call, type 4, print a string
	syscall			# print a newline
	# ------------------

	jal loop		# call loop function		
	# End program
	#li $v0,10
	#syscall

loop:	# registers: $a0 = n, $a0 --> $t2, $v0 = Fibonnaci2(n), $v0 --> $t3
	la $a0,msg 	# print msg; to input number
	li $v0,4	# sytem call, type 4, print a string
	syscall		# make system call to print string

	li $v0,5    	# Read the number(n)
	syscall		# make system call to read input

	move $t2,$v0    # n to $t2
	beqz $t2,zero   # if n=0 return 0
	beq $t2,1,one   # if n=1 return 1
	bgtu $t2,46,overflow # if n>46, goto overflow function

	# Call function to get fibonnacci(n)
	move $a0,$t2	# move n to $a0
	move $v0,$t2	# move fib(n) to $v0
	jal Fibonacci2    # call fib2(n)
	move $t3,$v0    # result is in $t3

	# Output message and n
	la $a0,msg1   	# Print msg1
	li $v0,4	# sytem call, type 4, print a string	
	syscall		# make system call to print string

	li $v0,1	# sytem call, type 1, print an integer
	move $a0,$t2    # Print n
	syscall		# make system call to print integer

	#beq $a0,$zero,zero
	#beq $a0,$t1,one

	la $a0,msg2  	# Print msg2
	li $v0,4	# sytem call, type 4, print a string
	syscall		# make system call to print string

	move $a0,$t3    # Print the answer
	li $v0,1	# sytem call, type 1, print an integer
	syscall		# make system call to print integer

	la $a0,endl 	# Print endl
	li $v0,4	# sytem call, type 4, print a string
	syscall		# make system call to print string

	j loop		# jump to loop function

# Fibonacci2 -- recursive fibonacci function
#
# RETURNS:
#   v0 -- fibonacci(n)
#
# arguments:
#   a0 -- the "n" for the Nth fibonacci number

# we need an extra cell (to preserve the result of fibo(n-1))
Fibonacci2: # registers: $v1 = fib(n-1)
	bgtu 	$a0, 1, recursion	# if n>1, goto recursion function	 
	move 	$v0, $a0	# set return value to $v0
	jr 	$ra 		# jump to return address
recursion: 	# registers: $a0 = n, $v0 = fib(n), $v1 = fib(n-1)
	subu 	$sp, $sp, 12 	# allocate to stack
	sw 	$ra, 0($sp) 	# save $ra
	sw 	$a0, 4($sp)	# save a copy of n 
	addiu 	$a0, $a0, -1	# n - 1 
	jal 	Fibonacci2	# call Fibonacci2 function 
	sw 	$v0, 8($sp)	# save a copy of Fibonacci2(n) 
	lw 	$a0, 4($sp) 	# retrieve n
	addiu 	$a0, $a0, -2 	# n - 2
	jal 	Fibonacci2	# call Fibonacci2 function 
	lw 	$v1, 8($sp) 	# retrieve fib(n - 1)
	addu 	$v0, $v0, $v1	# fib(n - 1) + fib(n - 2) 
	lw 	$ra, 0($sp) 	# restore $ra
	addiu 	$sp, $sp, 12	# restore $sp 
	jr 	$ra		# jump to return address

zero:	# registers: $a0 = n
	#li $v0,0
	#jr $ra
	# ------------------
	la 	$a0, msg3 	# print msg3
	li 	$v0, 4 		# print string at ($a0)
	syscall			# make system call to print string
	# ------------------
	la	$a0,endl	# $a0 = address of "nl"
	li	$v0,4		# sytem call, type 4, print a string
	syscall			# print a newline
	# -----------------
	li 	$v0,10		# End program
	syscall			# make system call to end program

one:	# registers: $a0 = n
	#la $v0,1
	# Output message and n
	la $a0,msg1   	# Print msg1
	li $v0,4	# sytem call, type 4, print a string
	syscall		# make system call to print string

	move $a0,$t2    # Print n
	li $v0,1	# sytem call, type 1, print an integer
	syscall		# make system call to print integer

	la $a0,msg2  	# Print msg2
	li $v0,4	# sytem call, type 4, print a string
	syscall		# make system call to print string

	move $a0,$t2    # Print the answer
	li $v0,1	# sytem call, type 1, print an integer
	syscall		# make system call to print integer

	la $a0,endl 	# Print endl
	li $v0,4	# sytem call, type 4, print a string
	syscall		# make system call to print string

	j loop		# jump to loop function

overflow:	# registers: $a0 = n
	#la $v0,1
	# Output message and n
	la $a0,msg1   	# Print msg1
	li $v0,4	# sytem call, type 4, print a string	
	syscall		# make system call to print string

	move $a0,$t2    # Print n
	li $v0,1	# sytem call, type 1, print an integer
	syscall		# make system call to print integer

	la $a0,msg2  	# Print msg2
	li $v0,4	# sytem call, type 4, print a string
	syscall		# make system call to print string

	la $a0,msg4  	# Print msg4
	li $v0,4	# sytem call, type 4, print a string
	syscall		# make system call to print string

	la $a0,endl 	# Print endl
	li $v0,4	# sytem call, type 4, print a string
	syscall		# make system call to print string

	j loop		# jump to loop function

	#jr $ra

