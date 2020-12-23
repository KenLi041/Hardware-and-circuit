#KEN LI COPYRIGHT

#WARNING!!!! FOR QUERY COMMAND PLEASE ENTER QH 4 WITH A SPACE IN BETWEEN! ENTERING QH4 is NOT VALID! THANK YOU!

# The program should use MMIO
#WARNING FIX COMMENT, SPACE, ...!!!

.data
#str2: 	.asciiz "\nThe sorted array is: "
#any any data you need be after this line 
str1:	.asciiz "Enter command\n"

str3: 	.asciiz "\nThe array is re-initialized\n"
buffer:	.space 2048		#buffer used to take in the user input
newbuff:.space 2048
array: 	.align 4		#array used to store numbers
	.space 2048

arrayinput: 	
	.align 4		#array used to store numbers
	.space 2048
arrayresult: .align 4
	.word 0, 0, 0, 0, 0
arrayrecord: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24, 0
space:	.asciiz "\n"
str_space: .asciiz " "
comma: 	.asciiz ","
whitespace: .asciiz " "
test: 	.asciiz "test"
error:  .asciiz "That is an invalid banking transaction. Please enter a valid one."
str_repeat: .asciiz "\nrepeat account number, enter again!"
str_noaccount: .asciiz "\nsorry no account matching"
str_accountexist: .asciiz "\nsorry conflicting checking saving account"
str_badcondition: .asciiz "\nsorry loan condition not matched"
invalidcommand: .asciiz "\ninvalid command try again"
str_nowithdraw: .asciiz "\nnot enough money to withdraw"
str_nopayloan: .asciiz "\ncan't transfer to pay loan"
str_noclose: .asciiz "\ncan't close account"
str_nohistory: .asciiz "\nquery history number not correct"
	.text
	.globl main

main:	# all subroutines you create must come below "main"
	la $a0, space #print output string TEST STRING!
	li $v0, 4 #call print
	syscall
	li $s0, 14		#for str1 LENGTH!!!
	li $s5, 1		#signifying printing str1
	la $a0, str1
	#clear array
	la $t5, array
	li $t2, 0
	li $t3, 5

	
#cleararray:
#	sw $zero, 0($t5)
#	addi $t5, $t5, 4
#	addi $t2, $t2, 1
#	beq $t2, $t3, print
#	jal cleararray
	#can print a standard window enter command too

print:	lui $t0, 0xffff	#printing welcome message
loop:	lw $t1, 8($t0) #print welcome message
	andi $t1, $t1, 0x0001 #if least bit = 1 it's ready
	beq $t1, $zero, loop #if not ready loop back to wait for output control
	lb $t3, ($a0) #load a byte 
	sb $t3, 12($t0) #store a byte
	addi $a0, $a0, 1 #move to next byte of string
	subi $s0, $s0, 1 #above 4 commands print a byte
	
	bne $s0, 0, loop #CHECK IF IT LENGTH OF WELCOME MESSAGE COMES TO 
	
	beq $s5, 2, buff #
	beq $s5, 7, aftsor
	beq $s5, 8, start
	beq $s5, 3, start
	
	li $s5, 8
	j start	#CHANGE TO arrayrecordpushset
	
aftsor:	li $s5, 8

			

	#j main

#when 's' is called and another array is entered, only clear the buffers and maintain the index of array
start:	la $t0, buffer		#t0 is text, t1 is search word

loopRW:	j Read # reading and writing using MMIO
	
continueafter:
	add $a0,$v0,$zero 
	jal Write
	j loopRW

#HERE START READING USER INPUT!
Read:	lui $t2, 0xffff #ffff0000 reading inlet
	la $t5, array #pointer for array to get every character!

	
	li $t6, 10 #for detecting newline key
	
Loop1:	lw $t3, 0($t2) #move control register value in t3
	
	andi $t3,$t3,0x0001 #LSB
	beq $t3,$zero,Loop1 #check if it's ready, if not loop back
	lw $t4, 4($t2) #get data in t4, changed v0 to t4
	
	#print v0 value for test previously here
	
readloop: #HERE INFINITE LOOP NEEDS DEBUG
	beq $t4, $t6, printarray # if user hit enter (\ symbol), then go to check CH or other characters, changed $t7 to $zero

	#lw sth from t4?
	move $a0, $t4 #This prints the value, WARNING THIS GET INFINITE LOOP, !now a0 has all user input in standard io
	
	li $v0, 11
	syscall
	
	sw $a0, 0($t5) #store a0 input value in t5 which is array
	addi $t5, $t5, 4 #move array to next place
	
	#sw $t4, 4($t5)#ERROR HERE! read data in another array, sw $v0, arraypointer, then increment array pointer by 4
	#addi $t5, $t5, 4 #array go next place
	
	j Loop1 #test, changed from printarray to loop1! Stucked here?, CHANGED TO LOOP1 NOW IT ONLY PRINTS THE SAME MEMORY ADDRESS FOR ALL ENTRIES 
	#jr $ra #problem, execution broke here

#CAN DISPLAY USER INPUT ON STANDARD IO!
Write:  lui $t2, 0xffff 	#ffff0000 print user input on the screen
Loop2: 	lw $t3, 8($t2) 		#control check if that is ready
	andi $t3,$t3,0x0001
	beq $t3,$zero,Loop2



#WARNING!!! A BUNCH OF THINGS WERE PREVIOUSLY PUT HERE, WHICH ONLY PRINTS ascii value of character like 67.
printarray:
	#j condition #CHANGED HERE FOR NO REPEAT PRINTING!
	la $t5, array #reset array, changed arrayinput to array
	#li $s7, 
	la $s4, 0 #length counter
	#j quit #comment sign deleted!!!WARNING
	
