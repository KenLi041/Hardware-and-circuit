.data
    message: .asciiz "Enter command\n"
.text

main:
    li $t1,0
    la $t0,message

loop:
    lb   $a0,0($t0)
    beqz $a0,done
    addi $t0,$t0,1
    addi $t1,$t1,1
    j     loop
done:

    li   $v0,1
    add  $a0, $0,$t1
    syscall

    li   $v0,10
    syscall
