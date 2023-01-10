.data
FBN: .space 400   		# An array with 400 bytes, which can store 100 32-bit integers
.align 2
NUM_FBN: .space 4   		# This allocates space to store the index of the largest fibonacci value we can compute without overflow 
number:		.asciiz ". " 	# label numbers in sequence
nl:	.asciiz "\n"		# ASCII for a new line
	.align 2		# aligned at word boundary
.text
main: # $s0 = FBN, $s1 = NUM_FBN, $s2 = counter, $s3 = first series number, $s4 = second series number, $t1 = shifted value 
  
   la 		$s0,FBN 			# contains the memory address of FBN
   la 		$s1,NUM_FBN 		# contains the memory address of NUM_FBN
   # ------------------
   li 		$s2, 0			# keeps track of numbers
   # ------------------
   li 		$s3, 1			# first number is 0
   sll 		$t1, $s2, 2		# 0*4
   addu 	$t1, $s0, $t1		# FBN[0]
   sw 		$s3, 0($t1)		# FBN[0] = 0
   addiu 	$s2, $s2, 1
   # ------------------
   li 		$s4, 1			# second number in series is 1
   sll 		$t1, $s2, 2		# (1)*4
   addu 	$t1, $s0, $t1		# FBN[1]
   sw 		$s4, 0($t1)		# FBN[1] = 1
  
Do: # $t1 = N-1, $s2 = N, $s0 = FBN, $s2 = N+1, $s3 = F[n], $s4 = FBN[N], $s5 =	F[n] + F[n-1], $t2 = $s3 XOR $s5, $t3 = $s4 XOR $s5
   addiu 	$t1, $s2, -1		# N-1
   sll 		$t1, $t1, 2		# (N-1)*4
   addu 	$t1, $t1, $s0		# FBN + (N-1)*4
   lw 		$s3, 0($t1)		# load FBN[N-1]
   # ------------------
   addiu 	$t1, $t1, 4		# FBN + (N*4)
   lw 		$s4, 0($t1)		# load FBN[N]
   # ------------------
   addu 	$s5,$s3,$s4   		# F[n] = F[n] + F[n-1]
   # check for overflow
   xor 		$t2, $s3, $s5		# $t2 = $s3 XOR $s5
   xor 		$t3, $s4, $s5		# $t3 = $s4 XOR $s5
   and 		$t3, $t2, $t3		# $t3 = $t2 AND $t3
   addiu 	$s2,$s2,1   		# N = N + 1
   bltz    	$t3, overflow		# if $t3 <= 0, then overflow occurred --> overflow function
   					# If the sign of the result is the same as the sign of the operands then no overflow occurred
   
   no_overflow:		# no overflow
   	addiu 		$t1, $t1, 4	# increment to FBN[N+1]
      	sw 		$s5,0($t1)   	# FBN[N+1] = F[n] + F[n-1]
      
      
   j Do				# loop 
   
overflow:		# overflow
	sw 	$s2, 0($s1)	 	# store count to memory
	li 	$t0, 0			# loop counter initialization to print
print:	# $t4 = index to increment 
	addiu	$t4,$t4,1		# increment index
	move 	$a0,$t4			# $a0 = $t3, which is n
	li	$v0,1			#system call, type 1, i.e. integer
	syscall				# print the value of n
	# ------------------
 	la 	$a0, number 		# print number from .data
	li 	$v0, 4 			# print string at ($a0)
	syscall				# make system call to print string
	# ------------------
	bge 	$t0, $s2, exit		# if i >= NUM_FBN, end loop
	sll 	$t1, $t0, 2		# calculate offset address
	addu 	$t1, $t1, $s0		# calculate base address
	lw 	$a0, 0($t1)		# load value from memory
	li 	$v0, 36			# print value	edit
	syscall
	# ------------------
	la	$a0,nl			# $a0 = address of "nl"
	li	$v0,4			# sytem call, type 4, print a string
	syscall				# print a newline
	addiu 	$t0, $t0, 1		# increment loop counter
	
	j print		# loop again
exit:
# exit
	li 	$v0, 10
	syscall