printarrayloop: #remember to count the initial array in!
	#test ENTER PRINTARRAY OR NOT
	
	lw $t3, 0($t5) # get from t3! #LOADING CHARACTER WRONG, 0 offset is the first character
	

	beq $zero, $t3, condition #changed from quit to condition
	addi $t5,$t5,4 # move pointer to next cell
	

	#li $v0,11 #print STORED value for test, `11 is character, 1 is integer JUSt CHANGED FROM 11 to 1
	#move $a0, $t3 #WARNING print fetched value for CHECK
	#syscall
	

	addi $s4, $s4, 1
	
	#la $a0, str_space #print output string
	#li $v0, 4 #call print
	#syscall
	
	j printarrayloop #changed from printarrayloop
	

condition:#WARNING FOR BRANCH ALL CAPITAL LETTER! C=67, H=72, S=83, V=86, D=68, E=69, W=87, T=84, L=76, N=78, R=82, B=66, Q=81
#TEST FOR 2nd character value!
	#la $a0, test #print output string TEST STRING!
	#li $v0, 4 #call print
	#syscall
	#add $a0, $t6, $zero #put result as print statement, print k0 for x
	#li $v0,1 #call print
	#syscall	
		#CHANGE THIS TO CH!
	la $t5, array #reset array to beginning, changed arrayinput to array
	lw $t3, 0($t5) #get first character? Offset right?
	bne $t3, 67, continue #NEED TO CHANGE TO CONTINUE LATER!!!
	lw $t6, 4($t5) #get 2nd character WARNING: OFFSET 4 or 8?
	bne $t6, 72, continue #NEED TO CHANGE TO CONTINUE LATER!!!
	li $gp, 1 #judging which operation later
	j open_account #WARNING CHANGEBACK!!!
	#open_account 
	
	#Change to branch need to go CHANGED FROM open_account to quit!
	
	#REMEMEBR ADD ERROR MESSAGE AT THE END OF ALL CONDITION CHECK!
	
	#SV
continue:#SV!	
	la $t5, array #reset array to beginning, changed arrayinput to array
	lw $t3, 0($t5) #get first character? Offset right?
	addi $t5, $t5, 4
	bne $t3, 83, continueDE #GO TO CONTINUE1 LATER! 
	lw $t6, 0($t5) #get 2nd character WARNING: OFFSET 4 or 8?
	bne $t6, 86, continueDE #GO TO CONTINUE1 LATER!
	li $gp, 2
	j open_account
	#open_account#open_account WHICH BRANCH?
	
continueDE: 
	la $t5, array #reset array to beginning, changed arrayinput to array
	lw $t3, 0($t5) #get first character? Offset right?
	addi $t5, $t5, 4
	bne $t3, 68, continueWT #GO TO CONTINUE1 LATER! 
	lw $t6, 0($t5) 
	bne $t6, 69, continueWT
	li $gp, 3
	j open_account

continueWT: #WT
	la $t5, array #reset array to beginning, changed arrayinput to array
	lw $t3, 0($t5) #get first character? Offset right?
	addi $t5, $t5, 4
	bne $t3, 87, continueLN #GO TO CONTINUE1 LATER! 
	lw $t6, 0($t5) 
	bne $t6, 84, continueLN
	li $gp, 4
	
	j open_account
continueLN: #LN
	la $t5, array #reset array to beginning, changed arrayinput to array
	lw $t3, 0($t5) #get first character? Offset right?
	addi $t5, $t5, 4
	bne $t3, 76, continueTR #GO TO CONTINUE1 LATER! 
	lw $t6, 0($t5) 
	bne $t6, 78, continueTR
	li $gp, 5
	
	j open_account
	
continueTR: #TR
	#go to transfer
	la $t5, array #reset array to beginning, changed arrayinput to array
	lw $t3, 0($t5) #get first character? Offset right?
	addi $t5, $t5, 4
	bne $t3, 84, continueCL #GO TO CONTINUE1 LATER! 
	lw $t6, 0($t5) 
	bne $t6, 82, continueCL
	li $gp, 6
	j open_account
	
continueCL: #CL
	la $t5, array #reset array to beginning, changed arrayinput to array
	lw $t3, 0($t5) #get first character? Offset right?
	addi $t5, $t5, 4
	bne $t3, 67, continueBL #GO TO CONTINUE1 LATER! 
	lw $t6, 0($t5) 
	bne $t6, 76, continueBL
	li $gp, 7
	j open_account
	
continueBL: #BL
	la $t5, array #reset array to beginning, changed arrayinput to array
	lw $t3, 0($t5) #get first character? Offset right?
	addi $t5, $t5, 4
	bne $t3, 66, continueQH #GO TO CONTINUE1 LATER! 
	lw $t6, 0($t5) 
	bne $t6, 76, continueQH
	li $gp, 8
	j open_account

continueQH: #QH
	la $t5, array #reset array to beginning, changed arrayinput to array
	lw $t3, 0($t5) #get first character? Offset right?
	addi $t5, $t5, 4
	bne $t3, 81, quitcheck #GO TO CONTINUE1 LATER! 
	
	lw $t6, 0($t5) 
	
	bne $t6, 72, quitcheck
	li $gp, 9
	j open_account

quitcheck: 
	#QT quit!
	
	la $t5, array #reset array to beginning, changed arrayinput to array
	lw $t3, 0($t5) #get first character? Offset right?
	beq $t3, 81, quit #NEED TO CHANGE TO CONTINUE LATER!!!
	lw $t6, 4($t5) #get 2nd character WARNING: OFFSET 4 or 8?
	beq $t6, 84, quit #NEED TO CHANGE TO CONTINUE LATER!!!
	li $gp, 1 #judging which operation later
	j errormsg #GO BACK TO ASK USER INPUT AGAIN!

errormsg:			#CHANGE IT TO MY CONDITION LIKE C, THEN GO TO ANOTHER BRANCH TO JUDGE
	la $a0, invalidcommand #print output string TEST STRING!
	li $v0, 4 #call print
	syscall
	j main



