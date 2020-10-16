# Ken Li 260823059	COMP 273 assignment 2 Q3

# This program calculates the slope and midpoint between two points in a plane

	.data
str_x1:
	.asciiz "Enter x1: "
str_y1:
	.asciiz "Enter y1: "
str_x2:
	.asciiz "Enter x2: "
str_y2:
	.asciiz "Enter y2: "
out_midpoint:
	.asciiz "The midpoint is: "
out_slope:
	.asciiz "The slope is: "
output_midpoint:
	.asciiz "The midpoint is: "
output_slope:
	.asciiz "The slope is: "
output_comma:
	.asciiz ","	
space:
	.asciiz "\n"

	.text	
# YOUR CODE HERE
main:
la $a0,str_x1 #prompt first int x1
li $v0, 4
syscall
li $v0, 5 #read first int x1
syscall
add $s0,$v0,$zero #save first int x1 into $s0

la $a0,str_y1 #prompt second int y1
li $v0, 4
syscall
li $v0, 5 #read second int y1
syscall
add $s1,$v0,$zero #save second int y1 into $s1

la $a0,str_x2 #prompt third int x2
li $v0, 4
syscall
li $v0, 5 #read third int x2
syscall
add $s2,$v0,$zero #save third int x2 into $s2

la $a0,str_y2 #prompt fourth int y2
li $v0, 4
syscall
li $v0, 5 #read fourth int y2
syscall
add $s3,$v0,$zero #save fourth int y2 into $s3

add $s4,$zero,$s0 #store given x1 to another variable for slope calculation
add $s5,$zero,$s1 #store given y1 to another variable for slope calculation
add $s6,$zero,$s2 #store given x2 to another variable for slope calculation
add $s7,$zero,$s3 #store given y2 to another variable for slope calculation

add $s0, $s0, $s2 #update s0 value to be s0+s2 (x1+x2)
add $s1, $s1, $s3 #update s1 value to be s1+s3 (y1+y2)
addi $t0, $zero, 2
div $s0, $t0 #midpoint formula for x
mflo $k0
div $s1, $t0 #midpoint formula for y
mflo $k1

sub $t5, $s7, $s5 #slope calculation, t5 = y2-y1
sub $t6, $s6, $s4 #slope calculation, t6 = x2-x1
div $t5, $t6 #get slope
mflo $t7

li $v0, 4 #call print
la $a0, output_midpoint #print output string
syscall

add $a0, $k0, $zero #put result as print statement, print k0 for x
li $v0,1 #call print
syscall

li $v0, 4 #call print
la $a0, output_comma #print output comma between
syscall

add $a0, $k1, $zero #put result as print statement, print k0 for x
li $v0,1 #call print
syscall

li $v0, 4 #call print
la $a0, space #print output space for new line
syscall

li $v0, 4 #call print
la $a0, output_slope #print output string
syscall

add $a0, $t7, $zero #put result as print statement, print t7 for slope
li $v0,1 #call print
syscall

# EXIT PROGRAM
li $v0,10		#system call code for exit = 10
syscall			#call operating sys : EXIT
