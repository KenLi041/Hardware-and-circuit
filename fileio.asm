#CHANGE EVERYTHING!

.data

#Must use accurate file path.
#These file paths are EXAMPLES, 
#should not work for you

#CHANGE TO SAME PATH FOR STR1 STR2!!!
str1:	.asciiz "/Users/yimingli/Desktop/Assignment3/test1.txt"
str2:	.asciiz "/Users/yimingli/Desktop/Assignment3/test2.txt"
str3:	.asciiz "test1.pbm"	#used as output

buffer:  .space 4096		# buffer for upto 4096 bytes (increase size if necessary)

error:	.asciiz "File I/O error\n"
writeword: .asciiz "P1\n50 50\n"

	.text
	.globl main

main:	la $a0,str1 #get input
	jal readfile
	


	la $a0, str3	#writefile get $a0 file location
	la $a1,buffer	#$a1 is location for write
	jal writefile

	li $v0,10		
	syscall


readfile:


	li $v0, 13 #open file
	li $a1, 0		
	syscall
	move $t0, $v0	#file descriptor 

	
	
	bge $t0, $zero, Read1#Error 
	li $v0, 4		
	la $a0, error#print error
	syscall
	li $v0,10		
	syscall



Read1:	li $v0, 14	#read file
	move $a0, $t0# file descriptor 
	
	
	la $a1, buffer#read to buffer
	li $a2, 4096#buffer size
	syscall
	bge $v0, $zero, Close1	#error
	li $v0, 4# print error
	
	la $a0, error
	syscall
	li $v0,10#exit
	syscall



Close1:	move $t1, $v0	#copy char
	li $v0, 16# close file
	
	move $a0, $t0	# file descriptor
	syscall
	
	bge $t0, $zero, End1	#error
	li $v0, 4# print error
	la $a0, error
	
	syscall
	li $v0,10		
	syscall
	
End1:	move $v0, $t1
	la $v1, buffer		
	jr $ra



writefile:

#	move $t1, $s0		
	move $t2, $a1	#copy buffer address 
	
	
	li $v0, 13# open file
	li $a1, 1		
	syscall
	move $t0, $v0	#file descriptor
	bge $t0, $zero, Write2	#error
	li $v0, 4#print error
	
	
	
	
	la $a0, error
	syscall
	li $v0,10		
	syscall

Write2:	li $v0, 15	#write file
	move $a0, $t0	#file descriptor
	la $a1, writeword#write content
	li $a2, 9# WARNING! SIZE OF CONTENT!
	syscall

	li $v0, 15#write file
	move $a0, $t0	#file descriptor
	move $a1, $t2	#write from buffer address
	
	li $a2, 4096#buffer size
	syscall
	
	
	
	bge $v0, $zero, Close2	#error
	li $v0, 4	#print error
	la $a0, error
	syscall
	li $v0,10		
	syscall

Close2:	move $t1, $v0	#copy char
	li $v0, 16	#close file
	
	move $a0, $t0	#file descriptor
	syscall
	
	bge $t0, $zero, End2	#error
	li $v0, 4#print error
	la $a0, error
	syscall
	
	li $v0,10		
	syscall
	
End2:	move $v0, $t1		#

	jr $ra