#DOWN THIS PART CHANGE TO BANKING FUNCTION
open_account:

	la $t6, array #reinitialize user input array pointer t6 to first position
	addi $t6, $t6, 12 #WARNING OFFSET!!!offset=4 get 72, offset=8 get 32 which is space, BUT offset 12 = 49 which is 1, need to convert to int!
	li $t4, 32 #for checking space
	
	#CLEAR 3th 4th element here?
	#sw $zero, 8(
	
	
conversionloop:
	lw $t7, 0($t6) #get value of that term, already at location of 4th element
	beq $t7, $t4, readfirst #if got 2nd space go to readaccount subroutine
			#else continue reading
	addi $t6, $t6, 4#array go next place
	#TEST PRINT VALUE ONLY!
	
	#CHANGED HERE!!!****
	addi $t7, $t7, -48
	
	#CHANGED HERE!!!****
	
	jal conversionloop #jal or j?
	
	#WARNING!!!store the new array in the 25 element array!!!
	#lw $t7, 4($s6) #take 2nd term from user input array
readfirst:
	la $s3, ($t6) #get the location of 2nd space for reading 2nd entry!
	addi $s3, $s3, 4 #go to 2nd number string for later use
	addi $t6, $t6, -4 #now t6 is on lowest digit address
	
	li $t9, 1#another counter for how many digits
	li $k0, 10 #constant for multiplication
	li $k1, 0 #for final result
	
readfirstloop:
	#now pointer t6 should be on least digit address

	lw $t8, 0($t6)#get value of last digit, if 0 here should be 48
	
	beq $t8, $t4, updatefirst#if got space on left stop
	
	addi $t6, $t6, -4 #shift to a digit on left
	addi $t8, $t8, -48 #convert ascii
	mul $t8, $t8, $t9 #convert each integer with real merge value
	
	
	mul $t9, $t9, $k0 #everytime update counter*10
	
	add $k1, $k1, $t8 #add a new digit value
	
	j readfirstloop#CHANGE TO LOOP AGAIN REMEMBER!!!readfirstloop #NEED CHANGE!
	#convert ascii!
	#add $k1
	
updatefirst:
	#add $a0, $k1, $zero #put result as print statement, print k1 for value
	#li $v0,1 #call print
	#syscall #it's true it's 10010
	li $t1, 2
	li $a3, 3 #check for deposit operation
	la $s2, arrayresult
	li $t4, 32 #t4=0 or 32?
	
	#add clear here
clearconversionloop:
	#now t6 is the pointer 
	addi $t6, $t6, 4 #should go to highest digit
	lw $s1, 0($t6)
	
	#j quit
	
	beq $s1, $t4, updateafter
	sw $t4, 0($t6) #changed from $zero to 32
	j clearconversionloop
	
updateafter:
	beq $gp, $t1, updatesv1
	#lw $t2, 0($s2) #check if repeat account
	
	#beq $gp, $a3, conversionloop2   #HERE CONTINUE update on deposit ch case!
	#get result into 1st element of new result array!
	#li $a3, 4 #WARNing SEE IF This AFFECTS OTHER OPERATIONS
	#beq $gp, $a3, conversionloop2
	beq $gp, $a3, skip #update a3 value later for other operations like withdraw!
	li $a3, 4
	beq $gp, $a3, skip #update a3 value later for other operations like withdraw!
	li $a3, 5
	beq $gp, $a3, get_loan #only get 1st num string then directly go to getloan
	li $a3, 6
	beq $gp, $a3, skip #need read next num string for transfer account
	li $a3, 7
	beq $gp, $a3, close_account
	li $a3, 8 
	beq $gp, $a3, get_balance
	li $a3, 9 
	beq $gp, $a3, history
	
	
	beq $t2, $k1, repeat 
	
	#check if new account = old account if yes error!, k1 is new scanned value, 
	lw $t9, 0($s2) #can't have same checking & saving account! JUST CHANGED 4 to 0!

	
	beq $t9, $k1, accountexist
	lw $t9, 4($s2) #can't have same checking & saving account! JUST CHANGED 4 to 0!
	beq $t9, $k1, accountexist

	sw $k1, 0($s2)
	li $t4, 0 #check for end of input which is 0, ascii 0 is 48
	j conversionloop2

skip:	#j quit #go to read update second number!
	li $t4, 0 #check for end of input which is 0, ascii 0 is 48
	j conversionloop2
	
updatesv1:
	li $a3, 3
	la $s2, arrayresult
	
	addi $s4, $k1, 0 #get first user input which is sv account in this case if sv entered
	beq $gp, $a3, skip1 #update a3 value later for other operations like withdraw!
	#update a3 value!!!
	li $a3, 4
	beq $gp, $a3, skip1
	
	lw $t2, 4($s2) #check if repeat sv account
	beq $t2, $s4, repeat 
	#check if new account = old account if yes error!, k1 is new scanned value, 
	
	lw $t9, 0($s2) #can't have same checking & saving account!
	beq $t9, $k1, accountexist #CHANGED HERE FROM s4 to k1!!!
	
	sw $s4, 4($s2) #enter saving number on 2th space
	li $t4, 0
	j conversionloop2
#j quit #go to read update second number!
skip1:	li $t4, 0
	j conversionloop2
	
#updatede1:
	#la $s2, arrayresult
	#lw $t2, 4($s2) #check need same sv account number
	#bne $t2, $k1, noaccount  
	
	#check if new account = old account if yes error!, k1 is new scanned value, 
	#sw $k1, 4($s2) #enter saving number on 2th space
#j quit #go to read update second number!
	#li $t4, 32
	#j updatede2 #if same account, go add number


conversionloop2:
	#li $t4, 10
	li $s6, 0 #t4 shouldn't = 0?
	
	
