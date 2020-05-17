		
main:	
li $a0,5
jal steps

########################Exit Labels#########################

main.exit:
	li $v0,10
	syscall	

steps: 
 li $v0,1
 syscall
       addi $sp,$sp,-12
       sw $ra,0($sp)
       sw $s0,4($sp)
       sw $s1,8($sp)
       
       move $s0,$a0
       bgt $s0,1 count
       move $v0,$s0
       j steps.return
       
count: addi $a0,$s0,-1
       jal steps
       move $s1,$v0
       
       addi $a0,$s0,-2
       jal steps
       add $v0,$v0,$s1
       
steps.return:
       lw $ra,0($sp)
       lw $s0,4($sp)
       lw $s1,8($sp)
       addi $sp,$sp,12
       jr $ra