conversionloop3:
	lw $t9, 0($s3) #offset 0 is 2nd number's highest digit 5 !
	beq $t9, $t4, readsecond #if got 2nd space go to readaccount subroutine
		#else continue reading
	addi $s3, $s3, 4#array go next place
	
	#print out conversion loop value $t9 for less digit case!

	#should add a counter here
	
	jal conversionloop3
	
readsecond: #WARNING HERE IS NEW CODE
	#for now it should be on 3nd space
	addi $s3, $s3, -4 #now s3 is on lowest digit position
	
	li $t9, 1#another counter for how many digits #WARNING CHANGED TO 10 for test!
	li $k0, 10 #constant for multiplication
	li $a1, 0 #for final result #CHANGE k1 for other variable! CHANGE k1 to a1!
	li $t8, 0 #clear t8?
	li $t4, 32
	li $s7, 0 #counter for counting digits of 1st input for further use!

readsecondloop:
	
	lw $t8, 0($s3)##now pointer t6 should be on least digit address, t6 change to s3, get value of lowest digit, if 0 here should be 48
	beq $t8, $t4, updatesecond#if got space on left stop
	
	addi $s3, $s3, -4 #shift to a digit on left
	
	addi $t8, $t8, -48 #convert ascii
	

	mul $t8, $t8, $t9 #convert each integer with real merge value
	
	addu $a1, $a1, $t8 #add a new digit value 
	
	#la $a0, test #print output string TEST STRING!
	#li $v0, 4 #call print
	#syscall
	
	mul $t9, $t9, $k0 #everytime update counter*10
	addi $s7, $s7, 1#counter for how many digits used later
	
	#WARNING! DOWN IN DEPOSIT/WITHDRAW CHECK IF NEW DIGIT > OLD DIGIT THEN DON'T USE COUNTER TO CHANGE DIGIT!

	#j quit

	j readsecondloop
updatesecond:
	#get result into 1st element of new result array!
	la $s2, arrayresult
	li $a3, 3
	li $t9, 1
	li $t4, 0 #make 
	
clearconversionloop2: #get remaining lower digit from previous round out to 0
	#s7 stores how many ascii digits need to clear, given s3 is array, now array should be on the space before highest digit
	addi $s3, $s3, 4 #should go to highest digit
	lw $s4, 0($s3)
	beq $s4, $t4, updateafterclear
	sw $zero, 0($s3)
	

	j clearconversionloop2
	#add $a0, $a1, $zero #put result as print statement, print k1 for value
	#li $v0,1 #call print
	#syscall
updateafterclear:
	
	beq $gp, $a3, skip2 #update a3 value later for other operations like withdraw!
	beq $gp, $t1, updatesv2
	
	li $a3, 4
	beq $gp, $a3, skip2
	li $a3, 6
	beq $gp, $a3, skip2
	#beq $gp, $a3, updatede2 #WARNING DELETE THIS
	#add $a0, $gp, $zero #put result as print statement, print k1 for value
	#li $v0,1 #call print
	#syscall #it's true it's 10010
	
	#TAKE USER 2nd VALUE HERE!
	
	#MOVE DEPOSIT ENTRY HERE! CHANGE k1 down here to another register!
	
	la $a2, ($a1)
	
	lw $t2, 0($s2) #check if repeat account
	
	
	sw $a1, 8($s2) #BECAREFUL LOAD IT TO 3rd position on result array!
	li $t4, 0
	
	j printset #MODIFED HERE!
skip2:
	#j quit #go to read update second number!
	li $t4, 0
	#j printset #MODIFED HERE!

updatesv2:	#WARNING! DOWN IN DEPOSIT/WITHDRAW CHECK IF NEW DIGIT > OLD DIGIT THEN DON'T USE COUNTER TO CHANGE DIGIT!
	li $a3, 3
	addi $s5, $a1, 0
	
	#check number digit issue here
	#add $a0, $a0, $zero #put result as print statement, print k1 for value
	#li $v0,1 #call print
	#syscall
	beq $gp, $a3, deposit   #HERE CONTINUE update on deposit ch case!
	
	li $a3, 4
	beq $gp, $a3, withdraw
	
	li $a3, 6
	beq $gp, $a3, transfer
	
	la $s2, arrayresult #update to 4th position on 5 array
	sw $s5, 12($s2) #enter saving number on 4th space

	#get result into 1st element of new result array!
	#li $a3, 4 #WARNing SEE IF This AFFECTS OTHER OPERATIONS
	#beq $gp, $a3, withdraw
#j quit #go to read update second number!
	li $t4, 0
	j printset
	
deposit:
	
	#add $a0, $k1, $zero #here k1 is USER's 1st input check or saving acocunt number 10101 or 20202
	#NOW WE GET USERS 1st input ACCOUNT NUMBER as k1, money as a2
	la $t3, arrayresult#reset array pointer
	lw $t4, 0($t3) #see existing checking number
	beq $k1, $t4, depcheck
	lw $t4, 4($t3) #see existing saving number
	beq $k1, $t4, depsave
	j noaccount
	
	#TEST see content here!
	
	#compare with array lw first 2 element if equal to 1st, add to 3th value, if equal to 2st, add to 4th value
	# then proceed, else noaccount
	
depcheck: #put amount in 3rd element!
	#load array element then add then put back!
	lw $t4, 8($t3)
	
	#add $a0, $k1, $zero #put result as print statement, print k0 for x
	#li $v0,1 #call print
	#syscall
	
	add $t4, $a1, $t4 
	sw $t4, 8($t3)
	
	li $t4, 0

	j printset
	
depsave: #put amount in 3rd element!
	#la $a0, test #print output string TEST STRING!
	#li $v0, 4 #call print
	#syscall
	lw $t5, 12($t3)
	add $t5, $s5, $t5
	sw $t5, 12($t3)
	
	j printset

withdraw:
	la $t3, arrayresult#reset array pointer
	lw $t4, 0($t3) #see existing checking number
	beq $k1, $t4, drawcheck
	lw $t4, 4($t3) #see existing saving number
	beq $k1, $t4, drawsave
	j noaccount

	#jr $ra
drawcheck:
	lw $t4, 8($t3)
	#add comparison
	bgt $a1, $t4, nowithdraw
	
	sub $t4, $t4, $a1
	sw $t4, 8($t3)
	
	li $t4, 0

	j printset
	
nowithdraw:
	la $a0, str_nowithdraw #print output string
	li $v0, 4 #call print
	syscall
	jal main
	
	
drawsave: #warning must deduct 5%! so *95 then /100
	lw $t5, 12($t3)
	li $t7, 5 #changed 95 to 5, revise arithmetics after!
	li $t4, 100
	mul $t7, $t7, $s5 #5% of this entry withdraw amount deduct from saving, so s5 no change, -5% from saving
	div $t4, $t7, $t4 #now t4 should be 5% of this entry amount
	
	#j quit
	bgt $s5, $t5, nowithdraw
	
	sub $t5, $t5, $s5
	sub $t5, $t5, $t4 #now account deduct this amount & 5% fee
	
	sw $t5, 12($t3) #16550 is correct but runtime exception here why
	
	j printset
	
get_loan:
	#k1 is this time's loan amount
	la $t3, arrayresult#reset array pointer
	lw $t4, 8($t3)
	lw $t5, 12($t3) #get current 2 accounts amount
	li $s4, 10000 #for compare
	li $s7, 2 #div 2 for 50%
	add $t4, $t4, $t5
	
	#now t4=17000 which is correct
	ble $t4, $s4, badcondition #check first condition
	#now $t4 is the combined amount 
	
	
	div $t4, $t4, $s7 #get 50% of balance in t4, checked is correct
	#now $t4 should be 50%
	lw $t7, 16($t3)
	
	
	add $t7, $t7, $k1
	
	#j quit
	bge $t7, $t4, badcondition
	sw $t7, 16($t3)
	j printset
	#jr $ra
	
badcondition:
	la $a0, str_badcondition #print output string
	li $v0, 4 #call print
	syscall
	jal main
	
transfer:
	#NEED TO ADD THE CASE OF 3 INPUTS LATER!!!
	la $t3, arrayresult#reset array pointer
	lw $t4, 0($t3) #see existing checking number vs first entry
	beq $k1, $t4, checkpaybackloan
	lw $t4, 4($t3) #see existing saving number vs first entry
	beq $k1, $t4, savepaybackloan
	j noaccount
	
checkpaybackloan:
	#a1 should be user entered amount
	lw $t4, 8($t3) #get checking amount
	#add comparison
	bgt $a1, $t4, nopayloan #check enough money in checking amount
	sub $t4, $t4, $a1 #deduct payback from checking
	lw $t7, 16($t3)#get loan amount
	#check payed money no more than loan amount, a1 is payback amount
	bgt $a1, $t7, nopayloan #if payback greater than loan can't payback
	sw $t4, 8($t3) #restore new checking amount to 3rd element
	sub $t7, $t7, $a1 #reduce loan amount
	sw $t7, 16($t3) #update value on loan 5th element
	li $t4, 0
	
	j printset
	
savepaybackloan:
	lw $t4, 12($t3) #get saving amount
	#add comparison
	bgt $a1, $t4, nopayloan #check enough money in checking amount
	sub $t4, $t4, $a1 #deduct payback from checking
	lw $t7, 16($t3)#get loan amount
	#check payed money no more than loan amount, a1 is payback amount
	bgt $a1, $t7, nopayloan #if payback greater than loan can't payback
	sw $t4, 12($t3) #restore new checking amount to 3rd element
	sub $t7, $t7, $a1 #reduce loan amount
	sw $t7, 16($t3) #update value on loan 5th element
	li $t4, 0
	
	j printset
	
nopayloan:
	la $a0, str_nopayloan #print output string
	li $v0, 4 #call print
	syscall
	jal main
	
	
close_account:
	#k1 is the user entered account number which need close, compare it to both check & save, if not error
	la $t3, arrayresult#reset array pointer
	lw $t4, 0($t3) #see existing cheqing number
	beq $k1, $t4, close1
	lw $t4, 4($t3) #see existing saving number
	beq $k1, $t4, close2
	j noclose
close1:
	li $t4, 0
	lw $t5, 4($t3) #if entered checking account, check if saving account is 0 or not
	beq $t5, $t4, allzero #if the other account already cleared, make all 5 entries to 0
	#else clean cheqing number & amount, and transfer amount to the other account!
	lw $t4, 8($t3)
	lw $t5, 12($t3) 
	add $t5, $t5, $t4 #transfer account
	sw $zero, 12($t3) #first clear then add the combined amount in
	sw $t5, 12($t3)
	sw $zero, 0($t3) #clear 1st & 3st element for checking acc & amount
	sw $zero, 8($t3)
	j printset
	
close2: 
	li $t4, 0
	lw $t5, 0($t3) #if entered saving account, check if checking account is 0 or not
	beq $t5, $t4, allzero #if the other account already cleared, make all 5 entries to 0
	#else clean cheqing number & amount, and transfer amount to the other account!
	lw $t4, 12($t3)
	lw $t5, 8($t3) 
	add $t5, $t5, $t4 #transfer account
	sw $zero, 8($t3) #first clear then add the combined amount in
	sw $t5, 8($t3)
	sw $zero, 4($t3) #clear 1st & 3st element for checking acc & amount
	sw $zero, 12($t3)
	j printset
	
allzero:
	sw $zero, 0($t3)
	sw $zero, 4($t3)
	sw $zero, 8($t3)
	sw $zero, 12($t3)
	sw $zero, 16($t3)
	j printset
	
noclose:
	la $a0, str_noclose #print output string
	li $v0, 4 #call print
	syscall
	jal main


get_balance:#k1 is the user entered account
	la $t3, arrayresult#reset array pointer
	lw $t4, 0($t3) #see existing cheqing number
	beq $k1, $t4, showbalancecheck
	lw $t4, 4($t3) #see existing saving number
	beq $k1, $t4, showbalancesave
	#else no account matching
	j noaccount

showbalancecheck:
	lw $t4, 8($t3) #get checking amount
	la $a0, space #print output string TEST STRING!
	li $v0, 4 #call print
	syscall
	add $a0, $t4, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	jal main
	#show checking amount
	
showbalancesave:
	lw $t4, 12($t3) #get saving amount
	la $a0, space #print output string TEST STRING!
	li $v0, 4 #call print
	syscall
	add $a0, $t4, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	jal main

history:
	#here k1 is the 0~5 user input for how many 5 array history need to see
	la $s3, arrayrecord
	#if user enter incorrect amount not 0~5
	li $s4, 0
	li $s6, 5
	ble $k1, $s4, nohistory #if less or equal to 0
	bgt $k1, $s6, nohistory #if greater than 5
	li $s4, 1
	beq $k1, $s4, sethistory1
	li $s4, 2
	beq $k1, $s4, sethistory2
	li $s4, 3
	beq $k1, $s4, sethistory3
	li $s4, 4
	beq $k1, $s4, sethistory4
	li $s4, 5
	beq $k1, $s4, sethistory5
	
sethistory1:
	li $s4, 0
	li $s6, 5
	
	la $a0, space #print newline
	li $v0, 4 #call print
	syscall
	
history1:
	#test ENTER PRINTARRAY OR NOT
	
	lw $t3, 0($s3) # get from arrayrecord
	beq $s4, $s6, main 
	addi $s3,$s3,4 # move pointer to next cell
	addi $s4, $s4, 1
	
	add $a0, $t3, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	
	la $a0, str_space #print output string
	li $v0, 4 #call print
	syscall
	
	jal history1
	


	
sethistory2:
	la $s3, arrayrecord
	li $s4, 0
	li $s6, 10
	li $s7, 5
	la $a0, space #print newline
	li $v0, 4 #call print
	addi $s3, $s3, 20
	syscall
	
history2:
	#test ENTER PRINTARRAY OR NOT
	
	lw $t3, 0($s3) # get from arrayrecord
	beq $s4, $s7, separatearray
	beq $s4, $s6, main 
	addi $s3,$s3,4 # move pointer to next cell
	addi $s4, $s4, 1
	
	add $a0, $t3, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	
	la $a0, str_space #print output string
	li $v0, 4 #call print
	syscall
	
	jal history2
	
separatearray:
	la $a0, space #print output string
	li $v0, 4 #call print
	syscall
	subi $s3, $s3, 40
	jal history2sec
	
history2sec:
	#test ENTER PRINTARRAY OR NOT
	
	lw $t3, 0($s3) # get from arrayrecord
	beq $s4, $s6, main 
	addi $s3,$s3,4 # move pointer to next cell
	addi $s4, $s4, 1
	
	add $a0, $t3, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	
	la $a0, str_space #print output string
	li $v0, 4 #call print
	syscall
	
	jal history2sec
	
	
	
sethistory3:
	la $s3, arrayrecord
	li $s4, 0
	li $s6, 15
	li $s7, 5 #later change it to 10!
	la $a0, space #print newline
	li $v0, 4 #call print
	addi $s3, $s3, 40
	syscall
history3:
	#test ENTER PRINTARRAY OR NOT
	
	lw $t3, 0($s3) # get from arrayrecord
	beq $s4, $s7, separatearray1
	beq $s4, $s6, main 
	addi $s3,$s3,4 # move pointer to next cell
	addi $s4, $s4, 1
	
	add $a0, $t3, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	
	la $a0, str_space #print output string
	li $v0, 4 #call print
	syscall
	
	jal history3
	
separatearray1:
	la $a0, space #print output string
	li $v0, 4 #call print
	syscall
	li $s7, 10
	subi $s3, $s3, 40
	jal history3sec
	
history3sec:
	#test ENTER PRINTARRAY OR NOT
	
	lw $t3, 0($s3) # get from arrayrecord
	beq $s4, $s7, separatearray2 #CHANGE TO SEPARATE ARRAY 2!
	beq $s4, $s6, main 
	addi $s3,$s3,4 # move pointer to next cell
	addi $s4, $s4, 1
	
	add $a0, $t3, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	
	la $a0, str_space #print output string
	li $v0, 4 #call print
	syscall
	
	jal history3sec

separatearray2:
	la $a0, space #print output string
	li $v0, 4 #call print
	syscall
	subi $s3, $s3, 40
	jal history3thi
	
history3thi:
	lw $t3, 0($s3) # get from arrayrecord
	beq $s4, $s6, main 
	addi $s3,$s3,4 # move pointer to next cell
	addi $s4, $s4, 1
	
	add $a0, $t3, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	
	la $a0, str_space #print output string
	li $v0, 4 #call print
	syscall
	
	jal history3thi

	

sethistory4:
	la $s3, arrayrecord
	li $s4, 0
	li $s6, 20
	li $s7, 5 #later change it to 10 & 15!
	la $a0, space #print newline
	li $v0, 4 #call print
	addi $s3, $s3, 60
	syscall
	
history4:
	#test ENTER PRINTARRAY OR NOT
	
	lw $t3, 0($s3) # get from arrayrecord
	beq $s4, $s7, separatearray3
	beq $s4, $s6, main 
	addi $s3,$s3,4 # move pointer to next cell
	addi $s4, $s4, 1
	
	add $a0, $t3, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	
	la $a0, str_space #print output string
	li $v0, 4 #call print
	syscall
	
	jal history4
	
separatearray3:
	la $a0, space #print output string
	li $v0, 4 #call print
	syscall
	li $s7, 10
	subi $s3, $s3, 40
	jal history4sec
	
history4sec:
	#test ENTER PRINTARRAY OR NOT
	
	lw $t3, 0($s3) # get from arrayrecord
	beq $s4, $s7, separatearray4 #CHANGE TO SEPARATE ARRAY 2!
	beq $s4, $s6, main 
	addi $s3,$s3,4 # move pointer to next cell
	addi $s4, $s4, 1
	
	add $a0, $t3, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	
	la $a0, str_space #print output string
	li $v0, 4 #call print
	syscall
	
	jal history4sec

separatearray4:
	la $a0, space #print output string
	li $v0, 4 #call print
	syscall
	subi $s3, $s3, 40
	li $s7, 15
	jal history4thi
	
history4thi:
	lw $t3, 0($s3) # get from arrayrecord
	beq $s4, $s7, separatearray5 #CHANGE TO SEPARATE ARRAY 2!
	beq $s4, $s6, main 
	addi $s3,$s3,4 # move pointer to next cell
	addi $s4, $s4, 1
	
	add $a0, $t3, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	
	la $a0, str_space #print output string
	li $v0, 4 #call print
	syscall
	
	jal history4thi
	
separatearray5:
	la $a0, space #print output string
	li $v0, 4 #call print
	syscall
	subi $s3, $s3, 40
	#li $s7, 15
	jal history4four
	
history4four:
	lw $t3, 0($s3) # get from arrayrecord

	beq $s4, $s6, main 
	addi $s3,$s3,4 # move pointer to next cell
	addi $s4, $s4, 1
	
	add $a0, $t3, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	
	la $a0, str_space #print output string
	li $v0, 4 #call print
	syscall
	
	jal history4four
	
	
sethistory5:
	la $s3, arrayrecord
	li $s4, 0
	li $s6, 25
	li $s7, 5 #later change it to 10 & 15!
	la $a0, space #print newline
	li $v0, 4 #call print
	addi $s3, $s3, 80
	syscall
	
history5:
	#test ENTER PRINTARRAY OR NOT
	
	lw $t3, 0($s3) # get from arrayrecord
	beq $s4, $s7, separatearray6
	beq $s4, $s6, main 
	addi $s3,$s3,4 # move pointer to next cell
	addi $s4, $s4, 1
	
	add $a0, $t3, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	
	la $a0, str_space #print output string
	li $v0, 4 #call print
	syscall
	
	jal history5
	
separatearray6:
	la $a0, space #print output string
	li $v0, 4 #call print
	syscall
	li $s7, 10
	subi $s3, $s3, 40
	jal history5sec
	
history5sec:
	#test ENTER PRINTARRAY OR NOT
	
	lw $t3, 0($s3) # get from arrayrecord
	beq $s4, $s7, separatearray7 #CHANGE TO SEPARATE ARRAY 2!
	beq $s4, $s6, main 
	addi $s3,$s3,4 # move pointer to next cell
	addi $s4, $s4, 1
	
	add $a0, $t3, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	
	la $a0, str_space #print output string
	li $v0, 4 #call print
	syscall
	
	jal history5sec

separatearray7:
	la $a0, space #print output string
	li $v0, 4 #call print
	syscall
	subi $s3, $s3, 40
	li $s7, 15
	jal history5thi
	
history5thi:
	lw $t3, 0($s3) # get from arrayrecord
	beq $s4, $s7, separatearray8 #CHANGE TO SEPARATE ARRAY 2!
	beq $s4, $s6, main 
	addi $s3,$s3,4 # move pointer to next cell
	addi $s4, $s4, 1
	
	add $a0, $t3, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	
	la $a0, str_space #print output string
	li $v0, 4 #call print
	syscall
	
	jal history5thi
	
separatearray8:
	la $a0, space #print output string
	li $v0, 4 #call print
	syscall
	subi $s3, $s3, 40
	li $s7, 20
	jal history5fif
	
history5fif:
	lw $t3, 0($s3) # get from arrayrecord
	beq $s4, $s7, separatearray9 #CHANGE TO SEPARATE ARRAY 2!
	beq $s4, $s6, main 
	addi $s3,$s3,4 # move pointer to next cell
	addi $s4, $s4, 1
	
	add $a0, $t3, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	
	la $a0, str_space #print output string
	li $v0, 4 #call print
	syscall
	
	jal history5fif
	
separatearray9:
	la $a0, space #print output string
	li $v0, 4 #call print
	syscall
	subi $s3, $s3, 40
	#li $s7, 15
	jal history5six
	
	
history5six:
	lw $t3, 0($s3) # get from arrayrecord

	beq $s4, $s6, main 
	addi $s3,$s3,4 # move pointer to next cell
	addi $s4, $s4, 1
	
	add $a0, $t3, $zero #put result as print statement, print k0 for x
	li $v0,1 #call print
	syscall
	
	la $a0, str_space #print output string
	li $v0, 4 #call print
	syscall
	
	jal history5six
	
	
	
	
	
	
nohistory:
	la $a0, str_nohistory #print output string
	li $v0, 4 #call print
	syscall
	jal main


	
printset:
	#Clear array first here!
	la $s2, arrayresult
	li $t9, 5#length of 5array!
	li $t8, 0#counter for length!
	la $a0, space #print output string TEST STRING!
	li $v0, 4 #call print
	syscall

	j printupdate
	#j quit #WARNING QUIT HERE NEEDS CHANGE!	
printupdate:
	#test ENTER PRINTARRAY OR NOT
	
	lw $t6, 0($s2) # get from s2!
	beq $t8, $t9, arrayrecordpushset #WARNING CHANGED TO LOOP BACK! WARNING LATER GO TO A NEW SUBROUTINE COPY MOVE TO 25 array than that subroutine go to main!!!
	addi $s2,$s2,4 # move pointer to next cell 
	addi $t8, $t8, 1 #counter+1
	#JUST FOR CHECK!
	li $v0,1 #print STORED value for test
	move $a0, $t6 #WARNING print fetched value for CHECK
	syscall
	#li $v0,1 #print STORED value for test
	#move $a0, $t6 #WARNING print fetched value for CHECK
	#syscall
	la $a0, str_space #print output string
	li $v0, 4 #call print
	syscall
	
	j printupdate
	
arrayrecordpushset:
	
	la $t2, arrayrecord
	li $t3, 20#move index 0~19 CHANGED TO 20!!! 19 or 20???
	li $t4, 0 #counter increment needed
	addi $t2, $t2, 76 #first get pointer to the 19th element CHANGED FROM 76 to 72!
	#HERE NO PROBLEM WITH NO SPACE PROBLEM
arrayrecordpush:
#query space problem solved by change to 20 24
	lw $t5, 0($t2) #take value of 19th element
	
	addi $t2, $t2, 20 #go to last 25th element #CHANGED FROM 20-24 to 24-28!

	
	sw $t5, 0($t2) #shift value of 19th element to 25th
	addi $t2, $t2, -24 #go back 6 elements 6*4
	
	#addi $t3, $t3, -1 #CHANGED POSITION OF COUNTER -1 FROM HERE!
	
	beq $t3, $t4, storearrayandclearset #if first 5 elements moved then insert new 5 element array
	addi $t3, $t3, -1

	j arrayrecordpush
	

storearrayandclearset: #arrayresult into arrayrecord! First move 1st to 20th element in arrayrecord all 5 after, 
	#copy arrayresult into arrayrecord, push everything after 5
	
	la $s2, arrayresult #problem is here
	la $t2, arrayrecord
	li $t9, 5#length of 5array!
	li $t8, 0#counter
	
storearrayandclear:
	lw $t6, 0($s2) #get first element from arrayresult
	sw $t6, 0($t2) #copy to 1st element in arrayrecord
	addi $s2, $s2, 4 #go to next element
	addi $t2, $t2, 4 #both go to next element
	addi $t8, $t8, 1 #counter + 1
	beq $t9, $t8, resetarrayresult#CHANGE THIS TO MAIN LATER! TEST IF THIS COUNTER = 4 or 5 can move exactly 5 elements!
	
	j storearrayandclear #go to clear array first!
	#GO BACK TO MAIN!
resetarrayresult:
	la $s2, arrayresult
	
	jal main
	
#!!!REMEMBER ADD CLEAR ARRAY (3th, 4th element) LATER!
	
repeat:
	la $a0, str_repeat #print output string
	li $v0, 4 #call print
	syscall
	jal main

noaccount:
	la $a0, str_noaccount #print output string TEST STRING!
	li $v0, 4 #call print
	syscall
	jal main
	
accountexist:
	la $a0, str_accountexist #print output string TEST STRING!
	li $v0, 4 #call print
	syscall
	jal main


	
updatedech: #if maching checking number go to add, else repeat subrou	

	
	
	lw $t3, 0($s2) #check need same CH account number
	beq $t3, $k1, updatesecond #is k1 the new entry number
	j noaccount

print5arraystoreto25:



#loop end here so can do 2 conditions

	#ignore everything except numbers and spaces
else:	
	beq $a0, 32, display
	sltiu $t1, $a0, 58	# if $a0 < 58 then set $t1 to 1
	beq $t1, $zero, jump	# not a digit or space, go to next
	sltiu $t1, $a0, 48	# if $t2 < 48(not a digit 0-9) then set $t1 to 1
	bne $t1, $zero, jump	# not a digit, go to next
	
display:sw $a0, 12($t2) 	# echo
	sb $a0, ($t0)		#else store the digit as ASCII
	addi $t0, $t0, 1
	
#Caution! else & display function originally here
jump:	jr $ra

#store from buffer to array
storing:li $s4, 0
	li $s2, 0
	li $t1, 0
	
calc:	lb $s2, buffer($t1)	#read the current character in buffer
	beq $s2, $zero, open_account	#end of buffer
	beq $s2, 32, next	#current is space
	subi $s2, $s2, 48	# get the real digit from ASCII
	
	addi $t1, $t1, 1	#check if next is space or null
	lb $t3, buffer($t1)
	subi $t1, $t1, 1
	beq $t3, $zero, onedig	#next is null means this is either the second digit or this is a one digit number
	beq $t3, 32, onedig	#next is space means this is either the second digit or this is a one digit number
	
	#else this is the tens digit of a two digits number
	mul $s4, $s2, 10
	j next
	
onedig:	beq $s4, $zero, store	#one digit number, then store
	add $s2, $s4, $s2	#two digits number
	j store

store:	sw $s2, array($s6)	# store current number into array	
	add $s4, $zero, $zero	# set $t4 to 0
	addi $s6, $s6, 4	# go to next number in array
	
	#CONDITION HERE FOR OPEN ACCOUNT
	
next:	addi $t1, $t1, 1	# next character in buffer
	j calc

#now we have stored the numbers user input so far into array, can start sorting










#STOP THE CHANGE OF CODE TO BANKING HERE!

#printing str2 WARNING CHANGE str2 to right banking string!

print2:	#li $s0, 22		#print str2 with length WARNING CALCULATE LENGTH OF PROMPT STRING!
	#li $s5, 2		#signifying printing str2
	#la $a0, str2	#WARNING! ADD [ before and ] after printing!!!
	j print

#store the sorted array into buffer
buff:  	li $t0, 0
	li $s1, 0

	
quit: 	nop

